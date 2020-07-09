import os, parseopt, parsecfg, strutils, streams, times, re, markdown, text,
  strformat

# current date, no more constant checking
let date = getDateStr()

# adds / if needed
proc addSlash(s: string): string =
  result = s
  if s[s.len-1] != '/': result.add('/')

# shorthand for creating a stream & config
proc getMetadata(f: string): Config =
  result = loadConfig(newStringStream(f))

# replace certain characters for a friendlier title
template makeTitle(s: string): string =
  s.replace(" ", "-").replace(".", "").replace("'", "")
    .toLowerAscii() & '_' & date & ".html"

# shorthand for replacing vars with values
template replaceVars(s, t, d, c: string): string =
  s.replace("{title}", t).replace("{description}", d).replace("{content}", c)
    .replace("{date}", date)


if paramCount() > 0:
  var
    # default values
    files: seq[string]
    outputLocation = getCurrentDir().addSlash()
    templateLocation = getCurrentDir().addSlash()
    generateExample = false
    generatePlain = false

  block ParseOptions:
    # get options and adjust above vars accordingly
    var opt = initOptParser(commandLineParams())
    opt.next()
    while opt.kind != cmdEnd:
      case opt.kind
      # add files to list
      of cmdArgument: files.add(opt.key)
      of cmdLongOption, cmdShortOption:
        case opt.key
        of "t", "template": templateLocation = opt.val.addSlash()
        of "o", "output": outputLocation = opt.val.addSlash()
        of "e", "example": generateExample = true
        of "p", "plain": generatePlain = true
        else: discard # ignore unknown flags
      of cmdEnd: discard # unreachable state
      opt.next()


  if generateExample: files = @["Template Example"]
  # make sure there's at least 1 file
  if files.len == 0: quit help_message, QuitSuccess
  

  # set template
  let jtemplate =
    if generatePlain:
      plain_template
    else:
      readFile(templateLocation & "template.html")

  for file in files:
    # create empty values
    var
      title: string
      description: string
      content: string

    # set defaults if applicable
    if generateExample:
      title = "Template Example"
      description = "This is an example post for testing Jeknil templates."
      content = example_template.markdown()
    # otherwise find them in the file
    else:
      
      let
        # load the file
        post = readFile(file)
        # regex for finding header, depends on which comes first
        htmlheader =
          if post.find("<!--") < post.find("~!"): true
          else: false
        MetaRe =
          if htmlheader: re"(?s)<!--.+-->"
          else: re"(?s)~!.+!~"
        # "size" of header start and end
        s = 
          if htmlheader: 4
          else: 2
        e = if htmlheader: 3
          else: 2
        
        # find start and end of header
        loc = post.findBounds(MetaRe)
        # use slice to ignore <!-- -->, strip potential whitespace, getMetadata()
        metadata = getMetadata(post[loc.first+s..loc.last-e].strip())
      title = metadata.getSectionValue("", "title")
      description = metadata.getSectionValue("", "description")
      # skip header completely, strip just in case, turn into html
      content = post[loc.last+1..^1].strip().markdown()
    
    block CheckEmptyFields:
    # check if any fields are empty, print message and skip file if so
      let
        has_title = title != ""
        has_desc = description != ""
        has_content = content != ""
      if not has_title or not has_desc or not has_content:
        echo &"""/!\ One or more elements are missing in file {file}:
        Has title? {has_title}
  Has description? {has_desc}
      Has content? {has_content}
Skipping file."""
        break
    
    stdout.write("Writing " & file & "... ")
    # set dir and title, run the replacement
    writeFile(outputLocation & title.makeTitle(),
              jtemplate.replaceVars(title, description, content))
    stdout.write("✓\n")

  quit "  All done!", QuitSuccess

else:
  quit help_message, QuitSuccess