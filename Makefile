all: jspanels jscharts json doc

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




# javascript of panels and their tests
jspanels: ${LODCHART_DIR}/lodchart.js ${LODCHART_TESTDIR}/test_lodchart.js ${SCATTERPLOT_DIR}/scatterplot.js ${SCATTERPLOT_TESTDIR}/test_scatterplot.js ${DOTCHART_DIR}/dotchart.js ${DOTCHART_TESTDIR}/test_dotchart.js

${LODCHART_DIR}/lodchart.js: ${LODCHART_DIR}/lodchart.coffee
	coffee -bc $^

${LODCHART_TESTDIR}/test_lodchart.js: ${LODCHART_TESTDIR}/test_lodchart.coffee
	coffee -c $^

${SCATTERPLOT_DIR}/scatterplot.js: ${SCATTERPLOT_DIR}/scatterplot.coffee
	coffee -bc $^

${SCATTERPLOT_TESTDIR}/test_scatterplot.js: ${SCATTERPLOT_TESTDIR}/test_scatterplot.coffee
	coffee -c $^

${DOTCHART_DIR}/dotchart.js: ${DOTCHART_DIR}/dotchart.coffee
	coffee -bc $^

${DOTCHART_TESTDIR}/test_dotchart.js: ${DOTCHART_TESTDIR}/test_dotchart.coffee
	coffee -c $^




# test data files
json: ${LODCHART_TESTDIR}/scanone.json ${SCATTERPLOT_TESTDIR}/data.json ${DOTCHART_TESTDIR}/data.json

${LODCHART_TESTDIR}/scanone.json: ${LODCHART_TESTDIR}/create_test_data.R
	cd ${LODCHART_TESTDIR};R CMD BATCH create_test_data.R

${SCATTERPLOT_TESTDIR}/data.json: ${SCATTERPLOT_TESTDIR}/create_test_data.R
	cd ${SCATTERPLOT_TESTDIR};R CMD BATCH create_test_data.R

${DOTCHART_TESTDIR}/data.json: ${DOTCHART_TESTDIR}/create_test_data.R
	cd ${DOTCHART_TESTDIR};R CMD BATCH create_test_data.R




# javascript for the real charts
jscharts: ${CHART_DIR}/iplotScanone_noeff.js ${CHART_DIR}/iplotScanone_pxg.js ${CHART_DIR}/iplotPXG.js ${CHART_DIR}/corr_w_scatter.js

${CHART_DIR}/iplotScanone_noeff.js: ${CHART_DIR}/iplotScanone_noeff.coffee
	coffee -bc $^

${CHART_DIR}/iplotScanone_pxg.js: ${CHART_DIR}/iplotScanone_pxg.coffee
	coffee -bc $^

${CHART_DIR}/iplotPXG.js: ${CHART_DIR}/iplotPXG.coffee
	coffee -bc $^

${CHART_DIR}/corr_w_scatter.js: ${CHART_DIR}/corr_w_scatter.coffee
	coffee -bc $^




# remove all data files and javascript files
clean:
	rm ${LODCHART_DIR}/lodchart.js ${LODCHART_TESTDIR}/test_lodchart.js ${SCATTERPLOT_DIR}/scatterplot.js ${SCATTERPLOT_TESTDIR}/test_scatterplot.js ${DOTCHART_DIR}/dotchart.js ${DOTCHART_TESTDIR}/test_dotchart.js ${PANEL_DIR}/*/*.json ${CHART_DIR}/*.js


web:
	scp ${LODCHART_DIR}/lodchart.* broman-2:public_html/D3/lodchart/
	cd ${LODCHART_TESTDIR};scp test_lodchart.* *.json index.html broman-2:public_html/D3/lodchart/test/
	scp ${SCATTERPLOT_DIR}/scatterplot.* broman-2:public_html/D3/scatterplot/
	cd ${SCATTERPLOT_TESTDIR};scp test_scatterplot.* *.json index.html broman-2:public_html/D3/scatterplot/test/
	scp ${DOTCHART_DIR}/dotchart.* broman-2:public_html/D3/dotchart/
	cd ${DOTCHART_TESTDIR};scp test_dotchart.* *.json index.html broman-2:public_html/D3/dotchart/test/
