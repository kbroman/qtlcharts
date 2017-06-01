# iplotScanone_ci: lod curves + phe x gen (as mean +/- 2 SE) plot
# Karl W Broman

iplotScanone_ci = (widgetdiv, lod_data, pxg_data, chartOpts) ->

    markers = (x for x of pxg_data.chrByMarkers)

    # chartOpts start
    height = chartOpts?.height ? 530                           # height of image in pixels
    width = chartOpts?.width ? 1200                            # width of image in pixels
    wleft = chartOpts?.wleft ? width*0.7                       # width of left panel in pixels
    margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40, inner:5} # margins in pixels (left, top, right, bottom, inner)
    lod_axispos = chartOpts?.lod_axispos ? chartOpts?.axispos ? {xtitle:25, ytitle:30, xlabel:5, ylabel:5} # position of axis labels in pixels (xtitle, ytitle, xlabel, ylabel) in LOD curve panel
    lod_titlepos = chartOpts?.lod_titlepos ? chartOpts?.titlepos ? 20 # position of title for LOD curve panel, in pixels
    chrGap = chartOpts?.chrGap ? 6                             # gap between chromosomes
    rectcolor = chartOpts?.rectcolor ? "#E6E6E6"               # color of lighter background rectangle
    altrectcolor = chartOpts?.altrectcolor ? "#C8C8C8"         # color of darker background rectangle
    lod_ylim = chartOpts?.lod_ylim ? null                      # y-axis limits in LOD curve panel
    lod_nyticks = chartOpts?.lod_nyticks ? 5                   # number of ticks in y-axis in LOD curve panel
    lod_yticks = chartOpts?.lod_yticks ? null                  # vector of tick positions for y-axis in LOD curve panel
    lod_linecolor = chartOpts?.lod_linecolor ? "darkslateblue" # line color for LOD curves
    lod_linewidth = chartOpts?.lod_linewidth ? 2               # line width for LOD curves
    lod_pointcolor = chartOpts?.lod_pointcolor ? "#E9CFEC"     # color for points at markers in LOD curve panel
    lod_pointsize = chartOpts?.lod_pointsize ? 0               # size of points at markers (default = 0 corresponding to no visible points at markers)
    lod_pointstroke = chartOpts?.lod_pointstroke ? "black"     # color of outer circle for points at markers in LOD curve panel
    lod_title = chartOpts?.lod_title ? ""                      # title of LOD curve panel
    lod_xlab = chartOpts?.lod_xlab ? null                      # x-axis label for LOD curve panel
    lod_ylab = chartOpts?.lod_ylab ? "LOD score"               # y-axis label for LOD curve panel
    lod_rotate_ylab = chartOpts?.lod_rotate_ylab ? null        # indicates whether to rotate the y-axis label 90 degrees, in LOD curve panel
    eff_ylim = chartOpts?.eff_ylim ? null                      # y-axis limits in effect plot panel
    eff_nyticks = chartOpts?.eff_nyticks ? 5                   # number of ticks in y-axis in effect plot panel
    eff_yticks = chartOpts?.eff_yticks ? null                  # vector of tick positions for y-axis in effect plot panel
    eff_linecolor = chartOpts?.eff_linecolor ? "slateblue"     # line color in effect plot panel
    eff_linewidth = chartOpts?.eff_linewidth ? "3"             # line width in effect plot panel
    eff_xlab = chartOpts?.eff_xlab ? "Genotype"                # x-axis label in effect plot panel
    eff_ylab = chartOpts?.eff_ylab ? "Phenotype"               # y-axis label in effect plot panel
    eff_rotate_ylab = chartOpts?.eff_rotate_ylab ? null        # indicates whether to rotate the y-axis label 90 degrees, in effect plot panel
    eff_segwidth = chartOpts?.eff_segwidth ? null              # width of line segments in effect plot panel, in pixels
    eff_axispos = chartOpts?.eff_axispos ? chartOpts?.axispos ? {xtitle:25, ytitle:30, xlabel:5, ylabel:5} # position of axis labels in pixels (xtitle, ytitle, xlabel, ylabel) in effect plot panel
    eff_titlepos = chartOpts?.eff_titlepos ? chartOpts?.titlepos ? 20 # position of title for effect plot panel, in pixels
    # chartOpts end
    chartdivid = chartOpts?.chartdivid ? 'chart'
    widgetdivid = d3.select(widgetdiv).attr('id')

    # make sure list args have all necessary bits
    margin = d3panels.check_listarg_v_default(margin, {left:60, top:40, right:40, bottom: 40, inner:5})
    lod_axispos = d3panels.check_listarg_v_default(lod_axispos, {xtitle:25, ytitle:30, xlabel:5, ylabel:5})
    eff_axispos = d3panels.check_listarg_v_default(eff_axispos, {xtitle:25, ytitle:30, xlabel:5, ylabel:5})

    wright = width - wleft

    mylodchart = d3panels.lodchart({
        height:height
        width:wleft
        margin:margin
        axispos:lod_axispos
        titlepos:lod_titlepos
        chrGap:chrGap
        altrectcolor:altrectcolor
        rectcolor:rectcolor
        ylim:lod_ylim
        nyticks:lod_nyticks
        yticks:lod_yticks
        linecolor:lod_linecolor
        linewidth:lod_linewidth
        pointcolor:lod_pointcolor
        pointsize:lod_pointsize
        pointstroke:lod_pointstroke
        title:lod_title
        xlab:lod_xlab
        ylab:lod_ylab
        rotate_ylab:lod_rotate_ylab
        tipclass:widgetdivid})

    svg = d3.select(widgetdiv).select("svg")

    g_lod = svg.append("g")
               .attr("id", "lodchart")
    mylodchart(g_lod, lod_data)

    mycichart = null
    plotCI = (markername, markerindex) ->
        mycichart.remove() if mycichart?

        g = pxg_data.geno[markerindex]
        gabs = (Math.abs(x) for x in g)

        chr = pxg_data.chrByMarkers[markername]
        chrtype = pxg_data.chrtype[chr]
        genonames = pxg_data.genonames[chrtype]

        means = []
        se = []
        low = []
        high = []
        for j in [1..genonames.length]
            phesub = (p for p,i in pxg_data.pheno when gabs[i] == j and p?)

            if phesub.length>0
                ave = (phesub.reduce (a,b) -> a+b)/phesub.length
                means.push(ave)
            else means.push(null)

            if phesub.length>1
                variance = (phesub.reduce (a,b) -> a+Math.pow(b-ave, 2))/(phesub.length-1)
                se.push((Math.sqrt(variance/phesub.length)))
                low.push(means[j-1] - 2*se[j-1])
                high.push(means[j-1] + 2*se[j-1])
            else
                se.push(null)
                low.push(null)
                high.push(null)

        range = [d3.min(low), d3.max(high)]
        if eff_ylim?
            eff_ylim = [d3.min([range[0],eff_ylim[0]]), d3.max([range[1],eff_ylim[1]])]
        else
            eff_ylim = range

        mycichart = d3panels.cichart({
            height:height
            width:wright
            margin:margin
            axispos:eff_axispos
            titlepos:eff_titlepos
            title:markername
            xlab:eff_xlab
            ylab:eff_ylab
            rotate_ylab:eff_rotate_ylab
            ylim:eff_ylim
            nyticks:eff_nyticks
            yticks:eff_yticks
            segcolor:eff_linecolor
            vertsegcolor:eff_linecolor
            segstrokewidth:eff_linewidth
            segwidth:eff_segwidth
            rectcolor:rectcolor
            tipclass:widgetdivid
            xcatlabels:genonames})

        ci_g = svg.append("g")
           .attr("id", "cichart")
           .attr("transform", "translate(#{wleft},0)")
        mycichart(ci_g, {'mean':means, 'low':low, 'high':high})

    # animate points at markers on click
    mylodchart.markerSelect()
              .on "click", (d,i) ->
                    plotCI(markers[i], i)

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
