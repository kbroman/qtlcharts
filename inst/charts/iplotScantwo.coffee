# iplotScantwo: interactive plot of scantwo results (2-dim, 2-QTL genome scan)
# Karl W Broman

iplotScantwo = (scantwo_data, pheno_and_geno, chartOpts) ->

    # chartOpts start
    pixelPerCell = chartOpts?.pixelPerCell ? null # pixels per cell in heat map
    chrGap = chartOpts?.chrGap ? 2 # gaps between chr in heat map
    wright = chartOpts?.wright ? 500 # width (in pixels) of right panels
    hbot = chartOpts?.hbot ? 300 # height (in pixels) of each of the lower panels
    margin = chartOpts?.margin ? {left:60, top:30, right:10, bottom: 40, inner: 5} # margins in each panel
    axispos = chartOpts?.axispos ? {xtitle:25, ytitle:30, xlabel:5, ylabel:5} # axis positions in heatmap
    lightrect = chartOpts?.lightrect ? "#e6e6e6" # background color in heatmap; light rect in lower panels
    darkrect = chartOpts?.darkrect ? "#c8c8c8" # dark rectangle in lower panels
    nullcolor = chartOpts?.nullcolor ? "#e6e6e6" # color of null pixels in heat map
    bordercolor = chartOpts?.bordercolor ? "black" # border color in heat map
    linecolor = chartOpts?.linecolor ? "slateblue" # line color in lower panels
    linewidth = chartOpts?.linewidth ? 2 # line width in lower panels
    colors = chartOpts?.colors ? ["white", "slateblue"] # colors for heat map
    oneAtTop = chartOpts?.oneAtTop ? false # whether to put chr 1 at top of heatmap
    # chartOpts end
    chartdivid = chartOpts?.chartdivid ? 'chart'

    # size of heatmap region
    totmar = sumArray(scantwo_data.nmar)
    pixelPerCell = d3.max([2, Math.floor(600/totmar)]) unless pixelPerCell?
    w = chrGap*scantwo_data.chrnames.length + pixelPerCell*totmar
    heatmap_width =  w + margin.left + margin.right
    heatmap_height = w + margin.top + margin.bottom

    hright = heatmap_height/2 - margin.top - margin.bottom
    totalw = heatmap_width + wright + margin.left + margin.right
    totalh = heatmap_height + (hbot + margin.top + margin.bottom)*2

    # width of lower panels
    wbot = (totalw/3 - margin.left - margin.right)

    # drop-down menus
    options = ["full", "fv1", "int", "add", "av1"]
    div = d3.select("div##{chartdivid}")
    form = div.append("g").attr("id", "form")
    left = form.append("div")
              .text("top-left: ")
              .style("float", "left")
              .style("margin-left", "50px")
    leftsel = left.append("select")
                  .attr("id", "leftselect")
                  .attr("name", "left")
    leftsel.selectAll("empty")
           .data(options)
           .enter()
           .append("option")
           .attr("value", (d) -> d)
           .text((d) -> d)
           .attr("selected", (d) ->
               return "selected" if d=="int"
               null)

    right = form.append("div")
                .text("bottom-right: ")
                .style("float", "left")
                .style("margin-left", "50px")
    rightsel = right.append("select")
                    .attr("id", "rightselect")
                    .attr("name", "right")
    rightsel.selectAll("empty")
            .data(options)
            .enter()
            .append("option")
            .attr("value", (d) -> d)
            .text((d) -> d)
            .attr("selected", (d) ->
                return "selected" if d=="fv1"
                null)

    submit = form.append("div")
                 .style("float", "left")
                 .style("margin-left", "50px")
                 .append("button")
                 .attr("name", "refresh")
                 .text("Refresh")
                 .on("click", () ->
                     leftsel = document.getElementById('leftselect')
                     leftval = leftsel.options[leftsel.selectedIndex].value
                     rightsel = document.getElementById('rightselect')
                     rightval = rightsel.options[rightsel.selectedIndex].value
                     console.log("left: #{leftval}, right: #{rightval}")
                     )

    # create SVG
    svg = d3.select("div##{chartdivid}")
            .append("svg")
            .attr("height", totalh)
            .attr("width", totalw)

    # make copy of rf/lod
    rf_data.z = rf_data.rf.map (d) -> d.map (dd) -> dd

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
                               .rectcolor(lightrect)
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

    g_crosstab = null
    g_scans = [null, null]

    create_crosstab = (marker1, marker2) ->
        data =
            x: geno.geno[marker1]
            y: geno.geno[marker2]
            xcat: geno.genocat[geno.chrtype[marker1]]
            ycat: geno.genocat[geno.chrtype[marker2]]
            xlabel: marker1
            ylabel: marker2

        g_crosstab.remove() if g_crosstab?

        mycrosstab = crosstab().cellHeight(cellHeight)
                               .cellWidth(cellWidth)
                               .cellPad(cellPad)
                               .margin(margin)
                               .fontsize(fontsize)
                               .rectcolor(lightrect)
                               .hilitcolor(hilitcolor)
                               .bordercolor(bordercolor)

        g_crosstab = svg.append("g")
                        .attr("id", "crosstab")
                        .attr("transform", "translate(#{crosstab_xpos}, #{crosstab_ypos})")
                        .datum(data)
                        .call(mycrosstab)

    create_scan = (markerindex, panelindex) -> # panelindex = 0 or 1 for left or right panels
        data =
            chrnames: rf_data.chrnames
            lodnames: ["lod"]
            chr: rf_data.chr
            pos: rf_data.pos
            lod: (i for i of rf_data.pos)
            markernames: rf_data.labels

        for row in [0...rf_data.rf.length]
            if row > markerindex
                data.lod[row] = rf_data.rf[markerindex][row]
            else if row < markerindex
                data.lod[row] = rf_data.rf[row][markerindex]
        data.lod[markerindex] = null # point at marker: set to maximum LOD

        g_scans[panelindex].remove() if g_scans[panelindex]?

        mylodchart = lodchart().height(hbot-margin.top-margin.bottom)
                               .width(wbot-margin.left-margin.right)
                               .margin(margin)
                               .axispos(axispos)
                               .ylim([0.0, d3.max(data.lod)])
                               .lightrect(lightrect)
                               .darkrect(darkrect)
                               .linewidth(0)
                               .linecolor("")
                               .pointsize(pointsize)
                               .pointcolor(pointcolor)
                               .pointstroke(pointstroke)
                               .lodvarname("lod")
                               .title(data.markernames[markerindex])

        g_scans[panelindex] = svg.append("g")
                                 .attr("id", "lod_rf_#{panelindex+1}")
                                 .attr("transform", "translate(#{wbot*panelindex}, #{htop})")
                                 .datum(data)
                                 .call(mylodchart)

        mylodchart.markerSelect().on "click", (d) ->
                                          newmarker = d.name
                                          if panelindex == 0
                                              create_crosstab(rf_data.labels[markerindex], newmarker)
                                          else
                                              create_crosstab(newmarker, rf_data.labels[markerindex])
                                          create_scan(rf_data.labels.indexOf(newmarker), 1-panelindex)

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
         .on "click", (d) ->
                     create_crosstab(rf_data.labels[d.j], rf_data.labels[d.i])
                     create_scan(d.i, 0)
                     if d.i != d.j
                       create_scan(d.j, 1)
                     else # if same marker, just show the one panel
                       g_scans[1].remove()
                       g_scans[1] = null
