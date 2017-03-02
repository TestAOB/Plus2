dojo.require('dojox.cometd');
dojo.require('dojox.cometd.timestamp');
dojo.require('dojox.cometd.ack');

dojo.ready(function() { 
    console.log('aaaaa1');
    var datastream = {
        _topic: '/topic/OccasionUpdates',
        _connected: false,
        _disconnecting: false,
        _topicsubscription: null,
        _token: null, 
        _clientid: '3MVG9lKcPoNINVBJL81nlIzB6Z7TFQtwfc6rMsiZXaW_yUy2Dv35Ayfe248X4yEMgEz0GmNDK5QMJ0MSFZdha',
        _loginURL: location.protocol + '//' + location.host + '//' + 'services/oauth2/authorize',
    
        _init: function()
        { 
                setTimeout(function()
                {			
					if(dojo.byId('tokenDiv').innerHTML!='')
					{
						datastream.subscribe('/topic/OccasionUpdates');
					}
					else
					{
					 setTimeout(datastream._init(),5000);
					}
					
                }, 1000);
        },
    
        subscribe: function(topic)
        {  
			console.log('subscribe called');
            var cometdURL = location.protocol + '//' + location.host + '/cometd/23.0';
            var auth = 'OAuth ' + dojo.byId('tokenDiv').innerHTML;
            dojox.cometd.configure({
            	url: cometdURL,
                requestHeaders: 
            	    { Authorization: auth}
            });
            dojox.cometd.handshake();
            datastream._disconnecting = false;
			datastream._topicsubscription = dojox.cometd.subscribe(datastream._topic, datastream.receive);			
			console.log('end of subscribe');
        },
    
        _unsubscribe: function()
        {
			console.log('unsubscribe');
            if (datastream._topicsubscription)
            {
                dojox.cometd.unsubscribe(datastream._topicsubscription);
            }
            datastream._topicsubscription = null;
        },
      
        receive: function(message) 
        { 
			console.log('received!!!');
            var myInput = dojo.byId('dojoInput');
        	//data = message.data; 
            //datastream.innerHTML += '<span class=\'text\'>' + JSON.stringify(data, null, '\t') + '</span><br/>';
            //datastream.innerHTML += '<span class=\'text\'>' + '_____________ ' + '</span><br/>';
            //datastream.scrollTop = datastream.scrollHeight - datastream.clientHeight;
			dojoInputOnChange();
			myInput.value = 'hello';
			dojo.byId('dojobtn').onclick();
			console.log('end of receive');
        }        

    };
    
    dojo.addOnLoad(datastream, '_init');
    
    dojo.addOnUnload(function()
    {
		datastream._unsubscribe(); 
        dojox.cometd.disconnect();
    }); 
});


