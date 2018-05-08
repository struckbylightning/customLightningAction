({
    performTheRequiredAction : function(component, eventParams) {
        var callApexOrLaunchComponent = component.get("v.callApexOrLaunchComponent").toLowerCase();
        if(callApexOrLaunchComponent == 'component'){
            var loadingType = component.get("v.componentLoadType").toLowerCase();
            if(loadingType == 'modal'){
                this.showComponentInModal(component);
            }else if(loadingType == 'redirect'){
                this.redirectToComponent(component);
            }   
        }else if(callApexOrLaunchComponent == 'apex'){
            debugger;
            var apexMethodName = "c."+component.get("v.apexMethodName");
            this.callApexMethod(component, apexMethodName, 'EXECUTE_APEX');
        }else{
            var eventToBeFired = $A.get(component.get("v.eventName"));
            console.log(eventParams);
            debugger;
            eventToBeFired.setParams(JSON.parse(eventParams));
            eventToBeFired.fire();            
        }
    },
    callApexMethod: function(component, apexMethodName, checkConditionalConfirm){
        var methodAttributes = {};
        methodAttributes[component.get("v.recordIdAttribute")] = component.get("v.recordId");
        this.callServer(component, apexMethodName, 
                        function(response){
                            debugger;
                            var callApexOrLaunchComponent = component.get("v.callApexOrLaunchComponent");
                            if(checkConditionalConfirm == 'CHECK_CONFIRM'){
                                if(response.objectData.showConfirmMessage && response.objectData.showConfirmMessage == true){
                                    this.showConfirmModal(component);
                                }else{
                                    this.performTheRequiredAction(component); 
                                }
                            }else if(checkConditionalConfirm == 'CHECK_REDIRECT'){
                                if(response.objectData && response.objectData.redirect == true){
                                    var eventParams;
                                    if(response.objectData && response.objectData.eventParams){
                                        eventParams = response.objectData.eventParams;
                                    }
                                    this.performTheRequiredAction(component, eventParams); 
                                }else{
                                    this.fireToast("error","Error!", response.message);    
                                }
                            }else{
                                debugger;
                                if(response.isSuccessful == true){
                                    this.fireToast("success", "Success!", response.message);
                                }else{
                                    this.fireToast("error", "Error!", response.message);                                    
                                }
                            }
                        }
                        , methodAttributes, false);
    },
    fireToast : function(type, title, message){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "mode": 'sticky',
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    },
    showComponentInModal: function(component) {
        debugger;
        var modalBody;
        var componentName = component.get("v.componentName");//"c:revisitCountyRatePlan"
        var params = {"recordId": component.get("v.recordId")};
        if(componentName){
            $A.createComponent(componentName, params,
                               function(content, status) {
                                   if (status === "SUCCESS") {
                                       modalBody = content;
                                       component.find('modalOverlay').showCustomModal({
                                           header: component.get("v.buttonLabel"),
                                           body: modalBody,
                                           showCloseButton: true,
                                           cssClass: "slds-modal_large"
                                       })
                                   }
                               });
        }
    },
    redirectToComponent: function(component) {
        var evt = $A.get("e.force:navigateToComponent");
        var componentAttributes = {};
        componentAttributes[component.get("v.recordIdAttribute")] = component.get("v.recordId");
        componentAttributes['sObjectName'] = component.get("v.sObjectName");
        
        console.log(componentAttributes);
        
        evt.setParams({
            componentDef : component.get("v.componentName"),
            componentAttributes: componentAttributes
        });
        evt.fire();            
    },
    showConfirmModal: function(component){  
        $A.util.addClass(component.find('confirmMsgModal'), 'slds-fade-in-open');
        $A.util.addClass(component.find('backDrop'), 'slds-backdrop--open');
    },
    hideConfirmModal: function(component){
        $A.util.removeClass(component.find('backDrop'),'slds-backdrop--open');
        $A.util.removeClass(component.find('confirmMsgModal'), 'slds-fade-in-open');        
    }
})