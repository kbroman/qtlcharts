# iplotMScanone_eff: image of lod curves linked to plot of lod curves
# Karl W Broman

plotLines = null

iplotMScanone_eff = (lod_data, eff_data, chartOpts) ->

  # chartOpts start
  wleft = chartOpts?.wleft ? 650 # width of left panels in pixels
  wright = chartOpts?.wright ? 350 # width of right panel in pixels
  htop = chartOpts?.htop ? 350 # height of top panels in pixels
  hbot = chartOpts?.hbot ? 350 # height of bottom panel in pixels
  margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40, inner:5} # margins in pixels (left, top, right, bottom, inner)
  axispos = chartOpts?.axispos ? {xtitle:25, ytitle:30, xlabel:5, ylabel:5} # position of axis labels in pixels (xtitle, ytitle, xlabel, ylabel)
  titlepos = chartOpts?.titlepos ? 20 # position of chart title in pixels
  chrGap = chartOpts?.chrGap ? 8 # gap between chromosomes in pixels
  darkrect = chartOpts?.darkrect ? "#C8C8C8" # color of darker background rectangle
  lightrect = chartOpts?.lightrect ? "#E6E6E6" # color of lighter background rectangle
  colors = chartOpts?.colors ? ["slateblue", "white", "crimson"] # heat map colors
  zlim = chartOpts?.zlim ? null # z-axis limits
  zthresh = chartOpts?.zthresh ? null # lower z-axis threshold for display in heat map
  eff_ylim = chartOpts?.eff_ylim ? null # y-axis limits for effect plot (right panel)
  eff_ylab = chartOpts?.eff_ylab ? "" # y-axis label for effect plot (right panel)
  linecolor = chartOpts?.linecolor ? "darkslateblue" # line color for LOD curves (lower panel)
  eff_linecolor = chartOpts?.eff_linecolor ? null # line color for effect plot (right panel)
  linewidth = chartOpts?.linewidth ? 2 # line width for LOD curves (lower panel)
  eff_linewidth = chartOpts?.eff_linewidth ? 2 # width of line for effect plot (right panel)
  # chartOpts end
  chartdivid = chartOpts?.chartdivid ? 'chart'

  totalh = htop + hbot + 2*(margin.top + margin.bottom)
  totalw = wleft + wright + 2*(margin.left + margin.right)

  mylodheatmap = lodheatmap().height(htop)
                             .width(wleft)
                             .margin(margin)
                             .axispos(axispos)
                             .titlepos(titlepos)
                             .chrGap(chrGap)
                             .rectcolor(lightrect)
                             .colors(colors)
                             .zlim(zlim)
                             .zthresh(zthresh)

  svg = d3.select("div##{chartdivid}")
          .append("svg")
          .attr("height", totalh)
          .attr("width", totalw)

  g_heatmap = svg.append("g")
                 .attr("id", "heatmap")
                 .datum(lod_data)
                 .call(mylodheatmap)

  mylodchart = lodchart().height(hbot)
                         .width(wleft)
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
                  .attr("transform", "translate(0,#{htop+margin.top+margin.bottom})")
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

  eff_ylim = eff_ylim ? matrixExtent(eff_data.map((d) -> matrixExtent(d.data)))
  eff_nlines = d3.max(eff_data.map((d) -> d.names.length))
  eff_linecolor = eff_linecolor ? selectGroupColors(eff_nlines, "dark")

  mycurvechart = curvechart().height(htop)
                             .width(wright)
                             .margin(margin)
                             .axispos(axispos)
                             .titlepos(titlepos)
                             .xlab("")
                             .ylab(eff_ylab)
                             .strokecolor("none")
                             .rectcolor(lightrect)
                             .xlim([-0.5, lod_data.lodnames.length-0.5])
                             .ylim(eff_ylim)
                             .nxticks(0)
                             .commonX(true)

  g_curvechart = svg.append("g")
                    .attr("transform", "translate(#{wleft+margin.top+margin.bottom},0)")
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

  # add X axis
  curvechart_xaxis = g_curvechart.append("g").attr("class", "x axis")
                                 .selectAll("empty")
                                 .data(lod_data.lodnames)
                                 .enter()
                                 .append("text")
                                 .attr("class", "y axis")
                                 .attr("id", (d,i) -> "xaxis#{i}")
                                 .attr("x", (d,i) -> mycurvechart.xscale()(i))
                                 .attr("y", margin.top+htop+axispos.xlabel)
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
                       g_lodchart.select("g.title text").text("#{lod_data.lodnames[d.lodindex]}")
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
