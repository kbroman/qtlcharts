# iplotMScanone_noeff: image of lod curves linked to plot of lod curves
# Karl W Broman

mycurvechart = null

iplotMScanone_noeff = (lod_data, chartOpts) ->

  # chartOpts start
  wleft = chartOpts?.wleft ? 650
  wright = chartOpts?.wright ? 350
  htop = chartOpts?.htop ? 350
  hbot = chartOpts?.hbot ? 350
  margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40, inner:5}
  axispos = chartOpts?.axispos ? {xtitle:25, ytitle:30, xlabel:5, ylabel:5}
  titlepos = chartOpts?.titlepos ? 20
  chrGap = chartOpts?.chrGap ? 5
  darkrect = chartOpts?.darkrect ? d3.rgb(200, 200, 200)
  lightrect = chartOpts?.lightrect ? d3.rgb(230, 230, 230)
  colors = chartOpts?.colors ? ["slateblue", "white", "crimson"]
  zlim = chartOpts?.zlim ? null
  zthresh = chartOpts?.zthresh ? null
  linecolor = chartOpts?.linecolor ? "darkslateblue"
  linewidth = chartOpts?.linewidth ? 2
  # chartOpts end

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

  svg = d3.select("div#chart")
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

  lodcurve = (chr, lodcolumn) ->
          d3.svg.line()
            .x((d) -> mylodchart.xscale()[chr](d)+margin.left)
            .y((d,i) -> mylodchart.yscale()(lod_data.lodByChr[chr][i][lodcolumn])+margin.top)

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

  # rearrange data for curves of time x LOD
  lod4curves = {data:[]}
  for pos of lod_data.pos
    y = (lod_data[lodcolumn][pos] for lodcolumn in lod_data.lodnames)
    x = (+i for i of lod_data.lodnames)
    lod4curves.data.push({x:x, y:y})

  mycurvechart = curvechart().height(htop)
                             .width(wright)
                             .margin(margin)
                             .axispos(axispos)
                             .titlepos(titlepos)
                             .xlab("")
                             .ylab("LOD score")
                             .strokecolor("none")
                             .rectcolor(lightrect)
                             .xlim([-0.5, lod_data.lodnames.length-0.5])
                             .ylim([0, d3.max(mylodheatmap.zlim())])
                             .nxticks(0)
                             .commonX(false)



  g_curvechart = svg.append("g")
                    .attr("transform", "translate(#{wleft+margin.top+margin.bottom},0)")
                    .attr("id", "curvehart")
                    .datum(lod4curves)
                    .call(mycurvechart)

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
                       g_curvechart.selectAll("path.path#{posindex[d.chr][d.pos]}")
                                   .attr("opacity", 1)
              .on "mouseout", (d) ->
                       g_lodchart.select("g#lodcurves").remove()
                       g_curvechart.selectAll("path.path#{posindex[d.chr][d.pos]}")
                                   .attr("opacity", 0)
