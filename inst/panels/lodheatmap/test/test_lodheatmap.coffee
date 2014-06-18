# illustration of use of the lodheatmap panel

h = 700
w = 1000

# Example: simplest use
d3.json "data.json", (data) ->
    mychart = lodheatmap().height(h)
                          .width(w)
                          .zthresh(1.0)

    d3.select("div#chart")
      .datum(data)
      .call(mychart)
