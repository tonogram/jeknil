const help_message* = """Jeknil - A blog post generator for people with priorities.

Usage:
  jeknil [--options] [files]

Options:
  -t:<dir>, --template:<dir>
    Specify an alternative directory for your template
  -o:<dir>, --output:<dir>
    Specify an alternative directory to output posts
  -e, --example
    Generate an example file to test your template
  -p, --plain
    Generate a plain HTML file, ignoring the template."""

const plain_template* = """<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <meta name="description" content="{description}">
    <title>{title}</title>

</head>
<body>

<i>Generated on {date}</i>
{content}

</body>
</html>"""

const example_template* = """# This is an h1
## This is an h2
### This is an h3
#### This is an h4
##### This is an h5

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc quis feugiat metus. Vestibulum quam erat, sagittis in ipsum sed, congue efficitur nisi. Aliquam nisi quam, fringilla sed fermentum vitae, pulvinar a libero. Vestibulum ac vehicula arcu. Pellentesque fringilla orci sit amet enim placerat, sed volutpat mauris ullamcorper. Duis molestie augue vel tempor luctus. Donec accumsan metus ac augue commodo, sed vehicula ex dictum. Nulla facilisi. Integer ultrices, orci sed imperdiet posuere, purus mauris tincidunt turpis, ut congue neque nunc ut felis. Nam dignissim, libero eu aliquam viverra, dolor justo congue mi, eu commodo urna nisi id nisl. Integer in lorem aliquam, suscipit nisl et, vehicula est. Etiam pulvinar nulla in gravida tristique. Ut lacinia efficitur justo sed euismod. Nunc consectetur libero non dui maximus, in suscipit neque dignissim.

*This is some italicized text.*
**This is some bold text.**
***This is both italicized and bold.***

[Jeknil's Website](https://knaque.dev/jeknil)

Created with love by Knaque

![Knaque Logo](https://knaque.dev/favicons/32.png "Knaque Logo")

```nim
while opt.kind != cmdEnd:
  opt.next()
  case opt.kind
  of cmdArgument: files.add(opt.key)
  of cmdLongOption, cmdShortOption:
    case opt.key
      of "t", "template": templateLocation = opt.val.addSlash()
      of "o", "output": outputLocation = opt.val.addSlash()
      of "e", "example": generateExample = true
      of "p", "plain": generatePlain = true
      else: discard # ignore unknown flags
  of cmdEnd: discard # unreachable state
```
"""