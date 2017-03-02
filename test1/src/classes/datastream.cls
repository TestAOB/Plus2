public class datastream {
   @AuraEnabled
    public string topic {get; set;}
    @AuraEnabled
    public boolean connected {get; set;}
    @AuraEnabled
    public boolean disconnecting {get; set;}
    @AuraEnabled
    public string topicSubscription {get; set;}
    @AuraEnabled
    public string clientId {get{return '3MVG9lKcPoNINVBJL81nlIzB6Z7TFQtwfc6rMsiZXaW_yUy2Dv35Ayfe248X4yEMgEz0GmNDK5QMJ0MSFZdha';}}
    @AuraEnabled
    public string loginURL {get {return '/services/oauth2/authorize';}}

}