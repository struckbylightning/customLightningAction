public class CrudResponseApxCtrl {
    
    public static final String TOP_OF_PAGE_ERROR = 'TOP_OF_PAGE_ERROR';
    private static final String TOP_OF_PAGE_ERRORCODE_PATTERN =  '(.*)(:)(.*)';
    
    public static List<APXFieldValidationError> getCrudResponseFromSaveResults(List<SObject> sObjects, List<Database.SaveResult> saveResults) {
        List<APXFieldValidationError> validationErrorList = new List<APXFieldValidationError>();
        for(Integer i = 0; i < saveResults.size(); i++) {
            Database.SaveResult saveResult = saveResults[i];
            List<Database.Error> saveResultErrors = saveResult.getErrors();
            for(Integer j = 0; j < saveResultErrors.size(); j++) {
                Database.Error saveResultError = saveResultErrors[j];
                String errorFieldName = TOP_OF_PAGE_ERROR; 
                Boolean isTopOfPageError = true;
                if(Pattern.matches(TOP_OF_PAGE_ERRORCODE_PATTERN, saveResultError.getMessage()) || saveResultError.getFields().isEmpty()){
                    validationErrorList.add(new APXFieldValidationError(sObjects[i].getSObjectType().getDescribe().getName(),
                                                                        null,
                                                                        saveResultError.getMessage(),
                                                                        sObjects[i].id,
                                                                        true,String.valueOf(i)
                                                                       ));
                }else{
                    validationErrorList.add(new APXFieldValidationError(sObjects[i].getSObjectType().getDescribe().getName(),
                                                                        saveResultError.getFields()[0],
                                                                        saveResultError.getMessage(),
                                                                        sObjects[i].id,
                                                                        false, String.valueOf(i)
                                                                       ));
                }
            }
        }
        return validationErrorList;
    }
    public static List<APXFieldValidationError> getCrudResponseFromDeleteResults(List<SObject> sObjects, List<Database.DeleteResult> deleteResults) {
        List<APXFieldValidationError> validationErrorList = new List<APXFieldValidationError>();
        for(Integer i = 0; i < deleteResults.size(); i++) {
            Database.DeleteResult deleteResult = deleteResults[i];
            List<Database.Error> deleteResultErrors = deleteResult.getErrors();
            for(Integer j = 0; j < deleteResultErrors.size(); j++) {
                Database.Error deleteResultError = deleteResultErrors[j];
                String errorFieldName = TOP_OF_PAGE_ERROR; 
                Boolean isTopOfPageError = true;
                if(Pattern.matches(TOP_OF_PAGE_ERRORCODE_PATTERN, deleteResultError.getMessage()) || deleteResultError.getFields().isEmpty()){
                    validationErrorList.add(new APXFieldValidationError(sObjects[i].getSObjectType().getDescribe().getName(),
                                                                        null,
                                                                        deleteResultError.getMessage(),
                                                                        sObjects[i].id,
                                                                        true,String.valueOf(i)
                                                                       ));
                }else{
                    validationErrorList.add(new APXFieldValidationError(sObjects[i].getSObjectType().getDescribe().getName(),
                                                                        deleteResultError.getFields()[0],
                                                                        deleteResultError.getMessage(),
                                                                        sObjects[i].id,
                                                                        false, String.valueOf(i)
                                                                       ));
                }
            }
        }
        return validationErrorList;
    }
}