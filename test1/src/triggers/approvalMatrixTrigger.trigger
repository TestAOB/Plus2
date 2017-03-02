/* The purpose of this trigger is to set the routing_key__c of 
 * each object to have a value that concatenates the values 
 * from the account_type__c and owner_region__c fields.
 * 
 * NOTE: there is a validation rule on Apdddproval_Routing_Rule__c
 * included with this package that enforces the two fields above 
 * be non-null. This trigger counts on that validation rule to be in
 * place.
 * 
 * author: awaite
 * since: 152 
 */
trigger approvalMatrixTrigger on Approval_Routing_Rule__c (before insert, before update) {
    
    for(Approval_Routing_Rule__c a:Trigger.new) {
        a.routing_key__c = ApprovalRoutingUtil.createRoutingKey(a.account_type__c,a.owner_region__c);
    }

}