public class CalendarMonth {
    @AuraEnabled
    public List<CalendarWeek> weeks {get; set;}
    @AuraEnabled
    public Map<Date, List<Occasion__c>> MapDateOccasions {get; set;}
    @AuraEnabled
    public Set<Date>DateOccasionsKeys {get; set;}
    @AuraEnabled
    public integer MonthIndex {get; set;}
    @AuraEnabled
    public integer YearIndex {get; set;}
    @AuraEnabled
    public string MonthName {get;set;}
    
    public CalendarMonth(Date d)
    {
        if (d == null) d = Date.today();
        MonthIndex = d.month();
        YearIndex = d.year();
        MonthName = Datetime.newInstance(d.year(), d.month(), d.day()).format('MMMMM');
        Weeks = new List<CalendarWeek>();
        Date firstDay = d.toStartOfMonth();
        integer daysofweek = Math.MOD( firstDay.daysBetween(DATE.newInstance(1900, 1, 8)), 7);
        firstDay = firstDay.addDays(daysofweek);
        
        List<Occasion__c> ues = [SELECT Details__c,Start_Date__c, Name, Duration__c, Location__c, Title__c 
                                       FROM Occasion__c WHERE Start_Date__c >= :firstDay and Start_Date__c < :firstDay.addDays(35) 
                                       ORDER BY Start_Date__c Limit  1000];
        MapDateOccasions = new Map<Date, List<Occasion__c>>();
        for (Occasion__c ue : ues)
        {
            if (MapDateOccasions.keySet().contains(ue.Start_Date__c))
            {
                MapDateOccasions.get(ue.Start_Date__c).add(ue);
            }
            else
            {
                List<Occasion__c> l = new List<Occasion__c>();
                l.add(ue);
                MapDateOccasions.put(ue.Start_Date__c, l);
            }
            
        }
        DateOccasionsKeys = MapDateOccasions.keySet();
              
        
        for (integer i=0; i < 5; i++)
        {      
            CalendarWeek w = new CalendarWeek(firstDay
                              ,firstDay.addDays(1)
                              ,firstDay.addDays(2)
                              ,firstDay.addDays(3)
                              ,firstDay.addDays(4)
                              ,firstDay.addDays(5)
                              ,firstDay.addDays(6)
                              ,MapDateOccasions
                             );
            
            weeks.add(w);
            firstDay = firstDay.addDays(7);
            
            
            
        }
        
        
        
        
    }
}
/*
CASE(
MOD( date - DATE( 1900, 1, 8 ), 7 ),
0, "Monday",
1, "Tuesday",
2, "Wednesday",
3, "Thursday",
4, "Friday",
5, "Saturday", 
"Sunday"
)
)
*/