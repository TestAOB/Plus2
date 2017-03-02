public class CalendarDay {
    @AuraEnabled
    public Date D {get; set;}
    @AuraEnabled
    public String Day {get; set;}
    @AuraEnabled
    public String Month {get; set;}
    @AuraEnabled
    public List<Occasion__c> Occasions {get;set;}
    @AuraEnabled
    public string CssClass {get; set;}
    
    
    public CalendarDay(List<Occasion__c> events, Date dt)
    {
        D = dt;
        Day = string.valueOf(dt.day());
        Month = string.valueOf(dt.Month());
        if (events != null) Occasions = events;
        else Occasions = new List<Occasion__c>();     
        
        if (Occasions.size() > 0) CssClass = '';
        else CssClass = 'slds-disabled-text';
        
            
        
    }
}