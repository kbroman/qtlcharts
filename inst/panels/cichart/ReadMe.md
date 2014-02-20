### Reusable CI chart (plot of estimates and confidence intervals for a set of categories)

A reusable chart for making a CI chart, following
[Mike Bostock](http://bost.ocks.org/mike)'s
[Towards Reuseable Charts](http://bost.ocks.org/mike/chart/).

For an illustration of its use, see [test_cichart.coffee](https://github.com/kbroman/qtlcharts/blob/master/inst/panels/cichart/test/test_cichart.coffee).

Add see it in action
[here](http://www.biostat.wisc.edu/~kbroman/D3/cichart),

Here are all of the options:

    mychart = cichart().xvar("x")                                               # variable containing x-coordinate
                       .yvar("y")                                               # variable containing y-coordinate
                       .width(400)                                              # internal width of chart
                       .height(500)                                             # internal height
                       .margin({left:60, top:40, right:40, bottom:40, inner:5}) # margins
                       .axispos({xtitle:25, ytitle:30, xlabel:5, ylabel:5})     # spacing for axis titles and labels
                       .titlepos(20)                                            # spacing for panel title
                       .xcatlabels(null)                                        # labels for x-axis categories
                       .segwidth(null)                                          # width of horizontal line segments
                       .ylim(null)                                              # y-axis limits
                       .nyticks(5)                                              # no. y-axis ticks
                       .yticks(null)                                            # locations of y-axis ticks
                       .rectcolor(d3.rgb(230,230,230))                          # background rectangle color
                       .segcolor("slateblue")                                   # color for horizontal line segments
                       .vertsegcolor(d3.rgb(100,100,100))                       # color for vertical line segments
                       .segstrokewidth("2")                                     # stroke width for horiz line segs
                       .title("")                                               # panel title
                       .xlab("Group")                                           # x-axis label
                       .ylab("Response")                                        # y-axis label

Organization of data:

  We expect `{means, low, high, categories}`, each a vector of common length.

Additional accessors:

    # x-axis scale
    xscale = mychart.xscale()
    xscale(x)

    # y-axis scale
    yscale = mychart.yscale()
    yscale(y)
