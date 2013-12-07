all: js json doc

CHART_DIR = inst/charts
LODCHART_DIR = ${CHART_DIR}/lodchart
SCATTERPLOT_DIR = ${CHART_DIR}/scatterplot
LODCHART_TESTDIR = ${CHART_DIR}/lodchart/test
SCATTERPLOT_TESTDIR = ${CHART_DIR}/scatterplot/test

doc:
	R -e 'library(devtools);document(roclets=c("namespace", "rd"))'

js: ${LODCHART_DIR}/lodchart.js ${SCATTERPLOT_DIR}/scatterplot.js ${LODCHART_TESTDIR}/test_lodchart.js ${SCATTERPLOT_TESTDIR}/test_scatterplot.js

json: ${LODCHART_TESTDIR}/scanone.json ${SCATTERPLOT_TESTDIR}/data.json

${LODCHART_DIR}/lodchart.js: ${LODCHART_DIR}/lodchart.coffee
	coffee -bc $^

${LODCHART_TESTDIR}/test_lodchart.js: ${LODCHART_TESTDIR}/test_lodchart.coffee
	coffee -c $^

${SCATTERPLOT_DIR}/scatterplot.js: ${SCATTERPLOT_DIR}/scatterplot.coffee
	coffee -bc $^

${SCATTERPLOT_TESTDIR}/test_scatterplot.js: ${SCATTERPLOT_TESTDIR}/test_scatterplot.coffee
	coffee -c $^

${LODCHART_TESTDIR}/scanone.json: ${LODCHART_TESTDIR}/create_test_data.R
	cd ${LODCHART_TESTDIR};R CMD BATCH create_test_data.R

${SCATTERPLOT_TESTDIR}/data.json: ${SCATTERPLOT_TESTDIR}/create_test_data.R
	cd ${SCATTERPLOT_TESTDIR};R CMD BATCH create_test_data.R


clean:
	rm ${LODCHART_DIR}/lodchart.js ${SCATTERPLOT_DIR}/scatterplot.js ${LODCHART_TESTDIR}/test_lodchart.js ${SCATTERPLOT_TESTDIR}/test_scatterplot.js ${LODCHART_TESTDIR}/scanone.json ${SCATTERPLOT_TESTDIR}/data.json

