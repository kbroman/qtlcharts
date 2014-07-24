# iplotRF: interactive plot of pairwise recombination fractions
# Karl W Broman

Z = null

iplotRF = (rf_data, geno, chartOpts) ->

    # chartOpts start
    pixelPerCell = chartOpts?.pixelPerCell ? null # pixels per cell in heat map
    chrGap = chartOpts?.chrGap ? 2 # gaps between chr in heat map
    cellHeight = chartOpts?.cellHeight ? 30 # cell height (in pixels) in crosstab
    cellWidth = chartOpts?.cellWidth ? 80 # cell width (in pixels) in crosstab
    cellPad = chartOpts?.cellPad ? 20 # cell padding (in pixels) to right of text in crosstab
    fontsize = chartOpts?.fontsize ? cellHeight*0.7 # font size in crosstab    
    margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40} # margins in each panel
    axispos = chartOpts?.axispos ? {xtitle:25, ytitle:30, xlabel:5, ylabel:5} # axis positions in heatmap
    rectcolor = chartOpts?.rectcolor ? "#e6e6e6" # background color in heatmap and crosstab
    hilitcolor = chartOpts?.hilitcolor ? "#e6e6e6" # highlight color in crosstab
    nullcolor = chartOpts?.nullcolor ? "#e6e6e6" # color of null pixels in heat map
    bordercolor = chartOpts?.bordercolor ? "black" # border color in heat map and in cross-tab
    colors = chartOpts?.colors ? ["slateblue", "white", "crimson"] # colors for heat map
    lodlim = chartOpts?.lodlim ? [2, 12] # range of LOD values to display; omit below 1st, truncate about 2nd
    oneAtTop = chartOpts?.oneAtTop ? false # whether to put chr 1 at top of heatmap
    # chartOpts end
    chartdivid = chartOpts?.chartdivid ? 'chart'
  
    # size of heatmap region
    totmar = sumArray(rf_data.nmar)
    pixelPerCell = Math.floor(700/totmar) unless pixelPerCell?
    w = chrGap*rf_data.chr.length + pixelPerCell*totmar
    heatmap_width =  w + margin.left + margin.right
    heatmap_height = w + margin.top + margin.bottom

    # size of crosstab region
    max_ngeno = d3.max( (geno.genocat[chrtype].length for chrtype of geno.genocat) )
    crosstab_width = cellWidth*max_ngeno + margin.left + margin.right
    crosstab_height = cellHeight*max_ngeno + margin.top + margin.bottom
    
    # total size of SVG
    totalw = heatmap_width + crosstab_width
    totalh = d3.max([heatmap_height, crosstab_height])

    # create SVG
    svg = d3.select("div##{chartdivid}")
            .append("svg")
            .attr("height", totalh)
            .attr("width", totalw)
  
    # ensure lodlim has 0 <= lo < hi 
    if d3.min(lodlim) < 0
        console.log("lodlim values must be non-negative; ignored")
        lodlim = [2, 12]
    if lodlim[0] >= lodlim[1]
        console.log("lodlim[0] must be < lodlim[1]; ignored")
        lodlim = [2, 12]

    # make copy of rf/lod
    rf_data.z = rf_data.rf.map (d) -> d.map (dd) -> dd

    Z = rf_data.rf

    # make symmetric
    for row in [0...rf_data.z.length]
        for col in [0...rf_data.z.length]
            rf_data.z[row][col] = rf_data.z[col][row] if row > col

    # truncate values; max value on diagonal
    for row in [0...rf_data.z.length]
        for col in [0...rf_data.z.length]
            rf_data.z[row][col] = lodlim[1] if row == col or (rf_data.z[row][col]? and rf_data.z[row][col] > lodlim[1])

            # negative values for rf > 0.5
            if row > col and rf_data.rf[row][col] > 0.5
                rf_data.z[row][col] = -rf_data.z[row][col]
            if col > row and rf_data.rf[col][row] > 0.5
                rf_data.z[row][col] = -rf_data.z[row][col]

    mychrheatmap = chrheatmap().pixelPerCell(pixelPerCell)
                               .chrGap(chrGap)
                               .axispos(axispos)
                               .rectcolor(rectcolor)
                               .nullcolor(nullcolor)
                               .bordercolor(bordercolor)
                               .colors(colors)
                               .zthresh(lodlim[0])
                               .oneAtTop(oneAtTop)
                               .hover(false)

    g_heatmap = svg.append("g")
                   .attr("id", "chrheatmap")
                   .datum(rf_data)
                   .call(mychrheatmap)

    celltip = d3.tip()
                .attr('class', 'd3-tip')
                .html((d) ->
                        mari = rf_data.labels[d.i]
                        marj = rf_data.labels[d.j]
                        if +d.i > +d.j                # +'s ensure number not string
                            rf = rf_data.rf[d.i][d.j]
                            lod = rf_data.rf[d.j][d.i]
                        else if +d.j > +d.i
                            rf = rf_data.rf[d.j][d.i]
                            lod = rf_data.rf[d.i][d.j]
                        else
                            return mari
                        rf = if rf >= 0.1 then d3.format(".2f")(rf) else d3.format(".3f")(rf)
                        return mari if d.i == d.j
                        "(#{mari} #{marj}), LOD = #{d3.format(".1f")(lod)}, rf = #{rf}")
                .direction('e')
                .offset([0,10])
    svg.call(celltip)
    
    cells = mychrheatmap.cellSelect()
    cells.on("mouseover", (d) ->
                     celltip.show(d))
         .on("mouseout", () ->
                     celltip.hide())
