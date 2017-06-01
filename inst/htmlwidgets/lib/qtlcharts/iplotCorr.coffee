# iplotCorr.coffee
#
# Left panel is a heat map of a correlation matrix; hover over pixels
# to see the values; click to see the corresponding scatterplot on the right

iplotCorr = (widgetdiv, data, chartOpts) ->

    # data is an object with 7 components
    #   data.indID  vector of character strings, of length n, with IDs for individuals
    #   data.var    vector of character strings, of length p, with variable names
    #   data.corr   matrix of correlation values, of dim q x r, with q and r each <= p
    #   data.rows   vector of indicators, of length q, with values in {0, 1, ..., p-1},
    #                  for each row in data.corr, it says which is the corresponding column in data.dat
    #   data.cols   vector of indicators, of length r, with values in {0, 1, ..., p-1}
    #                  for each column in data.corr, it says which is the corresponding column in data.dat
    #   data.dat    numeric matrix, of dim n x p, with data to be plotted in scatterplots
    #                  rows correspond to data.indID and columns to data.var
    #   data.group  numeric vector, of length n, with values in {1, ..., k},
    #                  used as categories for coloring points in the scatterplot

    # chartOpts start
    height = chartOpts?.height ? 560             # height of each panel in pixels
    width = chartOpts?.width ? 1050              # total width of panels
    margin = chartOpts?.margin ? {left:70, top:40, right:5, bottom: 70, inner:5} # margins in pixels (left, top, right, bottom, inner)
    corcolors = chartOpts?.corcolors ? ["darkslateblue", "white", "crimson"]     # heat map colors (same length as `zlim`)
    zlim = chartOpts?.zlim ? [-1, 0, 1]          # z-axis limits
    rectcolor = chartOpts?.rectcolor ? "#E6E6E6" # color of background rectangle
    cortitle = chartOpts?.cortitle ? ""          # title for heatmap panel
    scattitle = chartOpts?.scattitle ? ""        # title for scatterplot panel
    scatcolors = chartOpts?.scatcolors ? null    # vector of point colors for scatterplot
    pointsize = chartOpts?.pointsize ? 3         # size of points in scatterplot
    # chartOpts end
    chartdivid = chartOpts?.chartdivid ? 'chart'

    # make sure list args have all necessary bits
    margin = d3panels.check_listarg_v_default(margin, {left:70, top:40, right:5, bottom: 70, inner:5})

    panelheight = height - margin.top - margin.bottom
    panelwidth = (width - 2*margin.left - 2*margin.right)/2
    # force panelheight == panelwidth by taking minimum of the two
    min_paneldim = d3.min([panelheight, panelwidth])
    panelheight = min_paneldim
    panelwidth = min_paneldim
    widgetdivid = d3.select(widgetdiv).attr('id')

    svg = d3.select(widgetdiv).select("svg")

    # panel for correlation image
    corrplot = svg.append("g")
                 .attr("id", "corplot")
                 .attr("transform", "translate(#{margin.left},#{margin.top})")

    # panel for scatterplot
    scatterplot = svg.append("g")
                     .attr("id", "scatterplot")
                     .attr("transform", "translate(#{margin.left*2+margin.right+panelwidth},#{margin.top})")

    # no. data points
    nind = data.indID.length
    nvar = data.var.length
    ncorrX = data.cols.length
    ncorrY = data.rows.length

    corXscale = d3.scaleBand().domain(d3.range(ncorrX)).range([0, panelwidth])
    corYscale = d3.scaleBand().domain(d3.range(ncorrY)).range([panelheight, 0])
    corZscale = d3.scaleLinear().domain(zlim).range(corcolors)
    pixel_width = corXscale(1)-corXscale(0)
    pixel_height = corYscale(0)-corYscale(1)

    # create list with correlations
    corr = []
    for i of data.corr
        for j of data.corr[i]
            corr.push({row:i, col:j, value:data.corr[i][j]})


    # gray background on scatterplot
    scatterplot.append("rect")
               .attr("height", panelheight)
               .attr("width", panelwidth)
               .attr("fill", rectcolor)
               .attr("stroke", "black")
               .attr("stroke-width", 1)
               .attr("pointer-events", "none")

    corr_tip = d3.tip()
                .attr('class', "d3-tip #{widgetdivid}")
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
               .attr("width", Math.abs(corXscale(0) - corXscale(1)))
               .attr("height", Math.abs(corYscale(0) - corYscale(1)))
               .attr("fill", (d) -> corZscale(d.value))
               .attr("stroke", "none")
               .attr("stroke-width", 2)
               .on("mouseover", (d) ->
                     d3.select(this).attr("stroke", "black")
                     corr_tip.show(d)
                     corrplot.append("text").attr("class","corrlabel")
                             .attr("x", corXscale(d.col)+pixel_width/2)
                             .attr("y", panelheight+margin.bottom*0.2)
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
    scatcolors = d3panels.expand2vector(scatcolors) # make sure it's an array (or null)
    if !(scatcolors?) or scatcolors.length < nGroup
        if nGroup == 1
            scatcolors = [ "#969696" ]
        else if nGroup == 2
            scatcolors = ["MediumVioletRed", "slateblue"]
        else if nGroup == 3
            scatcolors = ["MediumVioletRed", "MediumSeaGreen", "slateblue"]
        else
            if nGroup <= 10
                colorScale = d3.schemeCategory10
            else
                colorScale = d3.schemeCategory20
            scatcolors = (colorScale[i] for i of d3.range(nGroup))

    scat_tip = d3.tip()
                .attr('class', "d3-tip #{widgetdivid}")
                .html((d,i) -> data.indID[i])
                .direction('e')
                .offset([0,10])
    scatterplot.call(scat_tip)

    drawScatter = (i,j) ->
        d3.selectAll("circle.points").remove()
        d3.selectAll("text.axes").remove()
        d3.selectAll("line.axes").remove()
        xScale = d3.scaleLinear()
                         .domain(d3.extent(data.dat[data.cols[i]]))
                         .range([margin.inner, panelwidth-margin.inner])
        yScale = d3.scaleLinear()
                         .domain(d3.extent(data.dat[data.rows[j]]))
                         .range([panelheight-margin.inner, margin.inner])
        # axis labels
        scatterplot.append("text")
                   .attr("id", "xaxis")
                   .attr("class", "axes")
                   .attr("x", panelwidth/2)
                   .attr("y", panelheight+margin.bottom*0.7)
                   .text(data.var[data.cols[i]])
                   .attr("dominant-baseline", "middle")
                   .attr("text-anchor", "middle")
                   .attr("fill", "slateblue")
        scatterplot.append("text")
                   .attr("id", "yaxis")
                   .attr("class", "axes")
                   .attr("x", -margin.left*0.8)
                   .attr("y", panelheight/2)
                   .text(data.var[data.rows[j]])
                   .attr("dominant-baseline", "middle")
                   .attr("text-anchor", "middle")
                   .attr("transform", "rotate(270,#{-margin.left*0.8},#{panelheight/2})")
                   .attr("fill", "slateblue")
        # axis scales
        xticks = xScale.ticks(5)
        yticks = yScale.ticks(5)
        scatterplot.selectAll("empty")
                   .data(xticks)
                   .enter()
                   .append("text")
                   .attr("class", "axes")
                   .text((d) -> d3panels.formatAxis(xticks)(d))
                   .attr("x", (d) -> xScale(d))
                   .attr("y", panelheight+margin.bottom*0.3)
                   .attr("dominant-baseline", "middle")
                   .attr("text-anchor", "middle")
        scatterplot.selectAll("empty")
                   .data(yticks)
                   .enter()
                   .append("text")
                   .attr("class", "axes")
                   .text((d) -> d3panels.formatAxis(yticks)(d))
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
                   .attr("y2", panelheight)
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
                   .attr("x2", panelwidth)
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
                         if x? and y? then pointsize else null)
                   .attr("stroke", "black")
                   .attr("stroke-width", 1)
                   .attr("fill", (d) -> scatcolors[data.group[d]-1])
                   .on("mouseover", scat_tip.show)
                   .on("mouseout", scat_tip.hide)

    # boxes around panels
    corrplot.append("rect")
           .attr("height", panelheight)
           .attr("width", panelwidth)
           .attr("fill", "none")
           .attr("stroke", "black")
           .attr("stroke-width", 1)
           .attr("pointer-events", "none")

    scatterplot.append("rect")
               .attr("height", panelheight)
               .attr("width", panelwidth)
               .attr("fill", "none")
               .attr("stroke", "black")
               .attr("stroke-width", 1)
               .attr("pointer-events", "none")

    # text above
    corrplot.append("text")
            .text(cortitle)
            .attr("id", "corrtitle")
            .attr("x", panelwidth/2)
            .attr("y", -margin.top/2)
            .attr("dominant-baseline", "middle")
            .attr("text-anchor", "middle")

    scatterplot.append("text")
               .text(scattitle)
               .attr("id", "scattitle")
               .attr("x", panelwidth/2)
               .attr("y", -margin.top/2)
               .attr("dominant-baseline", "middle")
               .attr("text-anchor", "middle")

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
