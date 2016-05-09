## convert_map
## Karl W Broman

# Convert marker map to list for use in interactive plot
#
# Convert a genetic map to format
# for use with interative graphics, such as \code{\link{iplotMap}}.
# (Largely for internal use.)
#
# @param map An object of class \code{"map"}: a list with each
#   component being a vector of marker positions
#
# @return Map in special format for using in \code{\link{iplotMap}},
#    includes ordered vectors of chromosome IDs, marker positions, and
#    marker names, and then the distinct chromosome IDs in order
#
# @keywords interface
#
# @examples
# library(qtl)
# data(hyper)
# map <- pull.map(hyper)
# map_reformatted <- convert_map(map)
convert_map <-
function(map) {
    chrnames <- names(map)

    # remove the A/X classes
    map <- lapply(map, unclass)

    chr <- rep(names(map), vapply(map, length, 1))
    names(chr) <- NULL

    pos <- unlist(map)
    names(pos) <- NULL

    mnames <- unlist(lapply(map, names))
    names(mnames) <- NULL

    list(chr=chr, pos=pos, marker=mnames, chrname=chrnames)
}
