all: jspanels jspaneltests jscharts json doc inst/ToDo.html

PANEL_DIR = inst/panels
LODCHART_DIR = ${PANEL_DIR}/lodchart
SCATTERPLOT_DIR = ${PANEL_DIR}/scatterplot
DOTCHART_DIR = ${PANEL_DIR}/dotchart
CICHART_DIR = ${PANEL_DIR}/cichart
CURVECHART_DIR = ${PANEL_DIR}/curvechart
MAPCHART_DIR = ${PANEL_DIR}/mapchart
HEATMAP_DIR = ${PANEL_DIR}/heatmap
LODCHART_TESTDIR = ${LODCHART_DIR}/test
SCATTERPLOT_TESTDIR = ${SCATTERPLOT_DIR}/test
DOTCHART_TESTDIR = ${DOTCHART_DIR}/test
CICHART_TESTDIR = ${CICHART_DIR}/test
CURVECHART_TESTDIR = ${CURVECHART_DIR}/test
MAPCHART_TESTDIR = ${MAPCHART_DIR}/test
HEATMAP_TESTDIR = ${HEATMAP_DIR}/test
CHART_DIR = inst/charts

COFFEE_ARGS = -c # use -cm for debugging; -c otherwise

# build html version of ToDo list
inst/ToDo.html: inst/ToDo.md
	cd inst;R -e 'library(markdown);markdownToHTML("ToDo.md", "ToDo.html")'

# build package documentation
doc:
	R -e 'library(devtools);document()'

#------------------------------------------------------------

# javascript of panel tests
jspaneltests: ${LODCHART_TESTDIR}/test_lodchart.js ${SCATTERPLOT_TESTDIR}/test_scatterplot.js ${DOTCHART_TESTDIR}/test_dotchart.js ${CICHART_TESTDIR}/test_cichart.js ${CURVECHART_TESTDIR}/test_curvechart.js ${MAPCHART_TESTDIR}/test_mapchart.js ${HEATMAP_TESTDIR}/test_heatmap.js

${PANEL_DIR}/*/test/%.js: ${PANEL_DIR}/*/test/%.coffee
	coffee ${COFFEE_ARGS} $^

#------------------------------------------------------------

# javascript of panels
jspanels: ${LODCHART_DIR}/lodchart.js ${SCATTERPLOT_DIR}/scatterplot.js ${DOTCHART_DIR}/dotchart.js ${CICHART_DIR}/cichart.js ${CURVECHART_DIR}/curvechart.js ${MAPCHART_DIR}/mapchart.js ${HEATMAP_DIR}/heatmap.js ${PANEL_DIR}/panelutil.js

${PANEL_DIR}/%.js: ${PANEL_DIR}/%.coffee
	coffee ${COFFEE_ARGS} -b $^

#------------------------------------------------------------

# test data files
json: ${LODCHART_TESTDIR}/data.json ${SCATTERPLOT_TESTDIR}/data.json ${DOTCHART_TESTDIR}/data.json ${CICHART_TESTDIR}/data.json ${CURVECHART_TESTDIR}/data.json ${MAPCHART_TESTDIR}/data.json ${HEATMAP_TESTDIR}/data.json

${PANEL_DIR}/*/test/data.json: ${PANEL_DIR}/*/test/create_test_data.R
	cd $(@D);R CMD BATCH $(<F)

#------------------------------------------------------------

# javascript for the real charts
jscharts: ${CHART_DIR}/iplotScanone_noeff.js ${CHART_DIR}/iplotScanone_pxg.js ${CHART_DIR}/iplotScanone_ci.js ${CHART_DIR}/iplotPXG.js ${CHART_DIR}/corr_w_scatter.js ${CHART_DIR}/manyboxplots.js ${CHART_DIR}/curves_w_scatter.js ${CHART_DIR}/iplotMap.js

${CHART_DIR}/%.js: ${CHART_DIR}/%.coffee
	coffee ${COFFEE_ARGS} -b $^

#------------------------------------------------------------

# remove all data files and javascript files
clean:
	rm ${PANEL_DIR}/*/*.js ${PANEL_DIR}/*/test/*.js  ${PANEL_DIR}/*/test/*.json ${CHART_DIR}/*.js

#------------------------------------------------------------

web:
	scp ${PANEL_DIR}/panelutil.* broman-2:public_html/D3/panels/
	scp ${LODCHART_DIR}/lodchart.* broman-2:public_html/D3/panels/lodchart/
	cd ${LODCHART_TESTDIR};scp *.js *.json index.html broman-2:public_html/D3/panels/lodchart/test/
	scp ${SCATTERPLOT_DIR}/scatterplot.* broman-2:public_html/D3/panels/scatterplot/
	cd ${SCATTERPLOT_TESTDIR};scp *.js *.json index.html broman-2:public_html/D3/panels/scatterplot/test/
	scp ${DOTCHART_DIR}/dotchart.* broman-2:public_html/D3/panels/dotchart/
	cd ${DOTCHART_TESTDIR};scp *.js *.json index.html broman-2:public_html/D3/panels/dotchart/test/
	scp ${CICHART_DIR}/cichart.* broman-2:public_html/D3/panels/cichart/
	cd ${CICHART_TESTDIR};scp *.js *.json index.html broman-2:public_html/D3/panels/cichart/test/
	scp ${CURVECHART_DIR}/curvechart.* broman-2:public_html/D3/panels/curvechart/
	cd ${CURVECHART_TESTDIR};scp *.js *.json index.html broman-2:public_html/D3/panels/curvechart/test/
	scp ${MAPCHART_DIR}/mapchart.* broman-2:public_html/D3/panels/mapchart/
	cd ${MAPCHART_TESTDIR};scp *.js *.json index.html broman-2:public_html/D3/panels/mapchart/test/
	scp ${HEATMAP_DIR}/heatmap.* broman-2:public_html/D3/panels/heatmap/
	cd ${HEATMAP_TESTDIR};scp *.js *.json index.html broman-2:public_html/D3/panels/heatmap/test/
