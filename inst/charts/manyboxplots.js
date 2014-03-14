// Generated by CoffeeScript 1.6.3
var manyboxplots;

manyboxplots = function(data, chartOpts) {
  var Baxis, BaxisData, Laxis, LaxisData, botylim, br2, clickStatus, colindex, curves, d, fix4hist, grp4BkgdHist, height, hi, hist, histColors, histline, i, indRect, indRectGrp, indindex, j, lo, longRect, longRectGrp, lowBaxis, lowBaxisData, lowsvg, lowxScale, lowyScale, margin, midQuant, nQuant, qucolors, quline, randomInd, recWidth, rectcolor, rightAxis, svg, tmp, topylim, width, x, xScale, xlab, yScale, ylab, _i, _j, _k, _l, _len, _len1, _len2, _len3, _len4, _len5, _m, _n, _o, _ref, _ref1, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7, _ref8, _ref9;
  width = (_ref = chartOpts != null ? chartOpts.width : void 0) != null ? _ref : 1000;
  height = (_ref1 = chartOpts != null ? chartOpts.height : void 0) != null ? _ref1 : 450;
  margin = (_ref2 = chartOpts != null ? chartOpts.margin : void 0) != null ? _ref2 : {
    left: 60,
    top: 20,
    right: 60,
    bottom: 40
  };
  ylab = (_ref3 = chartOpts != null ? chartOpts.ylab : void 0) != null ? _ref3 : "Response";
  xlab = (_ref4 = chartOpts != null ? chartOpts.xlab : void 0) != null ? _ref4 : "Individuals";
  rectcolor = (_ref5 = chartOpts != null ? chartOpts.rectcolor : void 0) != null ? _ref5 : d3.rgb(230, 230, 230);
  topylim = [data.quant[0][0], data.quant[0][1]];
  for (i in data.quant) {
    _ref6 = data.quant[i];
    for (_i = 0, _len = _ref6.length; _i < _len; _i++) {
      x = _ref6[_i];
      if (x < topylim[0]) {
        topylim[0] = x;
      }
      if (x > topylim[1]) {
        topylim[1] = x;
      }
    }
  }
  topylim[0] = Math.floor(topylim[0]);
  topylim[1] = Math.ceil(topylim[1]);
  botylim = [0, data.counts[0][1]];
  for (i in data.counts) {
    _ref7 = data.counts[i];
    for (_j = 0, _len1 = _ref7.length; _j < _len1; _j++) {
      x = _ref7[_j];
      if (x > botylim[1]) {
        botylim[1] = x;
      }
    }
  }
  indindex = d3.range(data.ind.length);
  br2 = [];
  _ref8 = data.breaks;
  for (_k = 0, _len2 = _ref8.length; _k < _len2; _k++) {
    i = _ref8[_k];
    br2.push(i);
    br2.push(i);
  }
  fix4hist = function(d) {
    var _l, _len3;
    x = [0];
    for (_l = 0, _len3 = d.length; _l < _len3; _l++) {
      i = d[_l];
      x.push(i);
      x.push(i);
    }
    x.push(0);
    return x;
  };
  for (i in data.counts) {
    data.counts[i] = fix4hist(data.counts[i]);
  }
  nQuant = data.quant.length;
  midQuant = (nQuant + 1) / 2 - 1;
  xScale = d3.scale.linear().domain([-1, data.ind.length]).range([margin.left, width - margin.right]);
  recWidth = xScale(1) - xScale(0);
  yScale = d3.scale.linear().domain(topylim).range([height - margin.bottom, margin.top]);
  quline = function(j) {
    return d3.svg.line().x(function(d) {
      return xScale(d);
    }).y(function(d) {
      return yScale(data.quant[j][d]);
    });
  };
  svg = d3.select("div#chart").append("svg").attr("width", width).attr("height", height);
  svg.append("rect").attr("x", margin.left).attr("y", margin.top).attr("height", height - margin.top - margin.bottom).attr("width", width - margin.left - margin.right).attr("stroke", "none").attr("fill", rectcolor).attr("pointer-events", "none");
  LaxisData = yScale.ticks(6);
  Laxis = svg.append("g").attr("id", "Laxis");
  Laxis.append("g").selectAll("empty").data(LaxisData).enter().append("line").attr("class", "line").attr("class", "axis").attr("x1", margin.left).attr("x2", width - margin.right).attr("y1", function(d) {
    return yScale(d);
  }).attr("y2", function(d) {
    return yScale(d);
  }).attr("stroke", "white").attr("pointer-events", "none");
  Laxis.append("g").selectAll("empty").data(LaxisData).enter().append("text").attr("class", "axis").text(function(d) {
    return formatAxis(LaxisData)(d);
  }).attr("x", margin.left * 0.9).attr("y", function(d) {
    return yScale(d);
  }).attr("dominant-baseline", "middle").attr("text-anchor", "end");
  BaxisData = xScale.ticks(10);
  Baxis = svg.append("g").attr("id", "Baxis");
  Baxis.append("g").selectAll("empty").data(BaxisData).enter().append("line").attr("class", "line").attr("class", "axis").attr("y1", margin.top).attr("y2", height - margin.bottom).attr("x1", function(d) {
    return xScale(d - 1);
  }).attr("x2", function(d) {
    return xScale(d - 1);
  }).attr("stroke", "white").attr("pointer-events", "none");
  Baxis.append("g").selectAll("empty").data(BaxisData).enter().append("text").attr("class", "axis").text(function(d) {
    return d;
  }).attr("y", height - margin.bottom * 0.75).attr("x", function(d) {
    return xScale(d - 1);
  }).attr("dominant-baseline", "middle").attr("text-anchor", "middle");
  colindex = d3.range((nQuant - 1) / 2);
  tmp = d3.scale.category10().domain(colindex);
  qucolors = [];
  for (_l = 0, _len3 = colindex.length; _l < _len3; _l++) {
    j = colindex[_l];
    qucolors.push(tmp(j));
  }
  qucolors.push("black");
  _ref9 = colindex.reverse();
  for (_m = 0, _len4 = _ref9.length; _m < _len4; _m++) {
    j = _ref9[_m];
    qucolors.push(tmp(j));
  }
  curves = svg.append("g").attr("id", "curves");
  for (j = _n = 0; 0 <= nQuant ? _n < nQuant : _n > nQuant; j = 0 <= nQuant ? ++_n : --_n) {
    curves.append("path").datum(indindex).attr("d", quline(j)).attr("class", "line").attr("stroke", qucolors[j]).attr("pointer-events", "none");
  }
  indRectGrp = svg.append("g").attr("id", "indRect");
  indRect = indRectGrp.selectAll("empty").data(indindex).enter().append("rect").attr("x", function(d) {
    return xScale(d) - recWidth / 2;
  }).attr("y", function(d) {
    return yScale(data.quant[nQuant - 1][d]);
  }).attr("id", function(d) {
    return "rect" + data.ind[d];
  }).attr("width", recWidth).attr("height", function(d) {
    return yScale(data.quant[0][d]) - yScale(data.quant[nQuant - 1][d]);
  }).attr("fill", "purple").attr("stroke", "none").attr("opacity", "0").attr("pointer-events", "none");
  longRectGrp = svg.append("g").attr("id", "longRect");
  longRect = indRectGrp.selectAll("empty").data(indindex).enter().append("rect").attr("x", function(d) {
    return xScale(d) - recWidth / 2;
  }).attr("y", margin.top).attr("width", recWidth).attr("height", height - margin.top - margin.bottom).attr("fill", "purple").attr("stroke", "none").attr("opacity", "0");
  rightAxis = svg.append("g").attr("id", "rightAxis");
  rightAxis.selectAll("empty").data(data.qu).enter().append("text").attr("class", "qu").text(function(d) {
    return "" + (d * 100) + "%";
  }).attr("x", width).attr("y", function(d, i) {
    return yScale(((i + 0.5) / nQuant / 2 + 0.25) * (topylim[1] - topylim[0]) + topylim[0]);
  }).attr("fill", function(d, i) {
    return qucolors[i];
  }).attr("text-anchor", "end").attr("dominant-baseline", "middle");
  svg.append("rect").attr("x", margin.left).attr("y", margin.top).attr("height", height - margin.top - margin.bottom).attr("width", width - margin.left - margin.right).attr("stroke", "black").attr("stroke-width", 2).attr("fill", "none");
  lowsvg = d3.select("div#chart").append("svg").attr("height", height).attr("width", width);
  lo = data.breaks[0] - (data.breaks[1] - data.breaks[0]);
  hi = data.breaks[data.breaks.length - 1] + (data.breaks[1] - data.breaks[0]);
  lowxScale = d3.scale.linear().domain([lo, hi]).range([margin.left, width - margin.right]);
  lowyScale = d3.scale.linear().domain([0, botylim[1] + 1]).range([height - margin.bottom, margin.top]);
  lowsvg.append("rect").attr("x", margin.left).attr("y", margin.top).attr("height", height - margin.top - margin.bottom).attr("width", width - margin.left - margin.right).attr("stroke", "none").attr("fill", rectcolor);
  lowBaxisData = lowxScale.ticks(8);
  lowBaxis = lowsvg.append("g").attr("id", "lowBaxis");
  lowBaxis.append("g").selectAll("empty").data(lowBaxisData).enter().append("line").attr("class", "line").attr("class", "axis").attr("y1", margin.top).attr("y2", height - margin.bottom).attr("x1", function(d) {
    return lowxScale(d);
  }).attr("x2", function(d) {
    return lowxScale(d);
  }).attr("stroke", "white");
  lowBaxis.append("g").selectAll("empty").data(lowBaxisData).enter().append("text").attr("class", "axis").text(function(d) {
    return formatAxis(lowBaxisData)(d);
  }).attr("y", height - margin.bottom * 0.75).attr("x", function(d) {
    return lowxScale(d);
  }).attr("dominant-baseline", "middle").attr("text-anchor", "middle");
  grp4BkgdHist = lowsvg.append("g").attr("id", "bkgdHist");
  histline = d3.svg.line().x(function(d, i) {
    return lowxScale(br2[i]);
  }).y(function(d) {
    return lowyScale(d);
  });
  randomInd = indindex[Math.floor(Math.random() * data.ind.length)];
  hist = lowsvg.append("path").datum(data.counts[randomInd]).attr("d", histline).attr("id", "histline").attr("fill", "none").attr("stroke", "purple").attr("stroke-width", "2");
  histColors = ["blue", "red", "green", "MediumVioletRed", "black"];
  lowsvg.append("text").datum(randomInd).attr("x", margin.left * 1.1).attr("y", margin.top * 2).text(function(d) {
    return data.ind[d];
  }).attr("id", "histtitle").attr("text-anchor", "start").attr("dominant-baseline", "middle").attr("fill", "blue");
  clickStatus = [];
  for (_o = 0, _len5 = indindex.length; _o < _len5; _o++) {
    d = indindex[_o];
    clickStatus.push(0);
  }
  longRect.on("mouseover", function(d) {
    d3.select("rect#rect" + data.ind[d]).attr("opacity", "1");
    d3.select("#histline").datum(data.counts[d]).attr("d", histline);
    return d3.select("#histtitle").datum(d).text(function(d) {
      return data.ind[d];
    });
  }).on("mouseout", function(d) {
    if (!clickStatus[d]) {
      return d3.select("rect#rect" + data.ind[d]).attr("opacity", "0");
    }
  }).on("click", function(d) {
    var curcolor;
    clickStatus[d] = 1 - clickStatus[d];
    d3.select("rect#rect" + data.ind[d]).attr("opacity", clickStatus[d]);
    if (clickStatus[d]) {
      curcolor = histColors.shift();
      histColors.push(curcolor);
      d3.select("rect#rect" + data.ind[d]).attr("fill", curcolor);
      return grp4BkgdHist.append("path").datum(data.counts[d]).attr("d", histline).attr("id", "path" + data.ind[d]).attr("fill", "none").attr("stroke", curcolor).attr("stroke-width", "2");
    } else {
      return d3.select("path#path" + data.ind[d]).remove();
    }
  });
  lowsvg.append("rect").attr("x", margin.left).attr("y", margin.top).attr("height", height - margin.bottom - margin.top).attr("width", width - margin.left - margin.right).attr("stroke", "black").attr("stroke-width", 2).attr("fill", "none");
  svg.append("text").text(ylab).attr("x", margin.left * 0.2).attr("y", height / 2).attr("fill", "blue").attr("transform", "rotate(270 " + (margin.left * 0.2) + " " + (height / 2) + ")").attr("dominant-baseline", "middle").attr("text-anchor", "middle");
  lowsvg.append("text").text(ylab).attr("x", (width - margin.left - margin.bottom) / 2 + margin.left).attr("y", height - margin.bottom * 0.2).attr("fill", "blue").attr("dominant-baseline", "middle").attr("text-anchor", "middle");
  return svg.append("text").text(xlab).attr("x", (width - margin.left - margin.bottom) / 2 + margin.left).attr("y", height - margin.bottom * 0.2).attr("fill", "blue").attr("dominant-baseline", "middle").attr("text-anchor", "middle");
};
