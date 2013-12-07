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
  cat('<!DOCTYPE html>\n<html lang="en">\n<head>\n    <meta charset="utf-8">\n',
      file=file)

  cat('    <title>', title, '</title>\n', file=file, append=TRUE)

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
  cat('    <link rel=stylesheet type="text/css" ', file=file, append=TRUE)
  cat('src="', cssfile, '">', file=file, append=TRUE, sep='')
  cat('</link>\n', file=file, append=TRUE)

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
  cat('    <script ', file=file, append=TRUE)
  if(!missing(charset))
    cat('charset="', charset, '" ', file=file, append=TRUE, sep='')
  cat('type="text/javascript" src="', jsfile, "></script>\n", file=file, append=TRUE, sep='')

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
  cat('</head>\n\n<body>\n', file=file, append=TRUE)
  if(!missing(title))
    cat('<h3>', title, '</h3>\n\n', file=file, append=TRUE, sep='')
  if(!missing(div))
    cat('<div id="', div, '></div>\n\n', file=file, append=TRUE, sep='')

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
