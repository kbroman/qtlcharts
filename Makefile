all: jspanels jspaneltests jscharts json d3 d3-tip doc inst/ToDo.html

PANEL_DIR = inst/panels
LODCHART_DIR = ${PANEL_DIR}/lodchart
SCATTERPLOT_DIR = ${PANEL_DIR}/scatterplot
DOTCHART_DIR = ${PANEL_DIR}/dotchart
CICHART_DIR = ${PANEL_DIR}/cichart
CURVECHART_DIR = ${PANEL_DIR}/curvechart
LODCHART_TESTDIR = ${LODCHART_DIR}/test
SCATTERPLOT_TESTDIR = ${SCATTERPLOT_DIR}/test
DOTCHART_TESTDIR = ${DOTCHART_DIR}/test
CICHART_TESTDIR = ${CICHART_DIR}/test
CURVECHART_TESTDIR = ${CURVECHART_DIR}/test
CHART_DIR = inst/charts

COFFEE_ARGS = -c # use -cm for debugging; -c otherwise

# build html version of ToDo list
inst/ToDo.html: inst/ToDo.md
	cd inst;R -e 'library(markdown);markdownToHTML("ToDo.md", "ToDo.html")'

# build package documentation
doc:
	R -e 'library(devtools);document(roclets=c("namespace", "rd"))'

#------------------------------------------------------------

# javascript of panel tests
jspaneltests: ${LODCHART_TESTDIR}/test_lodchart.js ${SCATTERPLOT_TESTDIR}/test_scatterplot.js ${DOTCHART_TESTDIR}/test_dotchart.js ${CICHART_TESTDIR}/test_cichart.js ${CURVECHART_TESTDIR}/test_curvechart.js

${PANEL_DIR}/*/test/%.js: ${PANEL_DIR}/*/test/%.coffee
	coffee ${COFFEE_ARGS} $^

#------------------------------------------------------------

# javascript of panels
jspanels: ${LODCHART_DIR}/lodchart.js ${SCATTERPLOT_DIR}/scatterplot.js ${DOTCHART_DIR}/dotchart.js ${CICHART_DIR}/cichart.js ${CURVECHART_DIR}/curvechart.js

${PANEL_DIR}/%.js: ${PANEL_DIR}/%.coffee
	coffee ${COFFEE_ARGS} -b $^

#------------------------------------------------------------

# test data files
json: ${LODCHART_TESTDIR}/data.json ${SCATTERPLOT_TESTDIR}/data.json ${DOTCHART_TESTDIR}/data.json ${CICHART_TESTDIR}/data.json ${CURVECHART_TESTDIR}/data.json

${PANEL_DIR}/*/test/data.json: ${PANEL_DIR}/*/test/create_test_data.R
	cd $(@D);R CMD BATCH $(<F)

#------------------------------------------------------------

# links to d3 for the test files

d3: ${LODCHART_TESTDIR}/d3.min.js ${SCATTERPLOT_TESTDIR}/d3.min.js ${DOTCHART_TESTDIR}/d3.min.js ${CICHART_TESTDIR}/d3.min.js ${CURVECHART_TESTDIR}/d3.min.js

${PANEL_DIR}/*/test/d3.min.js: inst/d3/d3.min.js
	ln -s ../../../d3/d3.min.js $@

#------------------------------------------------------------

# links to d3-tip for the test files

d3-tip: ${LODCHART_TESTDIR}/d3-tip.min.js ${SCATTERPLOT_TESTDIR}/d3-tip.min.js ${DOTCHART_TESTDIR}/d3-tip.min.js ${CICHART_TESTDIR}/d3-tip.min.js ${CURVECHART_TESTDIR}/d3-tip.min.js ${LODCHART_TESTDIR}/d3-tip.min.css ${SCATTERPLOT_TESTDIR}/d3-tip.min.css ${DOTCHART_TESTDIR}/d3-tip.min.css ${CICHART_TESTDIR}/d3-tip.min.css ${CURVECHART_TESTDIR}/d3-tip.min.css

${PANEL_DIR}/*/test/d3-tip.min.js: inst/d3-tip/d3-tip.min.js
	ln -s ../../../d3-tip/d3-tip.min.js $@

${PANEL_DIR}/*/test/d3-tip.min.css: inst/d3-tip/d3-tip.min.css
	ln -s ../../../d3-tip/d3-tip.min.css $@

#------------------------------------------------------------

# javascript for the real charts
jscharts: ${CHART_DIR}/iplotScanone_noeff.js ${CHART_DIR}/iplotScanone_pxg.js ${CHART_DIR}/iplotScanone_ci.js ${CHART_DIR}/iplotPXG.js ${CHART_DIR}/corr_w_scatter.js ${CHART_DIR}/manyboxplots.js ${CHART_DIR}/curves_w_2scatter.js

${CHART_DIR}/%.js: ${CHART_DIR}/%.coffee
	coffee ${COFFEE_ARGS} -b $^

#------------------------------------------------------------

# remove all data files and javascript files
clean:
	rm ${PANEL_DIR}/*/*.js ${PANEL_DIR}/*/test/*.js  ${PANEL_DIR}/*/test/*.json ${CHART_DIR}/*.js

#------------------------------------------------------------

web:
	scp ${LODCHART_DIR}/lodchart.* broman-2:public_html/D3/lodchart/
	cd ${LODCHART_TESTDIR};scp *.js *.css *.json index.html broman-2:public_html/D3/lodchart/test/
	scp ${SCATTERPLOT_DIR}/scatterplot.* broman-2:public_html/D3/scatterplot/
	cd ${SCATTERPLOT_TESTDIR};scp *.js *.css *.json index.html broman-2:public_html/D3/scatterplot/test/
	scp ${DOTCHART_DIR}/dotchart.* broman-2:public_html/D3/dotchart/
	cd ${DOTCHART_TESTDIR};scp *.js *.css *.json index.html broman-2:public_html/D3/dotchart/test/
	scp ${CICHART_DIR}/cichart.* broman-2:public_html/D3/cichart/
	cd ${CICHART_TESTDIR};scp *.js *.css *.json index.html broman-2:public_html/D3/cichart/test/
	scp ${CURVECHART_DIR}/curvechart.* broman-2:public_html/D3/curvechart/
	cd ${CURVECHART_TESTDIR};scp *.js *.css *.json index.html broman-2:public_html/D3/curvechart/test/
