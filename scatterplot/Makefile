all: scatterplot.js test_scatterplot.js data.json test_scatterplot_brush.js

scatterplot.js: scatterplot.coffee
	coffee -bc scatterplot.coffee

test_scatterplot.js: test_scatterplot.coffee
	coffee -c test_scatterplot.coffee

test_scatterplot_brush.js: test_scatterplot_brush.coffee
	coffee -c test_scatterplot_brush.coffee

data.json: create_test_data.R
	R CMD BATCH create_test_data.R

web: all
	scp index.html scatterplot.* *.json test_scatterplot.* broman-2:public_html/D3/scatterplot/
