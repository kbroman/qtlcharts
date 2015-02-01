# iplotMap: interactive plot of a genetic marker map
# Karl W Broman

iplotMap = (el, data, chartOpts) ->

    # chartOpts start
    width = chartOpts?.width ? 1000 # width of chart in pixels
    height = chartOpts?.height ? 600 # height of chart in pixels
    margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40, inner:10} # margins in pixels (left, top, right, bottom, inner)
    axispos = chartOpts?.axispos ? {xtitle:25, ytitle:30, xlabel:5, ylabel:5} # position of axis labels in pixels (xtitle, ytitle, xlabel, ylabel)
    titlepos = chartOpts?.titlepos ? 20 # position of chart title in pixels
    ylim = chartOpts?.ylim ? null # y-axis limits
    nyticks = chartOpts?.nyticks ? 5 # no. ticks on y-axis
    yticks = chartOpts?.yticks ? null # vector of tick positions on y-axis
    tickwidth = chartOpts?.tickwidth ? 10 # width of tick marks at markers, in pixels
    rectcolor = chartOpts?.rectcolor ? "#E6E6E6" # color of background rectangle
    linecolor = chartOpts?.linecolor ? "slateblue" # color of lines
    linecolorhilit = chartOpts?.linecolorhilit ? "Orchid" # color of lines, when highlighted
    linewidth = chartOpts?.linewidth ? 3 # width of lines
    title = chartOpts?.title ? "" # title for chart
    xlab = chartOpts?.xlab ? "Chromosome" # x-axis label
    ylab = chartOpts?.ylab ? "Position (cM)" # y-axis label
    # chartOpts end
    chartdivid = chartOpts?.chartdivid ? 'chart'

    mychart = mapchart().height(height-margin.top-margin.bottom)
                        .width(width-margin.left-margin.right)
                        .margin(margin)
                        .axispos(axispos)
                        .titlepos(titlepos)
                        .ylim(ylim)
                        .yticks(yticks)
                        .nyticks(nyticks)
                        .tickwidth(tickwidth)
                        .rectcolor(rectcolor)
                        .linecolor(linecolor)
                        .linecolorhilit(linecolorhilit)
                        .linewidth(linewidth)
                        .title(title)
                        .xlab(xlab)
                        .ylab(ylab)

    svg = d3.select(el).select("svg")
            .datum(data)
            .call(mychart)

    ##############################
    # code for marker search box for iplotMap
    ##############################

    # reorganize map information by marker
    markerpos = {}
    for chr in data.chr
        for marker of data.map[chr]
            markerpos[marker] = {chr:chr, pos:data.map[chr][marker]}

    # create marker tip
    martip = d3.tip()
               .attr('class', 'd3-tip')
               .html((d) ->
                  pos = d3.format(".1f")(markerpos[d].pos)
                  "#{d} (#{pos})")
               .direction('e')
               .offset([0,10])
    svg.call(martip)

    clean_marker_name = (markername) ->
        markername.replace(".", "\\.")
                  .replace("#", "\\#")
                  .replace("/", "\\/")

    # grab selected marker from the search box
    selectedMarker = ""
    $("#markerinput").submit () ->
        newSelection = document.getElementById("marker").value
        event.preventDefault()
        unless selectedMarker == ""
            d3.select("line##{clean_marker_name(selectedMarker)}")
              .attr("stroke", linecolor)
            martip.hide()

        if newSelection != ""
            if data.markernames.indexOf(newSelection) >= 0
                selectedMarker = newSelection
                line = d3.select("line##{clean_marker_name(selectedMarker)}")
                         .attr("stroke", linecolorhilit)
                martip.show(line.datum(), line.node())
                d3.select("a#currentmarker")
                  .text("")
                return true
            else
                d3.select("a#currentmarker")
                  .text("Marker \"#{newSelection}\" not found")

        return false


    # autocomplete
    $('input#marker').autocomplete({
        autoFocus: true,
        source: (request, response) ->
            matches = $.map(data.markernames, (tag) ->
                tag if tag.toUpperCase().indexOf(request.term.toUpperCase()) is 0)
            response(matches)
        ,
        select: (event, ui) ->
            $('input#marker').val(ui.item.label)
            $('input#submit').submit()})


    # grayed out "Marker name"
    $('input#marker').each(() ->
        $(this)
            .data('default', $(this).val())
            .addClass('inactive')
            .focus(() ->
                $(this).removeClass('inactive')
                $(this).val('') if($(this).val() is $(this).data('default') or $(this).val() is '')
            )
            .blur(() ->
                if($(this).val() is '')
                    $(this).addClass('inactive').val($(this).data('default'))
            )
        )

    # on hover, remove tool tip from marker search
    markerSelect = mychart.markerSelect()
    markerSelect.on("mouseover", martip.hide)

add_search_box = (el) ->
    form = d3.select(el)
             .append("div")
                 .attr("class", "searchbox")
                 .attr("id", "markerinput")
             .append("form")
                 .attr("name", "markerinput")
    form.append("input")
            .attr("id", "marker")
            .attr("type", "text")
            .attr("value", "Marker name")
            .attr("name", "marker")
    form.append("input")
            .attr("type", "submit")
            .attr("id", "submit")
            .attr("value", "Submit")
    form.append("a")
            .attr("id", "currentmarker")
