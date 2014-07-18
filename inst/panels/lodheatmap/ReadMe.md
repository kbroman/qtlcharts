### Reusable panel for heatmap of LOD curves

A reusable chart for making a heat map image of LOD curves,
following
[Mike Bostock](http://bost.ocks.org/mike)'s
[Towards Reuseable Charts](http://bost.ocks.org/mike/chart/).

For an illustration of its use, see [test_lodheatmap.coffee](https://github.com/kbroman/qtlcharts/blob/master/inst/panels/lodheatmap/test/test_lodheatmap.coffee).

Add see it in action
[here](http://kbroman.org/qtlcharts/assets/panels/lodheatmap/test).

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
                      .quantScale(null)                                        # optional vector of numbers, for y-axis scale
                      .lod_labels(null)                                        # optional vector of strings, for LOD column labels
                      .nyticks(5)                                              # no. y-axis ticks if quantitative scale
                      .yticks(null)                                            # positions of y-axis ticks if quantitative scale
```

#### Organization of data

The data is organized as for the [lodchart panel](../lodchart):  a hash with a number of components:

- `"chrnames`" is an ordered list of chromosome names
- `"lodnames"` is an ordered list of the names of LOD score columns
- `"chr"` is an ordered list of chromosome IDs for the markers/pseudomarkers
  at which LOD scores were calculated (length `n`)
- `"pos"` is an ordered list of numeric positions for the markers/pseudomarkers
  at which LOD scores were calculated (length `n`)
- additional ordered lists, named as in `"lodnames"`, containing LOD
  scores, each also of length `n`.
- `"markernames"` vector of marker names, of length `n`. Pseudomarkers
  should have an empty string (`""`).

Here's an example dataset: [`data.json`](http://kbroman.org/qtlcharts/assets/panels/lodheatmap/test/data.json).


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
