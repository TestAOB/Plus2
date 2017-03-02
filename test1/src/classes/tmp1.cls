public with sharing class tmp1{

public shipment__c s {get; set;}
  public PageReference saveAsDraft(){
        system.debug('kumikumi');
        database.update(s);
        return Page.tmp1;
        }
public Component.Apex.PageBlock getDynamicForm() {
 s = [SELECT num__c FROM shipment__c where id = 'a082400000VGLy3'];
        Component.Apex.PageBlock dynPageBlock = new Component.Apex.PageBlock();
        Component.Apex.InputField thisInputField = new Component.Apex.InputField();
        thisInputField.label = 'testinput';
        thisInputField.expressions.value = '{!s.Num__c}';
        dynPageBlock.childComponents.add(thisInputField);
        return dynPageBlock;

    }

}