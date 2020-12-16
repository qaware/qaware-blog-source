# qaware-blog-source

## Generated websites

* https://blog.qaware.de: Target environment of our QAware software engineering blog
* https://qawareblog-zkop4aqvwa-ez.a.run.app/: Testing environment with draft posts

## Write Content

### Fork our Github Repository

Writers work on a fork of the repository. A fork can be created either via the [web interface](https://github.com/qaware/qaware-blog-source) or with the [GitHub command line tool](https://cli.github.com/).

GitHub CLI example

```bash
gh repo fork qaware/qaware-blog-source
```

After this step, a fork is created for the current GitHub user of the Writer: `https://github.com/<GITHUB_USER>/qaware-blog-source`. To work with it locally on a computer, this fork must first be cloned. If the fork is created with the CLI tool, a clone can at once. When creating the fork via the Web UI, this step must be performed as an extra step.

```bash
git clone --recurse-submodules https://github.com/<GITHUB_USER>/qaware-blog-source
```

### Start with our project  

You'll need to install:

* [Hugo extended](https://github.com/gohugoio/hugo) (in doubt: run `hugo version` and check if `extended` is in the version)

Then [get used to Hugo](https://gohugo.io/getting-started/quick-start). Now you're ready for:

1) `hugo new posts/<articleTitle>.md` (as file name without blanks, e.g. `hello-world.md`)
2) edit content
3) `hugo server -D --minify`

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
---

Post text

```

1. Add `lastmod` attribute. Use value of `date` attribute for the first version of your new page.
2. Add `author` attribute. Add a markdown link to your GitHub profile as value.
3. Add `type` attribute with value `post`. Our theme supports more content type. But for the moment we only use `post`.
4. Add `image` attribute. Put an image to the `/static/images` folder and write the filename (without `images/`) into attribute's value. More infos about providing image files can be found in the next chapter.
5. Add `tags`: Select one or more fitting tags for your post: e.g. `Testing`, `Architecture`, `Cloud Native`

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
