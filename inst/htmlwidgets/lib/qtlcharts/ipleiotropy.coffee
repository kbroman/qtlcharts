# ipleiotropy: tool for exploring pleiotropy for two traits
# Karl W Broman

ipleiotropy = (widgetdiv, lod_data, pxg_data, chartOpts) ->

    markers = (x for x of pxg_data.chrByMarkers)

    # chartOpts start
    height = chartOpts?.height ? 450                                    # height of image in pixels
    width = chartOpts?.width ? 900                                      # width of image in pixels
    wleft = chartOpts?.wleft ? width*0.5                                # width of left panel in pixels
    margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40, inner:5} # margins in pixels (left, top, right, bottom, inner)
    lod_axispos = chartOpts?.lod_axispos ? chartOpts?.axispos ? {xtitle:25, ytitle:30, xlabel:5, ylabel:5} # position of axis labels in pixels (xtitle, ytitle, xlabel, ylabel) in LOD curve panel
    lod_titlepos = chartOpts?.lod_titlepos ? chartOpts?.titlepos ? 20   # position of title for LOD curve panel, in pixels
    rectcolor = chartOpts?.rectcolor ? "#E6E6E6"                        # color of background rectangle
    lod_ylim = chartOpts?.lod_ylim ? null                               # y-axis limits in LOD curve panel
    lod_nyticks = chartOpts?.lod_nyticks ? 5                            # number of ticks in y-axis in LOD curve panel
    lod_yticks = chartOpts?.lod_yticks ? null                           # vector of tick positions for y-axis in LOD curve panel
    lod_linecolor = chartOpts?.lod_linecolor ? ["darkslateblue", "orchid"]  # line colors for LOD curves
    lod_linewidth = chartOpts?.lod_linewidth ? 2                        # line width for LOD curves
    lod_title = chartOpts?.lod_title ? ""                               # title of LOD curve panel
    lod_xlab = chartOpts?.lod_xlab ? "Chromosome"                       # x-axis label for LOD curve panel
    lod_ylab = chartOpts?.lod_ylab ? "LOD score"                        # y-axis label for LOD curve panel
    lod_rotate_ylab = chartOpts?.lod_rotate_ylab ? null                 # indicates whether to rotate the y-axis label 90 degrees, in LOD curve panel
    pointcolor = chartOpts?.pointcolor ? null                           # vector of point colors for phenotype scatter plot
    pointstroke = chartOpts?.pointstroke ? "black"                      # color of outer circle for points, in scatterplot
    pointsize = chartOpts?.pointsize ? 3                                # point size in phe-by-gen paenl
    scat_ylim = chartOpts?.scat_ylim ? null                             # y-axis limits in scatterplot
    scat_nyticks = chartOpts?.scat_nyticks ? 5                          # number of ticks in y-axis in scatterplot
    scat_yticks = chartOpts?.scat_yticks ? null                         # vector of tick positions for y-axis in scatterplot
    scat_xlab = chartOpts?.scat_xlab ? "Phenotype 1"                    # x-axis label in scatterplot
    scat_ylab = chartOpts?.scat_ylab ? "Phenotype 2"                    # y-axis label in scatterplot
    scat_rotate_ylab = chartOpts?.scat_rotate_ylab ? null               # indicates whether to rotate the y-axis label 90 degrees, in scatterplot
    scat_axispos = chartOpts?.scat_axispos ? chartOpts?.axispos ? {xtitle:25, ytitle:30, xlabel:5, ylabel:5} # position of axis labels in pixels (xtitle, ytitle, xlabel, ylabel) in LOD curve panel
    scat_titlepos = chartOpts?.scat_titlepos ? chartOpts?.titlepos ? 20   # position of title for scatterplot, in pixels
    # chartOpts end
    chartdivid = chartOpts?.chartdivid ? 'chart'
    widgetdivid = d3.select(widgetdiv).attr('id')

    wright = width - wleft

    if lod_data.lod? # is there any lod score data?

        # y-axis limits for LOD curves
        lod_ylim = [0, 1.05*d3.max([d3.max(lod_data.lod), d3.max(lod_data.lod2)])] unless lod_ylim?

        mylodchart = d3panels.lodchart({
            height:height
            width:wleft
            margin:margin
            axispos:lod_axispos
            titlepos:lod_titlepos
            chrGap:0
            altrectcolor:null
            rectcolor:rectcolor
            ylim:lod_ylim
            nyticks:lod_nyticks
            yticks:lod_yticks
            linecolor:lod_linecolor[0]
            linewidth:lod_linewidth
            pointcolor:null
            pointsize:null
            pointstroke:null
            title:lod_title
            xlab:lod_xlab
            ylab:lod_ylab
            rotate_ylab:lod_rotate_ylab
            tipclass:widgetdivid})

        svg = d3.select(widgetdiv).select("svg")

        g_lod = svg.append("g")
                   .attr("id", "lodchart")
        mylodchart(g_lod, lod_data)

        my_second_curve = d3panels.add_lodcurve({
            linecolor:lod_linecolor[1]
            linewidth:lod_linewidth
            pointcolor:null
            pointsize:null
            pointstroke:null
            tipclass:widgetdivid})

        lod2_data = {chr:lod_data.chr, pos:lod_data.pos, lod:lod_data.lod2, marker:lod_data.marker}
        my_second_curve(mylodchart, lod2_data)
