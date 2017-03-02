public class AccountExtension extends PageControllerBase{
     public  Account a ;
     private ApexPages.StandardController controller;
   
   public PostCodeLookup POLookupController1 {set;
    get{
        //get the map, then the component controller using the appropriate key
        if(getComponentControllerMap()!=null){
          PostCodeLookup mcc;
          mcc = (PostCodeLookup )getComponentControllerMap().get('component1');
          if(mcc!= null)
             return mcc;
           
        }
        return new PostCodeLookup();
    }
  }
  public PostCodeLookup POLookupController2 {set;
    get{
         if(getComponentControllerMap()!=null){
          PostCodeLookup mcc;
          mcc = (PostCodeLookup )getComponentControllerMap().get('component2');
          if(mcc!= null)
             return mcc;
          
        }return new PostCodeLookup();
  
    }
  }

  public AccountExtension (ApexPages.StandardController stdController)
    {       
    
          this.a= (Account)stdController.getRecord();          
        controller = stdController;
        }
}