/* The purpose of this trigger is to assign the appropriate users
 * to the respective custom lookup fields for use in approval routing.
 * The logic for assignment is maintained in the ApprovalRoutingUtil class,
 * refer to it for additional details.
 *
 * author: awaite
 * since: 152
 */
trigger opportunityApproverTrigger on Opportunity (before insert, before update) {

	ApprovalRoutingUtil.assignApprovers(Trigger.new);
	
}