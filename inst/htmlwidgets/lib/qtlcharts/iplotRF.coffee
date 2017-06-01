# iplotRF: interactive plot of pairwise recombination fractions
# Karl W Broman

iplotRF = (widgetdiv, rf_data, geno, chartOpts) ->

    # chartOpts start
    height = chartOpts?.height ? 800                  # total height of chart in pixels
    width = chartOpts?.width ? 1000                    # total width of chart in pixels
    hbot = chartOpts?.hbot ? 300                       # height (in pixels) of each of the lower panels with LOD scores
    margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 60} # margins in pixels (left, top, right, bottom)
    axispos = chartOpts?.axispos ? {xtitle:25, ytitle:30, xlabel:5, ylabel:5}      # axis positions in heatmap
    titlepos = chartOpts?.titlepos ? 20                # position of chart title in pixels
    chrGap = chartOpts?.chrGap ? 2                     # gaps between chr in heat map
    chrlinecolor = chartOpts?.chrlinecolor ? ""        # color of lines between chromosomes (if "", leave off)
    chrlinewidth = chartOpts?.chrlinewidth ? 2         # width of lines between chromosomes
    oneAtTop = chartOpts?.oneAtTop ? false             # if true, put chromosome 1 at the top rather than bottom
    colors = chartOpts?.colors ? ["crimson", "white", "slateblue"]       # vector of three colors for the color scale (negative - zero - positive)
    nullcolor = chartOpts?.nullcolor ? "#e6e6e6"       # color for empty cells
    zlim = chartOpts?.zlim ? null                      # z-axis limits (if null take from data, symmetric about 0)
    zthresh = chartOpts?.zthresh ? null                # z threshold; if |z| < zthresh, not shown
    hilitCellcolor = chartOpts?.hilitCellcolor ? "black"   # color of box around highlighted cell
    cellPad = chartOpts?.cellPad ? null                # padding of cells (if null, we take cell width * 0.1)
    fontsize = chartOpts?.fontsize ? null              # font size in crosstab
    rectcolor = chartOpts?.rectcolor ? "#e6e6e6"       # background rectangle color (and color of cells in crosstab)
    altrectcolor = chartOpts?.altrectcolor ? "#c8c8c8" # alternate rectangle color in lower panels with LOD and rf
    hilitcolor = chartOpts?.hilitcolor ? "#e9cfec"     # color of rectangle in heatmap when highlighted
    boxcolor = chartOpts?.boxcolor ? "black"           # color of outer box of panels
    boxwidth = chartOpts?.boxwidth ? 2                 # width of outer box in pixels
    pointsize = chartOpts?.pointsize ? 2               # point size in lower panels with LOD and rf
    pointcolor = chartOpts?.pointcolor ? "slateblue"   # point color in lower panels with LOD and rf
    pointstroke = chartOpts?.pointstroke ? "black"     # stroke color for points in lower panels with LOD and rf
    lodlim = chartOpts?.lodlim ? [0, 12]               # range of LOD values to display; omit below 1st, truncate above 2nd
    nyticks = chartOpts?.nyticks ? 5                   # no. ticks on y-axis in LOD curve panels
    yticks = chartOpts?.yticks ? null                  # vector of tick positions on y-axis in LOD curve panels
    tipclass = chartOpts?.tipclass ? "tooltip"         # class name for tool tips
    # chartOpts end
    chartdivid = chartOpts?.chartdivid ? 'chart'
    widgetdivid = d3.select(widgetdiv).attr('id')

    # make sure list args have all necessary bits
    margin = d3panels.check_listarg_v_default(margin, {left:60, top:40, right:40, bottom: 60})
    axispos = d3panels.check_listarg_v_default(axispos, {xtitle:25, ytitle:30, xlabel:5, ylabel:5})

    # force things to be vectors
    rf_data.chrname = d3panels.forceAsArray(rf_data.chrname)
    rf_data.nmar = d3panels.forceAsArray(rf_data.nmar)

    # size of heatmap region
    totmar = d3panels.sumArray(rf_data.nmar)
    heatmap_width =  height-hbot
    heatmap_height = height-hbot
    if heatmap_width > width/2 # make sure heatmap width is less than half
        heatmap_width = width/2
        heatmap_height = width/2

    # size of crosstab region
    crosstab_width = width - heatmap_width
    crosstab_width = heatmap_width if crosstab_width > heatmap_width
    crosstab_height = heatmap_height*0.7
    crosstab_xpos = heatmap_width
    crosstab_ypos = (heatmap_height - crosstab_height)/2
    crosstab_ypos = 0 if crosstab_ypos < 0

    # width of bottom panels
    wbot = heatmap_width

    # height of top panels
    htop = d3.max([heatmap_height, crosstab_height])

    svg = d3.select(widgetdiv).select("svg")

    # ensure lodlim has 0 <= lo < hi
    if d3.min(lodlim) < 0
        displayError("lodlim values must be non-negative; ignored",
                     "error_#{chartdivid}")
        lodlim = [2, 12]
    if lodlim[0] >= lodlim[1]
        displayError("lodlim[0] must be < lodlim[1]; ignored",
                     "error_#{chartdivid}")
        lodlim = [2, 12]

    # make copy of rf/lod
    rf_data.lod = rf_data.rf.map (d) -> d.map (dd) -> dd

    # make symmetric
    for row in [0...rf_data.lod.length]
        for col in [0...rf_data.lod.length]
            rf_data.lod[row][col] = rf_data.lod[col][row] if row > col

    # truncate values; max value on diagonal
    for row in [0...rf_data.lod.length]
        for col in [0...rf_data.lod.length]
            rf_data.lod[row][col] = lodlim[1] if row == col or (rf_data.lod[row][col]? and rf_data.lod[row][col] > lodlim[1])

            # negative values for rf > 0.5
            if row > col and rf_data.rf[row][col] > 0.5
                rf_data.lod[row][col] = -rf_data.lod[row][col]
            if col > row and rf_data.rf[col][row] > 0.5
                rf_data.lod[row][col] = -rf_data.lod[row][col]

    # create the heatmap
    mylodheatmap = d3panels.lod2dheatmap({
        width:heatmap_width
        height:heatmap_height
        margin:margin
        chrGap:chrGap
        axispos:axispos
        titlepos:titlepos
        chrGap:chrGap
        chrlinecolor:chrlinecolor
        chrlinewidth:chrlinewidth
        rectcolor:rectcolor
        altrectcolor:altrectcolor
        nullcolor:nullcolor
        boxcolor:boxcolor
        boxwidth:boxwidth
        colors:colors
        hilitcolor:hilitCellcolor
        zthresh:lodlim[0]
        oneAtTop:oneAtTop
        equalCells:true
        tipclass:widgetdivid})

    g_heatmap = svg.append("g")
                   .attr("id", "chrheatmap")
    mylodheatmap(g_heatmap, rf_data)

    mycrosstab = null
    mylodchart = [null, null]

    # function to create the crosstab panel
    create_crosstab = (marker1, marker2) ->
        data =
            x: geno.geno[marker1]
            y: geno.geno[marker2]
            xcat: geno.genocat[geno.chrtype[marker1]]
            ycat: geno.genocat[geno.chrtype[marker2]]
            xlabel: marker1
            ylabel: marker2

        mycrosstab.remove() if mycrosstab?

        mycrosstab = d3panels.crosstab({
            width:crosstab_width
            height:crosstab_height
            margin:margin
            cellPad:cellPad
            fontsize:fontsize
            rectcolor:rectcolor
            hilitcolor:hilitcolor
            bordercolor:boxcolor})

        g_crosstab = svg.append("g")
                        .attr("id", "crosstab")
                        .attr("transform", "translate(#{crosstab_xpos}, #{crosstab_ypos})")
        mycrosstab(g_crosstab, data)

    # function to create a lod chart
    create_scan = (markerindex, panelindex) -> # panelindex = 0 or 1 for left or right panels
        data =
            chrname: rf_data.chrname
            chr: rf_data.chr
            pos: rf_data.pos
            lod: (i for i of rf_data.pos)
            marker: rf_data.marker

        # grab lod scores for this marker
        for row in [0...rf_data.rf.length]
            if row > markerindex
                data.lod[row] = rf_data.rf[markerindex][row]
            else if row < markerindex
                data.lod[row] = rf_data.rf[row][markerindex]
        data.lod[markerindex] = null # point at marker: set to maximum LOD

        mylodchart[panelindex].remove() if mylodchart[panelindex]?

        mylodchart[panelindex] = d3panels.lodchart({
            height:hbot
            width:wbot
            margin:margin
            axispos:axispos
            ylim:[0.0, d3.max(data.lod)*1.05]
            rectcolor:rectcolor
            altrectcolor:altrectcolor
            linewidth:0
            linecolor:""
            chrGap:chrGap
            chrlinecolor:chrlinecolor
            chrlinewidth:chrlinewidth
            boxcolor:boxcolor
            boxwidth:boxwidth
            nyticks:nyticks
            yticks:yticks
            pointsize:pointsize
            pointcolor:pointcolor
            pointstroke:pointstroke
            title:data.marker[markerindex]
            tipclass:widgetdivid})

        g_scans = svg.append("g")
                     .attr("id", "lod_rf_#{panelindex+1}")
                     .attr("transform", "translate(#{wbot*panelindex}, #{htop})")
        mylodchart[panelindex](g_scans, data)

        # when clicking a point, change the other panel
        mylodchart[panelindex].markerSelect().on "click", (d) ->
                                          newmarker = d.name
                                          if panelindex == 0
                                              create_crosstab(rf_data.marker[markerindex], newmarker)
                                          else
                                              create_crosstab(newmarker, rf_data.marker[markerindex])
                                          create_scan(rf_data.marker.indexOf(newmarker), 1-panelindex)

    # change the cell tip info
    mylodheatmap.celltip()
                .html((d) ->
                        mari = rf_data.marker[d.xindex]
                        marj = rf_data.marker[d.yindex]
                        if +d.xindex > +d.yindex                # +'s ensure number not string
                            rf = rf_data.rf[d.xindex][d.yindex]
                            lod = rf_data.rf[d.yindex][d.xindex]
                        else if +d.yindex > +d.xindex
                            rf = rf_data.rf[d.yindex][d.xindex]
                            lod = rf_data.rf[d.xindex][d.yindex]
                        else
                            return mari
                        rf = if rf >= 0.1 then d3.format(".2f")(rf) else d3.format(".3f")(rf)
                        "(#{mari} #{marj}), LOD = #{d3.format(".1f")(lod)}, rf = #{rf}")

    # when clicking cell, add crosstab and lod charts
    mylodheatmap.cells().on "click", (d) ->
                     create_scan(d.xindex, 0)
                     if d.xindex != d.yindex
                         create_scan(d.yindex, 1)
                     else # if same marker, just show the one panel
                         mylodchart[1].remove() if mylodchart[1]?
                         mylodchart[1] = null
                     create_crosstab(rf_data.marker[d.yindex], rf_data.marker[d.xindex])

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
