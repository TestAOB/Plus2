({
    
    setLngLat:function(component, lngval, latval)
    {
        var lng = component.find("lng");
        var lat = component.find("lat");
        lng.set ("v.value", lngval);
        lat.set("v.value", latval);
        
    },
    setErrorMessage:function(component, msg)
    {
 		var errorMessage = component.find("errorMessage");
        errorMessage.set ("v.value", msg);        
    }, 
    unHide : function(component, cmpname) {
        var target = component.find(cmpname);
        $A.util.removeClass(target,'slds-hide');
    },
    hide : function(component, cmpname) {
        var target = component.find(cmpname);
        $A.util.addClass(target,'slds-hide');
    }
})