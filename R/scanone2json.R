## scanone2json
## Karl W Broman

# Convert scanone output to json format
#
# Convert the results of a single-QTL genome scan, as output by
# \code{\link[qtl]{scanone}}, to JSON format, for use with
# interactive graphics, such as \code{\link{iplotScanone}}.
# (Largely for internal use.)
#
# @param output An object of class \code{"scanone"}, as output by
#   \code{\link[qtl]{scanone}}.
# @param ... Additional arguments passed to
#   \code{\link[RJSONIO]{toJSON}}.
#
# @return A character string with the input in JSON format.
#
#' @importFrom RJSONIO toJSON
#
# @keywords interface
# @seealso \code{\link{pxg2json}}
#
# @examples
# data(hyper)
# hyper <- calc.genoprob(hyper, step=1)
# out <- scanone(hyper)
# out_as_json <- scanone2json(out)
scanone2json <-
function(output, ...)
{
  # marker names: replace pseudomarkers with blanks
  mnames <- rownames(output)
  pmarkers <- grep("^c.+\\.loc-*[0-9]+", mnames)
  mnames[pmarkers] <- ""

  # chromosome names
  chrnames <- as.character(unique(output[,1]))

  # lod column names
  lodnames <- names(output)[-(1:2)]
  if(length(lodnames) != length(unique(lodnames)))
    warning("lod column names are not unique")

  RJSONIO::toJSON(c(list(chrnames = chrnames, lodnames=lodnames),
                    as.list(output), list(markernames = mnames)), ...)
}
