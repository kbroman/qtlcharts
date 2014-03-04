### Reusable scatterplot

A reusable chart for making a chart with multiple curves
following
[Mike Bostock](http://bost.ocks.org/mike)'s
[Towards Reuseable Charts](http://bost.ocks.org/mike/chart/).

For an illustration of its use, see [test_curvechart.coffee](https://github.com/kbroman/qtlcharts/blob/master/inst/panels/curvechart/test/test_curvechart.coffee).

Add see it in action
[here](http://www.biostat.wisc.edu/~kbroman/D3/curvechart/test).

Here are all of the options:

    mychart = cichart().width(800)                                              # internal width of chart
                       .height(500)                                             # internal height
                       .margin({left:60, top:40, right:40, bottom:40, inner:5}) # margins
                       .axispos({xtitle:25, ytitle:30, xlabel:5, ylabel:5})     # spacing for axis titles and labels
                       .titlepos(20)                                            # spacing for panel title
                       .xlim(null)                                              # x-axis limits
                       .ylim(null)                                              # y-axis limits
                       .nxticks(5)                                              # no. x-axis ticks
                       .nyticks(5)                                              # no. y-axis ticks
                       .xticks(null)                                            # locations of x-axis ticks
                       .yticks(null)                                            # locations of y-axis ticks
                       .rectcolor(d3.rgb(230,230,230))                          # background rectangle color
                       .strokecolor(d3.rgb(190,190,190))                        # color(s) for curves
                       .strokecolorhilit("slateblue")                           # color(s) for curves when highlighted
                       .strokewidth(2)                                          # line width for curves
                       .strokewidthhilit(2)                                     # line width for curves when highlighted
                       .title("")                                               # panel title
                       .xlab("X")                                               # x-axis label
                       .ylab("Y")                                               # y-axis label
                       .commonX(true)                                           # Do all curves have a common set of X's?

Organization of data:

  If `commonX == true` (the default), we expect the data to be like `{x:[x1, x2, ..., xt], data:[[y11, y12, .. y1t]...[yn1, .. ynt]]}`.
                       
  Alternatively, if `commonX == false` we expect the data to be like `{data:[{x:[x(1,1), ..., x(1,t1)],y:[y(1,1), ..., y(1,t[1])}, ...]}`
  
  The data can also contain a vector `groups` with length equal to the number of individuals, taking values in `(1, 2, ..., k)`, for specifying colors. 

Additional accessors:

    # x-axis scale
    xscale = mychart.xscale()
    xscale(x)

    # y-axis scale
    yscale = mychart.yscale()
    yscale(y)

    # selection of curves, to add .on("click", ...)
    curveSelect = mychart.curveSelect()
