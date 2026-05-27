# qaware-blog-source

## Write Content

Pre-requisites:
* Github account
* git
* Text- or code editor for writing markdown files

### Fork our Github Repository

Writers work on a fork of the repository (and then later create a pull request for merging). 

A fork can be created either 
* via the [web interface](https://github.com/qaware/qaware-blog-source) (click on the fork button on the right side and then select your GitHub account) or
* with the [GitHub command line tool](https://cli.github.com/).

GitHub CLI example

```bash
gh repo fork qaware/qaware-blog-source
```

After this step, a fork is created for the current GitHub user of the Writer: `https://github.com/<GITHUB_USER>/qaware-blog-source`. 

To work with it locally on a computer, this fork must first be cloned. 

```bash
git clone https://github.com/<GITHUB_USER>/qaware-blog-source
```

### Write your post 

1. Create a new folder `<YOUR-POST-TITLE>` in the posts folder
2. Create a new markdown file `<YOUR-POST-TITLE>.md` in this folder. Please use our markdown template in folder "post-template".
3. Start writing

#### Edit page meta data

Template:

```md
---
title: "Hello World"
author: ""
tags: []
summary: This post shows you how to ...
---

Post text
```

1. Update `title` attribute with the full title of your post.
2. Update `author` attribute. Add a markdown link to your QAware website, LinkedIn or GitHub profile as value.
3. Update `tags`: Select one or more fitting tags for your post: e.g. `Testing`, `Architecture`, `Cloud Native`
6. Update `summary`: Add a short sentence as summary. This will be the description shown under page name and url in search engine result pages.

Final example:

```md
---
title: "Hello World"
author: "[Josef Fuchshuber](https://github.com/fuchshuber)"
tags: ["Framework", "Tutorial", "Java"]
summary: An introduction to funny hello world post
---
```

### Add images

Please use only own images, images with creative commons licence or search and download your images by [gettyimages](https://www.gettyimages.de/). Store images for your post folder with a self explaining file name and refer them in markdown:

```md
![This is my hello world picture](hello-world.png)
```

Please insert the title image right before your first heading, as shown in the template

```md
![Title image](title-image.png)
```

### Create pull request

It is the best to work only on one post at a time and after the work on this post is finished for the time, create a pull request with the changes for the upstream respository.

1. Commit & push all changes to your fork
2. Create pull request

```bash
gh pr create

Creating pull request for master into master in qaware/qaware-blog-source

? Title Describes pull request creation
? What's next? Submit
https://github.com/qaware/qaware-blog-source/pull/20
```

### Update your fork

Fetch branches and commits from the upstream repo (`qaware/qaware-blog-source`). You’ll be storing the commits to master in a local branch upstream/master:

```bash
git fetch upstream
```

Checkout your fork’s local master, then merge changes from upstream/master into it.

```bash
git checkout master
git merge upstream/master
```

Push changes to update your fork on Github.

```bash
git push
```
