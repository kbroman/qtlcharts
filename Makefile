all: jspanels jspaneltests jscharts jswidgets json doc inst/ToDo.html vignettes/chartOpts.Rmd libs
.PHONY: all jspanels jspaneltests jscharts json doc clean libs d3, jquery, jqueryui, colorbrewer


PANEL_DIR = inst/htmlwidgets/lib/d3panels
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
CHART_DIR = inst/htmlwidgets/lib/qtlcharts
WIDGET_DIR = inst/htmlwidgets

COFFEE_ARGS = -c # use -cm for debugging; -c otherwise

# build html version of ToDo list
inst/ToDo.html: inst/ToDo.md
	cd inst;R -e 'library(markdown);markdownToHTML("ToDo.md", "ToDo.html")'

# build package documentation
doc:
	R -e 'library(devtools);document()'

#------------------------------------------------------------

# javascript of panel tests
JSPANELTESTS = ${LODCHART_TESTDIR}/test_lodchart.js ${SCATTERPLOT_TESTDIR}/test_scatterplot.js \
			   ${DOTCHART_TESTDIR}/test_dotchart.js ${CICHART_TESTDIR}/test_cichart.js \
			   ${CURVECHART_TESTDIR}/test_curvechart.js ${MAPCHART_TESTDIR}/test_mapchart.js \
			   ${HEATMAP_TESTDIR}/test_heatmap.js ${CHRHEATMAP_TESTDIR}/test_chrheatmap.js \
			   ${LODHEATMAP_TESTDIR}/test_lodheatmap.js ${CROSSTAB_TESTDIR}/test_crosstab.js
jspaneltests: ${JSPANELTESTS}

${PANEL_DIR}/%/test/%.js: ${PANEL_DIR}/%/test/%.coffee
	coffee ${COFFEE_ARGS} $^

#------------------------------------------------------------

# javascript of panels
JSPANELS = ${LODCHART_DIR}/lodchart.js ${SCATTERPLOT_DIR}/scatterplot.js \
		   ${DOTCHART_DIR}/dotchart.js ${CICHART_DIR}/cichart.js \
		   ${CURVECHART_DIR}/curvechart.js ${MAPCHART_DIR}/mapchart.js \
		   ${HEATMAP_DIR}/heatmap.js ${CHRHEATMAP_DIR}/chrheatmap.js \
		   ${LODHEATMAP_DIR}/lodheatmap.js ${CROSSTAB_DIR}/crosstab.js \
		   ${PANEL_DIR}/panelutil.js
jspanels: ${JSPANELS}

${PANEL_DIR}/%.js: ${PANEL_DIR}/%.coffee
	coffee ${COFFEE_ARGS} -b $^

#------------------------------------------------------------

# test data files
JSON = ${LODCHART_TESTDIR}/data.json ${SCATTERPLOT_TESTDIR}/data.json \
	   ${DOTCHART_TESTDIR}/data.json ${CICHART_TESTDIR}/data.json \
	   ${CURVECHART_TESTDIR}/data.json ${MAPCHART_TESTDIR}/data.json \
	   ${HEATMAP_TESTDIR}/data.json ${CHRHEATMAP_TESTDIR}/data.json \
	   ${LODHEATMAP_TESTDIR}/data.json ${CROSSTAB_TESTDIR}/data.json
json: ${JSON}

${PANEL_DIR}/%/test/data.json: ${PANEL_DIR}/%/test/create_test_data.R
	cd $(@D);R CMD BATCH --no-save $(<F)

#------------------------------------------------------------

# javascript for the chart functions
JSCHARTS = ${CHART_DIR}/iplotScanone_noeff.js ${CHART_DIR}/iplotScanone_pxg.js \
		   ${CHART_DIR}/iplotScanone_ci.js ${CHART_DIR}/iplotPXG.js \
		   ${CHART_DIR}/iplotCorr.js ${CHART_DIR}/iboxplot.js \
		   ${CHART_DIR}/iplotCurves.js ${CHART_DIR}/iplotMap.js \
		   ${CHART_DIR}/iplotRF.js ${CHART_DIR}/iplotMScanone_noeff.js \
		   ${CHART_DIR}/iplotMScanone_eff.js ${CHART_DIR}/iheatmap.js \
		   ${CHART_DIR}/iplot.js ${CHART_DIR}/iplotScantwo.js
