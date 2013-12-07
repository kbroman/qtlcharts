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
# @return None (invisible NULL)
# @keywords IO
append_html_csslink <-
function(file, cssfile)    
{
  text <- c('    <link rel="stylesheet" type="text/css" ',
            'href="', cssfile, '">\n')
  cat(text, file=file, append=TRUE, sep='')

  invisible(NULL)
}

# Append javascript link to an html file
#
# @param file File to which the link will be written
# @param jsfile Path to the jsfile
# @param charset Optional character set
# @return None (invisible NULL)
# @keywords IO
# @examples
# \dontrun{append_html_jslink("index.html", "d3.min.js", "utf-8")}
append_html_jslink <-
function(file, jsfile, charset)
{
  text <- '    <script '
  if(!missing(charset)) text <- c(text, 'charset="', charset, '" ')
  text <- c(text, 'type="text/javascript" src="', jsfile, '"></script>\n') 

  cat(text, file=file, append=TRUE, sep='')

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
