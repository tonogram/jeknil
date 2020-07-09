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
  s.replace("{content}", c).replace("{title}", t).replace("{description}", d)
    .replace("{date}", date)

# error checking for loading template
proc tryLoadTemplate(t: string): string =
  try:
    result = readFile(t & "template.html")
  except IOError:
    quit "Unable to find template.html. Aborting.", QuitFailure


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
    if generatePlain: plain_template
    else: tryLoadTemplate(templateLocation)


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
      var htmlheader: bool
      block CheckHeader:
        let (a, b) = (post.find("<!--").abs(), post.find("~!").abs())
        if a == b:
          quit "File " & file & " appears to be missing a Header. Aborting.",
            QuitFailure
        htmlheader = a < b
      let
        MetaRe = 
          if htmlheader: re"(?s)<!--.+-->"
          else: re"(?s)(~!).+(!~)"
        # "size" of header start and end
        (s, e) =
          if htmlheader: (4, 3)
          else: (2, 2)
        # find start and end of header
        loc = post.findBounds(MetaRe)
        # use slice to ignore start and end, strip potential whitespace, parse
        metadata = getMetadata(post[loc.first+s..loc.last-e].strip())
      title = metadata.getSectionValue("", "title")
      description = metadata.getSectionValue("", "description")
      # skip header completely, strip just in case, turn into html
      content = post[loc.last+1..^1].strip().markdown()
    
    
    # check if any fields are empty
    if title == "" or description == "" or content == "":
      quit "File " & file & " appears to be missing one or more required " &
        "elements (Title, Description, Content). Aborting.", QuitFailure
    

    stdout.write("Writing " & file & "... ")
    # set dir and title, run the replacement
    writeFile(outputLocation & title.makeTitle(),
              jtemplate.replaceVars(title, description, content))
    stdout.write("Done!\n")


  quit "  All finished!", QuitSuccess



else:
  quit help_message, QuitSuccess