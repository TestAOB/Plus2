public with sharing virtual class PageControllerBase 
{   
  private ComponentControllerBase myComponentController;
  private Map<String, ComponentControllerBase>componentControllerMap; 
    
  public virtual Map<String, ComponentControllerBase> getComponentControllerMap()
  {
    return componentControllerMap;
  }
    
  public virtual void setComponentControllerMap(String key, ComponentControllerBase compController){
    if(componentControllerMap == null)
      componentControllerMap = new Map<String, ComponentControllerBase>();
    componentControllerMap.put(key,compController); 
  }
 
  public virtual void setComponentController(ComponentControllerBase compController) 
  {
    myComponentController = compController;
  }
    
  public PageControllerBase getThis() 
  {
    return this;
  }
    
}