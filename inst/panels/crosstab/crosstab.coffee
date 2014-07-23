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
    rectcolor = "#e6e6e6"
    hilitcolor = "#e9cfec"
    bordercolor = "black"
  
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
            width = margin.left + margin.right + (ncol+2)*cellWidth
            height = margin.top + margin.bottom + (nrow+2)*cellHeight

            xscale = d3.scale.ordinal()
                             .domain([0..(ncol+1)])
                             .rangeBands([margin.left, width-margin.right], 0, 0)
            yscale = d3.scale.ordinal()
                             .domain([0..(nrow+1)])
                             .rangeBands([margin.top, height-margin.bottom], 0, 0)

            # Select the svg element, if it exists.
            svg = d3.select(this).selectAll("svg").data([data])
    
            # Otherwise, create the skeletal chart.
            gEnter = svg.enter().append("svg").append("g")
    
            # Update the outer dimensions.
            svg.attr("width", width+margin.left+margin.right)
               .attr("height", height+margin.top+margin.bottom)
    
            g = svg.select("g")
    
            # rectangles for body of table
            rect = g.append("g").attr("id", "value_rect")
            rect.selectAll("empty")
                .data(cells)
                .enter()
                .append("rect")
                .attr("id", (d) -> "cell_#{d.row}_#{d.col}")
                .attr("x", (d) -> xscale(d.col+1))
                .attr("y", (d) -> yscale(d.row+1))
                .attr("width", cellWidth)
                .attr("height", cellHeight)
                .attr("fill", (d) -> if d.col < ncol-1 and d.row < nrow-1 then rectcolor else "none")
                .attr("stroke", (d) -> if d.col < ncol-1 and d.row < nrow-1 then rectcolor else "none")
                .attr("stroke-width", 0)
            # border around central part
            rect.append("rect")
                .attr("x", xscale(1))
                .attr("y", yscale(1))
                .attr("width", cellWidth*ncol)
                .attr("height", cellHeight*nrow)
                .attr("fill", "none")
                .attr("stroke", bordercolor)
            # border around overall total
            rect.append("rect")
                .attr("x", xscale(ncol+1))
                .attr("y", yscale(nrow+1))
                .attr("width", cellWidth)
                .attr("height", cellHeight)
                .attr("fill", "none")
                .attr("stroke", bordercolor)

            # text for the body of the table
            values = g.append("g").attr("id", "values")
            values.selectAll("empty")
                  .data(cells)
                  .enter()
                  .append("text")
                  .attr("x", (d) -> xscale(d.col+1) + cellWidth - cellPad)
                  .attr("y", (d) -> yscale(d.row+1) + cellHeight/2)
                  .text((d) -> d.value)
                  .attr("class", "crosstab")
                  .style("font-size", cellHeight*0.8)

            # rectangles for the column headings
            colrect = g.append("g").attr("id", "colrect")
            colrect.selectAll("empty")
                   .data(data.xcat)
                   .enter()
                   .append("rect")
                   .attr("x", (d,i) -> xscale(i+1))
                   .attr("y", yscale(0))
                   .attr("width", cellWidth)
                   .attr("height", cellHeight)
                   .attr("fill", "none")
                   .attr("stroke", "none")
                   .on("mouseover", () -> d3.select(this).attr("fill", hilitcolor))
                   .on("mouseout", () -> d3.select(this).attr("fill", "none"))

            # labels in the column headings
            collab = g.append("g").attr("id", "collab")
            collab.selectAll("empty")
                  .data(data.xcat)
                  .enter()
                  .append("text")
                  .attr("x", (d,i) -> xscale(i+1) + cellWidth - cellPad)
                  .attr("y", yscale(0)+cellHeight/2)
                  .text((d) -> d)
                  .attr("class", "crosstab")
                  .style("font-size", cellHeight*0.8)

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
