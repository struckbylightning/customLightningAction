({
    //Generic Method to call server methods. Accepts component, methodName, callback function, parameters to be passed to server method and cacheable as input
    callServer : function(cmp, method, callback, params, cacheable) {
        var action = cmp.get(method);
        debugger;
        if (params) {
            action.setParams(params);
            console.log("Parameters are:"+JSON.stringify(params));
        }
        if (cacheable) {
            action.setStorable();
        }
        cmp.set("v.showSpinner", true);
        
        action.setCallback(this,function(response) {
            cmp.set("v.showSpinner", false);
            var state = response.getState();
            if (state === "SUCCESS") { 
                // pass returned value to callback function
                callback.call(this, response.getReturnValue()); 
            } else if (state === "ERROR") {
                // generic error handler
                var errors = response.getError();
                var errorMsg = '';
                console.log(errors);
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        errorMsg = errors[0].message;
                    }
                } else {
                    errorMsg = "Unknown Error";
                }                
                cmp.set("v.error",errorMsg+",Details:"+JSON.stringify(errors));
                console.log("errorMsg:"+errorMsg);
            }
        });  
        $A.enqueueAction(action);
    },
    merge : function(obj1,obj2){
        var obj3 = {};
        for (var attrname in obj1) { obj3[attrname] = obj1[attrname]; }
        for (var attrname in obj2) { obj3[attrname] = obj2[attrname]; }
        return obj3;
    },
    getCurrentSystemDate : function(addDays,addMonths,addYears){
        debugger;
        var today = new Date();
        var dd = addDays?today.getDate()+addDays:today.getDate();
        var MM = addMonths?today.getMonth()+1+addMonths:today.getMonth()+1;
        var yyyy = addYears?today.getFullYear()+addYears:today.getFullYear();
        if(dd<10){
            dd='0'+dd;
        } 
        if(MM<10){
            MM='0'+MM;
        } 
        return yyyy+'-'+MM+'-'+dd;
    },
    redirectToLightningComponent : function(componentName, params){
        debugger;
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : componentName,
            componentAttributes: params
        });
        evt.fire();            
    },
    redirectToRecord : function(recordId){
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recordId,
            "slideDevName": "detail"
        });
        navEvt.fire();
    },
    fireToast : function(mode, type, title, message){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "mode": mode,
            "type": type,
            "title": title,
            "message": message
        });
        toastEvent.fire();
    }    
})