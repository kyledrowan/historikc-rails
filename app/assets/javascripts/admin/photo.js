$('.settings-checkbox input[type=checkbox]').on('change', function(event) {
  $('.settings-checkbox input[type=checkbox]').prop('disabled', true);

  var params = [];
  locationMappedValues = $.map(
    $('.settings-checkbox input[type=checkbox][name=location_mapped]'),
    function(element) {
      if (element.checked) {
        return element.value;
      }
    }
  );
  activeValues = $.map(
    $('.settings-checkbox input[type=checkbox][name=active]'),
    function(element) {
      if (element.checked) {
        return element.value;
      }
    }
  );

  url = 'photos';
  if (locationMappedValues.length === 1) {
    params.push('location_mapped=' + locationMappedValues[0]);
  }
  if (activeValues.length === 1) {
    params.push('active=' + activeValues[0]);
  }
  if (params.length > 0) {
    url = url + '?' + params.join('&');
  }
  window.location.replace(url);
});
