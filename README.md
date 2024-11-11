# qaware-blog-source

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/qaware/qaware-blog-source)


## Generated websites

* [https://blog.qaware.de](https://blog.qaware.de)  
  Target environment of our QAware software engineering blog
* [https://qawareblog-2ixogl4y4q-ey.a.run.app](https://qawareblog-2ixogl4y4q-ey.a.run.app)  
  Testing environment with draft posts included. _(user: qaware, pw: qaware)_

## Write Content

Pre-requisites:
* Github account
* git
* IntelliJ
* hugo (only required if you want test the blog locally --> for installation see details below)

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
:warning: The `--recurse-submodules` is important as the [qaware-blog-theme](https://github.com/qaware/qaware-blog-theme) is included as a git submodule.

```bash
git clone --recurse-submodules https://github.com/<GITHUB_USER>/qaware-blog-source
```

To track more changes in the remote `qaware-blog-theme`, update the locally checked-out submodule with 
```bash
git submodule update --remote
```
Otherwise, you might see templating errors such as
```
failed to extract shortcode: template for shortcode "img" not found
```

### Write your post (with or without hugo) 

If you don't want to use hugo just add and edit your post md-file manually in `content/posts`. Then add the meta data at the beginning of your md-file like in the example below!

If you want to use hugo to generate your new post and to test locally, you'll need to install:

* [Hugo extended](https://gohugo.io/getting-started/installing/) (in doubt: run `hugo version` and check if `extended` is in the version)

Then [get used to Hugo](https://gohugo.io/getting-started/quick-start). 

Now you can use the hugo-commands in your IntelliJ terminal:

1) `hugo new content/posts/<articleTitle>.md` (as file name without blanks, e.g. `hello-world.md`) --> 
this will locally add a new post as a draft in the blog in `content/posts`.
2) edit content: write your blog post in the created md-file
3) `hugo server -D` --> this will start the local webserver and show you the blog locally on http://localhost:1313

### Edit page meta data

The Hugo Generator creates the content page as a markdown file. After running the generator the meta data must be extended.

Generator example:

```md
---
title: "Hello World"
date: 2020-05-11T10:43:02+02:00
author: ""
type: "post"
image: ""
categories: []
tags: []
draft: true
summary: This post shows you how to ...
---

Post text

```

1. Add `lastmod` attribute. Use value of `date` attribute for the first version of your new page.
2. Add `author` attribute. Add a markdown link to your GitHub profile as value.
3. Add `type` attribute with value `post`. Our theme supports more content type. But for the moment we only use `post`.
4. Add `image` attribute. Put an image to the `/static/images` folder and write the filename (without `images/`) into attribute's value. More infos about providing image files can be found in the next chapter.
5. Add `tags`: Select one or more fitting tags for your post: e.g. `Testing`, `Architecture`, `Cloud Native`
6. Add `summary`: Add a short sentence as summary. This will be the description shown under page name and url in search engine result pages.
7. `draft` is initially set to "true", which means that it will only be visible on the test environment [https://qawareblog-2ixogl4y4q-ey.a.run.app](https://qawareblog-2ixogl4y4q-ey.a.run.app) . Set `draft` to false when your post is ready!

Final example:

```md
---
title: "Hello World"
date: 2020-05-11T10:43:02+02:00
lastmod: 2020-05-11T10:43:02+02:00
author: "[Josef Fuchshuber](https://github.com/fuchshuber)"
type: "post"
image: "hello-world.jpg"
tags: ["Framework", "Tutorial", "Java"]
draft: true
summary: An introduction to ... 
---
```

### Add images

Please use only own images, images with creative commons licence or search and download your images by [gettyimages](https://www.gettyimages.de/). Store images for your post in the `static/images` folder with a self explaining file name and refer them in markdown:

```md
{{< img src="/images/hello-world.jpg" alt="Hello World title picture" >}}
```

or as a figure with caption:

```md
{{< figure figcaption="Hello World Caption" >}}
  {{< img src="/images/hello-world.jpg" alt="Hello World title picture" >}}
{{< /figure >}}
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

## Build and run Dockerfile locally

To test the preview dockerfile locally run.

```bash
docker build --tag=qaware-blog-local .
docker run --rm -p 1313:80 qaware-blog-local
open localhost:1313
```
