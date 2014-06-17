# iplotCorr.coffee
#
# Left panel is a heat map of a correlation matrix; hover over pixels
# to see the values; click to see the corresponding scatterplot on the right

iplotCorr = (data, chartOpts) ->

  # chartOpts start
  height = chartOpts?.height ? 450 # height of each panel in pixels
  width = chartOpts?.width ? height # width of each panel in pixels
  margin = chartOpts?.margin ? {left:70, top:40, right:5, bottom: 70, inner:5} # margins in pixels (left, top, right, bottom, inner)
  corcolors = chartOpts?.corcolors ? ["darkslateblue", "white", "crimson"] # heat map colors (same length as `zlim`)
  zlim = chartOpts?.zlim ? [-1, 0, 1] # z-axis limits
  rectcolor = chartOpts?.rectcolor ? "#E6E6E6" # color of background rectangle
  cortitle = chartOpts?.cortitle ? "" # title for heatmap panel
  scattitle = chartOpts?.scattitle ? "" # title for scatterplot panel
  scatcolors = chartOpts?.scatcolors ? null # vector of point colors for scatterplot
  # chartOpts end
  chartdivid = chartOpts?.chartdivid ? 'chart'

  totalh = height + margin.top + margin.bottom
  totalw = (width + margin.left + margin.right)*2

  svg = d3.select("div##{chartdivid}")
          .append("svg")
          .attr("height", totalh)
          .attr("width", totalw)

  # panel for correlation image
  corrplot = svg.append("g")
               .attr("id", "corplot")
               .attr("transform", "translate(#{margin.left},#{margin.top})")

  # panel for scatterplot
  scatterplot = svg.append("g")
                   .attr("id", "scatterplot")
                   .attr("transform", "translate(#{margin.left*2+margin.right+width},#{margin.top})")

  # no. data points
  nind = data.indID.length
  nvar = data.var.length
  ncorrX = data.cols.length
  ncorrY = data.rows.length

  corXscale = d3.scale.ordinal().domain(d3.range(ncorrX)).rangeBands([0, width])
  corYscale = d3.scale.ordinal().domain(d3.range(ncorrY)).rangeBands([height, 0])
  corZscale = d3.scale.linear().domain(zlim).range(corcolors)
  pixel_width = corXscale(1)-corXscale(0)
  pixel_height = corYscale(0)-corYscale(1)

  # create list with correlations
  corr = []
  for i of data.corr
    for j of data.corr[i]
      corr.push({row:i, col:j, value:data.corr[i][j]})


  # gray background on scatterplot
  scatterplot.append("rect")
             .attr("height", height)
             .attr("width", width)
             .attr("fill", rectcolor)
             .attr("stroke", "black")
             .attr("stroke-width", 1)
             .attr("pointer-events", "none")

  corr_tip = d3.tip()
              .attr('class', 'd3-tip')
              .html((d) -> d3.format(".2f")(d.value))
              .direction('e')
              .offset([0,10])
  corrplot.call(corr_tip)


  cells = corrplot.selectAll("empty")
             .data(corr)
             .enter().append("rect")
             .attr("class", "cell")
             .attr("x", (d) -> corXscale(d.col))
             .attr("y", (d) -> corYscale(d.row))
             .attr("width", corXscale.rangeBand())
             .attr("height", corYscale.rangeBand())
             .attr("fill", (d) -> corZscale(d.value))
             .attr("stroke", "none")
             .attr("stroke-width", 2)
             .on("mouseover", (d) ->
                 d3.select(this).attr("stroke", "black")
                 corr_tip.show(d)
                 corrplot.append("text").attr("class","corrlabel")
                         .attr("x", corXscale(d.col)+pixel_width/2)
                         .attr("y", height+margin.bottom*0.2)
                         .text(data.var[data.cols[d.col]])
                         .attr("dominant-baseline", "middle")
                         .attr("text-anchor", "middle")
                 corrplot.append("text").attr("class","corrlabel")
                         .attr("y", corYscale(d.row)+pixel_height/2)
                         .attr("x", -margin.left*0.1)
                         .text(data.var[data.rows[d.row]])
                         .attr("dominant-baseline", "middle")
                         .attr("text-anchor", "end"))
             .on("mouseout", (d) ->
                 corr_tip.hide(d)
                 d3.selectAll("text.corrlabel").remove()
                 d3.select(this).attr("stroke","none"))
             .on("click",(d) -> drawScatter(d.col, d.row))

  # colors for scatterplot
  nGroup = d3.max(data.group)
  if !(scatcolors?) or scatcolors.length < nGroup
    if nGroup == 1
      scatcolors = [ d3.rgb(150, 150, 150) ]
    else if nGroup <= 3
      scatcolors = ["crimson", "green", "darkslateblue"]
    else 
      if nGroup <= 10
        colorScale = d3.scale.category10()
      else
        colorScale = d3.scale.category20()
      scatcolors = (colorScale(i) for i of d3.range(nGroup))

  scat_tip = d3.tip()
              .attr('class', 'd3-tip')
              .html((d,i) -> data.indID[i])
              .direction('e')
              .offset([0,10])
  scatterplot.call(scat_tip)

  drawScatter = (i,j) ->
    d3.selectAll("circle.points").remove()
    d3.selectAll("text.axes").remove()
    d3.selectAll("line.axes").remove()
    xScale = d3.scale.linear()
                     .domain(d3.extent(data.dat[data.cols[i]]))
                     .range([margin.inner, width-margin.inner])
    yScale = d3.scale.linear()
                     .domain(d3.extent(data.dat[data.rows[j]]))
                     .range([height-margin.inner, margin.inner])
    # axis labels
    scatterplot.append("text")
               .attr("id", "xaxis")
               .attr("class", "axes")
               .attr("x", width/2)
               .attr("y", height+margin.bottom*0.7)
               .text(data.var[data.cols[i]])
               .attr("dominant-baseline", "middle")
               .attr("text-anchor", "middle")
               .attr("fill", "slateblue")
    scatterplot.append("text")
               .attr("id", "yaxis")
               .attr("class", "axes")
               .attr("x", -margin.left*0.8)
               .attr("y", height/2)
               .text(data.var[data.rows[j]])
               .attr("dominant-baseline", "middle")
               .attr("text-anchor", "middle")
               .attr("transform", "rotate(270,#{-margin.left*0.8},#{height/2})")
               .attr("fill", "slateblue")
    # axis scales
    xticks = xScale.ticks(5)
    yticks = yScale.ticks(5)
    scatterplot.selectAll("empty")
               .data(xticks)
               .enter()
               .append("text")
               .attr("class", "axes")
               .text((d) -> formatAxis(xticks)(d))
               .attr("x", (d) -> xScale(d))
               .attr("y", height+margin.bottom*0.3)
               .attr("dominant-baseline", "middle")
               .attr("text-anchor", "middle")
    scatterplot.selectAll("empty")
               .data(yticks)
               .enter()
               .append("text")
               .attr("class", "axes")
               .text((d) -> formatAxis(yticks)(d))
               .attr("x", -margin.left*0.1)
               .attr("y", (d) -> yScale(d))
               .attr("dominant-baseline", "middle")
               .attr("text-anchor", "end")
    scatterplot.selectAll("empty")
               .data(xticks)
               .enter()
               .append("line")
               .attr("class", "axes")
               .attr("x1", (d) -> xScale(d))
               .attr("x2", (d) -> xScale(d))
               .attr("y1", 0)
               .attr("y2", height)
               .attr("stroke", "white")
               .attr("stroke-width", 1)
    scatterplot.selectAll("empty")
               .data(yticks)
               .enter()
               .append("line")
               .attr("class", "axes")
               .attr("y1", (d) -> yScale(d))
               .attr("y2", (d) -> yScale(d))
               .attr("x1", 0)
               .attr("x2", width)
               .attr("stroke", "white")
               .attr("stroke-width", 1)
    # the points
    scatterplot.selectAll("empty")
               .data(d3.range(nind))
               .enter()
               .append("circle")
               .attr("class", "points")
               .attr("cx", (d) -> xScale(data.dat[data.cols[i]][d]))
               .attr("cy", (d) -> yScale(data.dat[data.rows[j]][d]))
               .attr("r", (d) ->
                     x = data.dat[data.cols[i]][d]
                     y = data.dat[data.rows[j]][d]
                     if x? and y? then 3 else null)
               .attr("stroke", "black")
               .attr("stroke-width", 1)
               .attr("fill", (d) -> scatcolors[data.group[d]-1])
               .on("mouseover", scat_tip.show)
               .on("mouseout", scat_tip.hide)

  # boxes around panels
  corrplot.append("rect")
         .attr("height", height)
         .attr("width", width)
         .attr("fill", "none")
         .attr("stroke", "black")
         .attr("stroke-width", 1)
         .attr("pointer-events", "none")

  scatterplot.append("rect")
             .attr("height", height)
             .attr("width", width)
             .attr("fill", "none")
             .attr("stroke", "black")
             .attr("stroke-width", 1)
             .attr("pointer-events", "none")

  # text above
  corrplot.append("text")
          .text(cortitle)
          .attr("id", "corrtitle")
          .attr("x", width/2)
          .attr("y", -margin.top/2)
          .attr("dominant-baseline", "middle")
          .attr("text-anchor", "middle")

  scatterplot.append("text")
             .text(scattitle)
             .attr("id", "scattitle")
             .attr("x", width/2)
             .attr("y", -margin.top/2)
             .attr("dominant-baseline", "middle")
             .attr("text-anchor", "middle")

  d3.select("div#caption")
    .style("opacity", 1)
