({
	 handlePress : function(component, event, helper) {
        var divSource = component.find('divSource');
        var btn = component.find('btnToggle');
        //console.log(divSource.elements[0].className);
        if (divSource.elements[0].className == 'slds-is-collapsed')
        {
			$A.util.removeClass(divSource,'slds-is-collapsed');
            $A.util.addClass(divSource,'slds-is-expanded');
            $A.util.removeClass(btn,'slds-not-selected');
            $A.util.addClass(btn,'slds-is-selected');
        }
        else
        {
           
            $A.util.removeClass(divSource,'slds-is-expanded');
            $A.util.addClass(divSource,'slds-is-collapsed');
            $A.util.removeClass(btn,'slds-is-selected');
            $A.util.addClass(btn,'slds-not-selected');
        }
       
		
	}
})