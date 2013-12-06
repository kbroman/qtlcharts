all: js json doc

CHART_DIR = inst/charts
LODCHART_DIR = ${CHART_DIR}/lodchart
SCATTERPLOT_DIR = ${CHART_DIR}/scatterplot

doc:
	R -e 'library(devtools);document()'

js: ${LODCHART_DIR}/lodchart.js ${SCATTERPLOT_DIR}/scatterplot.js ${LODCHART_DIR}/test_lodchart.js ${SCATTERPLOT_DIR}/test_scatterplot.js

json: inst/charts/lodchart/scanone.json inst/charts/scatterplot/data.json

${LODCHART_DIR}/lodchart.js: ${LODCHART_DIR}/lodchart.coffee
	coffee -c $^

${LODCHART_DIR}/test_lodchart.js: ${LODCHART_DIR}/test_lodchart.coffee
	coffee -c $^

${SCATTERPLOT_DIR}/scatterplot.js: ${SCATTERPLOT_DIR}/scatterplot.coffee
	coffee -bc $^

${SCATTERPLOT_DIR}/test_scatterplot.js: ${SCATTERPLOT_DIR}/test_scatterplot.coffee
	coffee -c $^

${LODCHART_DIR}/scanone.json: ${LODCHART_DIR}/create_test_data.R
	cd ${LODCHART_DIR};R CMD BATCH create_test_data.R

${SCATTERPLOT_DIR}/data.json: ${SCATTERPLOT_DIR}/create_test_data.R
	cd ${SCATTERPLOT_DIR};R CMD BATCH create_test_data.R

