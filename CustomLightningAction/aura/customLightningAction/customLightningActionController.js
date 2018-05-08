({
    handleModalButtonClick: function(component, evt, helper) {
        var showConfirmMsgModal = component.get("v.showConfirmMsgModal");
        if(showConfirmMsgModal == 'Always'){
            helper.showConfirmModal(component);
        }else if(showConfirmMsgModal == 'Conditional'){
            helper.callApexMethod(component, 'c.'+component.get("v.showConfirmApexMethodName"), 'CHECK_CONFIRM');
        }else if(showConfirmMsgModal == 'ValidatePriorToRedirecting'){
            helper.callApexMethod(component, 'c.'+component.get("v.showConfirmApexMethodName"), 'CHECK_REDIRECT');
        }else{
            helper.performTheRequiredAction(component);          
        }      
    },
    confirmModalYes: function(component, evt, helper) { 
        helper.hideConfirmModal(component);
        helper.performTheRequiredAction(component); 
    },
    hideConfirmModal: function(component, evt, helper){
        helper.hideConfirmModal(component);
    }
})