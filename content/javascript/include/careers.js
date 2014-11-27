$(function () {
  if ($("body#careers").length == 0) {
    return;
  }

  // Change hash for page-reload
  $('a.position-nav').on('click', function (e) {
    if(e.target.hash) {
      window.location.hash = e.target.hash;
    }
  });

  // Javascript to enable link to tab
  var url = document.location.toString();
  if (url.match('#')) {
    var element = $('a[href=#'+url.split('#')[1]+']');
    element.tab('show');
    $('html, body').animate({
        scrollTop: $("#careers-container").offset().top
    }, 0);
  }
});