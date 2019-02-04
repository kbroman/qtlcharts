# iplotMap: interactive plot of a genetic marker map
# Karl W Broman

iplotMap = (widgetdiv, data, chartOpts) ->

    # chartOpts start
    width = chartOpts?.width ? 1000                               # width of chart in pixels
    height = chartOpts?.height ? 600                              # height of chart in pixels
    margin = chartOpts?.margin ? {left:60, top:40, right:100, bottom: 40, inner:10} # margins in pixels (left, top, right, bottom, inner)
    axispos = chartOpts?.axispos ? {xtitle:25, ytitle:30, xlabel:5, ylabel:5}       # position of axis labels in pixels (xtitle, ytitle, xlabel, ylabel)
    titlepos = chartOpts?.titlepos ? 20                           # position of chart title in pixels
    ylim = chartOpts?.ylim ? null                                 # y-axis limits
    nyticks = chartOpts?.nyticks ? 5                              # no. ticks on y-axis
    yticks = chartOpts?.yticks ? null                             # vector of tick positions on y-axis
    xlineOpts = chartOpts?.xlineOpts ? {color:"#cdcdcd", width:5} # color and width of vertical lines
    tickwidth = chartOpts?.tickwidth ? 10                         # width of tick marks at markers, in pixels
    rectcolor = chartOpts?.rectcolor ? "#E6E6E6"                  # color of background rectangle
    linecolor = chartOpts?.linecolor ? "slateblue"                # color of lines
    linecolorhilit = chartOpts?.linecolorhilit ? "Orchid"         # color of lines, when highlighted
    linewidth = chartOpts?.linewidth ? 3                          # width of lines
    title = chartOpts?.title ? ""                                 # title for chart
    xlab = chartOpts?.xlab ? "Chromosome"                         # x-axis label
    ylab = chartOpts?.ylab ? "Position (cM)"                      # y-axis label
    shiftStart = chartOpts?.shiftStart ? false                    # if true, shift the start of chromosomes to 0
    horizontal = chartOpts?.horizontal ? false                    # if true, have chromosomes on vertical axis and positions horizontally
    # chartOpts end
    chartdivid = chartOpts?.chartdivid ? 'chart'
    widgetdivid = d3.select(widgetdiv).attr('id')

    # make sure list args have all necessary bits
    margin = d3panels.check_listarg_v_default(margin, {left:60, top:40, right:100, bottom: 40, inner:10})
    axispos = d3panels.check_listarg_v_default(axispos, {xtitle:25, ytitle:30, xlabel:5, ylabel:5})

    mychart = d3panels.mapchart({
                  height:height
                  width:width
                  margin:margin
                  axispos:axispos
                  titlepos:titlepos
                  ylim:ylim
                  yticks:yticks
                  nyticks:nyticks
                  xlineOpts:xlineOpts
                  tickwidth:tickwidth
                  rectcolor:rectcolor
                  linecolor:linecolor
                  linecolorhilit:linecolorhilit
                  linewidth:linewidth
                  title:title
                  xlab:xlab
                  ylab:ylab
                  horizontal:horizontal
                  shiftStart:shiftStart
                  tipclass:widgetdivid})

    # select htmlwidget div and grab its ID
    div = d3.select(widgetdiv)
    mychart(div.select("svg"), data)
    svg = mychart.svg()

    ##############################
    # code for marker search box for iplotMap
    ##############################

    # create marker tip
    martip = d3.tip()
               .attr('class', "d3-tip #{widgetdivid}")
               .html((d) ->
                  pos = d3.format(".1f")(data.pos[data.marker.indexOf(d)])
                  "#{d} (#{pos})")
               .direction(() ->
                   return 'n' if horizontal
                   'e')
               .offset(() ->
                   return [-10,0] if horizontal
                   [0,10])
    svg.call(martip)

    clean_marker_name = (markername) ->
        markername.replace(".", "\\.")
                  .replace("#", "\\#")
                  .replace("/", "\\/")

    # grab selected marker from the search box
    selectedMarker = ""
    $("div#markerinput_#{widgetdivid}").submit (event) ->
        newSelection = document.getElementById("marker_#{widgetdivid}").value
        event.preventDefault()
        unless selectedMarker == ""
            div.select("line##{clean_marker_name(selectedMarker)}")
               .attr("stroke", linecolor)
            martip.hide()

        if newSelection != ""
            if data.marker.indexOf(newSelection) >= 0
                selectedMarker = newSelection
                line = div.select("line##{clean_marker_name(selectedMarker)}")
                          .attr("stroke", linecolorhilit)
                martip.show(line.datum(), line.node())
                div.select("a#currentmarker")
                   .text("")
                return true
            else
                div.select("a#currentmarker")
                   .text("Marker \"#{newSelection}\" not found")

        return false


    # autocomplete
    $("input#marker_#{widgetdivid}").autocomplete({
        autoFocus: true,
        source: (request, response) ->
            matches = $.map(data.marker, (tag) ->
                tag if tag.toUpperCase().indexOf(request.term.toUpperCase()) is 0)
            response(matches)
        ,
        select: (event, ui) ->
            $("input#marker_#{widgetdivid}").val(ui.item.label)
            $("input#submit_#{widgetdivid}").submit(event)})


    # grayed out "Marker name"
    $("input#marker_#{widgetdivid}").each(() ->
        $("div.searchbox#markerinput_#{widgetdivid}").addClass('inactive')
        $(this)
            .data('default', $(this).val())
            .focus(() ->
                $("div.searchbox#markerinput_#{widgetdivid}").removeClass('inactive')
                $(this).val('') if($(this).val() is $(this).data('default') or $(this).val() is '')
            )
            .blur(() ->
                if($(this).val() is '')
                    $("div.searchbox#markerinput_#{widgetdivid}").addClass('inactive')
                    $(this).val($(this).data('default'))
            )
        )

    # on hover, remove tool tip from marker search
    markerSelect = mychart.markerSelect()
    markerSelect.on "mouseover", (d) ->
        unless selectedMarker == ""
            unless selectedMarker == d # de-highlight (if hovering over something other than the selected marker)
                div.select("line##{clean_marker_name(selectedMarker)}")
                   .attr("stroke", linecolor)
            martip.hide()

    if chartOpts.heading?
        d3.select("div#htmlwidget_container")
          .insert("h2", ":first-child")
          .html(chartOpts.heading)
          .style("font-family", "sans-serif")

    if chartOpts.caption?
        d3.select("body")
          .append("p")
          .attr("class", "caption")
          .html(chartOpts.caption)

    if chartOpts.footer?
        d3.select("body")
          .append("div")
          .html(chartOpts.footer)
          .style("font-family", "sans-serif")

add_search_box = (widgetdiv) ->
    div = d3.select(widgetdiv)
    widgetdivid = div.attr("id")

    form = div.append("div")
                 .attr("class", "searchbox")
                 .attr("id", "markerinput_#{widgetdivid}")
              .append("form")
                 .attr("name", "markerinput_#{widgetdivid}")
    form.append("input")
            .attr("id", "marker_#{widgetdivid}")
            .attr("type", "text")
            .attr("value", "Marker name")
            .attr("name", "marker")
    form.append("input")
            .attr("type", "submit")
            .attr("id", "submit_#{widgetdivid}")
            .attr("value", "Submit")
    form.append("a")
            .attr("id", "currentmarker")
