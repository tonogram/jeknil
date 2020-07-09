<!--
title: "Jeknil's README"
description: "Everything you need to know to get started with Jeknil."
-->

![Jeknil Banner](https://knaque.dev/ext/jeknil/jeknil_banner.png "Jeknil Banner")

[![nimble](https://raw.githubusercontent.com/knaque/nimble-tag-2/master/nimble-tag-2.png)](https://github.com/knaque/nimble-tag-2)

[![version](https://nimble.directory/ci/badges/jeknil/version.svg)](https://nimble.directory/pkg/stalinsort)
[![install test](https://nimble.directory/ci/badges/jeknil/nimdevel/status.svg)](https://github.com/Knaque/stalinsort)
[![doc build](https://nimble.directory/ci/badges/jeknil/nimdevel/docstatus.svg)](https://nimble.directory/docs/stalinsort//stalinsort.html)


Jeknil is a dead-simple static blog post generator designed to be as easy as
possible to use. No dependencies, no unnecessary deployment process, just a
single executable that turns Markdown into HTML.

If you're viewing this at [knaque.dev/jeknil](https://knaque.dev/jeknil), then
you're looking at Jeknil own README turned into nice HTML.
[Repository](https://github.com/knaque/jeknil)

# Installation
Make sure you have both the Nim compiler and the Nimble package manager
installed via `nim -v` and `nimble -v` respectively. If you don't both can be
installed simultaneously [here](https://nim-lang.org/install.html). Once both
are installed, just do `nimble install jeknil` and Jeknil will shortly be made
available in your command line.

## Building from source
Follow the same instructions as above to ensure you have both the Nim compiler 
and Nimble package manager. Once you do, clone this repository, then
navigate to the clone's folder. `nimble install` will automatically download
required libraries, build Jeknil, and install it to your system. Alternatively,
you can also compile Jeknil with `nim c -d:release ./src/jeknil.nim`, but this
method requires both manually installing dependencies and manually adding the
executable to the PATH, so it's not recommended.


# Usage
`jeknil [--options] [file(s)]`

Run `jeknil` without any arguments to display help information, including an
list of each flag and its function.


# Setup guide

## template.html

Whenever Jeknil is run, it checks for a file called `template.html` in the
working directory. This file describes the format that should be used for posts.
This is primarily intended for specifying custom `<head>` data, but can include
any valid HTML.

If you don't want to store your template in your working directory, the default
behavior can be overwritten with the `-t:<dir>` flag.
(i.e. `jeknil -t:./some_dir`)

The key part of `template.html` is variables. Variabes are a word surrounded by
curly brackets, and are used to tell Jeknil where to place different data.
The currently available variables are:
- `{title}` - The title of your post, as defined in its Header*.
- `{description}` - The description of your post, as defined in its Header.
- `{content}` - The actual content of your post, as written in Markdown.
- `{date}` - The date the post was generated in the `YYYY-MM-DD` format.

**Headers will be explained shortly.*

Here is an example of a typical template, including a favicon set, external
fonts, and a code block formatter.
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="{description}">
    <link rel="icon" type="image/png" sizes="16x16" href="../favicons/16.png">
    <link rel="icon" type="image/png" sizes="32x32" href="../favicons/32.png">
    <link rel="icon" type="image/png" sizes="180x180" href="../favicons/180.png">
    <link rel="icon" type="image/png" sizes="192x192" href="../favicons/192.png">
    <link rel="icon" type="image/png" sizes="512x512" href="../favicons/512.png">
    <link rel="stylesheet" href="https://indestructibletype.com/fonts/Jost.css" type="text/css" charset="utf-8" />
    <link href="https://fonts.googleapis.com/css2?family=Fira+Code:wght@300;400;500;600;700&display=swap" rel="stylesheet"> 
    <link rel="stylesheet" href="./assets/prism.css">
    <script src="./assets/prism.js"></script>
    <link rel="stylesheet" href="./assets/style.css">
    <title>knaque's blog - {title}</title>
</head>
<body>
<span class="date"><i>last updated on {date}</i></span> - <a href="../index.html">homepage</a>
{content}
</body>
</html>
```

Once you've made a template, you can test it with `jeknil -e`. This will
generate the file `template-example_<date>.html` with some example content, allowing you
to quickly ensure everything is displaying as it should.

## Writing posts

### The Header

Now it's time to write a post. The only Jeknil-unique part of this process is
the *Header*, which is very similar to Jekyll's *Front Matter*. The Header
starts with `~!` and ends with `!~`, or alternatively with standard HTML
comments. (Jeknil uses whichever it finds first. This is because using these
symbols more than once causes a parsing error.) At the moment, the Header is
used to define the `{title}` and `{description}` variables, therefore a standard
Header would be:

```
~!
title: "An example title"
description: "An example description."
!~
```

You *must* put each in quotes in order for it to be parsed properly. A Header
can be anywhere in the document, but generally it's best to put it at the
beginning.

Everything else is standard Markdown, and most thing should be supported.

### Code Syntax Highlighting

If you put the language just after the opening of a large code block
(i.e.```nim), a class for that language will automatically be added
(`language-nim` in this case), meaning nothing extra is required to use a code
formatter; just include a one in your `template.html` and specify the language
in your Markdown.

## Generating the result

Once you're done writing your post, simply run `jeknil some-post.md` and Jeknil
will output the generated file in your current working directory, with the
format `<header title>_YYYY-MM-DD.html` for the file name.

If you don't want save your generated posts in your working directory, the
default behavior can be overwritten with the `-o:<dir>` flag.
(i.e. `jeknil -o:./some_dir`)

Jeknil can also generate multiple posts at once, simply by listing every post
separated by a space, i.e. (`jeknil post1.md post2.md etc.md`)

---

### If this documentation could be improved in any way, don't hesitate to raise a GitHub issue describing your thoughts.