jscharts: ${JSCHARTS}

${CHART_DIR}/%.js: ${CHART_DIR}/%.coffee
	coffee ${COFFEE_ARGS} -b $^

#------------------------------------------------------------

# javascript for the widgets called from R
JSWIDGETS = ${WIDGET_DIR}/iplot.js ${WIDGET_DIR}/iplotPXG.js \
			${WIDGET_DIR}/iplotMap.js ${WIDGET_DIR}/iheatmap.js \
			${WIDGET_DIR}/iboxplot.js ${WIDGET_DIR}/iplotCorr.js \
			${WIDGET_DIR}/iplotCurves.js ${WIDGET_DIR}/iplotRF.js \
			${WIDGET_DIR}/iplotScanone.js ${WIDGET_DIR}/iplotMScanone.js \
			${WIDGET_DIR}/iplotScantwo.js
jswidgets: ${JSWIDGETS}

${WIDGET_DIR}/%.js: ${WIDGET_DIR}/%.coffee
	coffee ${COFFEE_ARGS} -b $^

#------------------------------------------------------------
# d3, jquery, jquery-ui, colorbrewer
libs: d3 jquery jqueryui colorbrewer d3-tip
LIB_DIR = inst/htmlwidgets/lib
BOWER_DIR = ../libs/bower_components

# d3
d3: ${LIB_DIR}/d3/d3.min.js ${LIB_DIR}/d3/LICENSE ${LIB_DIR}/d3/bower.json
${LIB_DIR}/d3/%: ${BOWER_DIR}/d3/%
	cp $< $@

# colorbrewer
colorbrewer: ${LIB_DIR}/colorbrewer/LICENSE \
			 ${LIB_DIR}/colorbrewer/colorbrewer.js \
			 ${LIB_DIR}/colorbrewer/colorbrewer.css \
			 ${LIB_DIR}/colorbrewer/bower.json
${LIB_DIR}/colorbrewer/%: ${BOWER_DIR}/colorbrewer/%
	cp $< $@

# jquery
jquery: ${LIB_DIR}/jquery/MIT-LICENSE.txt \
		${LIB_DIR}/jquery/dist/jquery.min.js \
		${LIB_DIR}/jquery/bower.json
${LIB_DIR}/jquery/%: ${BOWER_DIR}/jquery/%
	cp $< $@

# jquery-ui
jqueryui: ${LIB_DIR}/jquery-ui/jquery-ui.min.js
${LIB_DIR}/jquery-ui/jquery-ui.min.js: ${BOWER_DIR}/jquery-ui/jquery-ui.min.js
	cp $< $@
	cp $(<D)/LICENSE.txt $(@D)/
	cp $(<D)/bower.json $(@D)/
	cp $(<D)/themes/smoothness/*.* $(@D)/themes/smoothness/
	cp $(<D)/themes/smoothness/images/*.* $(@D)/themes/smoothness/images/

# d3-tip
d3-tip: ${LIB_DIR}/d3-tip/bower.json \
		${LIB_DIR}/d3-tip/d3-tip.min.css \
		${LIB_DIR}/d3-tip/d3-tip.min.js \
		${LIB_DIR}/d3-tip/LICENSE
${LIB_DIR}/d3-tip/%: ${BOWER_DIR}/../d3-tip/%
	cp $< $@

#------------------------------------------------------------

# Add list of chartOpts to vignette

vignettes/chartOpts.Rmd: vignettes/chartOpts/grab_chartOpts.rb \
						 vignettes/chartOpts/chartOpts_source.Rmd \
						 vignettes/chartOpts/multiversions.csv \
						 ${JSCHARTS}
	$<

#------------------------------------------------------------

# remove all data files and javascript files
clean:
	rm ${PANEL_DIR}/*/*.js ${PANEL_DIR}/*/test/*.js ${PANEL_DIR}/*/test/*.json ${CHART_DIR}/*.js
