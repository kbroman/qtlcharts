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

${THIS_VIGNETTES}/Rmarkdown.html: ${QTLCHARTS_VIGNETTES}/Rmarkdown.Rmd
	R -e 'library(knitr);knit2html("$<", "$@")'

${THIS_VIGNETTES}/chartOpts.html: ${QTLCHARTS_VIGNETTES}/chartOpts.Rmd
	R -e 'library(knitr);knit2html("$<", "$@")'

${THIS_VIGNETTES}/develGuide.html: ${QTLCHARTS_VIGNETTES}/develGuide.Rmd
	R -e 'library(knitr);knit2html("$<", "$@")'

${THIS_VIGNETTES}/userGuide.html: ${QTLCHARTS_VIGNETTES}/userGuide.Rmd
	mkdir tmp
	mkdir tmp/Figs
	cp $< tmp/userGuide.Rmd
	cp ${QTLCHARTS_VIGNETTES}/Figs/* tmp/Figs/
	cd tmp;R -e 'library(knitr);knit2html("userGuide.Rmd")'
	mv tmp/userGuide.html ${THIS_VIGNETTES}/
	rm -r tmp
