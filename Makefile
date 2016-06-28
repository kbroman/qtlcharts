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

#------------------------------------------------------------

# Add list of chartOpts to vignette

# javascript for the chart functions (outside this repo, in ../qtlcharts/)
CHART_DIR = ../qtlcharts/inst/htmlwidgets/lib/qtlcharts
CHARTS = $(CHART_DIR)/iplotScanone_noeff.coffee \
		 $(CHART_DIR)/iplotScanone_pxg.coffee \
		 $(CHART_DIR)/iplotScanone_ci.coffee \
		 $(CHART_DIR)/idotplot.coffee \
		 $(CHART_DIR)/iplotCorr.coffee \
		 $(CHART_DIR)/iplotCorr_noscat.coffee \
		 $(CHART_DIR)/iboxplot.coffee \
		 $(CHART_DIR)/iplotCurves.coffee \
		 $(CHART_DIR)/iplotMap.coffee \
		 $(CHART_DIR)/iplotRF.coffee \
		 $(CHART_DIR)/iplotMScanone_noeff.coffee \
		 $(CHART_DIR)/iplotMScanone_eff.coffee \
		 $(CHART_DIR)/iheatmap.coffee \
		 $(CHART_DIR)/iplot.coffee \
		 $(CHART_DIR)/iplotScantwo.coffee \
		 $(CHART_DIR)/scat2scat.coffee \
		 $(CHART_DIR)/itriplot.coffee

vignettes/chartOpts.Rmd: assets/vignettes/chartOpts/grab_chartOpts.rb \
						 assets/vignettes/chartOpts/chartOpts_source.Rmd \
						 assets/vignettes/chartOpts/multiversions.csv \
						 $(CHARTS)
	$<

#------------------------------------------------------------
# build all of the vignettes

VIGNETTES = assets/vignettes/Rmarkdown.html \
			assets/vignettes/chartOpts.html \
			assets/vignettes/develGuide.html \
			assets/vignettes/userGuide.html
vignettes: $(VIGNETTES)

assets/vignettes/%.html: assets/vignettes/%.Rmd
	cd $(<D);R -e "rmarkdown::render('$(<F)')"
