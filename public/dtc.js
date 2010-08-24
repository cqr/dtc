(function(){
  
  
  // Dude, it's like jQuery but without all of the stuff that nobody
  // really uses and without all of the browser compatibility and jank.
  // ... Also it is way faster.
  var $  = function(s,c){ return (c||document).querySelector(s); };
  var $i = function(s,c){return (c||document).getElementById(s);};
  var $c = function(s,c){return (c||document).getElementsByClassName(s);};
  var $t = function(s,c){return (c||document).getElementsByTagName(s)};
  Array.prototype.each = function(callback){
    for(var i = 0; i < this.length; i++){
      callback.call(this[i], i, this[i]);
    }
  };
  var removeChildren = function(dom_element){
    while(dom_element.firstChild){dom_element.removeChild(dom_element.firstChild)}
    return dom_element;
  };
  var addText = function(dom_element, text){
    dom_element.appendChild(document.createTextNode(text));
    return dom_element;
  };
  var replaceText = function(dom_element, text){
    return addText(removeChildren(dom_element), text);
  };
  var ajax = function(method, url, parameters, callback){
    var q  = new XMLHttpRequest();
    q.onreadystatechange = function(){
      if (q.readyState == 4){
        callback.call(q, q.responseText, q.status);
      }
    };
    q.open(method, url, true);
    q.setRequestHeader('Content-Type','application/x-www-form-urlencoded'); 
    q.send(parameters);
  }
  
  // and now we get into the stuff that I didn't write as a general purpose library
    
  var notify = function(field, title, message){
		done_loading();
		var field = $i(field), h1 = $t('h1',field)[0], p = $t('p',field)[0];
		replaceText(h1, title);
		replaceText(p, message);
		field.style.display = 'block';
	},
	loading = function(){
	  $i('loading').style.opacity = '1';
	  $('#loading img').style.margin =  (window.innerHeight/2 - 50)+ 'px auto 0';
	  $i('loading').style.display = 'block';
	},
	done_loading = function(){
		$i('loading').style.opacity = '1';
		setTimeout(function(){
		  $i('loading').style.opacity = parseFloat($i('loading').style.opacity) - 0.04;
		  if ($i('loading').style.opacity <= 0){
		    $i('loading').style.opacity = '1';
		    $i('loading').style.display = 'none';
		    return true;
		  }
		  setTimeout(arguments.callee, 33)
		}, 500)
	},
	dialog = function(text){
	  replaceText($i('dialog'), text).style.display = 'block';
	};
  
  window.addEventListener('load',function(){
    var loc = null;
    
    $i('map').style.height = window.innerHeight + 'px';

  	document.body.style.height = '500px';

  	$i('dialog').style.width  = window.innerWidth - 70 + 'px';
  	$i('dialog').style.height = window.innerHeight - 70 + 'px';

    window.scroll(0,500);

    $i('im_down').style.top = window.innerHeight - 47 + 'px';
    $i('im_down').style.width = window.innerWidth - 8 + 'px';
    $i('im_down').style.left = '4px';
    
    $('.info').style.width = window.innerWidth - 6 + 'px';
    
    $i('im_down').parentNode.addEventListener('submit',function(e){
      e.preventDefault();
  	  if (navigator.notification){
  	    navigator.notification.vibrate();
  	  }
  	  ajax('POST', '/cuddlers', 'cuddler[lat]='+loc.coords.latitude+'&cuddler[long]='+loc.coords.longitude, function(data, status){
  	    alert(data);
  	    alert(status);
  	  });
  	});

    
    
    if (navigator.geolocation) {
  	  var myOptions = {
          zoom: 15,
          mapTypeControl: false,
          draggable: false,
          navigationControl: false,
          mapTypeId: google.maps.MapTypeId.ROADMAP
        };
      loading();
  		navigator.geolocation.getCurrentPosition(function(location){
  		  var mapel = $i('map');
  		  mapel.style.opacity = '0';
  		  setTimeout(function(){
  		    mapel.style.opacity = parseFloat(mapel.style.opacity) + 0.05;
  		    if (mapel.style.opacity >= 1){
  		      return true;
  		    }
  		    setTimeout(arguments.callee, 33);
  		  }, 1000);
  		  loc = location;
  		  myOptions.center = new google.maps.LatLng(location.coords.latitude - 0.00025, location.coords.longitude);
  		  var map = new google.maps.Map($i("map"), myOptions);
  		  latlng = new google.maps.LatLng(location.coords.latitude, location.coords.longitude);
        var marker = new google.maps.Marker({
                position: latlng, 
                map: map, 
                title:"You are here!"
        });
        map.panTo(latlng);
        replaceText($('#loading span'), 'finding other cuddlers');
        ajax('GET', 'cuddlers/near/' + location.coords.latitude + '/' + location.coords.longitude, null, function(data, status){
          if (status != 200) {
            alert('There was a problem loading up DTC. Maybe you should come back later.');
          } else {
            data = JSON.parse(data);
            if (data.length == 1){
              notify('success', 'hrm.', 'there\'s one other cuddler in the area. fate?');
            } else if (data.length){
              notify('success', 'sweet', 'there are ' + data.length + ' nearby cuddlers waiting for you.');
            } else {
              notify('success', 'alright', 'no other cuddlers in your area yet. maybe you should start the party?');
            }
            done_loading();
          }
        });
  		}, function(){
        notify('error', 'you suck', 'either you denied me access to know where you are or there is another problem.')
  		});
  	} else {
  		notify('error', 'no how no way', 'come back with more chrome on.');
  	}
  });

})();

