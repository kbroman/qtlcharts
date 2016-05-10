### [d3panels](http://kbroman.org/d3panels): D3-based graphic panels

[Karl W Broman](http://kbroman.org)

This is a set of [D3](http://d3js.org)-based graphic panels, to
be combined into larger multi-panel charts.  They were developed for
the [R/qtlcharts](http://kbroman.org/qtlcharts) package.

There are other libraries with similar goals that are of more general
use (e.g., [C3.js](http://c3js.org) and
[d3.Chart](http://misoproject.com/d3-chart/); see
[this list of javascript chart libraries](http://blog.webkid.io/javascript-chart-libraries/)),
but I wanted charts that were a bit _less_ general and flexible, but
rather more specific to my particular applications (and style).

For snapshots and live tests, see <http://kbroman.org/d3panels>.

#### Documentation

For documentation, see <https://github.com/kbroman/d3panels/doc>.

#### Usage

All of the functions are called as `d3panels.blah()`.  And for each
chart, you first call the chart function with a set of options, like
this:

```coffeescript
mychart = d3panels.lodchart({height:600, width:800})
```

And then you call the function that's created with some selection and
the data:

```coffeescript
mychart(d3.select("div#chart"), mydata)
```

There are three exceptions to this:
[`add_lodcurve`](add_lodcurve.md), [`add_curves`](add_curves.md), and [`add_points`](add_points.md).
For these functions, you first need to call another function that
creates a panel
(for example, [`lodchart`](lodchart.md) or [`chrpanelframe`](chrpanelframe.md) in
the case of [`add_lodcurve`](add_lodcurve.md), or
[`panelframe`](panelframe.md) in the case of
[`add_curves`](add_curves.md) or [`add_points`](add_points.md)).  You
then use the chart function created by
that first call in place of a selection. For example:

```coffeescript
myframe = d3panels.panelframe({xlim:[0,100],ylim:[0,100]})
myframe(d3.select("body"))

addpts = d3panels.add_points()
addpts(myframe, {x:[5,10,25,50,75,90], y:[8,12,50,30,80,90], group:[1,1,1,2,2,3]})
```


#### Links

You'll need to link to the `d3panels.js` and `d3panels.css` files (or
to `d3panels.min.js` and `d3panels.min.css`):

```html
<script type="text/javascript" src="https://rawgit.com/kbroman/d3panels/master/d3panels.js"></script>
<link rel=stylesheet type="text/css" href="https://rawgit.com/kbroman/d3panels/master/d3panels.css">
```

You'll also want to link to [D3.js](https://d3js.org) and
[d3-tip](https://github.com/Caged/d3-tip):

```html
<script charset="utf-8" type="text/javascript" src="https://d3js.org/d3.v3.min.js"></script>
<script type="text/javascript" src="https://rawgit.com/Caged/d3-tip/master/index.js"></script>
```

For a couple of panels (`curvechart` and `scatterplot`) you may need
to link to [colorbrewer.js](https://github.com/mbostock/d3/blob/master/lib/colorbrewer/colorbrewer.js):

```html
<script type="text/javascript" src="https://rawgit.com/mbostock/d3/master/lib/colorbrewer/colorbrewer.js"></script>
```

#### License

Licensed under the
[MIT license](License.md). ([More information here](http://en.wikipedia.org/wiki/MIT_License).)
