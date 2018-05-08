public class LightningServerResponse {
 	@AuraEnabled public Boolean isSuccessful{get; private set;}
	@AuraEnabled public String message{get; private set;}
    @AuraEnabled public map<String, Object> objectData{get; private set; }
    @AuraEnabled public List<APXFieldValidationError> fieldValidationErrors{get; private set; }
    public LightningServerResponse(Boolean isSuccessful, String message, Map<String, Object> objectData){
        this.isSuccessful = isSuccessful;
        this.message = message;
        this.objectData = objectData;
	}

    public LightningServerResponse(Boolean isSuccessful, String message, Map<String, Object> objectData, List<APXFieldValidationError> fieldValidationErrors) {
        this.isSuccessful = isSuccessful;
        this.message = message;
        this.objectData = objectData;
        this.fieldValidationErrors = fieldValidationErrors;
	}
}