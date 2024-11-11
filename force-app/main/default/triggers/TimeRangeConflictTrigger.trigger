/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-11-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger TimeRangeConflictTrigger on Time_Entry__c (before insert, before update) {

    
    if(trigger.isInsert || trigger.isUpdate){
        if(trigger.isBefore){
            TimeRangeConflictHandler.TimeRangeConflictCheck(trigger.new);
        }
    }


}