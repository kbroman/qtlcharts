# curves_w_2scatter: Plot of a bunch of curves, linked to points in two scatterplots
# Karl W Broman

curves_w_2scatter = () ->
  htop = 500
  hbot = 500
  width = 1000
  margin = {left:60, top:40, right:40, bottom: 40, inner:5}
  axispos = {xtitle:25, ytitle:30, xlabel:5, ylabel:5}
  titlepos = 20
  rectcolor = d3.rgb(230, 230, 230)
  pointcolor = "slateblue"
  pointstroke = "black"
  pointsize = 3 # default = no visible points at markers
  strokecolor = d3.rgb(190, 190, 190)
  strokecolorhilit = "slateblue"
  strokewidth = 2
  strokewidthhilit = 2

  scat1_xlim = null
  scat1_ylim = null
  scat1_xNA = {handle:true, force:false, width:15, gap:10}
  scat1_yNA = {handle:true, force:false, width:15, gap:10}
  scat1_nxticks = 5
  scat1_xticks = null
  scat1_nyticks = 5
  scat1_yticks = null
  scat1_title = ""
  scat1_xlab = "X"
  scat1_ylab = "Y"

  scat2_xlim = null
  scat2_ylim = null
  scat2_xNA = {handle:true, force:false, width:15, gap:10}
  scat2_yNA = {handle:true, force:false, width:15, gap:10}
  scat2_nxticks = 5
  scat2_xticks = null
  scat2_nyticks = 5
  scat2_yticks = null
  scat2_title = ""
  scat2_xlab = "X"
  scat2_ylab = "Y"

  curves_xlim = null
  curves_ylim = null
  curves_nxticks = 5
  curves_xticks = null
  curves_nyticks = 5
  curves_yticks = null
  curves_title = ""
  curves_xlab = "X"
  curves_ylab = "Y"


  ## the main function
  chart = (selection) ->
    selection.each (data) ->

      curve_data = data.curve_data
      scatter1_data = data.scatter1_data
      scatter2_data = data.scatter2_data

      totalh = htop + hbot + 2*(margin.top + margin.bottom)
      totalw = width + margin.left + margin.right
      wtop = (width - margin.left - margin.right)/2

      # Select the svg element, if it exists.
      svg = d3.select(this).selectAll("svg").data([data])

      # Otherwise, create the skeletal chart.
      gEnter = svg.enter().append("svg").append("g")

      svg.attr("height", totalh)
         .attr("width", totalw)

      g = svg.select("g")

      ## configure the three charts
      myscatterplot1 = scatterplot().width(wtop)
                                    .height(htop)
                                    .margin(margin)
                                    .axispos(axispos)
                                    .titlepos(titlepos)
                                    .rectcolor(rectcolor)
                                    .pointcolor(pointcolor)
                                    .pointstroke(pointstroke)
                                    .pointsize(pointsize)
                                    .xlim(scat1_xlim)
                                    .ylim(scat1_ylim)
                                    .xNA(scat1_xNA)
                                    .yNA(scat1_yNA)
                                    .nxticks(scat1_nxticks)
                                    .xticks(scat1_xticks)
                                    .nyticks(scat1_nyticks)
                                    .yticks(scat1_yticks)
                                    .title(scat1_title)
                                    .xlab(scat1_xlab)
                                    .ylab(scat1_ylab)

      myscatterplot2 = scatterplot().width(wtop)
                                    .height(htop)
                                    .margin(margin)
                                    .axispos(axispos)
                                    .titlepos(titlepos)
                                    .rectcolor(rectcolor)
                                    .pointcolor(pointcolor)
                                    .pointstroke(pointstroke)
                                    .pointsize(pointsize)
                                    .xlim(scat2_xlim)
                                    .ylim(scat2_ylim)
                                    .xNA(scat2_xNA)
                                    .yNA(scat2_yNA)
                                    .nxticks(scat2_nxticks)
                                    .xticks(scat2_xticks)
                                    .nyticks(scat2_nyticks)
                                    .yticks(scat2_yticks)
                                    .title(scat2_title)
                                    .xlab(scat2_xlab)
                                    .ylab(scat2_ylab)

      mycurvechart = curvechart().width(width)
                                 .height(hbot)
                                 .margin(margin)
                                 .axispos(axispos)
                                 .titlepos(titlepos)
                                 .rectcolor(rectcolor)
                                 .strokecolor(strokecolor)
                                 .strokecolorhilit(strokecolorhilit)
                                 .strokewidth(strokewidth)
                                 .strokewidthhilit(strokewidthhilit)
                                 .xlim(curves_xlim)
                                 .ylim(curves_ylim)
                                 .nxticks(curves_nxticks)
                                 .xticks(curves_xticks)
                                 .nyticks(curves_nyticks)
                                 .yticks(curves_yticks)
                                 .title(curves_title)
                                 .xlab(curves_xlab)
                                 .ylab(curves_ylab)

      ## now make the actual charts
      g_scat1 = g.append("g")
                 .attr("id", "scatterplot1")
                 .datum(scatter1_data)
                 .call(myscatterplot1)

      g_scat2 = g.append("g")
                 .attr("id", "scatterplot2")
                 .attr("transform", "translate(#{wtop+margin.left+margin.right},0)")
                 .datum(scatter2_data)
                 .call(myscatterplot2)

      g_curves = g.append("g")
                  .attr("id", "curvechart")
                  .attr("transform", "translate(0,#{htop+margin.top+margin.bottom})")
                  .datum(curve_data)
                  .call(mycurvechart)

  ## configuration parameters
  chart.hbot = (value) ->
    return hbot if !arguments.length
    hbot = value
    chart

  chart.htop = (value) ->
    return htop if !arguments.length
    htop = value
    chart

  chart.width = (value) ->
    return width if !arguments.length
    width = value
    chart

  chart.margin = (value) ->
    return margin if !arguments.length
    margin = value
    chart

  chart.axispos = (value) ->
    return axispos if !arguments.length
    axispos = value
    chart

  chart.titlepos = (value) ->
    return titlepos if !arguments.length
    titlepos = value
    chart

  chart.rectcolor = (value) ->
    return rectcolor if !arguments.length
    rectcolor = value
    chart

  chart.pointcolor = (value) ->
    return pointcolor if !arguments.length
    pointcolor = value
    chart

  chart.pointstroke = (value) ->
    return pointstroke if !arguments.length
    pointstroke = value
    chart

  chart.pointsize = (value) ->
    return pointsize if !arguments.length
    pointsize = value
    chart

  chart.strokecolor = (value) ->
    return strokecolor if !arguments.length
    strokecolor = value
    chart

  chart.strokecolorhilit = (value) ->
    return strokecolorhilit if !arguments.length
    strokecolorhilit = value
    chart

  chart.strokewidth = (value) ->
    return strokewidth if !arguments.length
    strokewidth = value
    chart

  chart.strokewidthhilit = (value) ->
    return strokewidthhilit if !arguments.length
    strokewidthhilit = value
    chart

  chart.scat1_xNA = (value) ->
    return scat1_xNA if !arguments.length
    scat1_xNA = value
    chart

  chart.scat1_yYA = (value) ->
    return scat1_yNA if !arguments.length
    scat1_yNA = value
    chart

  chart.scat1_xlim = (value) ->
    return scat1_xlim if !arguments.length
    scat1_xlim = value
    chart

  chart.scat1_ylim = (value) ->
    return scat1_ylim if !arguments.length
    scat1_ylim = value
    chart

  chart.scat1_nxticks = (value) ->
    return scat1_nxticks if !arguments.length
    scat1_nxticks = value
    chart

  chart.scat1_xticks = (value) ->
    return scat1_xticks if !arguments.length
    scat1_xticks = value
    chart

  chart.scat1_nyticks = (value) ->
    return scat1_nyticks if !arguments.length
    scat1_nyticks = value
    chart

  chart.scat1_yticks = (value) ->
    return scat1_yticks if !arguments.length
    scat1_yticks = value
    chart

  chart.scat1_title = (value) ->
    return scat1_title if !arguments.length
    scat1_title = value
    chart

  chart.scat1_xlab = (value) ->
    return scat1_xlab if !arguments.length
    scat1_xlab = value
    chart

  chart.scat1_ylab = (value) ->
    return scat1_ylab if !arguments.length
    scat1_ylab = value
    chart

  chart.scat2_xNA = (value) ->
    return scat2_xNA if !arguments.length
    scat2_xNA = value
    chart

  chart.scat2_yYA = (value) ->
    return scat2_yNA if !arguments.length
    scat2_yNA = value
    chart

  chart.scat2_xlim = (value) ->
    return scat2_xlim if !arguments.length
    scat2_xlim = value
    chart

  chart.scat2_ylim = (value) ->
    return scat2_ylim if !arguments.length
    scat2_ylim = value
    chart

  chart.scat2_nxticks = (value) ->
    return scat2_nxticks if !arguments.length
    scat2_nxticks = value
    chart

  chart.scat2_xticks = (value) ->
    return scat2_xticks if !arguments.length
    scat2_xticks = value
    chart

  chart.scat2_nyticks = (value) ->
    return scat2_nyticks if !arguments.length
    scat2_nyticks = value
    chart

  chart.scat2_yticks = (value) ->
    return scat2_yticks if !arguments.length
    scat2_yticks = value
    chart

  chart.scat2_title = (value) ->
    return scat2_title if !arguments.length
    scat2_title = value
    chart

  chart.scat2_xlab = (value) ->
    return scat2_xlab if !arguments.length
    scat2_xlab = value
    chart

  chart.scat2_ylab = (value) ->
    return scat2_ylab if !arguments.length
    scat2_ylab = value
    chart
  chart.curves_xlim = (value) ->
    return curves_xlim if !arguments.length
    curves_xlim = value
    chart

  chart.curves_ylim = (value) ->
    return curves_ylim if !arguments.length
    curves_ylim = value
    chart

  chart.curves_nxticks = (value) ->
    return curves_nxticks if !arguments.length
    curves_nxticks = value
    chart

  chart.curves_xticks = (value) ->
    return curves_xticks if !arguments.length
    curves_xticks = value
    chart

  chart.curves_nyticks = (value) ->
    return curves_nyticks if !arguments.length
    curves_nyticks = value
    chart

  chart.curves_yticks = (value) ->
    return curves_yticks if !arguments.length
    curves_yticks = value
    chart

  chart.curves_title = (value) ->
    return curves_title if !arguments.length
    curves_title = value
    chart

  chart.curves_xlab = (value) ->
    return curves_xlab if !arguments.length
    curves_xlab = value
    chart

  chart.curves_ylab = (value) ->
    return curves_ylab if !arguments.length
    curves_ylab = value
    chart

  # return the chart function
  chart
