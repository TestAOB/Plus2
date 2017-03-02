/** This utility class contains the methods and associated tests
 * to facilitate the denormalization of account and owner fields
 * down to the opportunity for use in dynamic routing of approval
 * requests.
 *
 * author: awaite
 * since: 152
 */

public class ApprovalRoutingUtil {
	
	/** This method is the primary interface to this utility class which
	*   will set the appropriate approver values based on the custom object
	*   approval_routing_rule__c. 
	*   
	*   The single argument is expected to be the value of Trigger.new in a
	*   before insert/update trigger on opportunity. 
	*
	* @param opportunitties		the objects to assign approvers.
	*/
	public static void assignApprovers(List<Opportunity> opportunities) {
		
		/* The map of accountId -> List<Opportunity>. 
		   opporutnities passed in with null accountId values are ignored.*/
		Map<Id, List<Opportunity>> accountToOpportunitiesMap = new Map<Id, List<Opportunity>>();
		
		/* The set of user(owner) Ids that represent the unique owners of
		   the given opportunities. */
		Set<Id> userIdSet = new Set<Id>();
		
		/* Loop through the opportunities, adding to the map and set */
		for(Opportunity o:opportunities) {
			
			Id aid = o.accountId;
			userIdSet.add(o.ownerId);
			
			/* if the account Id is null we ignore it */
			if(aid != null) {
			  
			  /* if there is no list for this account id, create it */
			  if(accountToOpportunitiesMap.get(aid) == null) accountToOpportunitiesMap.put(aid, new List<Opportunity>());
			  
			  /* add the opporutnity to the map under this account id. */
			  accountToOpportunitiesMap.get(aid).add(o);	
			}
		}
		
		/* Get the map of accounts for the unique set of account IDs in the accountToOpportunitiesMap 
		   so we can associate the Account Type to the respective opportunities. */
		Map<Id, Account> accountMap = new Map<Id, Account>([select type from account where id in :accountToOpportunitiesMap.keySet() and type != null]);
	
	    /* Get the map of users for the unique set of user IDs in the userToOpportunitiesMap 
	       so we can associate the Region to the respective opportunities. */
		Map<Id, User> userMap = new Map<Id, User>([select region__c from user where id in :userIdSet and region__c != null]);
		
		/* This is the map for the routing key, the concatenation of the Account Type
		   and the owner's region which is used to access the approval_routing_rule object */
		Map<String, List<Opportunity>> routingKeyToOpportunitiesMap = new Map<String, List<Opportunity>>();
		
		/* Iterate over the account IDs in the accountToOpportunitiesMap map. This will
		   process the generation of the type, region key. */
		   
		for(Id aid:accountToOpportunitiesMap.keySet()) {
		   String t = accountMap.get(aid).type;
		   if(t != null) {
		   	
		   	/* Iterate over the associated opportunities and if the owner's region is 
		   	   non-null add the complete key and related opportunity to the routingKeyToOpportunitiesMap map. */
		     for(Opportunity o:accountToOpportunitiesMap.get(aid)) {
		     	String r = userMap.get(o.ownerId).region__c;
		     	
		     	if(r != null) {
		     		String key = createRoutingKey(t,r);
		     		if(routingKeyToOpportunitiesMap.get(key) == null) routingKeyToOpportunitiesMap.put(key, new List<Opportunity>());
		     		routingKeyToOpportunitiesMap.get(key).add(o);	
		     	}
		     }	
		   }
		}
		
		/* Iterate over the approval_routing_rule__c objects with the respective routing key values
		   so we can set the appropriate level assignments on the opportunities. */
		for(Approval_Routing_Rule__c rule:[select routing_key__c, Level1__c, Level2__c, Level3__c 
		                                     from Approval_Routing_Rule__c 
		                                     where routing_key__c in :routingKeyToOpportunitiesMap.keySet()]){
		                                     	
         	for(Opportunity o:routingKeyToOpportunitiesMap.get(rule.routing_key__c)) {
         		o.level1__c = rule.level1__c;
         		o.level2__c = rule.level2__c;
         		o.level3__c = rule.level3__c;
         	}	
		}
	}
	
	/** This method is used to generate the routing key based on the two given arguments, 
	*   the account type and the user region.
	*	
	*	@param accountType	the account type
	* 	@param region		a region associated to the approval route
	*/
	public static String createRoutingKey(String accountType, String region) {
		return accountType + ':' + region;	
	}
	
	/** This method is used by tests to get a map of routing_key__c -> Approval_Routing_Rule__c object.
	* 
	*	@param ruleList		a list of rule
	* 	@return ruleMap		a map of rule associated to the list of rule
	*/
	public static Map<String, Approval_Routing_Rule__c> getRuleMap(List<Approval_Routing_Rule__c> ruleList) {
		
		/* If the first key is null then we need to reload the collection */
		if(ruleList.get(0).routing_key__c == null) ruleList = [select routing_key__c, level1__c, level2__c, level3__c from Approval_Routing_Rule__c where id in :ruleList];
		Map<String, Approval_Routing_Rule__c> ruleMap = new Map<String, Approval_Routing_Rule__c>();
		
		/* Routing_key__c is defined with a unique constraint so this is a simple conversion process */
		for(Approval_Routing_Rule__c rule:ruleList) { ruleMap.put(rule.routing_key__c,rule); }
		
		return ruleMap;
	}
		
}