# ipleiotropy: tool for exploring pleiotropy for two traits
# Karl W Broman

ipleiotropy = (widgetdiv, lod_data, pxg_data, chartOpts) ->

    markers = (x for x of pxg_data.chrByMarkers)

    # chartOpts start
    height = chartOpts?.height ? 450                                    # height of image in pixels
    width = chartOpts?.width ? 900                                      # width of image in pixels
    wleft = chartOpts?.wleft ? width*0.5                                # width of left panel in pixels (ignored if LOD scores not provided)
    margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40, inner:5} # margins in pixels (left, top, right, bottom, inner)
    lod_axispos = chartOpts?.lod_axispos ? chartOpts?.axispos ? {xtitle:25, ytitle:30, xlabel:5, ylabel:5} # position of axis labels in pixels (xtitle, ytitle, xlabel, ylabel) in LOD curve panel
    lod_titlepos = chartOpts?.lod_titlepos ? chartOpts?.titlepos ? 20   # position of title for LOD curve panel, in pixels
    rectcolor = chartOpts?.rectcolor ? "#E6E6E6"                        # color of background rectangle
    lod_ylim = chartOpts?.lod_ylim ? null                               # y-axis limits in LOD curve panel
    lod_nyticks = chartOpts?.lod_nyticks ? 5                            # number of ticks in y-axis in LOD curve panel
    lod_yticks = chartOpts?.lod_yticks ? null                           # vector of tick positions for y-axis in LOD curve panel
    linecolor = chartOpts?.linecolor ? ["darkslateblue", "orchid"]      # line colors for LOD curves
    linewidth = chartOpts?.linewidth ? 2                                # line width for LOD curves
    lod_title = chartOpts?.lod_title ? ""                               # title of LOD curve panel
    lod_xlab = chartOpts?.lod_xlab ? "Chromosome"                       # x-axis label for LOD curve panel
    lod_ylab = chartOpts?.lod_ylab ? "LOD score"                        # y-axis label for LOD curve panel
    lod_rotate_ylab = chartOpts?.lod_rotate_ylab ? null                 # indicates whether to rotate the y-axis label 90 degrees, in LOD curve panel
    pointcolor = chartOpts?.pointcolor ? null                           # vector of point colors for phenotype scatter plot (non-recombinants first, then all of the recombinants)
    pointstroke = chartOpts?.pointstroke ? "black"                      # color of outer circle for points, in scatterplot
    pointsize = chartOpts?.pointsize ? 3                                # point size in phe-by-gen paenl
    scat_ylim = chartOpts?.scat_ylim ? null                             # y-axis limits in scatterplot
    scat_nyticks = chartOpts?.scat_nyticks ? 5                          # number of ticks in y-axis in scatterplot
    scat_yticks = chartOpts?.scat_yticks ? null                         # vector of tick positions for y-axis in scatterplot
    scat_xlab = chartOpts?.scat_xlab ? null                             # x-axis label in scatterplot
    scat_ylab = chartOpts?.scat_ylab ? null                             # y-axis label in scatterplot
    scat_rotate_ylab = chartOpts?.scat_rotate_ylab ? null               # indicates whether to rotate the y-axis label 90 degrees, in scatterplot
    scat_axispos = chartOpts?.scat_axispos ? chartOpts?.axispos ? {xtitle:25, ytitle:30, xlabel:5, ylabel:5} # position of axis labels in pixels (xtitle, ytitle, xlabel, ylabel) in LOD curve panel
    scat_titlepos = chartOpts?.scat_titlepos ? chartOpts?.titlepos ? 20 # position of title for scatterplot, in pixels
    slider_height = chartOpts?.slider_height ? 80                       # height of slider
    slider_color  = chartOpts?.slider_color ? "#E6E6E6"                 # color of slider bar
    button_color  = chartOpts?.button_color ? "#E6E6E6"                 # color of rectangular part of buttons
    ticks_at_markers = chartOpts?.ticks_at_markers ? true               # if true, put tick marks at the marker positions (above the slider)
    # chartOpts end
    chartdivid = chartOpts?.chartdivid ? 'chart'
    widgetdivid = d3.select(widgetdiv).attr('id')

    # make sure list args have all necessary bits
    margin = d3panels.check_listarg_v_default(margin, {left:60, top:40, right:40, bottom: 40, inner:5})
    lod_axispos = d3panels.check_listarg_v_default(lod_axispos, {xtitle:25, ytitle:30, xlabel:5, ylabel:5})
    scat_axispos = d3panels.check_listarg_v_default(scat_axispos, {xtitle:25, ytitle:30, xlabel:5, ylabel:5})

    svg = d3.select(widgetdiv).select("svg")

    #####
    # lod curve plot
    #####

    lod_at_marker = [null, null]

    if lod_data.lod? # is there any lod score data?
        # y-axis limits for LOD curves
        lod_ylim = [0, 1.05*d3.max([d3.max(lod_data.lod), d3.max(lod_data.lod2)])] unless lod_ylim?

        lod_at_marker[0] = (lod_data.lod[i] for i of lod_data.lod when lod_data.marker[i] != "")
        lod_at_marker[1] = (lod_data.lod2[i] for i of lod_data.lod when lod_data.marker[i] != "")

        mylodchart = d3panels.lodchart({
            height:height-slider_height
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
            linecolor:linecolor[0]
            linewidth:linewidth
            pointcolor:null
            pointsize:null
            pointstroke:null
            title:lod_title
            xlab:lod_xlab
            ylab:lod_ylab
            rotate_ylab:lod_rotate_ylab
            tipclass:widgetdivid})

        g_lod = svg.append("g")
                   .attr("id", "lodchart")
        mylodchart(g_lod, lod_data)

        my_second_curve = d3panels.add_lodcurve({
            linecolor:linecolor[1]
            linewidth:linewidth
            pointcolor:null
            pointsize:null
            pointstroke:null
            tipclass:widgetdivid})


        lod2_data = {chr:lod_data.chr, pos:lod_data.pos, lod:lod_data.lod2, marker:lod_data.marker}
        my_second_curve(mylodchart, lod2_data)

        lod_points = g_lod.selectAll("empty")
                          .data([0,1])
                          .enter()
                          .insert("circle")
                          .attr("cx", null)
                          .attr("cy", null)
                          .attr("r", pointsize)
                          .attr("fill", (i) -> linecolor[i])
                          .attr("stroke", (i) -> pointstroke)
                          .style("pointer-events", "none")


    #####
    # scatterplot
    #####

    g_scat = svg.append("g")
                .attr("id", "scatterplot")
    if lod_data.lod?
        g_scat.attr("transform", "translate(#{wleft},0)")
        wright = width - wleft
    else
        wright = width
        wleft = width

    scat_xlab = pxg_data.phenames[0] unless scat_xlab?
    scat_ylab = pxg_data.phenames[1] unless scat_ylab?

    myscatter = d3panels.scatterplot({
        height:height-slider_height
        width:wright
        margin:margin
        pointcolor:pointcolor
        pointstroke:pointstroke
        pointsize:pointsize
        ylim:scat_ylim
        nyticks:scat_nyticks
        yticks:scat_yticks
        xlab:scat_xlab
        ylab:scat_ylab
        rotate_ylab:scat_rotate_ylab
        axispos:scat_axispos
        titlepos:scat_titlepos
        xNA:{handle:false,force:false}
        yNA:{handle:false,force:false}
        rectcolor:rectcolor
        tipclass:widgetdivid})

    point_data = {x:pxg_data.pheno1, y:pxg_data.pheno2, indID:pxg_data.indID}

    myscatter(g_scat, point_data)
    points = myscatter.points()
    indtip = myscatter.indtip()

    #####
    # callback for sliders
    #####

    # set up colors
    n_geno = d3panels.matrixMaxAbs(pxg_data.geno)
    n_geno_sq = n_geno*n_geno
    if pointcolor?
        n_color = pointcolor.length
        if n_color < n_geno_sq
            d3.range(n_geno_sq-n_color).map( (i) -> pointcolor.push("#aaa"))
        dark = pointcolor[0...n_geno]
        light = pointcolor[n_geno...n_geno_sq]
    else
        dark = d3panels.selectGroupColors(n_geno, "dark")
        light = d3panels.selectGroupColors(n_geno_sq, "light")[n_geno...n_geno_sq]
    # re-arrange colors
    pointcolor = []
    dark.reverse()
    light.reverse()
    homozygotes = [0...n_geno].map((i) -> i*n_geno+i)
    for i in [0...n_geno_sq]
        if homozygotes.indexOf(i) > -1
            pointcolor.push(dark.pop())
        else
            pointcolor.push(light.pop())

    geno1 = []
    geno2 = []
    group = []
    m1_current = -1
    m2_current = -1

    callback = (sl) ->
        v = sl.stopindex() # current selected positions

        update = (m1_current != v[0] or m2_current != v[1])
        m1_current = v[0]
        m2_current = v[1]

        if update
            g1 = d3.range(point_data.x.length).map((i) -> pxg_data.geno[v[0]][i])
            g2 = d3.range(point_data.x.length).map((i) -> pxg_data.geno[v[1]][i])
            abs_g1 = (Math.abs(x) for x in g1)
            abs_g2 = (Math.abs(x) for x in g2)
            group = (abs_g1[i]-1 + (abs_g2[i]-1)*n_geno for i of g1)
            points.attr("fill", (d,i) -> pointcolor[group[i]])

            g1_lab = g1.map((g) ->
                glab = pxg_data.genonames[Math.abs(g)-1]
                if g < 0 then "(#{glab})" else "#{glab}")
            g2_lab = g2.map((g) ->
                glab = pxg_data.genonames[Math.abs(g)-1]
                if g < 0 then "(#{glab})" else "#{glab}")

            if v[0] > v[1] # make sure the genotypes show in the right order
                indtip.html((d,i) -> "#{pxg_data.indID[i]}: #{g2_lab[i]}&rarr;#{g1_lab[i]}")
            else
                indtip.html((d,i) -> "#{pxg_data.indID[i]}: #{g1_lab[i]}&rarr;#{g2_lab[i]}")

            if lod_data.lod?
                lod_points.attr("cx", (d,i) -> mylodchart.xscale()[lod_data.chr[0]](marker_pos[v[i]]))
                          .attr("cy", (d,i) -> mylodchart.yscale()(lod_at_marker[i][v[i]]))

    #####
    # slider
    #####

    g_slider = svg.insert("g").attr("transform", "translate(0,#{height-slider_height})")

    myslider = d3panels.double_slider({
        width:wleft
        height:slider_height
        width:wleft
        margin:margin
        buttoncolor:button_color
        rectcolor:rectcolor
        ticks_at_stops:ticks_at_markers})

    marker_pos = (lod_data.pos[i] for i of lod_data.pos when lod_data.marker[i] != "")

    if lod_data.lod?
        initial_value = [0..1].map((j) ->
            max_lod = d3.max(lod_at_marker[j])
            max_index = lod_at_marker[j].indexOf(max_lod)
            marker_pos[max_index])
    else
        initial_value = null

    myslider(g_slider, callback, callback, d3.extent(lod_data.pos), marker_pos, initial_value)

    # call it once to set colors
    callback(myslider)

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
