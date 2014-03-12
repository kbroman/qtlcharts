## scanone2json
## Karl W Broman

# Convert scanone output to json format
#
# Convert the results of a single-QTL genome scan, as output by
# \code{\link[qtl]{scanone}}, to JSON format, for use with
# interactive graphics, such as \code{\link{iplotScanone}}.
# (Largely for internal use.)
#
# @param output An object of class \code{"scanone"}, as output by \code{\link[qtl]{scanone}}.
# @param \dots Additional arguments passed to \code{\link[RJSONIO]{toJSON}}.
#
# @return A character string with the input in JSON format.
#
#' @importFrom RJSONIO toJSON
#
# @examples
# data(hyper)
# hyper <- calc.genoprob(hyper)
# out <- scanone(hyper, method="hk")
# out_as_json <- scanone2json(out)
#
# @seealso \code{\link{pxg2json}}
#
# @keywords interface
scanone2json <-
function(output, ...)
{
  # marker names: replace pseudomarkers with blanks
  mnames <- rownames(output)
  pmarkers <- grep("^c.+\\.loc-*[0-9]+", mnames)
  mnames[pmarkers] <- ""

  # chromosome names
  chrnames <- as.character(unique(output[,1]))

  RJSONIO::toJSON(c(list(chrnames = chrnames), as.list(output), list(markernames = mnames)), ...)
}
