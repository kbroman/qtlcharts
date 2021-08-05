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
    version <- unlist(utils::packageVersion("qtlcharts"))

    if (length(version) == 3) {
        return(paste(c(version, ".", "-")[c(1, 4, 2, 5, 3)],
            collapse = ""))
    }

    paste(version, collapse = ".")
}
