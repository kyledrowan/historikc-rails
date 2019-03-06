// Set body height to full window size, taking into account mobile navigation bars
$(document).ready(function() {
  $('body').css('height', window.innerHeight == null ? $(window).height() : window.innerHeight);
});
$(window).resize(function() {
  $('body').css('height', window.innerHeight == null ? $(window).height() : window.innerHeight);
});

$(document).ready(function() {
  if ($('#map-container').length) {
    var map                 = L.map('map-container', {zoomControl: false}),
        icon                = L.divIcon({className: 'location-icon'}),
        currentLocationIcon = L.divIcon({className: 'user-location-icon'}),
        hash                = new L.Hash(map);

    if (!window.location.hash) {
      map.setView([39.091641, -94.581368], 14);
    }

    L.control.zoom({ position: 'bottomright' }).addTo(map);
    L.control.locate({
      position: 'bottomright',
      drawCircle: false,
      showPopup: false,
      keepCurrentZoomLevel: true,
      drawCircle: true,
      drawMarker: false,
      strings: {
        title: 'Center on Current Location'
      }
    }).addTo(map);

    L.tileLayer('https://api.mapbox.com/styles/v1/historikc/cirimlxvl0002ggm07wdx9kn0/tiles/256/{z}/{x}/{y}?access_token={accessToken}', {
        attribution: '&copy; <a href="http://mapbox.com">Mapbox</a> &copy; <a href="http://openstreetmap.org">OpenStreetMap</a>',
        maxZoom: 20,
        id: 'historikc',
        accessToken: 'pk.eyJ1IjoiaGlzdG9yaWtjIiwiYSI6ImNpcG5hZWd1NjAwMGN0dG5pdnA1NGxmcTEifQ.i5Cs1vhsdiOIuEyr4eU2uQ'
    }).addTo(map);

    map.on('zoomend', function() {
      var currentZoom = map.getZoom();
      $('.location-icon').css('width', currentZoom).css('height', currentZoom);
    });

    $.ajax({
      url: "/locations.json",
      success: function(locations) {
        $.each(locations, function(i, location) {
          marker = L.marker([location.latitude, location.longitude], { icon: icon, riseOnHover: true }).addTo(map);

          marker.on('click', function() {
            document.location = '/locations/' + location.id;
          });
        });
      },
      error: function() {
        alert('Sorry, looks like something went wrong! Try reloading the page.');
      }
    });
  }
});
