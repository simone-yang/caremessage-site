$(function () {
  if ($("body#careers").length == 0) {
    return;
  }

  var getHash = function ($anchor) {
    var hash = $anchor.prop('hash');
    if (typeof hash != 'string') {
      hash = '#' + $anchor.prop('href').split('#').pop();
    }
    return hash;
  };

  // Change hash for page-reload
  $('a.position-nav').on('click', function (e) {
    var $target = $(e.target).closest('a');
    var hash = getHash($target);
    if(hash && hash != '#') {
      window.location.hash = hash;
    }
  });

  // Javascript to enable link to tab
  var url = window.location.toString();
  if (url.indexOf('#') > -1) {
    var element = $('a[href=#'+url.split('#')[1]+']');
    element.one('shown.bs.tab', function () {
      $('html, body').scrollTop($("#careers-container").offset().top);
    }).tab('show');
  }
});