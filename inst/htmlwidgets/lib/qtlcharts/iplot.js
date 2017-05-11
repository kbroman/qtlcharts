// Generated by CoffeeScript 1.12.5
var iplot;

iplot = function(widgetdiv, data, chartOpts) {
  var axispos, chartdivid, height, margin, mychart, nxticks, nyticks, pointcolor, pointsize, pointstroke, rectcolor, ref, ref1, ref10, ref11, ref12, ref13, ref14, ref15, ref16, ref17, ref18, ref19, ref2, ref20, ref21, ref3, ref4, ref5, ref6, ref7, ref8, ref9, rotate_ylab, title, titlepos, widgetdivid, width, xNA, xlab, xlim, xticks, yNA, ylab, ylim, yticks;
  height = (ref = chartOpts != null ? chartOpts.height : void 0) != null ? ref : 500;
  width = (ref1 = chartOpts != null ? chartOpts.width : void 0) != null ? ref1 : 800;
  title = (ref2 = chartOpts != null ? chartOpts.title : void 0) != null ? ref2 : "";
  margin = (ref3 = chartOpts != null ? chartOpts.margin : void 0) != null ? ref3 : {
    left: 60,
    top: 40,
    right: 40,
    bottom: 40,
    inner: 5
  };
  axispos = (ref4 = chartOpts != null ? chartOpts.axispos : void 0) != null ? ref4 : {
    xtitle: 25,
    ytitle: 30,
    xlabel: 5,
    ylabel: 5
  };
  titlepos = (ref5 = chartOpts != null ? chartOpts.titlepos : void 0) != null ? ref5 : 20;
  xlab = (ref6 = chartOpts != null ? chartOpts.xlab : void 0) != null ? ref6 : "X";
  ylab = (ref7 = chartOpts != null ? chartOpts.ylab : void 0) != null ? ref7 : "Y";
  xlim = (ref8 = chartOpts != null ? chartOpts.xlim : void 0) != null ? ref8 : null;
  xticks = (ref9 = chartOpts != null ? chartOpts.xticks : void 0) != null ? ref9 : null;
  nxticks = (ref10 = chartOpts != null ? chartOpts.nxticks : void 0) != null ? ref10 : 5;
  ylim = (ref11 = chartOpts != null ? chartOpts.ylim : void 0) != null ? ref11 : null;
  yticks = (ref12 = chartOpts != null ? chartOpts.yticks : void 0) != null ? ref12 : null;
  nyticks = (ref13 = chartOpts != null ? chartOpts.nyticks : void 0) != null ? ref13 : 5;
  rectcolor = (ref14 = chartOpts != null ? chartOpts.rectcolor : void 0) != null ? ref14 : "#E6E6E6";
  pointcolor = (ref15 = chartOpts != null ? chartOpts.pointcolor : void 0) != null ? ref15 : null;
  pointsize = (ref16 = chartOpts != null ? chartOpts.pointsize : void 0) != null ? ref16 : 3;
  pointstroke = (ref17 = chartOpts != null ? chartOpts.pointstroke : void 0) != null ? ref17 : "black";
  rotate_ylab = (ref18 = chartOpts != null ? chartOpts.rotate_ylab : void 0) != null ? ref18 : null;
  xNA = (ref19 = chartOpts != null ? chartOpts.xNA : void 0) != null ? ref19 : {
    handle: true,
    force: false,
    width: 15,
    gap: 10
  };
  yNA = (ref20 = chartOpts != null ? chartOpts.yNA : void 0) != null ? ref20 : {
    handle: true,
    force: false,
    width: 15,
    gap: 10
  };
  chartdivid = (ref21 = chartOpts != null ? chartOpts.chartdivid : void 0) != null ? ref21 : 'chart';
  widgetdivid = d3.select(widgetdiv).attr('id');
  mychart = d3panels.scatterplot({
    height: height,
    width: width,
    margin: margin,
    axispos: axispos,
    titlepos: titlepos,
    xlab: xlab,
    ylab: ylab,
    title: title,
    ylim: ylim,
    xlim: xlim,
    xticks: xticks,
    nxticks: nxticks,
    yticks: yticks,
    nyticks: nyticks,
    rectcolor: rectcolor,
    pointcolor: pointcolor,
    pointsize: pointsize,
    pointstroke: pointstroke,
    rotate_ylab: rotate_ylab,
    xNA: {
      handle: xNA.handle,
      force: xNA.force
    },
    xNA_size: {
      width: xNA.width,
      gap: xNA.gap
    },
    yNA: {
      handle: yNA.handle,
      force: yNA.force
    },
    yNA_size: {
      width: yNA.width,
      gap: yNA.gap
    },
    tipclass: widgetdivid
  });
  mychart(d3.select(widgetdiv).select("svg"), data);
  return mychart.points().on("mouseover", function(d) {
    return d3.select(this).attr("r", pointsize * 2).raise();
  }).on("mouseout", function(d) {
    return d3.select(this).attr("r", pointsize);
  });
};
