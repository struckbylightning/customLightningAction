public class APXFieldValidationError {  
    @AuraEnabled
    public String fieldName{get; set;}
    
    @AuraEnabled    
    public String sObjectName{get; set;}
    
    @AuraEnabled
    public String errorMessage{get; set;}
    
    @AuraEnabled
    public String recordId{get; set;}
    
    @AuraEnabled
    public String index{get; set;}
    
    @AuraEnabled
    public Boolean isTopOfPageError{get; set;}
    
    public APXFieldValidationError(String sObjectName, String fieldName, String errorMessage, Id recordId, Boolean isTopOfPageError, String index) {
        this.fieldName = fieldName;      
        this.sObjectName = sObjectName;     
        this.errorMessage = errorMessage;
        this.recordId = recordId;
        this.isTopOfPageError = isTopOfPageError;
        this.index = index;
    }
}