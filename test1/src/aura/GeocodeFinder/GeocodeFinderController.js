({
    searchEvents: function(component, event, helper) {
      if(event.getParams().keyCode == 13){
       component.findGeo();
      }
   },
    handlePress : function(component, event, helper) {
        helper.hide(component,"err");
        var address = component.find("addr").get("v.value");
		var streetAddRegEx = new RegExp(/^[a-zA-Z\s\d\/.,]*\d[a-zA-Z\s\d\/,.]*$/);
        console.log('regex result: '+streetAddRegEx.test(address));
        if (address.replace(' ','').length < 10 || !streetAddRegEx.test(address)) 
        {
             helper.setErrorMessage(component, 'Please enter valid address');
             helper.unHide(component,"err");
        }
        else
        {
            var geocoder = new google.maps.Geocoder();
            geocoder.geocode( { 'address': address, 'region':'uk'}, function(results, status) {
                console.log(status);
                if (status == google.maps.GeocoderStatus.OK && results.length) 
                {
					component.set('v.lng', results[0].geometry.location.lng().toString());
                    component.set('v.lat', results[0].geometry.location.lat().toString());
                    component.set('v.addr', address);
                    component.set('v.renderFrame',true);
                    component.set('v.frameHeight',300);                    
                    helper.unHide(component,'gmap');
                    helper.setLngLat(component
                                     ,results[0].geometry.location.lng().toString()
                                     ,results[0].geometry.location.lat().toString());                    
                    helper.unHide(component,"result");
                    
                }   
                else
                {
                    if (status = google.maps.GeocoderStatus.ZERO_RESULTS)
                    {
                        helper.setErrorMessage(component, 'Not Found');
                    }
                    else 
                    {
                        helper.setErrorMessage(component, status);
                    }
                    helper.unHide(component,"err");
                }
                this.superRerender();
            })  
        }
    } 
    
    
    
})