## write_html (all internal functions)
## Karl W Broman

# Write the initial part of an html file
#
# @param file Character vector with file name, will be over-written
# @param title Character vector with title for html page
# @return Returns the file name (invisibly)
# @keywords IO
# @examples
# \dontrun{file <- write_html_top(title="QTL chart")}
write_html_top <-
function(file=tempfile(tmpdir=tempdir(), fileext=".html"), title="qtlcharts chart")
{
  text <- c('<!DOCTYPE html>\n<html lang="en">\n<head>\n    <meta charset="utf-8">\n',
            '    <title>', title, '</title>\n')

  cat(text, file=file, sep='')

  # return file name invisibly
  invisible(file)
}

# Append css link to an html file
#
# @param file File to which the link will be written
# @param cssfile Path to the cssfile
# @param onefile If TRUE, include the text of the cssfile within file
# @return None (invisible NULL)
# @keywords IO
append_html_csslink <-
function(file, cssfile, onefile=FALSE)
{
  if(!onefile) { # just include link
    text <- c('    <link rel="stylesheet" type="text/css" ',
              'href="', cssfile, '">\n')
    cat(text, file=file, append=TRUE, sep='')
  }
  else {
    cat('<style type="text/css">\n', file=file, append=TRUE)
    file.append(file, cssfile)
    cat('</style>\n', file=file, append=TRUE)
  }

  invisible(NULL)
}

# Append javascript link to an html file
#
# @param file File to which the link will be written
# @param jsfile Path to the jsfile
# @param charset Optional character set
# @param onefile If true, include the text of the jsfile within file
# @return None (invisible NULL)
# @keywords IO
# @examples
# \dontrun{append_html_jslink("index.html", "d3.min.js", "utf-8")}
append_html_jslink <-
function(file, jsfile, charset, onefile)
{
  if(!onefile) {
    text <- '    <script '
    if(!missing(charset)) text <- c(text, 'charset="', charset, '" ')
    text <- c(text, 'type="text/javascript" src="', jsfile, '"></script>\n') 

    cat(text, file=file, append=TRUE, sep='')
  }
  else {
    text <- '    <script '
    if(!missing(charset)) text <- c(text, 'charset="', charset, '" ')
    text <- c(text, 'type="text/javascript">\n')
    cat(text, file=file, append=TRUE, sep='')

    file.append(file, jsfile)

    cat('</script>\n', file=file, append=TRUE) 
  }

  invisible(NULL)
}

# Append javascript code to an html file
#
# @param file File to which the code will be written
# @return None (invisible NULL)
# @keywords IO
# @examples
# \dontrun{append_html_jscode("index.html", "d3.min.js", "utf-8")}
append_html_jscode <-
function(file, ...)
{
  cat('\n<script type="text/javascript">\n', file=file, append=TRUE)
  cat(..., file=file, append=TRUE, sep='')
  cat('\n</script>\n', file=file, append=TRUE)

  invisible(NULL)
}

# Append middle part of an html file
#
# @param file File name
# @param title Optional h3 title
# @param div Optional id for a div following the title
# @return None (invisible NULL)
# @keywords IO
# \examples
# \dontrun{append_html_middle("index.html", "QTL chart", "chart")}
append_html_middle <-
function(file, title, div)
{
  text <- '</head>\n\n<body>\n'
  if(!missing(title)) text <- c(text, '<h3>', title, '</h3>\n\n')
  if(!missing(div)) text <- c(text, '<div id="', div, '"></div>\n\n')

  cat(text, file=file, append=TRUE, sep='')

  invisible(NULL)
}

# Append the bottom bit of an html file
#
# @param file File to which to write
# @return None (invisible NULL)
# @keywords IO
# @examples
# \dontrun{append_html_bottom("index.html")}
append_html_bottom <-
function(file)
{
  cat('</body>\n</html>\n', file=file, append=TRUE)

  invisible(NULL)
}

# Append a paragraph to an html file
#
# @param file File to which to write
# @param \dots The text to put within the paragraph
# @param tag The type of object to add
# @param id Optional id
# @param class Optional class
# @param style Optional style
# @return None (invisible NULL)
# @keywords IO
# @examples
# \dontrun{append_html_p("index.html", "Some text.")}
append_html_p <-
function(file, ..., tag="p", id, class, style)
{
  text <- c('<', tag)
  if(!missing(id)) text <- c(text, ' id="', id, '"')
  if(!missing(class)) text <- c(text, ' class="', class, '"')
  text <- c(text, '>')
  cat(text, file=file, append=TRUE, sep='')
  cat(..., file=file, append=TRUE, sep='')
  cat('</', tag, '>\n', file=file, append=TRUE, sep='')

  invisible(NULL)
}

# Append jsOpts data to an html file
#
# @param file File to which to write
# @param jsOpts The options (a list)
# @return None (invisible NULL)
# @keywords IO
append_html_jsopts <-
function(file, jsOpts)
{
  if(is.null(jsOpts))
    jsOpts <- list("null" = NULL)
  
  cat('\n<script type="text/javascript">\n', file=file, append=TRUE)
  cat('jsOpts = ', toJSON(jsOpts), ';', file=file, append=TRUE, sep='')
  cat('\n</script>\n', file=file, append=TRUE)

  invisible(NULL)
}
      
