
all: chartexamples jspanels jspaneltests json testhtml d3 d3tip colorbrewer vignettes

# Examples
CHARTEX = assets/chartexamples

chartexamples: ${CHARTEX}/iboxplot_example.html ${CHARTEX}/iplotCorr_example.html ${CHARTEX}/iplotCurves_example.html ${CHARTEX}/iplotMScanone_example.html ${CHARTEX}/iplotMap_example.html ${CHARTEX}/iplotScanone_example.html ${CHARTEX}/iheatmap_example.html

${CHARTEX}/iboxplot_example.html: ${CHARTEX}/R/iboxplot_example.R ${CHARTEX}/R/hypo.RData
	cd ${CHARTEX}/R; R CMD BATCH --no-save $(<F)

${CHARTEX}/iplotCorr_example.html: ${CHARTEX}/R/iplotCorr_example.R
	cd ${CHARTEX}/R; R CMD BATCH --no-save $(<F)

${CHARTEX}/iplotCurves_example.html: ${CHARTEX}/R/iplotCurves_example.R
	cd ${CHARTEX}/R; R CMD BATCH --no-save $(<F)

${CHARTEX}/iplotMScanone_example.html: ${CHARTEX}/R/iplotMScanone_example.R
	cd ${CHARTEX}/R; R CMD BATCH --no-save $(<F)

${CHARTEX}/iplotMap_example.html: ${CHARTEX}/R/iplotMap_example.R
	cd ${CHARTEX}/R; R CMD BATCH --no-save $(<F)

${CHARTEX}/iplotScanone_example.html: ${CHARTEX}/R/iplotScanone_example.R
	cd ${CHARTEX}/R; R CMD BATCH --no-save $(<F)

${CHARTEX}/iheatmap_example.html: ${CHARTEX}/R/iheatmap_example.R
	cd ${CHARTEX}/R; R CMD BATCH --no-save $(<F)

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
LODHEATMAP_DIR = ${PANEL_DIR}/lodheatmap
LODCHART_TESTDIR = ${LODCHART_DIR}/test
SCATTERPLOT_TESTDIR = ${SCATTERPLOT_DIR}/test
DOTCHART_TESTDIR = ${DOTCHART_DIR}/test
CICHART_TESTDIR = ${CICHART_DIR}/test
CURVECHART_TESTDIR = ${CURVECHART_DIR}/test
MAPCHART_TESTDIR = ${MAPCHART_DIR}/test
HEATMAP_TESTDIR = ${HEATMAP_DIR}/test
LODHEATMAP_TESTDIR = ${LODHEATMAP_DIR}/test
CHART_DIR = inst/charts
THIS_D3 = assets/d3
QTLCHARTS_D3 = ../qtlcharts/inst/d3
THIS_D3TIP = assets/d3-tip
QTLCHARTS_D3TIP = ../qtlcharts/inst/d3-tip
THIS_BREWER = assets/colorbrewer
QTLCHARTS_BREWER = ../qtlcharts/inst/colorbrewer

#------------------------------------------------------------

# javascript of panel tests
jspaneltests: ${LODCHART_TESTDIR}/test_lodchart.js ${SCATTERPLOT_TESTDIR}/test_scatterplot.js ${DOTCHART_TESTDIR}/test_dotchart.js ${CICHART_TESTDIR}/test_cichart.js ${CURVECHART_TESTDIR}/test_curvechart.js ${MAPCHART_TESTDIR}/test_mapchart.js ${HEATMAP_TESTDIR}/test_heatmap.js ${LODHEATMAP_TESTDIR}/test_lodheatmap.js

${THIS}/%/test/%.js: ${QTLCHARTS}/%/test/%.js
	cp $< $@

#------------------------------------------------------------

# javascript of panels
jspanels: ${LODCHART_DIR}/lodchart.js ${SCATTERPLOT_DIR}/scatterplot.js ${DOTCHART_DIR}/dotchart.js ${CICHART_DIR}/cichart.js ${CURVECHART_DIR}/curvechart.js ${MAPCHART_DIR}/mapchart.js ${HEATMAP_DIR}/heatmap.js ${LODHEATMAP_DIR}/lodheatmap.js ${PANEL_DIR}/panelutil.js ${PANEL_DIR}/panelutil.css

${THIS}/%.js: ${QTLCHARTS}/%.js
	cp $< $@

${THIS}/panelutil.css: ${QTLCHARTS}/panelutil.css
	cp $< $@

#------------------------------------------------------------

# test data files
json: ${LODCHART_TESTDIR}/data.json ${SCATTERPLOT_TESTDIR}/data.json ${DOTCHART_TESTDIR}/data.json ${CICHART_TESTDIR}/data.json ${CURVECHART_TESTDIR}/data.json ${MAPCHART_TESTDIR}/data.json ${HEATMAP_TESTDIR}/data.json ${LODHEATMAP_TESTDIR}/data.json

${THIS}/%/test/data.json: ${QTLCHARTS}/%/test/data.json
	cp $< $@

#------------------------------------------------------------

# test/index.html files
testhtml: ${LODCHART_TESTDIR}/index.html ${SCATTERPLOT_TESTDIR}/index.html ${DOTCHART_TESTDIR}/index.html ${CICHART_TESTDIR}/index.html ${CURVECHART_TESTDIR}/index.html ${MAPCHART_TESTDIR}/index.html ${HEATMAP_TESTDIR}/index.html ${LODHEATMAP_TESTDIR}/index.html

${THIS}/%/test/index.html: ${QTLCHARTS}/%/test/index.html
	cp $< $@

#------------------------------------------------------------

# d3, d3tip, colorbrewer
d3: ${THIS_D3}/d3.min.js ${THIS_D3}/LICENSE ${THIS_D3}/ReadMe.md

${THIS_D3}/%: ${QTLCHARTS_D3}/%
	cp $< $@

d3tip: ${THIS_D3TIP}/d3-tip.min.js ${THIS_D3TIP}/d3-tip.min.css ${THIS_D3TIP}/LICENSE ${THIS_D3TIP}/ReadMe.md

${THIS_D3TIP}/%: ${QTLCHARTS_D3TIP}/%
	cp $< $@

colorbrewer: ${THIS_BREWER}/colorbrewer.js ${THIS_BREWER}/colorbrewer.css ${THIS_BREWER}/LICENSE ${THIS_BREWER}/ReadMe.md

${THIS_BREWER}/%: ${QTLCHARTS_BREWER}/%
	cp $< $@

#------------------------------------------------------------

vignettes: assets/vignettes/Rmarkdown.html

assets/vignettes/Rmarkdown.html: ../qtlcharts/vignettes/Rmarkdown.Rmd
	R -e 'library(knitr);knit2html("$<", "$@")'
