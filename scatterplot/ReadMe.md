### Reusable scatterplot

A reusable chart for making a scatterplot,
following
[Mike Bostock](http://bost.ocks.org/mike)'s
[Towards Reuseable Charts](http://bost.ocks.org/mike/chart/).

For an illustration of its use, see [test_scatterplot.coffee](https://github.com/kbroman/d3examples/blob/master/scatterplot/test_scatterplot.coffee).

Add see it in action [here](http://www.biostat.wisc.edu/~kbroman/D3/scatterplot).

Here are all of the options:

    mychart = scatterplot().xvar("x")                                               # variable containing x-coordinate
                           .yvar("y")                                               # variable containing y-coordinate
                           .width(800)                                              # internal width of chart
                           .height(500)                                             # internal height
                           .margin({left:60, top:40, right:40, bottom:40, inner:5}) # margins
                           .axispos({xtitle:25, ytitle:30, xlabel:5, ylabel:5})     # spacing for axis titles and labels
                           .xlim(null)                                              # x-axis limits
                           .ylim(null)                                              # y-axis limits
                           .nxticks(5)                                              # no. x-axis ticks
                           .nyticks(5)                                              # no. y-axis ticks
                           .xticks(null)                                            # locations of x-axis ticks
                           .yticks(null)                                            # locations of y-axis ticks
                           .rectcolor(d3.rgb(230,230,230))                          # background rectangle color
                           .pointcolor("darkslateblue")                             # color for points
                           .pointsize(3)                                            # radius of points at markers
                           .xlab("X")                                               # x-axis label
                           .ylab("Y")                                               # y-axis label
                           .xNA({handle:true, force:false, width:15, gap:10})       # treatment of missing x values
                           .yNA({handle:true, force:false, width:15, gap:10})       # treatment of missing y values

Treatment of missing values through `xNA` and `yNA`:

    handle: if true, plot missing values in separated area; if false, omit missing values
    force:  force handle==true (with separate area for missing values) even if there are no missing values
    width:  width of space reserved for missing values
    gap:    gap between space for missing values and the main panel
 
Additional accessors:

    # x-axis scale
    xscale = mychart.xscale()
    xscale(x)

    # y-axis scale
    yscale = mychart.yscale()
    yscale(y)

    # selection of points at markers, to add .on("click", ...)
    pointsSelect = mychart.pointsSelect()
