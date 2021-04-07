---
title: "Building our own QAware Technology Radar"
date: 2021-02-20
lastmod: 2021-12-23
author: "[M.-Leander Reimer](https://github.com/lreimer)"
type: "post"
image: "build-your-own-radar.png"
tags: ["Technology", "Radar", "Tools", "Techniques", "Platforms", "Serverless", "GCP"]
summary: "Building a Technology Radar using Serverless GCP services (inspired by ThoughtWorks)"
draft: true
---

Cool technology comes and goes! Keeping track of every change and innovation regarding the tools, platforms, techniques or languages we use to build enterprise systems is challenging. To address this problem the concept of the _Technology Radar_ is now widely known and adopted by the community. The initial idea was probably born and made popular at ThoughtWorks and since then many other companies followed and published their own technology radar:
- https://www.thoughtworks.com/en/radar
- https://opensource.zalando.com/tech-radar/
- https://techradar.qaware.de

To get you started quickly with your own radar, have a look ath the [Build Your Own Radar](https://radar.thoughtworks.com) initiative from ThoughtWorks: simply enter your radar data in a Google Sheet and you are ready to go. But in case you want to build and host your own technology radar instance the source code can be found [here](https://github.com/thoughtworks/build-your-own-radar).


## Conceptual Architecture

So we started off by forking the official repository. Great! But we soon realized that we wanted more and we needed to make a few modications to the original soures:

* __Static Datasource__: instead of specifying a URL to a Google Sheet that contains the radar data at every start, we wanted the UI to use a static or hard-coded URL to a known data source instead.

* __No Google Sheet__: for some reason I didn't like to the idea of using a Google Sheet as datasoure for our radar data. I wanted to use a _proper_ database instead.

* __Serverless Infrastructure__: many internal IT services at QAware are hosted in the Google Cloud. So it was pretty obvious that our Technology Radar should also be run on GCP as well, ideally using Serverless technology to save costs and not worry about infrastructure maintenance. We use _Cloud Run_ to run the Web UI container, _Cloud Functions_ for the backend logic to access the radar data and _Firestore_ to store the actual radar data.

{{< img src="/images/conceptual-techradar.png" alt="Conceptual Architecture of QAware Tech Radar" >}}

This is what we ended up with, the code of this customized technology radar version can be found in the follwing [GitHub](https://github.com/qaware/build-your-own-radar) repository.


## Technical Details

The logic to display the technology radar UI had already been implemented in the [upstream project](https://github.com/thoughtworks/build-your-own-radar) from ThoughtWorks. The first thing we added was a Cloud Build based pipeline to continuously build and deploy the Web UI container and the required Cloud functions. The following snippet is a simple example `cloudbuild.yaml` that get's the job done.

```yaml
steps:
  # build the Docker image for the Web UI using Kaniko
  - name: 'gcr.io/kaniko-project/executor:latest'
    args: ["--dockerfile=./Dockerfile",
           "--cache=true",
           "--destination=gcr.io/qaware-techradar/techradar:latest"]

  # deploy the previously build image to Cloud Run
  - name: 'gcr.io/cloud-builders/gcloud'
    args: ['run', 'deploy', 'techradar', '--image', 'gcr.io/$PROJECT_ID/techradar', '--region', 'europe-west1', '--platform', 'managed', '--allow-unauthenticated']

  # deploy the CSV data function to Cloud Functions
  - name: 'gcr.io/cloud-builders/gcloud'
    args: ['functions', 'deploy', 'get-source-as-csv', '--entry-point', 'getSourceAsCsv', '--runtime', 'nodejs10', '--region', 'europe-west1', '--source', './functions/get-source-as-csv', '--trigger-http', '--allow-unauthenticated']
```

To store the radar data we decided to use Firebase as a serverless NoSQL database. Connecting to Firebase from a Cloud function is fairly straight forward and well documented with many samples. By using the `json2csv` library we were able to transform the JSON data documents to CSV in just a few lines of JavaScript code.

```javascript
const functions = require('firebase-functions')

const admin = require('firebase-admin')
admin.initializeApp(functions.config().firebase)

const { Parser } = require('json2csv')
var fields = ['name', 'quadrant', 'ring', 'isNew', 'description']

exports.getSourceAsCsv = functions.https.onRequest((request, response) => {
  // allow OPTIONS requests
  if (request.method === 'OPTIONS') {
    response.set('Access-Control-Allow-Methods', 'GET')
    response.set('Access-Control-Allow-Headers', 'Authorization')
    response.set('Access-Control-Max-Age', '3600')
    return response.status(204).send('')
  }

  // required because of UI and function have different origins
  response.set('Access-Control-Allow-Origin', '*')
  var jsondata = []

  const db = admin.firestore()
  db.collection('version').doc('currentVersion').get().then((ver) => {
    var version = request.query.name || ver.data().version
    const dBData = db.collection(version)

    // get all data from the versioned data collection
    return dBData.get().then((querySnapshot) => {
      querySnapshot.forEach(doc => {
        jsondata.push(doc.data())
      })

      // produce CSV from JSON documents
      var json2csv = new Parser({ delimiter: ';', fields: fields })
      const csv = json2csv.parse(jsondata)
      response.setHeader(
        'Content-disposition',
        'attachment; filename=files.csv'
      )
      
      response.set('Content-Type', 'text/csv')
      return response.status(200).send(csv)
    }).catch((err) => {
      return console.log(err)
    })
  })
})
```

Finally, we added a few convenience functions to upload the radar data to Firebase either via HTTP POST or via a storage bucket. Have a look at the sources in the [GitHub](https://github.com/qaware/build-your-own-radar) repository for more details.


## Planned Improvements and Outlook

After the initial release of our technology radar we realized that we are only at the beginning of our journey and that there are some improvements required.

The dynamic nature of the single-page application (SPA) of the technology radar is not ideal for proper search engine optimization (SEO). Although, we have performed some minor tuning on the initial loaded page, we know that this is far from ideal. So we are currently working on improving this situation. Ideally, we will use some sort of server-side pre-rendering to produce a static version of each possible page of the radar.

Another issue was more of an organisantional nature: how could we orchestrate the curation of the content of our technology radar so that every project and business division is equally involved? To solve this we established a dedicated guild that takes care of the curation and also serves as an internal technology adivisory to all our projects and teams.