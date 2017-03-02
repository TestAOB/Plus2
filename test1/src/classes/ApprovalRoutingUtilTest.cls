/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class ApprovalRoutingUtilTest {

    /* Static variables for tests */
	static final String accountTypeValue     = 'ACCOUNT TYPE:';
    static final String userRegionValue      = 'USER REGION:';
    static final String accountName          = 'ACCOUNT NAME';
    static final String opportunityName      = 'OPPORTUNITY NAME';
    static final String opportunityStageName = 'Prospecting';  
	
	/* This is the test for the down-the-middle positive case, i.e. where there is a single opportunty being
	   saved and there is an associated account with a non-null type value and the user has a non-null
	   region value; */
	private static testMethod void basicSingleTest() {
		
		cleanData();
		/* create an account with a given type */
		User user;
		Account a = new Account(Name = accountName, Type = accountTypeValue);
		Database.insert(a);
		
		List<User> userList = new List<User>();
		
		for(Integer i = 0; i < 3; i++) {
		    user = generateUserAndInsert(userRegionValue + i);
		    userList.add(user);
		}
		
		/* Create the Approval_Routing_Rule__c record with the 3 users above and set the region to 
		   that of the first user in the list */
		Approval_Routing_Rule__c rule = new Approval_Routing_Rule__c(level1__c       = userList.get(0).id, 
		                                                                 level2__c       = userList.get(1).id, 
		                                                                 level3__c       = userList.get(2).id,
		                                                                 account_type__c = accountTypeValue,
		                                                                 owner_region__c       = userList.get(0).region__c);
		Database.insert(rule);
		
		/* Create the opportunity that is the primary subject of this test
		   with the account Id of the created account and an ower equal to user 0 in the list */
		Opportunity o = new Opportunity(StageName = opportunityStageName, CloseDate = System.today(), Name = opportunityName, AccountId = a.id, OwnerId = userLIst.get(0).id);
		
		Test.startTest();
		Database.insert(o);
		Test.stopTest();
		
		/* Reload the opportunity so we can assert the values set by the trigger */
		o = [select level1__c, level2__c, level3__c from opportunity where id = :o.id];
		
		/* Assert that the various user lookups are equivalent to their matrix object mapping */ 
		System.assertEquals(rule.level1__c,o.level1__c,'User lookup level1__c does not match rule value.');
		System.assertEquals(rule.level2__c,o.level2__c,'User lookup level2__c does not match rule value.');
		System.assertEquals(rule.level3__c,o.level3__c,'User lookup level3__c does not match rule value.');
		
	}
	
	/** 
	*   This is a variation of the basic test which affirms the code in question is capable of handling 
	*   a bulk API save operation on opportunity. 
	*/
	private static testmethod void basicBulkTest() {
		
		cleanData();
		final Integer numAccounts                = 10;
		final Integer numOpportunitiesPerAccount = 5;
		User user;
		List<Account> accountList                 = new List<Account>();
		List<Opportunity> opportunityList         = new List<Opportunity>();
		List<Approval_Routing_Rule__c> ruleList = new List<Approval_Routing_Rule__c>();
		List<User> userList = new List<User>();
		
		for(Integer i = 0; i < 3; i++) {
		    user = generateUserAndInsert(userRegionValue + i);
		    userList.add(user);
		}
		
		/* create accounts - each with their own type */
		for(Integer i=0;i<numAccounts;i++) { 
			accountList.add(new Account(Name = accountName, Type = accountTypeValue + i));
		}
		
		System.runAs(user){
			Database.insert(accountList);	
		}
		
		/* create separate routing rules for each type and region combination */
		for(Integer i=0;i<numAccounts;i++) {
			for(Integer u=0;u<userList.size();u++) { 
			  ruleList.add(new Approval_Routing_Rule__c(level1__c       = userList.get(0).id,
			  											  level2__c       = userList.get(1).id,
		                                                  level3__c       = userList.get(2).id,
		                                                  account_type__c = accountTypeValue + i, 
		                                                  owner_region__c       = userRegionValue + u));
			}
		}
		
		System.runAs(user){
			Database.insert(ruleList);
		}
		
		//create 50 opportunities - 5 each against the given accounts and assigned to the various users
		for(Account a:accountList) {
			for(Integer i=0;i<numOpportunitiesPerAccount;i++) {
				for(User u:userList) {
				  opportunityList.add(new Opportunity(ownerId = u.id, AccountId = a.id, Name = opportunityName, StageName = opportunityStageName, CloseDate = System.today()));
				}
			}	
		}
		
		Test.startTest();
		System.runAs(user){
			Database.insert(opportunityList);	
		}
		/* get the rule map, a map of routing_key__c -> Approval_Routing_Rule__c object */
		Map<String, Approval_Routing_Rule__c> ruleMap = ApprovalRoutingUtil.getRuleMap(ruleList);
		Test.stopTest();
		
		/* Now re-load the opportunity records so we can assert the user lookups were assigned appropriately */
		for(Opportunity o:[select owner.region__c, account.type, level1__c, level2__c, level3__c from opportunity where id in :opportunityList]) {
			String key = ApprovalRoutingUtil.createRoutingKey(o.account.type, o.owner.region__c);
			Approval_Routing_Rule__c rule = ruleMap.get(key);
			System.assertNotEquals(null,rule,'Approval_Routing_Rule__c record not found in the map for key: ' + key);
			System.assertNotEquals(null,o.level1__c,'User lookup level1__c on opportunity found to be null.');
			System.assertEquals(rule.level1__c,o.level1__c,'User lookup level1__c does not match rule value.');
			System.assertEquals(rule.level2__c,o.level2__c,'User lookup level2__c does not match rule value.');
			System.assertEquals(rule.level3__c,o.level3__c,'User lookup level3__c does not match rule value.');
		}
		
	}
	
	/**
	* 	This test affirms that validation rules are in place to require non-null values for
	* 	the Account_Type__c and Owner_Region__c fields on Approval_Routing_Rule__c.  
	*/
	private static testmethod void validationTest() {
	    Approval_Routing_Rule__c rule = new Approval_Routing_Rule__c();
	    try {
	    	Database.insert(rule);
	    	System.assert(false,'Insert did not throw expected exception: FIELD_CUSTOM_VALIDATION_EXCEPTION with null values for account_type__c and owner_region__c.');
	    } catch(System.DmlException e) {
	        System.assertEquals(StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION, e.getDmlType(0));	
	    }	
	    
	    /* give the rule a value for account_type__c but leave owner_region__c null */
	    rule.account_type__c = accountTypeValue;
	    try {
	    	Database.insert(rule);
	    	System.assert(false,'Insert did not throw expected exception: FIELD_CUSTOM_VALIDATION_EXCEPTION with null value for owner_region__c and account_type__c value: ' + accountTypeValue);
	    } catch(System.DmlException e) {
	        System.assertEquals(StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION, e.getDmlType(0));	
	    }	  
	    
	    /* nullify the acount_type__c and give a value for owner_region__c */
	    rule.account_type__c = null;
	    rule.owner_region__c       = userRegionValue;
	    try {
	    	Database.insert(rule);
	    	System.assert(false,'Insert did not throw expected exception: FIELD_CUSTOM_VALIDATION_EXCEPTION with null value for account_type__c and owner_region__c value: ' + userRegionValue);
	    } catch(System.DmlException e) {
	        System.assertEquals(StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION, e.getDmlType(0));	
	    }	 	    
	    
	}
	
	/**
	* 	This test validates the routing_key__c is set properly in the trigger
	* 	on Approval_Routing_Rule__c 
	*/
	private static testmethod void routingTriggerTest() {
		
		/* Create an Approval_Routing_Rule__c record. */
		Approval_Routing_Rule__c rule = new Approval_Routing_Rule__c(Account_Type__c = accountTypeValue, owner_Region__c = userRegionValue);
		Database.insert(rule);
		
		/* Get the updated value from the database to assert the trigger functionality. */
		rule = [select routing_key__c, account_type__c, owner_region__c from Approval_Routing_Rule__c where id = :rule.id];
		
		/* Assert the key was generated as expected. */
		System.assertEquals(ApprovalRoutingUtil.createRoutingKey(rule.account_type__c, rule.owner_region__c),rule.routing_key__c,'Routing Key value not created properly for account_type__c: ' + rule.account_type__c + ' and owner_region__c: ' + rule.owner_region__c);
		
	}
	
	/**
	*	Generate a random user and insert it.
	* 
	* 	@param userRegion 	user region which belongs
	* 	@return user
	*/
	private static User generateUserAndInsert(String userRegion){
    	String userName = 'user'+Datetime.now().millisecond()+'@mail.com';
    	Profile profile = [select id from profile where name LIKE '%Administrator%' limit 1];
        User user = new User(alias = 'standt', email='standarduser@testorg.com',
						emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
						localesidkey='en_US',profileId = profile.Id,
						region__c=userRegion,
						timezonesidkey='America/Los_Angeles', username=userName);
		System.assert(true);
		insert user;
		return user;
    }
    
    /**
    *	Clean the existing oportunities in the db. 
    */
    private static void cleanData(){
    	Opportunity[] opportunities = [select Id from Opportunity];
    	System.assert(true);
    	delete opportunities;
    }
}