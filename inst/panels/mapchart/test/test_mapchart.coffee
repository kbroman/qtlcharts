# illustration of use of the mapchart function

d3.json "data.json", (data) ->
    mychart = mapchart()

    d3.select("div#chart")
      .datum(data)
      .call(mychart)
