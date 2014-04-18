### Reusable dotchart

A reusable chart for making a dotchart,
following
[Mike Bostock](http://bost.ocks.org/mike)'s
[Towards Reuseable Charts](http://bost.ocks.org/mike/chart/).

For an illustration of its use, see [test_dotchart.coffee](https://github.com/kbroman/qtlcharts/blob/master/inst/panels/dotchart/test/test_dotchart.coffee).

Add see it in action
[here](http://kbroman.github.io/qtlcharts/assets/panels/dotchart/test).

Here are all of the options:

```coffeescript
mychart = dotchart().xvar("x")                                               # variable containing x-coordinate
                    .yvar("y")                                               # variable containing y-coordinate
                    .width(400)                                              # internal width of chart
                    .height(500)                                             # internal height
                    .margin({left:60, top:40, right:40, bottom:40, inner:5}) # margins
                    .axispos({xtitle:25, ytitle:30, xlabel:5, ylabel:5})     # spacing for axis titles and labels
                    .titlepos(20)                                            # spacing for panel title
                    .xjitter(null)                                           # horizontal jittering
                    .xcategories(null)                                       # ordered categories for X variable
                    .xcatlabels(null)                                        # labels for x-axis categories
                    .ylim(null)                                              # y-axis limits
                    .nyticks(5)                                              # no. y-axis ticks
                    .yticks(null)                                            # locations of y-axis ticks
                    .rectcolor(d3.rgb(230,230,230))                          # background rectangle color
                    .pointcolor("darkslateblue")                             # color for points
                    .pointstroke("black")                                    # stroke color for points
                    .pointsize(3)                                            # radius of points at markers
                    .title("")                                               # panel title
                    .xlab("Group")                                           # x-axis label
                    .ylab("Response")                                        # y-axis label
                    .rotate_ylab(null)                                       # rotate y-axis label
                    .yNA({handle:true, force:false, width:15, gap:10})       # treatment of missing y values
                    .dataByInd(true)                                         # is data organized by individual?
```

Treatment of missing values through `yNA`:

    handle: if true, plot missing values in separated area; if false, omit missing values
    force:  force handle==true (with separate area for missing values) even if there are no missing values
    width:  width of space reserved for missing values
    gap:    gap between space for missing values and the main panel

Treatment of horizontal jittering (move points horizontally to avoid overlap):

    xjitter(null):   (Default) results in random horizontal jittering
    xjitter(0):      No jittering
    xjitter(vector): vector must be numeric with same length as data; these values (in pixels)
                     are used for the jittering

Organization of data:

  If `dataByInd == true` (the default), we expect the data to be like `[[x1,y1], [x2,y2], ..., [xn,yn]]`

  Alternatively, if `dataByInd == false` we expect the data to be like `[[x1,x2, ..., xn], [y1,y2, ..., yn]]`

Additional accessors:

```coffeescript
# x-axis scale
xscale = mychart.xscale()
xscale(x)

# y-axis scale
yscale = mychart.yscale()
yscale(y)

# selection of points at markers, to add .on("click", ...)
pointsSelect = mychart.pointsSelect()
```
