({
    getCalMonth : function(cmp,newdate)
    {
       console.log('getCalMonth');
       var action = cmp.get("c.getCalendarMonthwithNumber");
       action.setParams(
            {
                yyyy: newdate.getFullYear().toString()
                ,mm:(newdate.getMonth()+1).toString()
            }
        );
         action.setCallback(this, function(response) 
        {
            var state = response.getState();
            if (cmp.isValid() && state === "SUCCESS") {                
                cmp.set("v.calmonth", response.getReturnValue());
            }      
        });   
        $A.enqueueAction(action);
       
    },
        clearSelected: function(cmp, target)
    {
        for(var i=0;i<target.elements[0].parentElement.parentElement.parentElement.parentElement.childNodes.length; i++)
        {
            for(var ii=0;ii<target.elements[0].parentElement.parentElement.parentElement.parentElement.childNodes[i].childNodes.length;ii++)
            {
                if(target.elements[0].parentElement.parentElement.parentElement.parentElement.childNodes[i].children[ii].className == 'slds-is-selected')
                target.elements[0].parentElement.parentElement.parentElement.parentElement.childNodes[i].children[ii].className = 'slds-is-today';
            }
                
        }
    },
    callGetSessionId: function (cmp, helper)
    {
       var action = cmp.get("c.getSessionId");
       action.setCallback(this, function(response) 
        {
            var state = response.getState();
            if (cmp.isValid() && state === "SUCCESS") {
               cmp.set("v.streamingToken",response.getReturnValue());
               helper.subscribeStreaming(cmp, helper);
            }      
        });   
        $A.enqueueAction(action);
    },
    
    
    

    
    subscribeStreaming: function(cmp, helper)
    {
            var cometdURL = 'https://sul-developer-edition.eu5.force.com/cometd/23.0';
            var auth = 'OAuth ' + cmp.get("v.streamingToken");
            dojox.cometd.configure({
            	url: cometdURL,
                requestHeaders: 
            	    { Authorization: auth}
            });
            dojox.cometd.handshake();
  			var ts = dojox.cometd.subscribe('/topic/OccasionUpdates',
                                                 function(message){
                                                     console.log('received!!!');
                                                     // This works but euqueueAction seems to keep the action pending for 30 min and not usable
                                                     //helper.getCalMonth(cmp, new Date());
                                                     // This will refresh whole page
                                                     // $A.get('e.force:refreshView').fire();

                                                     // Fire Event instead
                                                     var myEvent = cmp.getEvent("myEvt");
                                                 	 myEvent.fire();
                                                     console.log('refreshed');
                                                 }
            
                                                 
                                                 
            );			
            cmp.set('v.topicsubscription', ts);
			console.log('end of subscribe');
    },
    
    unsubscribe: function(cmp)
    {
			console.log('unsubscribe');
            var tsubscription = cmp.get("v.topicsubscription");
            if (tsubscription)
            {
                dojox.cometd.unsubscribe(tsubscription);
            }
            cmp.set('v.topicsubscription', null);
     }      
    
    
    

    
})