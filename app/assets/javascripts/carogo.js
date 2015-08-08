var compready = function(){
    console.log("GOGO BITCH GO");
    // $(".owl-carousel").owlCarousel();
    $("#owl-demo").owlCarousel({
     
          navigation : true, // Show next and prev buttons
          slideSpeed : 300,
          paginationSpeed : 400,
          singleItem:true,
          pagination: false
          // "singleItem:true" is a shortcut for:
          // items : 1, 
          // itemsDesktop : false,
          // itemsDesktopSmall : false,
          // itemsTablet: false,
          // itemsMobile : false
     
      });
    $("#owl-mini-demo").owlCarousel({
     
          autoPlay: 3000, //Set AutoPlay to 3 seconds
     
          items : 4,
          itemsDesktop : [1050,4],
          itemsDesktopSmall : [950,3],
          paginationNumbers: true
     
      });
    // var owl = $("#owl-demo");
    var owl = $(".smitify");
     
      // owl.owlCarousel({
         
      //     itemsCustom : [
      //       [0, 2],
      //       [450, 4],
      //       [600, 7],
      //       [700, 9],
      //       [1000, 10],
      //       [1200, 12],
      //       [1400, 13],
      //       [1600, 15]
      //     ],
      //     navigation : true
     
      // });

      // owl.owlCarousel({
      //   items : 4,
      //   lazyLoad : true,
      //   navigation : true
      // }); 
    
     owl.owlCarousel({
         items : 10, //10 items above 1000px browser width
         itemsDesktop : [1000,5], //5 items between 1000px and 901px
         itemsDesktopSmall : [900,3], // betweem 900px and 601px
         itemsTablet: [600,2], //2 items between 600 and 0
         itemsMobile : false // itemsMobile disabled - inherit from itemsTablet option
     });
    
     // Custom Navigation Events
     $(".next").on("click", function(){
       owl.trigger('owl.next');
       console.log("next");
     })
     $(".prev").on("click", function(){
       owl.trigger('owl.prev');
       console.log("prev");
     })
     $(".play").on("click",function(){
       owl.trigger('owl.play',1000); //owl.play event accept autoPlay speed as second parameter
       console.log("play");
     })
     $(".stop").on("click",function(){
       owl.trigger('owl.stop');
       console.log("stop");
     })

}

$(document).ready(compready);
$(document).on("page:load", compready);