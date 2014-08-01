# code for marker search box for iplotMap

# grab selected marker from the search box
selectedMarker = ""
$("#markerinput").submit () ->
    newSelection = document.getElementById("marker").value
    console.log("input: #{newSelection}")
    event.preventDefault()
    if newSelection != "" and newSelection != selectedMarker
        if markernames.indexOf(newSelection) >= 0
            selectedMarker = newSelection
            console.log("selected marker: #{selectedMarker}")
            d3.select("a#currentmarker")
              .text(selectedMarker)
            return true
        else
            d3.select("a#currentmarker")
              .text("Marker \"#{selectedMarker}\" not found")
    return false

# autocomplete
$('input#marker').autocomplete({
    autoFocus: true,
    source: (request, response) ->
        matches = $.map(markernames, (tag) ->
            tag if tag.toUpperCase().indexOf(request.term.toUpperCase()) is 0)
        response(matches)
    ,
    select: (event, ui) ->
        $('input#marker').val(ui.item.label)
        $('input#submit').submit()})

# grayed out "Marker name"
$('input#marker').each(() ->
    $(this)
        .data('default', $(this).val())
        .addClass('inactive')
        .focus(() ->
            $(this).removeClass('inactive')
            $(this).val('') if($(this).val() is $(this).data('default') or $(this).val() is '')
        )
        .blur(() ->
            if($(this).val() is '')
                $(this).addClass('inactive').val($(this).data('default'))
        )
    )
