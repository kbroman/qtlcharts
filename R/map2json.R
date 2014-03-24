## map2json
## Karl W Broman

# Convert marker map to JSON format
#
# Convert a genetic map to JSON format,
# for use with interative graphics, such as \code{\link{iplotMap}}.
# (Largely for internal use.)
#
# @param map An object of class \code{"map"}: a list with each
#   component being a vector of marker positions
# @param ... Additional arguments passed to the
#   \code{\link[RJSONIO]{toJSON}} function
#
# @return A character string with the input in JSON format.  This
#    includes an ordered vector of chromosome names and then the map,
#    organized by chromosome and then by marker.
#
#' @importFrom RJSONIO toJSON
#
# @keywords interface
# @seealso \code{\link{scanone2json}}, \code{\link{pxg2json}}
#
# @examples
# data(hyper)
# map <- pull.map(hyper)
# map_as_json <- map2json(map)
map2json <-
function(map, ...)
  RJSONIO::toJSON(list(chr=names(map), map=map), ...)
