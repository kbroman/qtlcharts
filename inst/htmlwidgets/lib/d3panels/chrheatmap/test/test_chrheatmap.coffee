# illustration of use of the chrheatmap function

# Example: chr 1 at bottom (default)
d3.json "data.json", (data) ->
    mychart = chrheatmap().pixelPerCell(20).chrGap(4)

    d3.select("div#chart1")
      .datum(data)
      .call(mychart)

# Example: chr 1 at top
d3.json "data.json", (data) ->
    mychart = chrheatmap().pixelPerCell(20).chrGap(4).oneAtTop(true)

    d3.select("div#chart2")
      .datum(data)
      .call(mychart)

