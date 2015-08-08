var geolocready = function(){
    // console.log("ready func has run");
    
    $("#geolocbtn").on("click", function(event){
        // console.log("button clicked has run");
        event.preventDefault();
        geoFindMe();
    });

    function geoFindMe() {
      var output = document.getElementById("out");
      // console.log("geofindme has run");
      if (!navigator.geolocation){
        output.innerHTML = "<p>Geolocation is not supported by your browser</p>";
        return;
      }

      function success(position) {
        var latitude  = position.coords.latitude;
        var longitude = position.coords.longitude;
        // console.log("success has run");
        
        output.innerHTML = '<p>Latitude is ' + latitude + '° <br>Longitude is ' + longitude + '°</p>';
        
        document.getElementById("user_longitude").value = longitude;
        document.getElementById("user_latitude").value = latitude;

        // var img = new Image();
        // img.src = "https://maps.googleapis.com/maps/api/staticmap?center=" + latitude + "," + longitude + "&zoom=13&size=300x300&sensor=false";

        // output.appendChild(img);
      };

      function error() {
        // console.log("error has run");
        output.innerHTML = "Unable to retrieve your location";
      };

      output.innerHTML = "<p>Locating…</p>";

      navigator.geolocation.getCurrentPosition(success, error);
    }
}

$(document).ready(geolocready);
$(document).on("page:load", geolocready);