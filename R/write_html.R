## write_html (all internal functions)
## Karl W Broman

# Write the entire initial part of the file
write_top <-
function(file, onefile=FALSE, title='',
         links=NULL, panels=NULL, charts=NULL,
         chartdivid='chart', caption='', print=FALSE)
{
  if(print) file <- ""
  else {
    if(missing(file) || is.null(file))
      file <- tempfile(tmpdir=tempdir(), fileext='.html')
    else file <- path.expand(file)

    if(file.exists(file))
      stop('The file already exists; please remove it first: ', file)
  }

  if(!print) {
    write_html_top(file, title=title)
    if("d3" %in% links) link_d3(file, onefile=onefile, print=print)
    if("d3tip" %in% links) link_d3tip(file, onefile=onefile, print=print)
    if("colorbrewer" %in% links) link_colorbrewer(file, onefile=onefile, print=print)
    if("panelutil" %in% links) link_panelutil(file, onefile=onefile, print=print)
    for(panel in panels)
      link_panel(panel, file, onefile=onefile, print=print)
    for(chart in charts)
      link_chart(chart, file, onefile=onefile, print=print)
  }

  append_html_middle(file, title, chartdivid, print=print)

  append_caption(caption, file)

  file
}



# Write the initial part of an html file
#
# @param file Character vector with file name, will be over-written
# @param title Character vector with title for html page
# @param print If TRUE, print rather than writing to file
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
function(file, cssfile, onefile=FALSE, print=FALSE)
{
  if(!onefile) { # just include link
    text <- c('<link rel="stylesheet" type="text/css" ',
              'href="', cssfile, '">\n')
    cat(text, file=file, append=TRUE, sep='')
  }
  else {
    cat('<style type="text/css">\n', file=file, append=TRUE)

    if(print) {
      cat(readLines(cssfile, warn=FALSE), sep="\n")
    } else {
      file.append(file, cssfile)
    }

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
function(file, jsfile, charset, onefile, print=FALSE)
{
  if(!onefile) {
    text <- '<script '
    if(!missing(charset) && !is.null(charset)) text <- c(text, 'charset="', charset, '" ')
    text <- c(text, 'type="text/javascript" src="', jsfile, '"></script>\n')

    cat(text, file=file, append=TRUE, sep='')
  }
  else {
    text <- '<script '
    if(!missing(charset) && !is.null(charset)) text <- c(text, 'charset="', charset, '" ')
    text <- c(text, 'type="text/javascript">\n')
    cat(text, file=file, append=TRUE, sep='')

    if(print) {
      cat(readLines(jsfile, warn=FALSE), sep="\n")
    } else {
      file.append(file, jsfile)
    }

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
function(file, title, div, print=print)
{
  if(print) text <- ''
  else {
    text <- '</head>\n\n<body>\n'
    if(!missing(title) && !is.null(title)) text <- c(text, '<h3>', title, '</h3>\n\n')
  }
  text <- c(text, '<p class="loading">Loading...</p>\n\n')
  if(!missing(div) && !is.null(div)) text <- c(text, '<div id="', div, '" class="qtlcharts"></div>\n\n')

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
function(file, print=FALSE)
{
  cat('<script type="text/javascript">d3.selectAll("p.loading").remove();</script>\n\n', file=file, append=TRUE)
  if(!print) cat('</body>\n</html>\n', file=file, append=TRUE)

  invisible(NULL)
}

# Append a paragraph to an html file
#
# @param file File to which to write
# @param ... The text to put within the paragraph
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
  if(!missing(id) && !is.null(id)) text <- c(text, ' id="', id, '"')
  if(!missing(class) && !is.null(class)) text <- c(text, ' class="', class, '"')
  text <- c(text, '>')
  cat(text, file=file, append=TRUE, sep='')
  cat(..., file=file, append=TRUE, sep='')
  cat('</', tag, '>\n', file=file, append=TRUE, sep='')

  invisible(NULL)
}

# Append chartOpts data to an html file
#
# @param file File to which to write
# @param chartOpts The options (a list)
# @param digits Number of digits in JSON; passed to \code{\link[jsonlite]{toJSON}}
#
# @return None (invisible NULL)
# @keywords IO
#' @importFrom jsonlite toJSON
#
append_html_chartopts <-
function(file, chartOpts, chartdivid='chart', digits=2)
{
  if(is.null(chartOpts))
    chartOpts <- list("null" = NULL)

  opts_json <- strip_whitespace( toJSON( opts4json(chartOpts), digits=digits, na="null") )

  cat('\n<script type="text/javascript">\n', file=file, append=TRUE)
  cat(chartdivid, '_chartOpts = ', opts_json, ';', file=file, append=TRUE, sep='')
  cat('\n</script>\n', file=file, append=TRUE)

  invisible(NULL)
}

# reformat chartOpts, to prepare for export as JSON object
#
# named vector -> list
# vectors of length 1 "unboxed" (scalar rather than array)
# NULL -> unbox(NA) [converted to null]
#
#' @importFrom jsonlite unbox
#
opts4json <-
function(opts)
{
  # NULL -> unbox(NA)
  if(is.null(opts)) return(jsonlite::unbox(NA))

  # NA -> unbox(NA)
  if(!is.list(opts) && length(opts)==1 && is.null(names(opts)))
    return(jsonlite::unbox(opts))

  if(!is.null(names(opts)))
    opts <- as.list(opts)

  for(i in seq(along=opts)) {
    if(!is.list(opts[[i]]) && length(opts[[i]])==1)
      opts[[i]] <- jsonlite::unbox(opts[[i]])
    else
      opts[[i]] <- opts4json(opts[[i]])
  }

  opts
}


# functions to simplify linking/incorporating js/css code
link_d3 <-
function(file, onefile=FALSE, print=FALSE)
{
  suppressWarnings(append_html_jslink(file, system.file('d3', 'd3.min.js', package='qtlcharts'),
                     charset='utf-8', onefile=onefile, print=print))
}

link_d3tip <-
function(file, onefile=FALSE, print=FALSE)
{
  append_html_csslink(file, system.file('d3-tip', 'd3-tip.min.css', package='qtlcharts'),
                      onefile=onefile, print=print)
  append_html_jslink(file, system.file('d3-tip', 'd3-tip.min.js', package='qtlcharts'),
                     onefile=onefile, print=print)
}

link_colorbrewer <-
function(file, onefile=FALSE, print=FALSE)
{
  append_html_csslink(file, system.file('colorbrewer', 'colorbrewer.css', package='qtlcharts'),
                     onefile=onefile, print=print)
  append_html_jslink(file, system.file('colorbrewer', 'colorbrewer.js', package='qtlcharts'),
                     onefile=onefile, print=print)
}

link_panelutil <-
function(file, onefile=FALSE, print=FALSE)
{
  cssfile <- system.file('panels', 'panelutil.css', package='qtlcharts')
  if(file.exists(cssfile))
    append_html_csslink(file, cssfile, onefile=onefile, print=print)

  jsfile <- system.file('panels', 'panelutil.js', package='qtlcharts')
  if(file.exists(jsfile))
    append_html_jslink(file, jsfile, onefile=onefile, print=print)
}

link_panel <-
function(panel, file, onefile=FALSE, print=FALSE)
{
  jsfile <- system.file('panels', panel, paste0(panel, '.js'), package='qtlcharts')
  if(file.exists(jsfile))
    append_html_jslink(file, jsfile, onefile=onefile, print=print)
}

link_chart <-
function(chart, file, onefile=FALSE, print=print)
{
  cssfile <- system.file('charts', 'charts.css', package='qtlcharts')
  if(file.exists(cssfile))
    append_html_csslink(file, cssfile, onefile=onefile, print=print)

  cssfile <- system.file('charts', paste0(chart, '.css'), package='qtlcharts')
  if(file.exists(cssfile))
    append_html_csslink(file, cssfile, onefile=onefile, print=print)

  jsfile <- system.file('charts', paste0(chart, '.js'), package='qtlcharts')
  if(file.exists(jsfile))
    append_html_jslink(file, jsfile, onefile=onefile, print=print)
}

append_caption <-
function(caption, file)
{
  append_html_p(file, paste(caption, collapse=""),
                tag='p', class='caption')#, id=NULL)
}

strip_whitespace <-
function(x)
{
  if(length(x) > 1)
    return(vapply(x, strip_whitespace, ""))

  # if no quotes:
  if(length(grep("[\'\"]", x)) == 0)
    return(gsub("\\s", "", x))

  # otherwise, double-quotes get converted to \'
  spl <- strsplit(x, "[\"\']")[[1]]
  tosub <- seq(1, length(spl), by=2)
  spl[tosub] <- vapply(spl[tosub], function(a) gsub("\\s", "", a), "")

  paste(spl, collapse="\'")
}
