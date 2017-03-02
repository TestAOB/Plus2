public class OccasionCalendarController {
    @AuraEnabled
    public static CalendarMonth getCalendarMonthwithNumber(integer yyyy, integer mm)
    {
        Date d = Date.newInstance(yyyy, mm, 1);
        return new CalendarMonth(d);
    }
    @AuraEnabled
    public static string getSessionId()
    {
      	String token = '';
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        //req.ContentType = 'application/x-www-form-urlencoded';
        req.setEndpoint('https://login.salesforce.com/services/oauth2/token');
        req.setMethod('POST');
        req.setHeader('ContentType','application/x-www-form-urlencoded');
        req.setBody('grant_type=password'
                    +'&client_id='
                    + EncodingUtil.urlEncode('3MVG9Rd3qC6oMalUjOf85_IClxBC9jZyvOBBboDNLEaq0VjF2AFq3HBIulV23yhmT7E5hNhw9okrTZum.9z_p','UTF-8')
                    +'&client_secret='
                    + EncodingUtil.urlEncode('2817635742591499896','UTF-8')
                    +'&username='
                    + EncodingUtil.urlEncode('kumiko@sullivan.com', 'UTF-8')//+ EncodingUtil.urlEncode('test@kumikosullivan.com', 'UTF-8')
                    +'&password='
                    + EncodingUtil.urlEncode('Odaiba1.IK5GhKGiRO5J1dJYygBCuEfVp','UTF-8'));//+ EncodingUtil.urlEncode('Odaiba1.U1TUtOnuh0mcBO3dl6KZAtN8','UTF-8'));
        
        //req.setBody('code=&grant_type=password&client_id=3MVG9Rd3qC6oMalUjOf85_IClxBC9jZyvOBBboDNLEaq0VjF2AFq3HBIulV23yhmT7E5hNhw9okrTZum.9z_p&client_secret=2817635742591499896&username=test%40kumikosullivan.com&password=Odaiba1.U1TUtOnuh0mcBO3dl6KZAtN8');
        //req.setCompressed(true);
        try
        {
            res = http.send(req);
            if (res.getStatusCode() == 200) {
                // Deserialize the JSON string into collections of primitive data types.
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                // Cast the values in the 'animals' key as a list
                token = (string) results.get('access_token');
                System.debug(token);
                
            }
        }
        catch(System.CalloutException e)
        {
            System.debug('Callout error: '+ e);
            System.debug(res.toString());
        }
        catch(System.Exception exp)
        {
            system.debug(exp.getMessage());   
        }
        return token;
    }
    
}