all: jspanels jspaneltests jscharts json doc

PANEL_DIR = inst/panels
LODCHART_DIR = ${PANEL_DIR}/lodchart
SCATTERPLOT_DIR = ${PANEL_DIR}/scatterplot
DOTCHART_DIR = ${PANEL_DIR}/dotchart
LODCHART_TESTDIR = ${LODCHART_DIR}/test
SCATTERPLOT_TESTDIR = ${SCATTERPLOT_DIR}/test
DOTCHART_TESTDIR = ${DOTCHART_DIR}/test
CHART_DIR = inst/charts

# build package documentation
doc:
	R -e 'library(devtools);document(roclets=c("namespace", "rd"))'

#------------------------------------------------------------

# javascript of panel tests
jspaneltests: ${LODCHART_TESTDIR}/test_lodchart.js ${SCATTERPLOT_TESTDIR}/test_scatterplot.js ${DOTCHART_TESTDIR}/test_dotchart.js

${PANEL_DIR}/*/test/%.js: ${PANEL_DIR}/*/test/%.coffee
	coffee -c $^

#------------------------------------------------------------

# javascript of panels
jspanels: ${LODCHART_DIR}/lodchart.js ${SCATTERPLOT_DIR}/scatterplot.js ${DOTCHART_DIR}/dotchart.js

${PANEL_DIR}/%.js: ${PANEL_DIR}/%.coffee
	coffee -bc $^

#------------------------------------------------------------

# test data files
json: ${LODCHART_TESTDIR}/data.json ${SCATTERPLOT_TESTDIR}/data.json ${DOTCHART_TESTDIR}/data.json

${PANEL_DIR}/*/test/data.json: ${PANEL_DIR}/*/test/create_test_data.R
	cd $(@D);R CMD BATCH $(<F)

#------------------------------------------------------------

# javascript for the real charts
jscharts: ${CHART_DIR}/iplotScanone_noeff.js ${CHART_DIR}/iplotScanone_pxg.js ${CHART_DIR}/iplotPXG.js ${CHART_DIR}/corr_w_scatter.js

${CHART_DIR}/%.js: ${CHART_DIR}/%.coffee
	coffee -bc $^

#------------------------------------------------------------

# remove all data files and javascript files
clean:
	rm ${PANEL_DIR}/*/*.js ${PANEL_DIR}/*/test/*.js  ${PANEL_DIR}/*/test/*.json ${CHART_DIR}/*.js

#------------------------------------------------------------

web:
	scp ${LODCHART_DIR}/lodchart.* broman-2:public_html/D3/lodchart/
	cd ${LODCHART_TESTDIR};scp test_lodchart.* *.json index.html broman-2:public_html/D3/lodchart/test/
	scp ${SCATTERPLOT_DIR}/scatterplot.* broman-2:public_html/D3/scatterplot/
	cd ${SCATTERPLOT_TESTDIR};scp test_scatterplot.* *.json index.html broman-2:public_html/D3/scatterplot/test/
	scp ${DOTCHART_DIR}/dotchart.* broman-2:public_html/D3/dotchart/
	cd ${DOTCHART_TESTDIR};scp test_dotchart.* *.json index.html broman-2:public_html/D3/dotchart/test/
