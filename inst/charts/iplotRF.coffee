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
    rflim = chartOpts?.rflim ? [0.01, 0.4] # range of rf values to display (will also show symmetric interval on other side of 1/2, in another color)
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
  
    # ensure lodlim and rflim conform
    if d3.min(lodlim) < 0
        console.log("lodlim values must be non-negative; ignored")
        lodlim = [2, 12]
    if lodlim[0] >= lodlim[1]
        console.log("lodlim[0] must be < lodlim[1]; ignored")
        lodlim = [2, 12]
    if d3.min(rflim) <= 0 or d3.min(rflim) > 0.5
        console.log("rflim values must be > 0 and <= 0.5; ignored")
        rflim = [0.001, 0.4]
    if rflim[0] >= rflim[1]
        console.log("rflim[0] must be < rflim[1]; ignored")
        rflim = [0.001, 0.4]

    # transforming rf to a LOD-type scale, using lodlim and rflim
    rftran = (rf) ->
        p = (log2(r*(1-r)) for r in rflim)
        a = (lodlim[1]-lodlim[0])/(p[1] - p[0])
        b = lodlim[0] + a*p[1]
        -a*log2(rf*(1-rf)) + b

    # make copy of rf/lod
    rf_data.z = rf_data.rf.map (d) -> d.map (dd) -> dd

    # transform rec frac and truncate values
    for row in [0...rf_data.z.length]
        for col in [0...rf_data.z.length]
            if rf_data.z[row][col]?
                if col > row # rec frac
                    rf_data.z[row][col] = rftran(rf_data.z[row][col])
                rf_data.z[row][col] = lodlim[1] if rf_data.z[row][col] > lodlim[1]

    Z = rf_data.z

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
