## convert4iboxplot
## Karl W Broman

# Convert data to a list format for iboxplot vis
#
# @param dat Data matrix (individuals x variables)
# @param qu Quantiles to plot (All with 0 < qu < 0.5)
# @param orderByMedian If TRUE, reorder individuals by their median
# @param breaks Number of bins in the histograms, or a vector of
#     locations of the breakpoints between bins (as in \code{\link[graphics]{hist}})
#
# @return Data formated as a list
#
# @keywords interface
# @seealso \code{\link{iboxplot}}
#
# @examples
# n.ind <- 500
# n.gene <- 10000
# expr <- matrix(rnorm(n.ind * n.gene, (1:n.ind)/n.ind*3), ncol=n.gene)
# dimnames(expr) <- list(paste0("ind", 1:n.ind),
#                        paste0("gene", 1:n.gene))
# geneexpr_data <- convert4iboxplot(expr)
convert4iboxplot <-
function(dat, qu = c(0.001, 0.01, 0.1, 0.25), orderByMedian=TRUE,
         breaks=251)
{
    if(is.null(rownames(dat)))
        rownames(dat) <- paste0(1:nrow(dat))

    if(orderByMedian)
        dat <- dat[order(apply(dat, 1, median, na.rm=TRUE)),,drop=FALSE]

    # check quantiles
    if(any(qu <= 0)) {
        warning("qu should all be > 0")
        qu <- qu[qu > 0]
    }

    if(any(qu >= 0.5)) {
        warning("qu should all by < 0.5")
        qu <- qu[qu < 0.5]
    }

    qu <- sort(c(qu, 0.5, rev(1-qu)))
    quant <- apply(dat, 1, stats::quantile, qu, na.rm=TRUE)

    # counts for histograms
    if(length(breaks) == 1)
        breaks <- seq(min(dat, na.rm=TRUE), max(dat, na.rm=TRUE), length=breaks+1)
    else { # make sure all values are within range
        if(any(!is.na(dat) & (dat > max(breaks) | dat < min(breaks)))) {
            warning("breaks do not span the range of the data")
            dat[dat > max(breaks) | dat < min(breaks)] <- NA
        }
    }
    counts <- apply(dat, 1, function(a) graphics::hist(a, breaks=breaks, plot=FALSE)$counts)

    ind <- rownames(dat)

    dimnames(quant) <- dimnames(counts) <- NULL

    # data structure for iboxplot
    list(ind=ind, qu=qu, breaks=breaks, quant=quant,
         counts=t(counts))
}
