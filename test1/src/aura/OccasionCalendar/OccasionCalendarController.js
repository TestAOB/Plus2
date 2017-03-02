({
    doInit : function(cmp, event, helper) {
        helper.getCalMonth(cmp, new Date());        
        console.log('end of doInit');
    },
    doStreaming : function(cmp, event, helper) {
        helper.callGetSessionId(cmp, helper);        
        console.log('end of doStreaming');
    },

    handlePress: function(cmp,event, helper)
    {     
        cmp.set("v.body",'');
        var lid = event.getSource().getLocalId();
        var d = new Date();
		if (lid == 'buttonRight')
        {
            var mi = cmp.get("v.calmonth.MonthIndex");
            var yi = cmp.get("v.calmonth.YearIndex");
            d = new Date(yi, mi, 1);
            console.log(d);           
        }
      		if (lid == 'buttonLeft')
        {
            var mi = cmp.get("v.calmonth.MonthIndex");
            var yi = cmp.get("v.calmonth.YearIndex");
            d = new Date(yi, mi- 2, 1);
            console.log(d);           
        }
        helper.getCalMonth(cmp, d); 
    }
    ,
    handleClick : function(cmp, event, helper) {
        var target = event.getSource();   
        helper.clearSelected(cmp, target);      
        if (target.elements[0].parentElement.parentElement.className != 'slds-disabled-text')
        target.elements[0].parentElement.parentElement.className = 'slds-is-selected';
        
        var calmonth = cmp.get("{!v.calmonth}");
        var newBody = "";  
        if (calmonth.MapDateOccasions[target.elements[0].title])
        {
            newBody += "<ul>"
            for (var i=0;i<calmonth.MapDateOccasions[target.elements[0].title].length;i++)
            {
                newBody += "<li class='slds-has-divider--top'>";
                newBody += "<dl><dd><a href='/"+calmonth.MapDateOccasions[target.elements[0].title][i].Id+"'>" + calmonth.MapDateOccasions[target.elements[0].title][i].Title__c+"</a></dd></dl>";
                newBody += "<dl><dd>Start Date: " + calmonth.MapDateOccasions[target.elements[0].title][i].Start_Date__c+"</dd></dl>";
                newBody += "<dl><dd>Location: " + calmonth.MapDateOccasions[target.elements[0].title][i].Location__c+"</dd></dl>";
            }
            newBody += "</ul>"
        }        
        $A.createComponent(
            "aura:unescapedHTML",
            {
                "value" : newBody
            },
            function(newComponent){
                cmp.set("v.body",newComponent);
            }
        )
        
    },
    dojoInputOnChange: function()
    {
        console.log('onChagne fired');
    }
    
})