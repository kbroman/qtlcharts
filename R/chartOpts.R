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
