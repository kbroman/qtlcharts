## setScreenSize
## Karl Broman

#' Set default maximum screen size
#'
#' Set the default screen size as a global option.
#'
#' @param size Character vector representing screen size (normal,
#'   small, large). Ignored if height and width are provided.
#' @param height (Optional) Height in pixels
#' @param width (Optional) Width in pixels
#'
#' @return None.
#'
#' @keywords utilities
#'
#' @examples
#' setScreenSize("large")
#'
#' @details Used to set a global option, `qtlchartsScreenSize`, that
#' contains the maximum height and maximum width for a chart in the
#' browser.
#'
#' `"small"`, `"normal"`, and `"large"` correspond to 600x900, 700x1000, and
#' 1200x1600, for height x width, respectively.
#'
#' @export
setScreenSize <-
    function(size=c("normal", "small", "large"),
             height, width)
{
    if(!missing(height) && !is.null(height) && !is.na(height) && height > 0 &&
       !missing(width) && !is.null(width) && !is.na(width) && width > 0)
        screensize <- list(height=height, width=width)
    else {
        size <- match.arg(size)
        screensize <- switch(size,
                             small=  list(height= 600, width= 900),
                             normal= list(height= 700, width=1000),
                             large=  list(height=1200, width=1600))
    }

    message("Set screen size to height=", screensize$height,
            " x width=", screensize$width)
    options(qtlchartsScreenSize=screensize)
}

# returns the default screen size saved with setScreenSize()
getScreenSize <-
    function()
{
    screensize <- getOption("qtlchartsScreenSize")
    if(is.null(screensize)) {
        setScreenSize()
        screensize <- getOption("qtlchartsScreenSize")
    }

    screensize
}

# get the plot size for a given aspect ratio that will fit within the
# maximum screen size set with setScreenSize
getPlotSize <-
    function(aspectRatio) # aspectRatio = width/height (generally > 1)
{
    screensize <- getScreenSize()

    if(screensize$height*aspectRatio <= screensize$width)
            return( list(height=screensize$height, width=screensize$height*aspectRatio) )
     list(height=screensize$width/aspectRatio, width=screensize$width)

}
