all: jscharts jswidgets json doc inst/ToDo.html libs longname
.PHONY: all jscharts json doc clean libs d3, jquery, jqueryui, colorbrewer longname

PANEL_DIR = inst/htmlwidgets/lib/d3panels
CHART_DIR = inst/htmlwidgets/lib/qtlcharts
WIDGET_DIR = inst/htmlwidgets

COFFEE_ARGS = -c # use -cm for debugging; -c otherwise

inst/ToDo.html: inst/ToDo.md
	cd inst;R -e 'markdown::markdownToHTML("ToDo.md", "ToDo.html")'

# build package documentation
doc:
	R -e 'devtools::document()'

#------------------------------------------------------------

# javascript for the chart functions
JSCHARTS = $(CHART_DIR)/iplotScanone_noeff.js \
		   $(CHART_DIR)/iplotScanone_pxg.js \
		   $(CHART_DIR)/iplotScanone_ci.js \
		   $(CHART_DIR)/idotplot.js \
		   $(CHART_DIR)/iplotCorr.js \
		   $(CHART_DIR)/iplotCorr_noscat.js \
		   $(CHART_DIR)/iboxplot.js \
		   $(CHART_DIR)/iplotCurves.js \
		   $(CHART_DIR)/iplotMap.js \
		   $(CHART_DIR)/iplotRF.js \
		   $(CHART_DIR)/iplotMScanone_noeff.js \
		   $(CHART_DIR)/iplotMScanone_eff.js \
		   $(CHART_DIR)/iheatmap.js \
		   $(CHART_DIR)/iplot.js \
		   $(CHART_DIR)/iplotScantwo.js \
		   $(CHART_DIR)/scat2scat.js \
		   $(CHART_DIR)/itriplot.js
jscharts: $(JSCHARTS)

$(CHART_DIR)/%.js: $(CHART_DIR)/%.coffee
	coffee $(COFFEE_ARGS) -b $^

#------------------------------------------------------------

# javascript for the widgets called from R
JSWIDGETS = $(WIDGET_DIR)/iplot.js \
			$(WIDGET_DIR)/idotplot.js \
			$(WIDGET_DIR)/iplotMap.js \
			$(WIDGET_DIR)/iheatmap.js \
			$(WIDGET_DIR)/iboxplot.js \
			$(WIDGET_DIR)/iplotCorr.js \
			$(WIDGET_DIR)/iplotCurves.js \
			$(WIDGET_DIR)/iplotRF.js \
			$(WIDGET_DIR)/iplotScanone.js \
			$(WIDGET_DIR)/iplotMScanone.js \
			$(WIDGET_DIR)/iplotScantwo.js \
			$(WIDGET_DIR)/scat2scat.js \
			$(WIDGET_DIR)/itriplot.js
jswidgets: $(JSWIDGETS)

$(WIDGET_DIR)/%.js: $(WIDGET_DIR)/%.coffee
	coffee $(COFFEE_ARGS) -b $^

#------------------------------------------------------------
# d3, jquery, jquery-ui, colorbrewer, d3panels
libs: d3 jquery jqueryui colorbrewer d3-tip d3panels
LIB_DIR = inst/htmlwidgets/lib
BOWER_DIR = bower/bower_components

# d3
d3: $(LIB_DIR)/d3/d3.min.js $(LIB_DIR)/d3/LICENSE $(LIB_DIR)/d3/bower.json
$(LIB_DIR)/d3/%: $(BOWER_DIR)/d3/%
	cp $< $@

# colorbrewer
colorbrewer: $(LIB_DIR)/colorbrewer/LICENSE \
			 $(LIB_DIR)/colorbrewer/colorbrewer.js \
			 $(LIB_DIR)/colorbrewer/colorbrewer.css \
			 $(LIB_DIR)/colorbrewer/bower.json
$(LIB_DIR)/colorbrewer/%: $(BOWER_DIR)/colorbrewer/%
	cp $< $@

# jquery
jquery: $(LIB_DIR)/jquery/MIT-LICENSE.txt \
		$(LIB_DIR)/jquery/dist/jquery.min.js \
		$(LIB_DIR)/jquery/bower.json
$(LIB_DIR)/jquery/%: $(BOWER_DIR)/jquery/%
	cp $< $@

# jquery-ui
jqueryui: $(LIB_DIR)/jquery-ui/jquery-ui.min.js
$(LIB_DIR)/jquery-ui/jquery-ui.min.js: $(BOWER_DIR)/jquery-ui/jquery-ui.min.js
	cp $< $@
	cp $(<D)/LICENSE.txt $(@D)/
	cp $(<D)/bower.json $(@D)/
	cp $(<D)/themes/smoothness/*.* $(@D)/themes/smoothness/
	cp $(<D)/themes/smoothness/images/*.* $(@D)/themes/smoothness/images/

# d3-tip
d3-tip: $(LIB_DIR)/d3-tip/bower.json \
		$(LIB_DIR)/d3-tip/LICENSE \
		$(LIB_DIR)/d3-tip/index-min.js
$(LIB_DIR)/d3-tip/%: $(BOWER_DIR)/d3-tip/%
	cp $< $@
$(LIB_DIR)/d3-tip/index-min.js: $(BOWER_DIR)/d3-tip/index.js
	uglifyjs $< -o $@

# d3panels
d3panels: $(LIB_DIR)/d3panels/d3panels.min.js \
		  $(LIB_DIR)/d3panels/d3panels.min.css \
		  $(LIB_DIR)/d3panels/ReadMe.md \
		  $(LIB_DIR)/d3panels/License.md \
		  $(LIB_DIR)/d3panels/bower.json
$(LIB_DIR)/d3panels/%: $(BOWER_DIR)/d3panels/%
	cp $< $@

#------------------------------------------------------------

# remove all data files and javascript files
clean:
	rm $(PANEL_DIR)/*.js $(CHART_DIR)/*.js

#------------------------------------------------------------

# deal with a jquery-ui file with a really long name
# (by just renaming it, though I think then this won't work)

longname: inst/htmlwidgets/lib/jquery-ui/themes/smoothness/images/ui-longname.png
inst/htmlwidgets/lib/jquery-ui/themes/smoothness/images/ui-longname.png:
	cd $(@D);mv ui-bg_highlight-soft_75_cccccc_1x100.png $(@F)
