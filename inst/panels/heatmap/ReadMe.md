### Reusable heatmap panel

A reusable chart for making a heat map image,
following
[Mike Bostock](http://bost.ocks.org/mike)'s
[Towards Reuseable Charts](http://bost.ocks.org/mike/chart/).

For an illustration of its use, see [test_heatmap.coffee](https://github.com/kbroman/qtlcharts/blob/master/inst/panels/heatmap/test/test_heatmap.coffee).

Add see it in action
[here](http://kbroman.org/qtlcharts/assets/panels/heatmap/test).

Here are all of the options:

```coffeescript
mychart = heatmap().width(400)                                              # internal width of chart
                   .height(500)                                             # internal height
                   .margin({left:60, top:40, right:40, bottom:40})          # margins
                   .axispos({xtitle:25, ytitle:30, xlabel:5, ylabel:5})     # spacing for axis titles and labels
                   .titlepos(20)                                            # spacing for panel title
                   .xlim(null)                                              # x-axis limits
                   .nxticks(5)                                              # no. x-axis ticks
                   .xticks(null)                                            # locations of x-axis ticks
                   .ylim(null)                                              # y-axis limits
                   .nyticks(5)                                              # no. y-axis ticks
                   .yticks(null)                                            # locations of y-axis ticks
                   .rectcolor(d3.rgb(230,230,230))                          # background rectangle color
                   .colors(["slateblue", "white", "crimson"]                # colors
                   .zlim(null)                                              # z-axis limits
                   .title("")                                               # panel title
                   .xlab("X")                                               # x-axis label
                   .ylab("Y")                                               # y-axis label
                   .rotate_ylab(null)                                       # rotate y-axis label
                   .zthresh(null)                                           # plot cells with z >= zthresh or <= -zthresh
                   .dataByCell(false)                                       # is data organized by cell?
```

#### Organization of data

  If `dataByCell == true`, we expect the data to be like `[{x:x, y:y, z:z}]

  Alternatively, if `dataByCell == false` we expect the data to be
  like `{x:[x1, ..., xn], y:[y1, ..., ym], z:[[z11, ..., z1n], ...,
  [zm1, ..., zmn]]}

  Here's an example dataset: [`data.json`](http://kbroman.org/qtlcharts/assets/panels/heatmap/test/data.json).


#### Additional accessors

```coffeescript
# x-axis scale
xscale = mychart.xscale()
xscale(x)

# y-axis scale
yscale = mychart.yscale()
yscale(y)

# z-axis scale
zscale = mychart.zscale()
zscale(z)

# selection of cells within image, to add .on("click", ...)
cellSelect = mychart.cellSelect()
```
