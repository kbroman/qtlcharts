## convert_scanone
## Karl W Broman

# Convert scanone output to a list format for interactive visualization
#
# Convert the results of a single-QTL genome scan, as output by
# \code{\link[qtl]{scanone}}, to a list format, for use with
# interactive graphics, such as \code{\link{iplotScanone}}.
# (Largely for internal use.)
#
# @param output An object of class \code{"scanone"}, as output by
#   \code{\link[qtl]{scanone}}.
#
# @return A list with the data reformatted
#
# @keywords interface
#
# @examples
# library(qtl)
# data(hyper)
# hyper <- calc.genoprob(hyper, step=1)
# out <- scanone(hyper)
# out_as_list <- convert_scanone(out)
convert_scanone <-
function(output)
{
    # marker names: replace pseudomarkers with blanks
    mnames <- rownames(output)
    pmarkers <- grep("^c.+\\.loc-*[0-9]+", mnames)
    mnames[pmarkers] <- ""

    # chromosome IDs factor -> character
    output[,1] <- as.character(output[,1])

    # chromosome names
    chrnames <- unique(output[,1])

    # lod scores
    lod <- as.matrix(output[,-(1:2)])
    dimnames(lod) <- NULL

    # lod column names
    lodnames <- names(output)[-(1:2)]
    if(length(lodnames) != length(unique(lodnames)))
        warning("lod column names are not unique")

    list(chr=as.character(output[,1]),
         pos=output[,2],
         lod=lod,
         marker=mnames,
         chrname=chrnames,
         lodnames=lodnames)
}
