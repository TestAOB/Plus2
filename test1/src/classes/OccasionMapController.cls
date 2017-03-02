public class OccasionMapController {
 @AuraEnabled
    public static Occasion__c getOccasion(string OccasionId)
    {
        Occasion__c o = [SELECT Address__c, Location__c FROM Occasion__c WHERE ID = :OccasionId];
        return o;
    }
}