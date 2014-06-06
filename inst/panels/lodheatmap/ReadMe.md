### Reusable panel for heatmap of LOD curves

A reusable chart for making a heat map image of LOD curves,
following
[Mike Bostock](http://bost.ocks.org/mike)'s
[Towards Reuseable Charts](http://bost.ocks.org/mike/chart/).

For an illustration of its use, see [test_lodheatmap.coffee](https://github.com/kbroman/qtlcharts/blob/master/inst/panels/lodheatmap/test/test_lodheatmap.coffee).

Add see it in action
[here](http://kbroman.github.io/qtlcharts/assets/panels/lodheatmap/test).

Here are all of the options:

```coffeescript
mychart = lodheatmap().width(1200)                                             # internal width of chart
                      .height(600)                                             # internal height
                      .margin({left:60, top:40, right:40, bottom:40})          # margins
                      .axispos({xtitle:25, ytitle:30, xlabel:5, ylabel:5})     # spacing for axis titles and labels
                      .titlepos(20)                                            # spacing for panel title
                      .rectcolor(d3.rgb(230,230,230))                          # background rectangle color
                      .colors(["slateblue", "white", "crimson"]                # colors
                      .zlim(null)                                              # z-axis limits
                      .title("")                                               # panel title
                      .xlab("X")                                               # x-axis label
                      .ylab("Y")                                               # y-axis label
                      .rotate_ylab(null)                                       # rotate y-axis label
                      .zthresh(null)                                           # plot cells with z >= zthresh or <= -zthresh
                      .chrGap(5)                                               # gap between chromosomes (in pixels)
```

#### Organization of data *(needs to be explained)*

  Here's an example dataset: [`data.json`](http://kbroman.github.io/qtlcharts/assets/panels/lodheatmap/test/data.json).


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
