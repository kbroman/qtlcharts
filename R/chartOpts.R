## chartOpts.R
## Karl W Broman

# add an option to chartOpts, if it's not already present
add2chartOpts <-
function(chartOpts, ...)
{
    dots <- list(...)
    for(newarg in names(dots)) {
        if(!(newarg %in% names(chartOpts)))
          chartOpts <- c(chartOpts, dots[newarg])
    }
    chartOpts
}

# clean off names from chartOpts
# (of non-list components)
stripNames_chartOpts <-
function(chartOpts)
{
    if(!is.null(chartOpts)) {
        for(arg in names(chartOpts)) {
            if(!is.list(chartOpts[[arg]])) {
                names(chartOpts[[arg]]) <- NULL
            }
        }
    }

    chartOpts
}
