all: chartexamples jspanels jspaneltests json testhtml d3 d3tip colorbrewer vignettes
.PHONY: chartexamples jspanels jspaneltests json testhtml d3 d3tip colorbrewer vignettes

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

# All of the stuff below is for moving stuff from qtlcharts to its web page
#     This is the gh-pages branch
#     I assume that ../qtlcharts is the master (or devel) branch

# This is probably overly complicated, but it seems to work.


THIS = assets/panels
QTLCHARTS = ../qtlcharts/inst/panels
PANEL_DIR = assets/panels
LODCHART_DIR = ${PANEL_DIR}/lodchart
SCATTERPLOT_DIR = ${PANEL_DIR}/scatterplot
DOTCHART_DIR = ${PANEL_DIR}/dotchart
CICHART_DIR = ${PANEL_DIR}/cichart
CURVECHART_DIR = ${PANEL_DIR}/curvechart
MAPCHART_DIR = ${PANEL_DIR}/mapchart
HEATMAP_DIR = ${PANEL_DIR}/heatmap
CHRHEATMAP_DIR = ${PANEL_DIR}/chrheatmap
LODHEATMAP_DIR = ${PANEL_DIR}/lodheatmap
CROSSTAB_DIR = ${PANEL_DIR}/crosstab
LODCHART_TESTDIR = ${LODCHART_DIR}/test
SCATTERPLOT_TESTDIR = ${SCATTERPLOT_DIR}/test
DOTCHART_TESTDIR = ${DOTCHART_DIR}/test
CICHART_TESTDIR = ${CICHART_DIR}/test
CURVECHART_TESTDIR = ${CURVECHART_DIR}/test
MAPCHART_TESTDIR = ${MAPCHART_DIR}/test
HEATMAP_TESTDIR = ${HEATMAP_DIR}/test
CHRHEATMAP_TESTDIR = ${CHRHEATMAP_DIR}/test
LODHEATMAP_TESTDIR = ${LODHEATMAP_DIR}/test
CROSSTAB_TESTDIR = ${CROSSTAB_DIR}/test
CHART_DIR = inst/charts
THIS_D3 = assets/d3
QTLCHARTS_D3 = ../qtlcharts/inst/d3
THIS_D3TIP = assets/d3-tip
QTLCHARTS_D3TIP = ../qtlcharts/inst/d3-tip
THIS_BREWER = assets/colorbrewer
QTLCHARTS_BREWER = ../qtlcharts/inst/colorbrewer

#------------------------------------------------------------

# javascript of panel tests
JSPANELTESTS = ${LODCHART_TESTDIR}/test_lodchart.js ${SCATTERPLOT_TESTDIR}/test_scatterplot.js \
			   ${DOTCHART_TESTDIR}/test_dotchart.js ${CICHART_TESTDIR}/test_cichart.js \
			   ${CURVECHART_TESTDIR}/test_curvechart.js ${MAPCHART_TESTDIR}/test_mapchart.js \
			   ${HEATMAP_TESTDIR}/test_heatmap.js ${CHRHEATMAP_TESTDIR}/test_chrheatmap.js \
			   ${LODHEATMAP_TESTDIR}/test_lodheatmap.js ${CROSSTAB_TESTDIR}/test_crosstab.js
jspaneltests: ${JSPANELTESTS}

${THIS}/%/test/%.js: ${QTLCHARTS}/%/test/%.js
	cp $< $@

#------------------------------------------------------------

# javascript of panels
JSPANELS = ${LODCHART_DIR}/lodchart.js ${SCATTERPLOT_DIR}/scatterplot.js \
		   ${DOTCHART_DIR}/dotchart.js ${CICHART_DIR}/cichart.js \
		   ${CURVECHART_DIR}/curvechart.js ${MAPCHART_DIR}/mapchart.js \
		   ${HEATMAP_DIR}/heatmap.js ${CHRHEATMAP_DIR}/chrheatmap.js \
		   ${LODHEATMAP_DIR}/lodheatmap.js ${CROSSTAB_DIR}/crosstab.js \
		   ${PANEL_DIR}/panelutil.js ${PANEL_DIR}/panelutil.css
jspanels: ${JSPANELS}

${THIS}/%.js: ${QTLCHARTS}/%.js
	cp $< $@

${THIS}/panelutil.css: ${QTLCHARTS}/panelutil.css
	cp $< $@

#------------------------------------------------------------

# test data files
JSON = ${LODCHART_TESTDIR}/data.json ${SCATTERPLOT_TESTDIR}/data.json \
	   ${DOTCHART_TESTDIR}/data.json ${CICHART_TESTDIR}/data.json \
	   ${CURVECHART_TESTDIR}/data.json ${MAPCHART_TESTDIR}/data.json \
	   ${HEATMAP_TESTDIR}/data.json ${CHRHEATMAP_TESTDIR}/data.json \
	   ${LODHEATMAP_TESTDIR}/data.json ${CROSSTAB_TESTDIR}/data.json
json: ${JSON}

${THIS}/%/test/data.json: ${QTLCHARTS}/%/test/data.json
	cp $< $@

#------------------------------------------------------------

# test/index.html files
TESTHTML = ${LODCHART_TESTDIR}/index.html ${SCATTERPLOT_TESTDIR}/index.html \
		   ${DOTCHART_TESTDIR}/index.html ${CICHART_TESTDIR}/index.html \
		   ${CURVECHART_TESTDIR}/index.html ${MAPCHART_TESTDIR}/index.html \
		   ${HEATMAP_TESTDIR}/index.html ${CHRHEATMAP_TESTDIR}/index.html \
		   ${LODHEATMAP_TESTDIR}/index.html ${CROSSTAB_TESTDIR}/index.html
testhtml: ${TESTHTML}

${THIS}/%/test/index.html: ${QTLCHARTS}/%/test/index.html
	cp $< $@

#------------------------------------------------------------

# d3, d3tip, colorbrewer
D3 = ${THIS_D3}/d3.min.js ${THIS_D3}/LICENSE ${THIS_D3}/ReadMe.md
d3: ${D3}

${THIS_D3}/%: ${QTLCHARTS_D3}/%
	cp $< $@

D3TIP = ${THIS_D3TIP}/d3-tip.min.js ${THIS_D3TIP}/d3-tip.min.css ${THIS_D3TIP}/LICENSE ${THIS_D3TIP}/ReadMe.md
d3tip: ${D3TIP}

${THIS_D3TIP}/%: ${QTLCHARTS_D3TIP}/%
	cp $< $@

COLORBREWER = ${THIS_BREWER}/colorbrewer.js ${THIS_BREWER}/colorbrewer.css ${THIS_BREWER}/LICENSE ${THIS_BREWER}/ReadMe.md
colorbrewer: ${COLORBREWER}

${THIS_BREWER}/%: ${QTLCHARTS_BREWER}/%
	cp $< $@

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
