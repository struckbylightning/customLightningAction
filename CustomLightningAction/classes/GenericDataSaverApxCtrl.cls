public class GenericDataSaverApxCtrl {
    
    @auraEnabled
    public static LightningServerResponse doDML(List<SObject> sObjects, String operation){
        Savepoint sp = Database.setSavepoint();
        Map<String, Object> objectData = new map<String, Object>();
        Boolean isSuccessful;
        String message;
        List<APXFieldValidationError> fieldValidationErrors; 
        List<SObject> recordsToBeInserted = new List<SObject>();
        List<SObject> recordsToBeUpdated = new List<SObject>();
        List<SObject> recordsToBeDeleted = new List<SObject>();
        for(SObject sOb: sObjects){
            if((operation.equalsIgnoreCase('Upsert') || operation.equalsIgnoreCase('Update') )
               && String.isNotBlank(sOb.Id)){
                   recordsToBeUpdated.add(sOb);
               }else if(operation.equalsIgnoreCase('Upsert') || operation.equalsIgnoreCase('Insert')){
                   recordsToBeInserted.add(sOb);
               }else if(operation.equalsIgnoreCase('Delete')){
                   recordsToBeDeleted.add(sOb);
               }
        }	
        
        List<Database.SaveResult> saveResults = new List<Database.SaveResult>();
        if(!recordsToBeInserted.isEmpty()) 
            saveResults.addAll(Database.insert(recordsToBeInserted, false));
        if(!recordsToBeUpdated.isEmpty())
            saveResults.addAll(Database.update(recordsToBeUpdated, false));
        if(!saveResults.isEmpty()){
            recordsToBeUpdated.addAll(recordsToBeInserted);
            fieldValidationErrors = CrudResponseApxCtrl.getCrudResponseFromSaveResults(recordsToBeUpdated, saveResults);
            if(fieldValidationErrors.isEmpty()){
                objectData.put('upsertedRecords', recordsToBeUpdated);
                message = 'Record has been successfully updated.';
                isSuccessful = true;
            }else{
                objectData.put('upsertedRecords', recordsToBeUpdated);
                message = 'There are errors on this page. Please correct them to proceed.';
                isSuccessful = false;
                Database.rollback(sp);
            }
        }
        List<Database.DeleteResult> deleteResults = new List<Database.DeleteResult>();
        if(!recordsToBeDeleted.isEmpty()) 
            deleteResults.addAll(Database.delete(recordsToBeDeleted, false));
        if(!deleteResults.isEmpty()){
            fieldValidationErrors = CrudResponseApxCtrl.getCrudResponseFromDeleteResults(recordsToBeDeleted, deleteResults);
            if(fieldValidationErrors.isEmpty()){
                objectData.put('deletedRecords', recordsToBeUpdated);
                message = 'Record has been successfully deleted.';
                isSuccessful = true;
            }else{
                objectData.put('deletedRecords', recordsToBeUpdated);
                message = 'There are errors on this page. Please correct them to proceed.';
                isSuccessful = false;
                Database.rollback(sp);
            }
        }
        return new LightningServerResponse(isSuccessful, message, objectData, fieldValidationErrors);
    }
}