## ----knitr_options-------------------------------------------------------
knitr::opts_chunk$set(fig.width=8, fig.height=6, message=FALSE)

## ----load_data, message=FALSE--------------------------------------------
library(qtl)
library(qtlcharts)
data(grav)

## ----subset_pheno--------------------------------------------------------
grav$pheno <- grav$pheno[,seq(1, nphe(grav), by=5)]

## ----grab_times----------------------------------------------------------
times <- as.numeric(sub("T", "", phenames(grav)))/60

## ----scanone-------------------------------------------------------------
grav <- calc.genoprob(grav, step=1)
out.hk <- scanone(grav, pheno.col=1:nphe(grav), method="hk")

## ----iplotMap------------------------------------------------------------
iplotMap(grav)

## ----iplotCorr, fig.height=4.2-------------------------------------------
iplotCorr(grav$pheno)

## ----iplotCurves---------------------------------------------------------
iplotCurves(grav$pheno, times,
            grav$pheno[,c("T30", "T240")],
            grav$pheno[,c("T240", "T480")],
            chartOpts=list(curves_xlab="Time", curves_ylab="Root tip angle",
                           scat1_xlab="Angle at 30 min", scat1_ylab="Angle at 4 hrs",
                           scat2_xlab="Angle at 4 hrs", scat2_ylab="Angle at 8 hrs"))

## ----iplotMScanone-------------------------------------------------------
iplotMScanone(out.hk, grav, chartOpts=list(eff_ylab="QTL effect"))

## ----iplotScanone_loop---------------------------------------------------
times <- c("T30", "T240", "T480")
times_number <- match(times, phenames(grav))
plot_list <- vector("list", length(times))
for(i in seq(along=times))
    plot_list[[i]] <- iplotScanone(out.hk, lodcolumn=times_number[i])
plot_list <- lapply(plot_list, htmltools::tags$p)
htmltools::tagList(plot_list)

