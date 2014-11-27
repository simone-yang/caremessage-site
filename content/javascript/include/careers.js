$(function () {
  if ($("body#careers").length == 0) {
    return;
  }

  // Change hash for page-reload
  $('a.position-nav').on('click', function (e) {
    var hash = $(this).attr('href').split('#')[1];
    console.log($(this).attr('href'))
    if(hash) {
      window.location.hash = hash;
    }
  });

  // Javascript to enable link to tab
  var url = document.location.toString();
  if (url.match('#')) {
    var element = $('a[href=#'+url.split('#')[1]+']');
    if (element) {
      element.trigger("click");
      $('html, body').animate({
          scrollTop: $("#careers-container").offset().top
      }, 0);
    }
  }
});