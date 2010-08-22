$(function(){
  
  window.scroll(0,500);
  
	var notify = function(field, title, message){
		done_loading();
		$('#'+field).children('h1').html(title).siblings('p').html(message).parent().show();
	},
	loading = function(){
	  $('#loading img').css('margin', (window.innerHeight/2 - 50)+ 'px auto 0' );
	  $('#loading').show();
	},
	done_loading = function(){
		$('#loading').hide();
	};
	
	done_loading();
	
	$('#map').css('height', window.innerHeight / 2);
	
	$('body').css('height', 500);
	
	if (navigator.geolocation) {
	  var latlng = new google.maps.LatLng(42, -71);
	  var myOptions = {
        zoom: 15,
        center: latlng,
        mapTypeControl: false,
        draggable: false,
        navigationControl: false,
        mapTypeId: google.maps.MapTypeId.ROADMAP
      };
    var map = new google.maps.Map(document.getElementById("map"), myOptions);
		
		
		
		loading();
		
		
		navigator.geolocation.getCurrentPosition(function(location){
		  latlng = new google.maps.LatLng(location.coords.latitude, location.coords.longitude);
      var marker = new google.maps.Marker({
              position: latlng, 
              map: map, 
              title:"You are here!"
      });
      done_loading();
      map.panTo({'latLng': latlng});
			notify('success', 'got it.', 'now that you know where you are, you might be down.');
		}, function(){
			notify('error', 'we have a problem, yo.', 'you can try reloading the page or whatevs.');
		});
	} else {
		notify('error', 'no how no way', 'come back with more chrome on.');
	}
});