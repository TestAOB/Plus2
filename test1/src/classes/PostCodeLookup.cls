public with sharing class PostCodeLookup  extends ComponentControllerBase
{
    public Map<string, SfAddress> AddressMap { get; set;}
    public string addressMapKey { get; set;}
    public string PostCode { get; set;}    
    public Account acc { get; set;}
    public Contact c   { get; set;}
    public Boolean IsBilling { get {if (IsBilling == null) return true; else return IsBilling;} set;}
    public Boolean renderThis { get; set;}
    public Boolean isTest {get; set;}
    public PostCodeWS.ArrayOfAddressInfo addressInfos;
    
    public PostCodeLookup()
    {                      
    }
    public PageReference Lookup()
    {        
        renderThis = true;
        AddressMap = new Map<string, SfAddress>();
        integer i = 0;
        if (PostCode != null & PostCode != '')
        {
            WebServiceConfig__c conf = WebServiceConfig__c.getInstance('PostcodeLookup');     
            string wsPassword  = conf.password__c;
            PostCodeWS.BasicServiceWeb   ws = new PostCodeWS.BasicServiceWeb ();
            if (isTest == null || isTest == false) addressInfos = ws.GetAddressSearchAsList(wsPassword,'','',postCode);
            
            if (addressInfos != null && addressInfos.AddressInfo != null)
            {
                for (PostCodeWS.addressInfo addressInfo: addressInfos.AddressInfo)
                {                    
                    if (addressInfo != null)
                    {
                        string addr = '';
                        if (addressInfo.AddressLine1 != null && addressInfo.AddressLine1.trim()!= '') addr = addressInfo.AddressLine1.trim();
                        if (addressInfo.AddressLine2 != null && addressInfo.AddressLine2.trim()!= '') addr += ',' + addressInfo.AddressLine2.trim();
                        if (addressInfo.AddressLine3 != null && addressInfo.AddressLine3.trim()!= '') addr += ',' + addressInfo.AddressLine3.trim();
                        if (addressInfo.AddressLine4 != null && addressInfo.AddressLine4.trim()!= '') addr += ',' + addressInfo.AddressLine4.trim();
                        SfAddress sfAddr = new SfAddress(addr, addressInfo.PostTown, '', addressInfo.Postcode);
                        AddressMap.put(String.valueOf(i++),sfAddr);                        
                    }
                }   
            }           
        }        
        return null;
    }
    public PageReference selectAddr()
    {
        sfAddress selectedAddr = AddressMap.get(addressMapKey);
        if (acc != null)
        {
            if (IsBilling)
            {
                acc.BillingStreet = selectedAddr.Street;
                acc.BillingCity = selectedAddr.City;
                //acc.BillingState = selectedAddr.State;
                acc.BillingPostalCode = selectedAddr.PostalCode;
            }
            else
            {
                acc.ShippingStreet = selectedAddr.Street;
                acc.ShippingCity = selectedAddr.City;
                //acc.ShippingState = selectedAddr.State;
                acc.ShippingPostalCode = selectedAddr.PostalCode;
            }
        }
        if (c != null)
        {
            c.MailingStreet = selectedAddr.Street;
            c.MailingCity = selectedAddr.City;
            c.MailingState = selectedAddr.State;
            c.MailingPostalCode = selectedAddr.PostalCode;
        }
        renderThis = false;
        return null;
    }
    public class SfAddress
    {
        public string Street { get; set;}
        public string City { get; set;}
        public string State { get; set;}
        public string PostalCode { get; set;}
        public string Country { get; set;}
        
        public SfAddress (string inStreet, string inCity, string inState, string inPostalcode)
        {
            Street = instreet;
            if (inCity != null) City = inCity.trim();
            if (inState != null) State = inState.trim();
            if (inPostalCode != null) PostalCode = inPostalCode.trim();
        }
    }
    
    
}