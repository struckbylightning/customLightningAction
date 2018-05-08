public class CustomLightningActionApxCtrl {
    
    public static Boolean isSuccessful = true;
    public static String message = '';
    
    @auraEnabled
    public static LightningServerResponse creditStatusConfirmConditionalCheck(String recordId){
        Boolean showConfirmMessage = false;
        try{
            List<Account> accounts = [Select Credit_Status__c from Account where id=:recordId];
            if(!accounts.isEmpty() && accounts[0].Credit_Status__c == 'Red')           
                showConfirmMessage = true;
            message = 'Record id '+recordId+' Credit_Status__c '+accounts[0].Credit_Status__c; 
        }catch(Exception ex){
            handleException(ex);  
        }
        return new LightningServerResponse(isSuccessful, message, 
                                           new Map<String, Object>{'showConfirmMessage'=>showConfirmMessage});
    }
    
    @auraEnabled
    public static LightningServerResponse creditStatusRedirectCheck(String recordId){
        Boolean redirect = true;
        try{
            List<Account> accounts = [Select Credit_Status__c from Account where id=:recordId];
            if(!accounts.isEmpty() && accounts[0].Credit_Status__c == 'Red'){        
                redirect = false;
                message = 'You cannot place new Sales order as Finance has marked this account Red, Check with Finance team for more info'; 
            }
        }catch(Exception ex){
            handleException(ex);  
        }
        return new LightningServerResponse(isSuccessful, message, 
                                           new Map<String, Object>{'redirect'=>redirect,
                                               'eventParams'=>'{"entityApiName": "Opportunity"}'});
    }
    @auraEnabled
    public static LightningServerResponse stupidStaticMethod(String recordId){
        Savepoint sp = Database.setSavepoint();
        try{
            system.debug('stupid method called, id passed '+recordId);
            isSuccessful = true;
            message = 'You are Stupid for a fact, here`s the passed id '+recordId;
            //Integer xyz = 1/0;
        }catch(Exception ex){
            handleException(ex);            
            Database.rollback(sp);
        }
        return new LightningServerResponse(isSuccessful, message, null, null);
    }
    @auraEnabled
    public static LightningServerResponse createSalesOrder(String recordId){
        system.debug('createSalesOrder called, recordid passed '+recordId);
        //DML
        //API Callout
        return new LightningServerResponse(true, 'Sales Order Created Successfully', null, null);
    }
    public static void handleException(Exception ex){
        isSuccessful = false;
        message = ex.getLineNumber()+':'+ex.getMessage();
        System.debug(message);
    }
}