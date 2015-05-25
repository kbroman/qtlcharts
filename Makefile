all: chartexamples vignettes
.PHONY: chartexamples vignettes

# Examples
CHARTEX = example

CHARTEXAMPLES = ${CHARTEX}/iboxplot.html ${CHARTEX}/iplotCorr.html \
				${CHARTEX}/iplotCurves.html ${CHARTEX}/iplotMScanone.html \
				${CHARTEX}/iplotMap.html ${CHARTEX}/iplotScanone.html \
				${CHARTEX}/iheatmap.html ${CHARTEX}/iplotRF.html \
				${CHARTEX}/iplotScantwo.html
chartexamples: ${CHARTEXAMPLES}

${CHARTEX}/iboxplot.html: ${CHARTEX}/R/iboxplot_example.R ${CHARTEX}/R/iboxplot_data.RData
	cd $(<D); R CMD BATCH --no-save $(<F)

${CHARTEX}/%.html: ${CHARTEX}/R/%_example.R
	cd $(<D); R CMD BATCH --no-save $(<F)

#------------------------------------------------------------

THIS_VIGNETTES= assets/vignettes
QTLCHARTS_VIGNETTES = ../qtlcharts/vignettes

VIGNETTES = ${THIS_VIGNETTES}/Rmarkdown.html ${THIS_VIGNETTES}/userGuide.html ${THIS_VIGNETTES}/chartOpts.html ${THIS_VIGNETTES}/develGuide.html
vignettes: ${VIGNETTES}

${THIS_VIGNETTES}/%.html: ${QTLCHARTS_VIGNETTES}/%.Rmd
	cd $(<D); \
	R -e "rmarkdown::render('$(<F)')"; \
	mv $(@F) ../../Web/$(@D)/
