# crosstab: reusable chart (a table, really) for displaying a cross-tabulation

crosstab = () ->
    cellHeight = 30
    cellWidth = 80
    cellPad = 20
    margin = {left:60, top:40, right:40, bottom: 40}
    axispos = {xtitle:25, ytitle:30, xlabel:5, ylabel:5}
    titlepos = 20
    title = ""
    xlab = ""
    ylab = ""
  
    ## the main function
    chart = (selection) ->
        selection.each (data) ->

            n = data.x.length
            if data.y.length != n
                console.log("data.x.length != data.y.length")
            ncol = data.xcat.length
            if d3.max(data.x) >= ncol or d3.min(data.x) < 0
                console.log("data.x should be in range 0-#{ncol-1}")
            nrow = data.ycat.length
            if d3.max(data.y) >= nrow or d3.min(data.y) < 0
                console.log("data.y should be in range 0-#{nrow-1}")

            tab = calc_crosstab(data)

            # turn it into a vector of cells
            cells = []
            for i in [0..nrow]
                for j in [0..ncol]
                    cells.push({value:tab[i][j], row:i, col:j})

            # svg width and height
            width = margin.left + margin.right + (ncol+1)*cellWidth
            height = margin.top + margin.bottom + (nrow+1)*cellHeight

            # Select the svg element, if it exists.
            svg = d3.select(this).selectAll("svg").data([data])
    
            # Otherwise, create the skeletal chart.
            gEnter = svg.enter().append("svg").append("g")
    
            # Update the outer dimensions.
            svg.attr("width", width+margin.left+margin.right)
               .attr("height", height+margin.top+margin.bottom)
    
            g = svg.select("g")
    
            # box
            g.append("rect")
             .attr("x", margin.left)
             .attr("y", margin.top)
             .attr("height", height-margin.bottom-margin.top)
             .attr("width", width-margin.left-margin.right)
             .attr("fill", "#e6e6e6")
             .attr("stroke", null)
             .attr("stroke-width", "0")
    
            g.append("g").attr("id", "value_rect")
             .selectAll("empty")
             .data(cells)
             .enter()
             .append("rect")
             .attr("x", (d) -> d.col*cellWidth + margin.left)
             .attr("y", (d) -> d.row*cellHeight + margin.top)
             .attr("width", cellWidth)
             .attr("height", cellHeight)
             .attr("fill", "none")
             .attr("stroke", "blue")

            g.append("g").attr("id", "values")
             .selectAll("empty")
             .data(cells)
             .enter()
             .append("text")
             .attr("x", (d) -> (d.col+1)*cellWidth - cellPad + margin.left)
             .attr("y", (d) -> (d.row+1)*cellHeight - cellHeight/2 + margin.top)
             .text((d) -> d.value)
             .attr("class", "crosstab")
             .attr("font-size", d3.min([cellHeight, cellWidth-cellPad*2])*0.8)

    ## configuration parameters
    chart.cellHeight = (value) ->
                      return cellHeight if !arguments.length
                      cellHeight = value
                      chart

    chart.cellWidth = (value) ->
                      return cellWidth if !arguments.length
                      cellWidth = value
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
                      titlepos
                      chart

    chart.title = (value) ->
                      return title if !arguments.length
                      title = value
                      chart

    chart.xlab = (value) ->
                      return xlab if !arguments.length
                      xlab = value
                      chart

    chart.ylab = (value) ->
                      return ylab if !arguments.length
                      ylab = value
                      chart

    # return the chart function
    chart
