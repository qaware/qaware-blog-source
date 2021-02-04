---
title: "How to add a sticky header to a table using react-bootstrap"
date: 2021-01-27
lastmod: 2021-01-27
author: "[Kilian Schneider](https://github.com/koax064)"
type: "post"
image: "sticky-header-table.png"
tags: ["Java", "React", "Bootstrap", "UI"]
aliases:
    - /posts/2021-01-27-react-bootstrap-sticky-table-header/
summary: This post shows you how to handle common problems when adding a sticky header to a table using react-bootstrap.
draft: true
---
Tables are a popular choice within the design of UIs to visualize and structure data in a clear way and to allow its manipulation via different actions by the user. As soon as several rows of data will be displayed and scrolling through the table gets necessary, there is a particular feature for each table that can significantly increase its clearness and usability: a *sticky header* showing the column names when scrolling would have pushed the header row out of the user’s view.

## Solution

In the case the application’s UI is based on React as well as Bootstrap is in usage to represent the tables therein, it exists in principle a straightforward way to add a sticky header to your table. Bootstrap offers a standard CSS class `sticky-top` which leads when applied to the header cells of the respective table (`<th>` tag) to the desired sticky header.

## Problems

But why is it worth writing a blog post about more or less the same things which are also described within the Bootstrap documentation? The answer is that the mentioned straightforward way does not always work directly and as described which is proven by many entries on the same topic in the relevant forums.
So, if this also occurs in your case, the cause could be counteracting and competing CSS classes applied in the context around your table. The recommended procedure to check if it is valid is mainly trial-and-error driven. Presuming the `sticky-top` class has been added to the header cells, other Bootstrap utility classes on the table’s ancestors should be deactivated and activated one after another to find the culprit. However, there are some candidates that are especially suspicious: the `overflow` CSS properties and all CSS classes using or containing these properties. Once the causing CSS class is finally found, consideration can be given to how it can be replaced or used differently to preserve the functionality it triggered and at the same time add the sticky header successfully.

## Side notes

Ultimately, two further points are worth mentioning. Firstly, the sticky header can also be incorporated with the same procedure in case a Navbar (a Bootstrap navigation header) is placed above. This can easily be done by adding an offset of the height of the Navbar to the top of the sticky header. Secondly, as soon as the sticky header is included, the CSS property `z-index` of all elements of the page should be checked. They should still be visible as desired in all respective scenarios instead of being potentially covered because of the relatively high default value of `z-index` when `sticky-top` is in usage.