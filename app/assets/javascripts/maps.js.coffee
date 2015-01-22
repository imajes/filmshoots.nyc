$(document).ready ->




setMarkers = (map, locations) ->

  $.get '/', (data) ->
    $('body').append "Successfully got the page."

  i = 0

  while i < locations.length
    beach = locations[i]
    myLatLng = new google.maps.LatLng(beach[1], beach[2])
    marker = new google.maps.Marker(
      position: myLatLng
      map: map
      icon: image
      shape: shape
      title: beach[0]
      zIndex: beach[3]
    )
    i++
  return
