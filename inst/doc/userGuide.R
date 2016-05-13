## ----load_library--------------------------------------------------------
library(qtlcharts)

## ----geneExpr_data-------------------------------------------------------
data(geneExpr)

## ----split_geneExpr------------------------------------------------------
expr <- geneExpr$expr
geno <- geneExpr$genotype

## ----iplotCorr_reordered, eval=FALSE-------------------------------------
## iplotCorr(expr, reorder=TRUE)

## ----iplotCorr_reordered_with_genotype, eval=FALSE-----------------------
## iplotCorr(expr, geno, reorder=TRUE)

## ----iplotCorr_specify_file, eval=FALSE----------------------------------
## corrplot <- iplotCorr(expr, reorder=TRUE)
## htmlwidgets::saveWidget(corrplot, file="~/Desktop/iplotCorr_example.html")

## ----iplotCorr_now_view, eval=FALSE--------------------------------------
## corrplot

## ----iplotCorr_height, eval=FALSE----------------------------------------
## iplotCorr(expr, reorder=TRUE, chartOpts=list(height=600))

## ----iplotCorr_scatcolors, eval=FALSE------------------------------------
## iplotCorr(expr, reorder=TRUE,
##           chartOpts=list(scatcolors="lightblue"))

## ----iplotCorr_height_and_scatcolors, eval=FALSE-------------------------
## iplotCorr(expr, reorder=TRUE,
##           chartOpts=list(height=600, scatcolors="lightblue"))

## ----iplotCorr_multiscatcolors, eval=FALSE-------------------------------
## iplotCorr(expr, geno, reorder=TRUE,
##           chartOpts=list(scatcolors=c("lightblue", "lightgreen", "pink")))

## ----chartOpts_vignette, eval=FALSE--------------------------------------
## vignette("chartOpts", "qtlcharts")

## ----setScreen_small, eval=FALSE-----------------------------------------
## setScreenSize("small")

## ----setScreen_large, eval=FALSE-----------------------------------------
## setScreenSize("large")

## ----setScreen_normal, eval=FALSE----------------------------------------
## setScreenSize("normal")

## ----setScreen_custom, eval=FALSE----------------------------------------
## setScreenSize(height=500, width=700)

## ----iplotCorr_height_width, eval=FALSE----------------------------------
## iplotCorr(expr, chartOpts=list(height=400, width=800))

## ----Rmarkdown_vignette, eval=FALSE--------------------------------------
## vignette("Rmarkdown", "qtlcharts")

## ----iplotCorr_spearman, eval=FALSE--------------------------------------
## data(geneExpr)
## expr <- geneExpr$expr
## geno <- geneExpr$genotype
## spearman <- cor(expr, use="pairwise.complete.obs", method="spearman")
## 
## iplotCorr(expr, geno, corr=spearman)

## ----iplotCorr_own_reorder, eval=FALSE-----------------------------------
## ord <- hclust(as.dist(-spearman))$order
## iplotCorr(expr[,ord], geno, corr=spearman[ord,ord])

## ----get_eqtl_effect_est-------------------------------------------------
beta <- apply(expr, 2, function(y,x) lm(y~x)$coef[2], geno)
pos <- which(beta > 0)
neg <- which(beta < 0)

## ----iplotCorr_subset_of_corr, eval=FALSE--------------------------------
## iplotCorr(expr, geno, rows=pos, cols=neg)

## ----iplotCorr_subset_of_spearman_corr, eval=FALSE-----------------------
## iplotCorr(expr, geno, corr=spearman[pos,neg])

## ----sim_data_iplot------------------------------------------------------
n <- 100
x <- rnorm(n)
grp <- sample(1:3, n, replace=TRUE)
y <- grp*x + rnorm(n)

## ----iplot_example, eval=FALSE-------------------------------------------
## iplot(x, y, grp)

## ----iplot_example_id, eval=FALSE----------------------------------------
## id <- paste(seq(along=x), " x =", round(x,1), "  y =", round(y, 1), " group =", grp)
## iplot(x, y, grp, id)

## ----iplot_chartOpts, eval=FALSE-----------------------------------------
## iplot(x, y, grp, id,
##       chartOpts=list(xlab="x variable", ylab="y variable",
##                      pointcolor=c("slateblue", "#999999", "violetred")))

## ---- load_hyper---------------------------------------------------------
library(qtl)
data(hyper)
map <- pull.map(hyper)

## ----iplotMap_example, eval=FALSE----------------------------------------
## iplotMap(map)

## ----iplotMap_shift, eval=FALSE------------------------------------------
## iplotMap(map, shift=TRUE)

