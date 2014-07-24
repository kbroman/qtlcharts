# crosstab: reusable chart (a table, really) for displaying a cross-tabulation

crosstab = () ->
    cellHeight = 30
    cellWidth = 80
    cellPad = 20
    margin = {left:60, top:80, right:40, bottom: 20}
    titlepos = 50
    title = ""
    fontsize = cellHeight*0.7
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

            # in case labels weren't provided
            data.xlabel = data?.xlabel ? ""
            data.ylabel = data?.ylabel ? ""

            # turn it into a vector of cells
            cells = []
            for i in [0..nrow]
                for j in [0..ncol]
                    cell = {value:tab[i][j], row:i, col:j, shaded: false, rowpercent: "", colpercent: ""}
                    if (i < nrow-1 and (j < ncol-1 or j==ncol))
                        cell.shaded = true
                    if (j < ncol-1 and (i < nrow-1 or i==nrow))
                        cell.shaded = true
                    if i < nrow-1
                        denom = tab[nrow][j] - tab[nrow-1][j]
                        cell.colpercent = if denom > 0 then "#{Math.round(100*tab[i][j]/denom)}%" else "&mdash;"
                    else if i == nrow-1
                        denom = tab[nrow][j]
                        cell.colpercent = if denom > 0 then "(#{Math.round(100*tab[i][j]/denom)}%)" else "&mdash;"
                    else
                        cell.colpercent = cell.value
                    if j < ncol-1
                        denom = tab[i][ncol] - tab[i][ncol-1]
                        cell.rowpercent = if denom > 0 then "#{Math.round(100*tab[i][j]/denom)}%" else "&mdash;"
                    else if j == ncol-1
                        denom = tab[i][ncol]
                        cell.rowpercent = if denom > 0 then "(#{Math.round(100*tab[i][j]/denom)}%)" else "&mdash;"
                    else
                        cell.rowpercent = cell.value
                    cells.push(cell)
                        
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
                .attr("x", (d) -> xscale(d.col+1))
                .attr("y", (d) -> yscale(d.row+1))
                .attr("width", cellWidth)
                .attr("height", cellHeight)
                .attr("fill", (d) -> if d.shaded then rectcolor else "none")
                .attr("stroke", (d) -> if d.shaded then rectcolor else "none")
                .attr("stroke-width", 0)
                .style("pointer-events", "none")

            # text for the body of the table
            values = g.append("g").attr("id", "values")
            values.selectAll("empty")
                  .data(cells)
                  .enter()
                  .append("text")
                  .attr("x", (d) -> xscale(d.col+1) + cellWidth - cellPad)
                  .attr("y", (d) -> yscale(d.row+1) + cellHeight/2)
                  .text((d) -> d.value)
                  .attr("class", (d) -> "crosstab row#{d.row} col#{d.col}")
                  .style("font-size", fontsize)
                  .style("pointer-events", "none")

            # rectangles for the column headings
            colrect = g.append("g").attr("id", "colrect")
            colrect.selectAll("empty")
                   .data((data.xcat).concat("Total"))
                   .enter()
                   .append("rect")
                   .attr("x", (d,i) -> xscale(i+1))
                   .attr("y", yscale(0))
                   .attr("width", cellWidth)
                   .attr("height", cellHeight)
                   .attr("fill", "white")
                   .attr("stroke", "white")
                   .on "mouseover", (d,i) ->
                        d3.select(this).attr("fill", hilitcolor).attr("stroke", hilitcolor)
                        values.selectAll(".col#{i}").text((d) -> d.colpercent)
                   .on "mouseout", (d,i) ->
                        d3.select(this).attr("fill", "white").attr("stroke", "white")
                        values.selectAll("text.col#{i}").text((d) -> d.value)

            # labels in the column headings
            collab = g.append("g").attr("id", "collab")
            collab.selectAll("empty")
                  .data((data.xcat).concat("Total"))
                  .enter()
                  .append("text")
                  .attr("x", (d,i) -> xscale(i+1) + cellWidth - cellPad)
                  .attr("y", yscale(0)+cellHeight/2)
                  .text((d) -> d)
                  .attr("class", "crosstab")
                  .style("font-size", fontsize)
                  .style("pointer-events", "none")

            # rectangles for the row headings
            rowrect = g.append("g").attr("id", "rowrect")
            rowrect.selectAll("empty")
                   .data((data.ycat).concat("Total"))
                   .enter()
                   .append("rect")
                   .attr("x", xscale(0))
                   .attr("y", (d,i) -> yscale(i+1))
                   .attr("width", cellWidth)
                   .attr("height", cellHeight)
                   .attr("fill", "white")
                   .attr("stroke", "white")
                   .on "mouseover", (d,i) ->
                        d3.select(this).attr("fill", hilitcolor).attr("stroke", hilitcolor)
                        values.selectAll(".row#{i}").text((d) -> d.rowpercent)
                   .on "mouseout", (d,i) ->
                        d3.select(this).attr("fill", "white").attr("stroke", "white")
                        values.selectAll(".row#{i}").text((d) -> d.value)

            # labels in the column headings
            rowlab = g.append("g").attr("id", "rowlab")
            rowlab.selectAll("empty")
                  .data((data.ycat).concat("Total"))
                  .enter()
                  .append("text")
                  .attr("x", xscale(0) + cellWidth - cellPad)
                  .attr("y", (d,i) -> yscale(i+1) + cellHeight/2)
                  .text((d) -> d)
                  .attr("class", "crosstab")
                  .style("font-size", fontsize)
                  .style("pointer-events", "none")

            # border around central part
            borders = g.append("g").attr("id", "borders")
            borders.append("rect")
                   .attr("x", xscale(1))
                   .attr("y", yscale(1))
                   .attr("width", cellWidth*ncol)
                   .attr("height", cellHeight*nrow)
                   .attr("fill", "none")
                   .attr("stroke", bordercolor)
                   .attr("stroke-width", 2)
                   .style("pointer-events", "none")
            # border around overall total
            borders.append("rect")
                   .attr("x", xscale(ncol+1))
                   .attr("y", yscale(nrow+1))
                   .attr("width", cellWidth)
                   .attr("height", cellHeight)
                   .attr("fill", "none")
                   .attr("stroke", bordercolor)
                   .attr("stroke-width", 2)
                   .style("pointer-events", "none")

            # row and column headings and optional overall title
            titles = g.append("g").attr("id", "titles")
            titles.append("text").attr("class", "crosstabtitle")
                  .attr("x", margin.left + (ncol+1)*cellWidth/2)
                  .attr("y", margin.top - cellHeight/2)
                  .text(data.xlabel)
                  .style("font-size", fontsize)
                  .style("font-weight", "bold")
            titles.append("text").attr("class", "crosstab")
                  .attr("x", xscale(0) + cellWidth - cellPad)
                  .attr("y", yscale(0) + cellHeight/2)
                  .text(data.ylabel)
                  .style("font-size", fontsize)
                  .style("font-weight", "bold")
            titles.append("text").attr("class", "crosstabtitle")
                  .attr("x", margin.left+(width-margin.left-margin.right)/2)
                  .attr("y", margin.top-titlepos)
                  .text(title)
                  .style("font-size", fontsize)

    ## configuration parameters
    chart.cellHeight = (value) ->
                      return cellHeight if !arguments.length
                      cellHeight = value
                      chart

    chart.cellWidth = (value) ->
                      return cellWidth if !arguments.length
                      cellWidth = value
                      chart

    chart.cellPad = (value) ->
                      return cellPad if !arguments.length
                      cellPad = value
                      chart

    chart.margin = (value) ->
                      return margin if !arguments.length
                      margin = value
                      chart

    chart.titlepos = (value) ->
                      return titlepos if !arguments.length
                      titlepos
                      chart

    chart.title = (value) ->
                      return title if !arguments.length
                      title = value
                      chart

    chart.rectcolor = (value) ->
                      return rectcolor if !arguments.length
                      rectcolor = value
                      chart

    chart.hilitcolor = (value) ->
                      return hilitcolor if !arguments.length
                      hilitcolor = value
                      chart

    chart.bordercolor = (value) ->
                      return bordercolor if !arguments.length
                      bordercolor = value
                      chart

    chart.fontsize = (value) ->
                      return fontsize if !arguments.length
                      fontsize = value
                      chart

    # return the chart function
    chart
