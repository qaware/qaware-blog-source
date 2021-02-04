---
title: "QAware Smart Office with LoRaWAN and GCP"
date: 2020-12-10
lastmod: 2020-12-10
author: "[M.-Leander Reimer](https://github.com/lreimer)"
type: "post"
image: "smart-office-lorawan-gcp.png"
tags: ["Smart Office", "LoRaWAN", "IoT", "GCP", "Serverless", "Raspberry", "Pi"]
aliases:
    - /posts/2020-12-10-smart-office-lorawan-gcp/
summary: "Building a Smart QAware Office using LoRaWAN devices and GCP serverless technology"
draft: false
---

The initial idea for this project dates back to November 2019, when I attended an event about the digital strategy of my home town Rosenheim. One of the talks at this event was about Rosenheim becoming a Smart city presented by speakers from Komro, the local internet provider, and the municipal utilities. They presented many ideas different use cases, like power cicuit monitoring or room climate control. See https://smartcity-rosenheim.de for more details.

Pretty much at the same time, we had just opened our QAware office in Rosenheim. It was apparant to me that the presented LoRaWAN technology together with a serverless backend would be an awesome combination to implement simple use cases such as CO2 monitoring in our meeting rooms or temparature readings in our server room. Unfortunately, COVID19 kicked in then and we had to transform our offices into safe environments to work. And guess what: even more use cases emerged like occupancy detection on shared desks and even toilets.

During our QAgarage day I finally found the time to write up this blog post and build the *Klo Ampel*, a digital occupancy indicator for toilets. Great fun!

## Required Hardware

The following is a shopping list of some of the hardware we used for this project. Of course there are many other LoRaWAN sensor devices you can buy.

- [ELSYS ERS CO2](https://www.elsys.se/en/ers-co2/) for indoor environment monitoring, with sensors for temperature, CO2, humidity, light and motion.
- [ELSYS ERS Eye](https://www.elsys.se/en/ers-eye/) to detect people by movement and also by heat.
- [ELSYS ERS Desk](https://www.elsys.se/en/ers-desk/) for occupancy detection of shared desks.
- [Raspberry Pi Zero W Starter Kit](https://www.amazon.de/gp/product/B07D5G3459/ref=ox_sc_act_title_2?smid=A2KDI895FDYZAF&psc=1) as a small MQTT client device.
- [blink(1) mk3](https://www.getdigital.de/blink-1-mk3.html) as a simple LED status display.

## Conceptual Architecture

The general idea was to host the complete backend on Google Cloud and mainly use serverless technologies such as _Cloud Functions_, _Cloud Firestore_ or _Cloud Run_. The basic infrastructure setup for the project is performed using Terraform, in order to create
- the _Cloud Source Repositories_ to mirror the sources for each function from our GitLab instance,
- the _Cloud Build_ triggers for each repository to build and deploy the functions and containers,
- several _Cloud Pup/Sub_ topics to publish current temperature and CO2 values to,
- a _Cloud Scheduler_ to run regular cleanup jobs,
- a _Cloud IoT Registry_ to register external MQTT clients.

The LoRaWAN devices are registered and connected to the local available LoRaWAN network. For our Rosenheim office we are using the network provided by Komro, and for our Munich office we use [The Things Network](https://www.thethingsnetwork.org) with the HTTP integration configured. The sensor data is delivered to an HTTP receiver Cloud function, that decodes and stores the original payload as document in a Firestore collection. This function looks something like this:

```javascript
const functions = require('firebase-functions')
const admin = require('firebase-admin')
admin.initializeApp(functions.config().firebase)

exports.receive = functions.https.onRequest((request, response) => {
    if (request.method !== 'POST') {
        return response.status(405).end();
    }
    if (request.get('content-type') !== 'application/json') {
        return response.status(415).end();
    }

    const data = request.rawBody;
    const json = JSON.parse(data.toString());
    json.data = decodePayload(hexToBytes(json.data));
        
    admin.firestore().collection('raw-device-data')
                     .add(json)
                     .then(() => console.info('Added raw device data'));
    
    return response.status(200).end();
});
```

The whole backend logic is event driven and solely built using functions. Once the data has been persisted to Firestore, we use a series of Cloud functions to further process and aggregate the raw data. Some functions are trigger by the add and update events emitted by Firestore itself, others are trigger by Pub/Sub messages or cron jobs. As you can see from the conceptual architecture diagram we experimented with different runtime environments and languages. For simple functions it is really fast and convenient to write the function in plain JavaScript and use Node as runtime. However, using Go and Java for me felt very natural since these are my home turf.

We also built a small admin dashboard web UI using Vue. Nothing fancy, just a simple timeline view of the received data for each device and a device view with all current device readings. The UI itself is served from a containerized Nginx that is deployed on __Cloud Run__. The following code shows the `cloudbuild.yaml` used to build the Docker image using Kaniko and to deploy the image using the Google Cloud CLI.
```yaml
steps:
  # build Docker image with Kaniko and push to Container Registry
  - name: 'gcr.io/kaniko-project/executor:latest'
    args: ["--dockerfile=./Dockerfile",
           "--cache=true",
           "--destination=gcr.io/lorawan-office-qaware/web-ui:latest"]
  
  # deploy and run image with Cloud Run
  - name: 'gcr.io/cloud-builders/gcloud'
    args: ['run', 'deploy', 'web-ui', '--image', 'gcr.io/lorawan-office-qaware/web-ui', '--region', 'europe-west1', '--platform', 'managed']
```

The data for the UI is exposed via a REST API implemented as a JavaScript function leveraging the Express.js framework. Each API endpoint is a simple function that queries Firestore and returns the result documents as JSON. I was impressed how quick and easy simple CRUD style APIs can be implemented this way.
```javascript
const application = require('./application');
// ... more imports ...
const express = require('express');
const app = express();

// the REST API endpoints
app.get('/applications', application.applications);
app.get('/applications/:applicationid', application.application);
// ... more endpoints ...
app.get(unsupported);
app.post(unsupported);
app.use(options);

exports.api = app;

function unsupported(req, res) {
    res.status(404).send('Unknown API.');
}

function options(req, res) {
    res.set('Access-Control-Allow-Credentials', 'true');
    res.set('Access-Control-Allow-Headers', 'access-control-allow-origin,authorization,content-type')
    const ORIGIN = req.headers.origin;
    res.set('Access-Control-Allow-Origin', ORIGIN)
    res.status(204).send('');
}
```

The final piece of the architecture is to connect further external devices to receive and act upon certain thresholds and events. For this we use the _Cloud IoT Core_ and _Pub/Sub_ APIs from GCP. Each client device (or application) is registered together with its public key at the device manager. The device later authenicates itself using a JSON Web Token (JWT) that is signed with its own matching private key. To communicated with the backend the client connects via the MQTT protocol to receive the commands from the backend. Have a look at the official [Quickstart](https://cloud.google.com/iot/docs/quickstart?hl=en) documentation for further details. 

The following pictures show the final result: a Raspberry Pi Zero W with a connected blink(1) mk3 LED. The Pi runs a small Go program that establishes the MQTT connection and then toggles the LED between red and green depending on the occupancy data sent by the backend. Finally, you do not have to manually turn the sign anymore!

{{< img src="/images/kloampel-00.jpg" alt="Raspberry Pi Zero W with blink(1) mk3" >}}

## Cloud Costs

Of course, there is the initial investment for the hardware. The prices for the sensors vary quite significantly, somewhere between 60 and 180 Euro. But this is a one-time investment. The cloud costs are much much cheaper than this. In an average month the costs are somewhere in the range of 10 Euro cent!