## ----iplotMap_w_cross, eval=FALSE----------------------------------------
## iplotMap(hyper)

## ----iplotMap_xylab, eval=FALSE------------------------------------------
## iplotMap(map, chartOpts=list(xlab="Linkage group", ylab="Position (Mbp)"))

## ----iplotMap_selected_chr, eval=FALSE-----------------------------------
## iplotMap(map, chr=c(5, 10, 15, "X"))

## ----iplotMap_chartOpts_title, eval=FALSE--------------------------------
## iplotMap(map, chr=c(5, 10, 15, "X"),
##          chartOpts=list(title="Selected chromosomes"))

## ---- load_hyper_and_scan------------------------------------------------
data(hyper)
hyper <- calc.genoprob(hyper, step=1)
out <- scanone(hyper)

## ----iplotScanone_example, eval=FALSE------------------------------------
## iplotScanone(out)

## ----iplotScanone_selected_chr, eval=FALSE-------------------------------
## iplotScanone(out, chr=c(1, 4, 6, 15))

## ----iplotScanone_w_eff, eval=FALSE--------------------------------------
## iplotScanone(out, hyper)

## ----iplotScanone_fillgenoArgs, eval=FALSE-------------------------------
## iplotScanone(out, hyper, fillgenoArgs=list(method="argmax", error.prob=0.01))

## ----iplotScanone_rawpxg, eval=FALSE-------------------------------------
## iplotScanone(out, hyper, pxgtype="raw")

## ----iplotScanone_lodlinecolor, eval=FALSE-------------------------------
## iplotScanone(out, hyper, chartOpts=list(lod_linecolor="black"))

## ----iplotScanone_rectcolor, eval=FALSE----------------------------------
## iplotScanone(out, hyper, chartOpts=list(darkrect="#CCC", lightrect="#EEE"))

## ----iplotScanone_efflinecolor, eval=FALSE-------------------------------
## iplotScanone(out, hyper, chartOpts=list(lod_linecolor="DarkViolet",
##                                         eff_linecolor="DarkViolet"))

## ---- grav_load_data-----------------------------------------------------
data(grav)

## ---- grav_calc_genoprob-------------------------------------------------
grav <- calc.genoprob(grav, step=1)
grav <- reduce2grid(grav)

## ---- grav_scanone-------------------------------------------------------
phecol <- 1:nphe(grav)
out <- scanone(grav, phe=phecol, method="hk")

## ----iplotMScanone_example, eval=FALSE-----------------------------------
## iplotMScanone(out)

## ----grab_grav_times-----------------------------------------------------
times <- attr(grav, "time")

## ----iplotMScanone_w_times, eval=FALSE-----------------------------------
## iplotMScanone(out, times=times, chartOpts=list(lod_ylab="Time (hrs)"))

## ---- grav_esteff--------------------------------------------------------
eff <- estQTLeffects(grav, phe=phecol, what="effects")

## ---- iplotMScanone_with_effects, eval=FALSE-----------------------------
## iplotMScanone(out, effects=eff, times=times)

## ---- iplotMScanone_with_effects_alt, eval=FALSE-------------------------
## iplotMScanone(out, grav, times=times)

## ----scantwo-------------------------------------------------------------
data(hyper)
hyper <- hyper[c(1,4,6,15),]
hyper <- calc.genoprob(hyper, step=5)
out2 <- scantwo(hyper, method="hk", verbose=FALSE)

## ----iplotScantwo, eval=FALSE--------------------------------------------
## iplotScantwo(out2, hyper)

## ----iplotScantwo_bigger, eval=FALSE-------------------------------------
## iplotScantwo(out2, hyper, chartOpts=list(pixelPerCell=12))

## ----iplotScantwo_oneAtTop, eval=FALSE-----------------------------------
## iplotScantwo(out2, hyper, chartOpts=list(oneAtTop=TRUE))

## ----iplotCurves_data----------------------------------------------------
data(grav)
times <- attr(grav, "time")
phe <- grav$pheno

## ----iplotCurves_simple, eval=FALSE--------------------------------------
## iplotCurves(phe)

## ----iplotCurves_wtimes, eval=FALSE--------------------------------------
## iplotCurves(phe, times)

## ----iplotCurves_axislab, eval=FALSE-------------------------------------
## iplotCurves(phe, times, chartOpts=list(curves_xlab="Time (hrs)",
##                                        curves_ylab="Response"))

## ----iplotCurves_axislabalt, eval=FALSE----------------------------------
## iplotCurves(phe, times, chartOpts=list(xlab="Time (hrs)",
##                                        ylab="Response"))

