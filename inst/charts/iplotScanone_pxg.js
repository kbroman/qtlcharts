// Generated by CoffeeScript 1.8.0
var iplotScanone_pxg;

iplotScanone_pxg = function(lod_data, pxg_data, chartOpts) {
  var chartdivid, chrGap, darkrect, eff_axispos, eff_nyticks, eff_pointcolor, eff_pointcolorhilit, eff_pointsize, eff_pointstroke, eff_rotate_ylab, eff_titlepos, eff_xlab, eff_yNA, eff_ylab, eff_ylim, eff_yticks, g_lod, height, lightrect, lod_axispos, lod_linecolor, lod_linewidth, lod_nyticks, lod_pointcolor, lod_pointsize, lod_pointstroke, lod_rotate_ylab, lod_title, lod_titlepos, lod_xlab, lod_ylab, lod_ylim, lod_yticks, margin, markers, mylodchart, plotPXG, svg, totalh, totalw, wleft, wright, x, xjitter, _ref, _ref1, _ref10, _ref11, _ref12, _ref13, _ref14, _ref15, _ref16, _ref17, _ref18, _ref19, _ref2, _ref20, _ref21, _ref22, _ref23, _ref24, _ref25, _ref26, _ref27, _ref28, _ref29, _ref3, _ref30, _ref31, _ref32, _ref33, _ref34, _ref35, _ref36, _ref37, _ref38, _ref39, _ref4, _ref40, _ref41, _ref42, _ref43, _ref44, _ref5, _ref6, _ref7, _ref8, _ref9;
  markers = (function() {
    var _results;
    _results = [];
    for (x in pxg_data.chrByMarkers) {
      _results.push(x);
    }
    return _results;
  })();
  height = (_ref = chartOpts != null ? chartOpts.height : void 0) != null ? _ref : 450;
  wleft = (_ref1 = chartOpts != null ? chartOpts.wleft : void 0) != null ? _ref1 : 700;
  wright = (_ref2 = chartOpts != null ? chartOpts.wright : void 0) != null ? _ref2 : 300;
  margin = (_ref3 = chartOpts != null ? chartOpts.margin : void 0) != null ? _ref3 : {
    left: 60,
    top: 40,
    right: 40,
    bottom: 40,
    inner: 5
  };
  lod_axispos = (_ref4 = (_ref5 = chartOpts != null ? chartOpts.lod_axispos : void 0) != null ? _ref5 : chartOpts != null ? chartOpts.axispos : void 0) != null ? _ref4 : {
    xtitle: 25,
    ytitle: 30,
    xlabel: 5,
    ylabel: 5
  };
  lod_titlepos = (_ref6 = (_ref7 = chartOpts != null ? chartOpts.lod_titlepos : void 0) != null ? _ref7 : chartOpts != null ? chartOpts.titlepos : void 0) != null ? _ref6 : 20;
  chrGap = (_ref8 = chartOpts != null ? chartOpts.chrGap : void 0) != null ? _ref8 : 8;
  darkrect = (_ref9 = chartOpts != null ? chartOpts.darkrect : void 0) != null ? _ref9 : "#C8C8C8";
  lightrect = (_ref10 = chartOpts != null ? chartOpts.lightrect : void 0) != null ? _ref10 : "#E6E6E6";
  lod_ylim = (_ref11 = chartOpts != null ? chartOpts.lod_ylim : void 0) != null ? _ref11 : null;
  lod_nyticks = (_ref12 = chartOpts != null ? chartOpts.lod_nyticks : void 0) != null ? _ref12 : 5;
  lod_yticks = (_ref13 = chartOpts != null ? chartOpts.lod_yticks : void 0) != null ? _ref13 : null;
  lod_linecolor = (_ref14 = chartOpts != null ? chartOpts.lod_linecolor : void 0) != null ? _ref14 : "darkslateblue";
  lod_linewidth = (_ref15 = chartOpts != null ? chartOpts.lod_linewidth : void 0) != null ? _ref15 : 2;
  lod_pointcolor = (_ref16 = chartOpts != null ? chartOpts.lod_pointcolor : void 0) != null ? _ref16 : "#E9CFEC";
  lod_pointsize = (_ref17 = chartOpts != null ? chartOpts.lod_pointsize : void 0) != null ? _ref17 : 0;
  lod_pointstroke = (_ref18 = chartOpts != null ? chartOpts.lod_pointstroke : void 0) != null ? _ref18 : "black";
  lod_title = (_ref19 = chartOpts != null ? chartOpts.lod_title : void 0) != null ? _ref19 : "";
  lod_xlab = (_ref20 = chartOpts != null ? chartOpts.lod_xlab : void 0) != null ? _ref20 : "Chromosome";
  lod_ylab = (_ref21 = chartOpts != null ? chartOpts.lod_ylab : void 0) != null ? _ref21 : "LOD score";
  lod_rotate_ylab = (_ref22 = chartOpts != null ? chartOpts.lod_rotate_ylab : void 0) != null ? _ref22 : null;
  eff_pointcolor = (_ref23 = (_ref24 = chartOpts != null ? chartOpts.eff_pointcolor : void 0) != null ? _ref24 : chartOpts != null ? chartOpts.pointcolor : void 0) != null ? _ref23 : "slateblue";
  eff_pointcolorhilit = (_ref25 = (_ref26 = chartOpts != null ? chartOpts.eff_pointcolorhilit : void 0) != null ? _ref26 : chartOpts != null ? chartOpts.pointcolorhilit : void 0) != null ? _ref25 : "Orchid";
  eff_pointstroke = (_ref27 = (_ref28 = chartOpts != null ? chartOpts.eff_pointstroke : void 0) != null ? _ref28 : chartOpts != null ? chartOpts.pointstroke : void 0) != null ? _ref27 : "black";
  eff_pointsize = (_ref29 = (_ref30 = chartOpts != null ? chartOpts.eff_pointsize : void 0) != null ? _ref30 : chartOpts != null ? chartOpts.pointsize : void 0) != null ? _ref29 : 3;
  eff_ylim = (_ref31 = chartOpts != null ? chartOpts.eff_ylim : void 0) != null ? _ref31 : null;
  eff_nyticks = (_ref32 = chartOpts != null ? chartOpts.eff_nyticks : void 0) != null ? _ref32 : 5;
  eff_yticks = (_ref33 = chartOpts != null ? chartOpts.eff_yticks : void 0) != null ? _ref33 : null;
  eff_xlab = (_ref34 = chartOpts != null ? chartOpts.eff_xlab : void 0) != null ? _ref34 : "Genotype";
  eff_ylab = (_ref35 = chartOpts != null ? chartOpts.eff_ylab : void 0) != null ? _ref35 : "Phenotype";
  eff_rotate_ylab = (_ref36 = chartOpts != null ? chartOpts.eff_rotate_ylab : void 0) != null ? _ref36 : null;
  xjitter = (_ref37 = (_ref38 = chartOpts != null ? chartOpts.xjitter : void 0) != null ? _ref38 : chartOpts != null ? chartOpts.eff_xjitter : void 0) != null ? _ref37 : null;
  eff_axispos = (_ref39 = (_ref40 = chartOpts != null ? chartOpts.eff_axispos : void 0) != null ? _ref40 : chartOpts != null ? chartOpts.axispos : void 0) != null ? _ref39 : {
    xtitle: 25,
    ytitle: 30,
    xlabel: 5,
    ylabel: 5
  };
  eff_titlepos = (_ref41 = (_ref42 = chartOpts != null ? chartOpts.eff_titlepos : void 0) != null ? _ref42 : chartOpts != null ? chartOpts.titlepos : void 0) != null ? _ref41 : 20;
  eff_yNA = (_ref43 = chartOpts != null ? chartOpts.eff_yNA : void 0) != null ? _ref43 : {
    handle: true,
    force: false,
    width: 15,
    gap: 10
  };
  chartdivid = (_ref44 = chartOpts != null ? chartOpts.chartdivid : void 0) != null ? _ref44 : 'chart';
  totalh = height + margin.top + margin.bottom;
  totalw = wleft + wright + (margin.left + margin.right) * 2;
  mylodchart = lodchart().lodvarname("lod").height(height).width(wleft).margin(margin).axispos(lod_axispos).titlepos(lod_titlepos).chrGap(chrGap).darkrect(darkrect).lightrect(lightrect).ylim(lod_ylim).nyticks(lod_nyticks).yticks(lod_yticks).linecolor(lod_linecolor).linewidth(lod_linewidth).pointcolor(lod_pointcolor).pointsize(lod_pointsize).pointstroke(lod_pointstroke).title(lod_title).xlab(lod_xlab).ylab(lod_ylab).rotate_ylab(lod_rotate_ylab);
  svg = d3.select("div#" + chartdivid).append("svg").attr("height", totalh).attr("width", totalw);
  g_lod = svg.append("g").attr("id", "lodchart").datum(lod_data).call(mylodchart);
  plotPXG = function(markername, markerindex) {
    var chr, chrtype, g, gabs, genonames, inferred, mypxgchart, _i, _ref45, _results;
    svg.select("g#pxgchart").remove();
    g = pxg_data.geno[markerindex];
    gabs = (function() {
      var _i, _len, _results;
      _results = [];
      for (_i = 0, _len = g.length; _i < _len; _i++) {
        x = g[_i];
        _results.push(Math.abs(x));
      }
      return _results;
    })();
    inferred = (function() {
      var _i, _len, _results;
      _results = [];
      for (_i = 0, _len = g.length; _i < _len; _i++) {
        x = g[_i];
        _results.push(x < 0);
      }
      return _results;
    })();
    chr = pxg_data.chrByMarkers[markername];
    chrtype = pxg_data.chrtype[chr];
    genonames = pxg_data.genonames[chrtype];
    mypxgchart = dotchart().height(height).width(wright).margin(margin).xcategories((function() {
      _results = [];
      for (var _i = 1, _ref45 = genonames.length; 1 <= _ref45 ? _i <= _ref45 : _i >= _ref45; 1 <= _ref45 ? _i++ : _i--){ _results.push(_i); }
      return _results;
    }).apply(this)).xcatlabels(genonames).dataByInd(false).title(markername).xvar('geno').yvar('pheno').axispos(eff_axispos).titlepos(eff_titlepos).xlab(eff_xlab).ylab(eff_ylab).rotate_ylab(eff_rotate_ylab).ylim(eff_ylim).nyticks(eff_nyticks).yticks(eff_yticks).pointcolor(eff_pointcolor).pointstroke(eff_pointstroke).pointsize(eff_pointsize).rectcolor(lightrect).xjitter(xjitter).yNA(eff_yNA);
    svg.append("g").attr("id", "pxgchart").attr("transform", "translate(" + (wleft + margin.left + margin.right) + ",0)").datum({
      'geno': gabs,
      'pheno': pxg_data.pheno,
      'indID': pxg_data.indID
    }).call(mypxgchart);
    return mypxgchart.pointsSelect().attr("fill", function(d, i) {
      if (inferred[i]) {
        return eff_pointcolorhilit;
      }
      return eff_pointcolor;
    });
  };
  return mylodchart.markerSelect().on("click", function(d, i) {
    return plotPXG(markers[i], i);
  });
};
