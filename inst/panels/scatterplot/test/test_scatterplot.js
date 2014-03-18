// Generated by CoffeeScript 1.7.1
(function() {
  var h, halfh, halfw, margin, totalh, totalw, w;

  h = 300;

  w = 400;

  margin = {
    left: 60,
    top: 40,
    right: 40,
    bottom: 40,
    inner: 5
  };

  halfh = h + margin.top + margin.bottom;

  totalh = halfh * 2;

  halfw = w + margin.left + margin.right;

  totalw = halfw * 2;

  d3.json("data.json", function(data) {
    var mychart;
    mychart = scatterplot().xvar(0).yvar(1).xlab("X1").ylab("X2").height(h).width(w).margin(margin);
    d3.select("div#chart1").datum({
      data: data
    }).call(mychart);
    return mychart.pointsSelect().on("mouseover", function(d) {
      return d3.select(this).attr("r", mychart.pointsize() * 3);
    }).on("mouseout", function(d) {
      return d3.select(this).attr("r", mychart.pointsize());
    });
  });

  d3.json("data.json", function(data) {
    var brush, brushend, brushmove, brushstart, chart, i, mychart, svg, xscale, xshift, xvar, yscale, yshift, yvar, _i, _j, _results;
    xvar = [1, 2, 2];
    yvar = [0, 0, 1];
    xshift = [0, halfw, halfw];
    yshift = [0, 0, halfh];
    svg = d3.select("div#chart2").append("svg").attr("height", totalh).attr("width", totalw);
    mychart = [];
    chart = [];
    for (i = _i = 0; _i <= 2; i = ++_i) {
      mychart[i] = scatterplot().xvar(xvar[i]).yvar(yvar[i]).nxticks(6).height(h).width(w).margin(margin).pointsize(4).xlab("X" + (xvar[i] + 1)).ylab("X" + (yvar[i] + 1)).title("X" + (yvar[i] + 1) + " vs. X" + (xvar[i] + 1));
      chart[i] = svg.append("g").attr("id", "chart" + i).attr("transform", "translate(" + xshift[i] + "," + yshift[i] + ")");
      chart[i].datum({
        data: data
      }).call(mychart[i]);
    }
    brush = [];
    brushstart = function(i) {
      return function() {
        var j, _j;
        for (j = _j = 0; _j <= 2; j = ++_j) {
          if (j !== i) {
            chart[j].call(brush[j].clear());
          }
        }
        return svg.selectAll("circle").attr("opacity", 0.6).classed("selected", false);
      };
    };
    brushmove = function(i) {
      return function() {
        var e;
        svg.selectAll("circle").classed("selected", false);
        e = brush[i].extent();
        return chart[i].selectAll("circle").classed("selected", function(d, j) {
          var circ, cx, cy, selected;
          circ = d3.select(this);
          cx = circ.attr("cx");
          cy = circ.attr("cy");
          selected = e[0][0] <= cx && cx <= e[1][0] && e[0][1] <= cy && cy <= e[1][1];
          if (selected) {
            svg.selectAll("circle.pt" + j).classed("selected", true);
          }
          return selected;
        });
      };
    };
    brushend = function() {
      return svg.selectAll("circle").attr("opacity", 1);
    };
    xscale = d3.scale.linear().domain([margin.left, margin.left + w]).range([margin.left, margin.left + w]);
    yscale = d3.scale.linear().domain([margin.top, margin.top + h]).range([margin.top, margin.top + h]);
    _results = [];
    for (i = _j = 0; _j <= 2; i = ++_j) {
      brush[i] = d3.svg.brush().x(xscale).y(yscale).on("brushstart", brushstart(i)).on("brush", brushmove(i)).on("brushend", brushend);
      _results.push(chart[i].call(brush[i]));
    }
    return _results;
  });

  d3.json("data.json", function(data) {
    var chart01, chart02, chart12, mychart01, mychart02, mychart12, svg;
    mychart01 = scatterplot().xvar(1).yvar(0).height(h).width(w).margin(margin).xlab("X2").ylab("X1").xNA({
      handle: true,
      force: true,
      width: 15,
      gap: 10
    }).yNA({
      handle: true,
      force: true,
      width: 15,
      gap: 10
    }).title("X1 vs X2");
    mychart02 = scatterplot().xvar(2).yvar(0).height(h).width(w).margin(margin).xlab("X3").ylab("X1").yNA({
      handle: true,
      force: true,
      width: 15,
      gap: 10
    }).title("X1 vs X3");
    mychart12 = scatterplot().xvar(2).yvar(1).height(h).width(w).margin(margin).xlab("X3").ylab("X2").xNA({
      handle: false,
      force: false,
      width: 15,
      gap: 10
    }).title("X2 vs X3");
    svg = d3.select("div#chart3").append("svg").attr("height", totalh).attr("width", totalw);
    chart01 = svg.append("g").attr("id", "chart01");
    chart02 = svg.append("g").attr("id", "chart02").attr("transform", "translate(" + halfw + ", 0)");
    chart12 = svg.append("g").attr("id", "chart12").attr("transform", "translate(" + halfw + ", " + halfh + ")");
    chart01.datum({
      data: data
    }).call(mychart01);
    chart02.datum({
      data: data
    }).call(mychart02);
    chart12.datum({
      data: data
    }).call(mychart12);
    return [mychart01, mychart02, mychart12].forEach(function(chart) {
      return chart.pointsSelect().on("mouseover", function(d, i) {
        return svg.selectAll("circle.pt" + i).attr("r", chart.pointsize() * 3);
      }).on("mouseout", function(d, i) {
        return svg.selectAll("circle.pt" + i).attr("r", chart.pointsize());
      });
    });
  });

  d3.json("data.json", function(data) {
    var data2, mychart, x;
    mychart = scatterplot().height(h).width(w).margin(margin).dataByInd(false);
    data2 = [
      (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = data.length; _i < _len; _i++) {
          x = data[_i];
          _results.push(x[0]);
        }
        return _results;
      })(), (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = data.length; _i < _len; _i++) {
          x = data[_i];
          _results.push(x[1]);
        }
        return _results;
      })()
    ];
    d3.select("div#chart4").datum({
      data: data2
    }).call(mychart);
    return mychart.pointsSelect().on("mouseover", function(d) {
      return d3.select(this).attr("r", mychart.pointsize() * 3);
    }).on("mouseout", function(d) {
      return d3.select(this).attr("r", mychart.pointsize());
    });
  });

}).call(this);
