$(function () {
  $("a.read-bio").popover();
  $("input, textarea").placeholder();

  var Browser = {
    Version: function() {
      var version = 999; // we assume a sane browser
      if (navigator.appVersion.indexOf("MSIE") != -1)
        // bah, IE again, lets downgrade version number
        version = parseFloat(navigator.appVersion.split("MSIE")[1]);
      return version;
    }
  }

  // Typekit bugs on lower ies
  if(!(Browser.Version() < 9)) {
    try{Typekit.load();}catch(e){}
  }
});

$(function(){
  // Hide Header on on scroll down
  var didScroll;
  var lastScrollTop = 0;
  var delta = 5;
  var navbarHeight = $('header').outerHeight();

  $(window).scroll(function(event){
      didScroll = true;
  });

  setInterval(function() {
      if (didScroll) {
          hasScrolled();
          didScroll = false;
      }
  }, 250);

  function hasScrolled() {
    var st = $(this).scrollTop();
    // Make sure they scroll more than delta
    if(Math.abs(lastScrollTop - st) <= delta)
        return;
    // If they scrolled down and are past the navbar, add class .nav-up.
    // This is necessary so you never see what is "behind" the navbar.
    if (st > lastScrollTop && st > navbarHeight){
        // Scroll Down
         $(".secondary-nav").removeClass("secondary-visible").addClass("secondary-hidden");
    } else {
        // Scroll Up
        if(st + $(window).height() < $(document).height() && $(window).scrollTop()>201) {
             $(".secondary-nav").addClass("secondary-visible").removeClass("secondary-hidden");
        }
    }
    lastScrollTop = st;
  }
});