## qtlchartsversion
## Karl W Broman

#' print the installed version of R/qtlcharts
#'
#' @return Character string with version number
#'
#' @examples
#' qtlchartsversion()
#'
#' @export
qtlchartsversion <-
function()
{
    version <- unlist(packageVersion("qtlcharts"))

    # make it like #.#-#
    paste(c(version,".","-")[c(1,4,2,5,3)], collapse="")
}
