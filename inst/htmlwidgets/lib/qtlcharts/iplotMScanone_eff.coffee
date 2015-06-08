# iplotMScanone_eff: image of lod curves linked to plot of lod curves
# Karl W Broman

iplotMScanone_eff = (widgetdiv, lod_data, eff_data, times, chartOpts) ->

    # chartOpts start
    height = chartOpts?.height ? 700 # height of chart in pixels
    width = chartOpts?.width ? 1000 # width of chart in pixels
    wleft = chartOpts?.wleft ? width*0.65 # width of left panels in pixels
    htop = chartOpts?.htop ? height/2 # height of top panels in pixels
    margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40, inner:5} # margins in pixels (left, top, right, bottom, inner)
    axispos = chartOpts?.axispos ? {xtitle:25, ytitle:30, xlabel:5, ylabel:5} # position of axis labels in pixels (xtitle, ytitle, xlabel, ylabel)
    titlepos = chartOpts?.titlepos ? 20 # position of chart title in pixels
    chrGap = chartOpts?.chrGap ? 8 # gap between chromosomes in pixels
    darkrect = chartOpts?.darkrect ? "#C8C8C8" # color of darker background rectangle
    lightrect = chartOpts?.lightrect ? "#E6E6E6" # color of lighter background rectangle
    nullcolor = chartOpts?.nullcolor ? "#E6E6E6" # color for pixels with null values
    colors = chartOpts?.colors ? ["slateblue", "white", "crimson"] # heat map colors
    zlim = chartOpts?.zlim ? null # z-axis limits
    zthresh = chartOpts?.zthresh ? null # lower z-axis threshold for display in heat map
    lod_ylab = chartOpts?.lod_ylab ? "" # y-axis label for LOD heatmap (also used as x-axis label on effect plot)
    eff_ylim = chartOpts?.eff_ylim ? null # y-axis limits for effect plot (right panel)
    eff_ylab = chartOpts?.eff_ylab ? "" # y-axis label for effect plot (right panel)
    linecolor = chartOpts?.linecolor ? "darkslateblue" # line color for LOD curves (lower panel)
    eff_linecolor = chartOpts?.eff_linecolor ? null # line color for effect plot (right panel)
    linewidth = chartOpts?.linewidth ? 2 # line width for LOD curves (lower panel)
    eff_linewidth = chartOpts?.eff_linewidth ? 2 # width of line for effect plot (right panel)
    pointcolor = chartOpts?.pointcolor ? "slateblue" # point color for LOD curves (lower panel)
    pointsize = chartOpts?.pointsize ? 0 # point size for LOD curves (lower panel); 0 means no points
    pointstroke = chartOpts?.pointstroke ? "black" # stroke color for points in LOD curves (lower panel)
    eff_pointcolor = chartOpts?.eff_pointcolor ? null # point color for effect plot (right panel)
    eff_pointsize = chartOpts?.eff_pointsize ? 0 # point size for effect plot (right panel); 0 means no points
    eff_pointstroke = chartOpts?.eff_pointstroke ? "black" # stroke color for points in effect plot (right panel)
    nxticks = chartOpts?.nxticks ? 5 # no. ticks in x-axis for effect plot (right panel), if quantitative scale
    xticks = chartOpts?.xticks ? null # tick positions in x-axis for effect plot (right panel), if quantitative scale
    lod_labels = chartOpts?.lod_labels ? null # optional vector of strings, for LOD column labels
    # chartOpts end
    chartdivid = chartOpts?.chartdivid ? 'chart'

    wright = width - wleft
    hbot = height - htop

    # if quant scale, use times as labels; otherwise use lod_data.lodnames
    unless lod_labels?
        lod_labels = if times? then (formatAxis(times, extra_digits=1)(x) for x in times) else lod_data.lodnames

    mylodheatmap = lodheatmap().height(htop-margin.top-margin.bottom)
                               .width(wleft-margin.left-margin.right)
                               .margin(margin)
                               .axispos(axispos)
                               .titlepos(titlepos)
                               .chrGap(chrGap)
                               .rectcolor(lightrect)
                               .colors(colors)
                               .zlim(zlim)
                               .zthresh(zthresh)
                               .quantScale(times)
                               .lod_labels(lod_labels)
                               .ylab(lod_ylab)
                               .nullcolor(nullcolor)

    svg = d3.select(widgetdiv).select("svg")

    g_heatmap = svg.append("g")
                   .attr("id", "heatmap")
                   .datum(lod_data)
                   .call(mylodheatmap)

    mylodchart = lodchart().height(hbot-margin.top-margin.bottom)
                           .width(wleft-margin.left-margin.right)
                           .margin(margin)
                           .axispos(axispos)
                           .titlepos(titlepos)
                           .chrGap(chrGap)
                           .linecolor("none")
                           .pad4heatmap(true)
                           .darkrect(darkrect)
                           .lightrect(lightrect)
                           .ylim([0, d3.max(mylodheatmap.zlim())])
                           .pointsAtMarkers(false)

    g_lodchart = svg.append("g")
                    .attr("transform", "translate(0,#{htop})")
                    .attr("id", "lodchart")
                    .datum(lod_data)
                    .call(mylodchart)

    # function for lod curve path
    lodcurve = (chr, lodcolumn) ->
                  d3.svg.line()
                    .x((d) -> mylodchart.xscale()[chr](d))
                    .y((d,i) -> mylodchart.yscale()(Math.abs(lod_data.lodByChr[chr][i][lodcolumn])))

    # plot lod curves for selected LOD column
    lodchart_curves = null
    plotLodCurve = (lodcolumn) ->
        lodchart_curves = g_lodchart.append("g").attr("id", "lodcurves")
        for chr in lod_data.chrnames
            lodchart_curves.append("path")
                           .datum(lod_data.posByChr[chr])
                           .attr("d", lodcurve(chr, lodcolumn))
                           .attr("stroke", linecolor)
                           .attr("fill", "none")
                           .attr("stroke-width", linewidth)
                           .style("pointer-events", "none")
            if pointsize > 0
                lodchart_curves.append("g").attr("id", "lodpoints")
                               .selectAll("empty")
                               .data(lod_data.posByChr[chr])
                               .enter()
                               .append("circle")
                               .attr("cx", (d) -> mylodchart.xscale()[chr](d))
                               .attr("cy", (d,i) ->
                                   mylodchart.yscale()(Math.abs(lod_data.lodByChr[chr][i][lodcolumn])))
                               .attr("r", pointsize)
                               .attr("fill", pointcolor)
                               .attr("stroke", pointstroke)

    # dealing with the possibly multiple QTL effects (like add've and dominance)
    eff_ylim = eff_ylim ? matrixExtent(eff_data.map((d) -> matrixExtent(d.data)))
    eff_nlines = d3.max(eff_data.map((d) -> d.names.length))
    eff_linecolor = eff_linecolor ? selectGroupColors(eff_nlines, "dark")
    eff_pointcolor = eff_pointcolor ? selectGroupColors(eff_nlines, "dark")
    eff_linecolor = forceAsArray(eff_linecolor) # force to be arrays
    eff_pointcolor = forceAsArray(eff_pointcolor) # force to be an array

    mycurvechart = curvechart().height(htop-margin.top-margin.bottom)
                               .width(wright-margin.left-margin.right)
                               .margin(margin)
                               .axispos(axispos)
                               .titlepos(titlepos)
                               .xlab(lod_ylab)
                               .ylab(eff_ylab)
                               .strokecolor("none")
                               .rectcolor(lightrect)
                               .xlim([-0.5, lod_data.lodnames.length-0.5])
                               .ylim(eff_ylim)
                               .nxticks(0)
                               .commonX(true)

    g_curvechart = svg.append("g")
                      .attr("transform", "translate(#{wleft},0)")
                      .attr("id", "curvechart")
                      .datum(eff_data[0])
                      .call(mycurvechart)

    # function for eff curve path
    effcurve = (posindex, column) ->
                  d3.svg.line()
                    .x((d) -> mycurvechart.xscale()(d))
                    .y((d,i) -> mycurvechart.yscale()(eff_data[posindex].data[column][i]))

    # plot effect curves for a given position
    effchart_curves = null
    plotEffCurves = (posindex) ->
        effchart_curves = g_curvechart.append("g").attr("id", "curves")
        for curveindex of eff_data[posindex].names
            effchart_curves.append("path")
                           .datum(eff_data[posindex].x)
                           .attr("d", effcurve(posindex,curveindex))
                           .attr("fill", "none")
                           .attr("stroke", eff_linecolor[curveindex])
                           .attr("stroke-width", eff_linewidth)
            effchart_curves.selectAll("empty")
                           .data(eff_data[posindex].names)
                           .enter()
                           .append("text")
                           .text((d) -> d)
                           .attr("x", (d,i) -> margin.left + wright + axispos.ylabel)
                           .attr("y", (d,i) ->
                                     z = eff_data[posindex].data[i]
                                     mycurvechart.yscale()(z[z.length-1]))
                           .style("dominant-baseline", "middle")
                           .style("text-anchor", "start")
            if eff_pointsize > 0
                effchart_curves.append("g").attr("id", "eff_points")
                               .selectAll("empty")
                               .data(eff_data[posindex].x)
                               .enter()
                               .append("circle")
                               .attr("cx", (d) -> mycurvechart.xscale()(d))
                               .attr("cy", (d,i) ->
                                   mycurvechart.yscale()(eff_data[posindex].data[curveindex][i]))
                               .attr("r", eff_pointsize)
                               .attr("fill", eff_pointcolor[curveindex])
                               .attr("stroke", eff_pointstroke)

    # add X axis
    if times? # use quantitative axis
        xscale = d3.scale.linear().range(mycurvechart.xscale().range())
        xscale.domain([times[0], times[times.length-1]])
        xticks = xticks ? xscale.ticks(nxticks)
        curvechart_xaxis = g_curvechart.select("g.x.axis")
        curvechart_xaxis.selectAll("empty")
                        .data(xticks)
                        .enter()
                        .append("line")
                        .attr("x1", (d) -> xscale(d))
                        .attr("x2", (d) -> xscale(d))
                        .attr("y1", margin.top)
                        .attr("y2", htop-margin.bottom)
                        .attr("fill", "none")
                        .attr("stroke", "white")
                        .attr("stroke-width", 1)
                        .style("pointer-events", "none")
        curvechart_xaxis.selectAll("empty")
                        .data(xticks)
                        .enter()
                        .append("text")
                        .attr("x", (d) -> xscale(d))
                        .attr("y", htop-margin.bottom+axispos.xlabel)
                        .text((d) -> formatAxis(xticks)(d))
    else # qualitative axis
        curvechart_xaxis = g_curvechart.select("g.x.axis")
                                       .selectAll("empty")
                                       .data(lod_labels)
                                       .enter()
                                       .append("text")
                                       .attr("class", "y axis")
                                       .attr("id", (d,i) -> "xaxis#{i}")
                                       .attr("x", (d,i) -> mycurvechart.xscale()(i))
                                       .attr("y", htop-margin.bottom+axispos.xlabel)
                                       .text((d) -> d)
                                       .attr("opacity", 0)

    # hash for [chr][pos] -> posindex
    posindex = {}
    curindex = 0
    for chr in lod_data.chrnames
        posindex[chr] = {}
        for pos in lod_data.posByChr[chr]
            posindex[chr][pos] = curindex
            curindex += 1

    mycurvechart.curvesSelect()
                .on("mouseover.panel", null)
                .on("mouseout.panel", null)

    mylodheatmap.cellSelect()
                .on "mouseover", (d) ->
                         plotLodCurve(d.lodindex)
                         g_lodchart.select("g.title text").text("#{lod_labels[d.lodindex]}")
                         plotEffCurves(posindex[d.chr][d.pos])
                         p = d3.format(".1f")(d.pos)
                         g_curvechart.select("g.title text").text("#{d.chr}@#{p}")
                         g_curvechart.select("text#xaxis#{d.lodindex}").attr("opacity", 1)
                .on "mouseout", (d) ->
                         lodchart_curves.remove()
                         g_lodchart.select("g.title text").text("")
                         effchart_curves.remove()
                         g_curvechart.select("g.title text").text("")
                         g_curvechart.select("text#xaxis#{d.lodindex}").attr("opacity", 0)
