$(function(){
  
  $('#map').css('height', window.innerHeight);
	
	$('body').css('height', 500);
	
	$('#dialog').css({width: window.innerWidth - 70, height: window.innerHeight - 70});
  
  window.scroll(0,500);
  $('#im_down').css({bottom: 'none !important', top: window.innerHeight - $('#im_down').height()})
  
  $('.info').css('width', window.innerWidth - 6);
  
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
	},
	dialog = function(text){
	  $('#dialog').text(text).show();
	};
	
	$('#im_down').click(function(){
	  if (navigator.notification){
	    navigator.notification.vibrate();
	  }
	  dialog('this is it.');
	  return false;
	});
	
	done_loading();
	
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
      map.panTo(latlng);
      notify('success', 'okay', 'there are like 4 of you');
		}, function(){
      notify('error', 'you suck', 'either you denied me access to know where you are or there is another problem.')
		});
	} else {
		notify('error', 'no how no way', 'come back with more chrome on.');
	}
});