## ----iplotCurves_bigex, eval=FALSE---------------------------------------
## iplotCurves(phe, times, phe[,times==2 | times==4], phe[,times==4 | times==6],
##             chartOpts=list(curves_xlab="Time (hours)", curves_ylab="Response",
##                            scat1_xlab="Angle at 2 hrs", scat1_ylab="Angle at 4 hrs",
##                            scat2_xlab="Angle at 4 hrs", scat2_ylab="Angle at 6 hrs"))

## ----iplotCurves_onescat, eval=FALSE-------------------------------------
## iplotCurves(phe, times, phe[,times==2 | times==4],
##             chartOpts=list(curves_xlab="Time (hours)", curves_ylab="Response",
##                            scat1_xlab="Angle at 2 hrs", scat1_ylab="Angle at 4 hrs"))

## ----iplotCurves_groups, eval=FALSE--------------------------------------
## g <- pull.geno(fill.geno(grav))[,"BF.206L-Col"]
## iplotCurves(phe, times, phe[,times==2 | times==4], phe[,times==4 | times==6],
##             group=g,
##             chartOpts=list(curves_xlab="Time (hours)", curves_ylab="Response",
##                            scat1_xlab="Angle at 2 hrs", scat1_ylab="Angle at 4 hrs",
##                            scat2_xlab="Angle at 4 hrs", scat2_ylab="Angle at 6 hrs"))

## ----iplotCurves_colors, eval=FALSE--------------------------------------
## iplotCurves(phe, times, phe[,times==2 | times==4], phe[,times==4 | times==6],
##             group=g,
##             chartOpts=list(curves_xlab="Time (hours)", curves_ylab="Response",
##                            scat1_xlab="Angle at 2 hrs", scat1_ylab="Angle at 4 hrs",
##                            scat2_xlab="Angle at 4 hrs", scat2_ylab="Angle at 6 hrs",
##                            color=c("pink", "lightblue"), colorhilit=c("red", "blue")))

## ----iboxplot_simdata----------------------------------------------------
# simulated data
n.ind <- 500
n.gene <- 10000
mat <- matrix(rnorm(n.ind * n.gene, rnorm(n.ind, 5)), ncol=n.gene)
dimnames(mat) <- list(paste0("ind", 1:n.ind),
                      paste0("gene", 1:n.gene))

## ----iboxplot_example, eval=FALSE----------------------------------------
## iboxplot(mat)

## ----iboxplot_orderBy99, eval=FALSE--------------------------------------
## iboxplot(mat[order(apply(mat, 1, quantile, 0.99)),], orderByMedian=FALSE)

## ----iboxplot_diff_quant, eval=FALSE-------------------------------------
## iboxplot(mat, qu=c(0.25, 0.05, 0.01))

## ----iboxplot_qucolors, eval=FALSE---------------------------------------
## iboxplot(mat, qu=c(0.25, 0.05, 0.01),
##          chartOpts=list(qucolors=c("black", "green", "red", "blue")))

## ----iboxplot_breaks, eval=FALSE-----------------------------------------
## iboxplot(mat, breaks=151)

## ----iboxplot_breaks2, eval=FALSE----------------------------------------
## iboxplot(mat, breaks=seq(2, 8, by=0.1))

## ----iboxplot_axislab, eval=FALSE----------------------------------------
## iboxplot(mat, chartOpts=list(xlab="Mice", ylab="Expression level"))

## ----iheatmap_data-------------------------------------------------------
n <- 101
x <- y <- seq(-2, 2, len=n)
z <- matrix(ncol=n, nrow=n)
for(i in seq(along=x))
  for(j in seq(along=y))
    z[i,j] <- x[i]*y[j]*exp(-x[i]^2 - y[j]^2)

## ----iheatmap_example, eval=FALSE----------------------------------------
## iheatmap(z, x, y)

## ----iheatmap_diffcolors, eval=FALSE-------------------------------------
## iheatmap(z, x, y,
##          chartOpts=list(zlim=c(-1, 0, 1),
##                         colors=c("purple", "white", "orangered")))

## ----iheatmap_axislab, eval=FALSE----------------------------------------
## iheatmap(z, x, y, chartOpts=list(xlab="theta", ylab="psi", zlab="response"))

## ----badorder_rf---------------------------------------------------------
data(badorder)
badorder <- est.rf(badorder)

## ----iplotRF, eval=FALSE-------------------------------------------------
## iplotRF(badorder)

## ----iplotRF_lodlim, eval=FALSE------------------------------------------
## iplotRF(badorder, chartOpts=list(lodlim=c(2, 15)))

