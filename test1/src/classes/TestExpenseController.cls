@isTest
public class TestExpenseController {
	static testMethod void test() {
        //Create new expense and insert it into the database
        Expense__c exp = new Expense__c(name='My New Expense',
        	amount__c=20, client__c='ABC',
        	reimbursed__c=false, date__c=null);
        ExpenseController.saveExpense(exp);
        
        //Assert the name field and saved expense
        System.assertEquals('My New Expense',
        ExpenseController.getExpenses()[0].Name,
        'Name does not match');
        System.assertEquals(exp, ExpenseController.saveExpense(exp));
    }
}