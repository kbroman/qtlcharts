# illustration of use of the chrheatmap function

# Example 1: two autosomal markers
d3.json "data.json", (data) ->
    markers = ["D1M430", "D1M318"]
    mychart = crosstab()

    data2pass = 
            x: data.geno[markers[0]]
            y: data.geno[markers[1]]
            xcat: data.genocat[data.chrtype[markers[0]]]
            ycat: data.genocat[data.chrtype[markers[1]]]
            xlabel: markers[0]
            ylabel: markers[1]

    d3.select("div#chart1")
      .datum(data2pass)
      .call(mychart)

# Example 2: two X-linked markers
d3.json "data.json", (data) ->
    markers = ["DXM64", "DXM66"]
    mychart = crosstab()

    data2pass = 
            x: data.geno[markers[0]]
            y: data.geno[markers[1]]
            xcat: data.genocat[data.chrtype[markers[0]]]
            ycat: data.genocat[data.chrtype[markers[1]]]
            xlabel: markers[0]
            ylabel: markers[1]

    d3.select("div#chart2")
      .datum(data2pass)
      .call(mychart)

# Example 3: an autosomal and an X-linked marker
d3.json "data.json", (data) ->
    markers = ["D1M430", "DXM64"]
    mychart = crosstab()

    data2pass = 
            x: data.geno[markers[0]]
            y: data.geno[markers[1]]
            xcat: data.genocat[data.chrtype[markers[0]]]
            ycat: data.genocat[data.chrtype[markers[1]]]
            xlabel: markers[0]
            ylabel: markers[1]

    d3.select("div#chart3")
      .datum(data2pass)
      .call(mychart)


