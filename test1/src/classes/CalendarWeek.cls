public class CalendarWeek {
    @AuraEnabled
    public CalendarDay Mon {get; set;}
    @AuraEnabled
    public CalendarDay Tue {get; set;}
    @AuraEnabled
    public CalendarDay Wed {get; set;}
    @AuraEnabled
    public CalendarDay Thu {get; set;}
    @AuraEnabled
    public CalendarDay Fri {get; set;}
    @AuraEnabled
    public CalendarDay Sat {get; set;}
    @AuraEnabled
    public CalendarDay Sun {get; set;}
    @AuraEnabled
    public integer WeekNumber {get; set;}
    
    public CalendarWeek (date m, date t, date w, date th, date f, date sa, date su, Map<Date,List<Occasion__c>> mapDateOccasions)
    {
        Mon = new CalendarDay(mapDateOccasions.get(m),m);
        Tue = new CalendarDay(mapDateOccasions.get(t),t);
        Wed = new CalendarDay(mapDateOccasions.get(w),w);
        Thu = new CalendarDay(mapDateOccasions.get(th),th);
        Fri = new CalendarDay(mapDateOccasions.get(f),f);
        Sat = new CalendarDay(mapDateOccasions.get(sa),sa);
        Sun = new CalendarDay(mapDateOccasions.get(su),su);
        WeekNumber = m.dayOfYear()/7;
    }
}