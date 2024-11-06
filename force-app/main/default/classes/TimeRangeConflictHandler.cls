/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-06-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class TimeRangeConflictHandler {

    public static void TimeRangeConflictCheck(List<Time_Entry__c> timeEntries){

        //Store the Date
        Set<Date> dates = new Set<Date>();
        for(Time_Entry__c newRecord : timeEntries){
            if (newRecord.Date__c != null && newRecord.From_Time__c != null && newRecord.To_Time__c != null){
                dates.add(newRecord.Date__c);
            }
        }

        // fetch all record with the same date
        List<Time_Entry__c> existingRecords = [SELECT Id, Date__c, From_Time__c, To_Time__c FROM Time_Entry__c WHERE Date__c IN :dates];

        //Store RecordList with the Particular Date
        Map<Date, List<Time_Entry__c>> existingRecordsByDate = new Map<Date, List<Time_Entry__c>>();
        for (Time_Entry__c record : existingRecords) {
            if (!existingRecordsByDate.containsKey(record.Date__c)) {
                existingRecordsByDate.put(record.Date__c, new List<Time_Entry__c>());
            }
            existingRecordsByDate.get(record.Date__c).add(record);
        }

        //Check that new Record overlap or not to the existing record
        for(Time_Entry__c record : timeEntries){
            if(record.Date__c!=null && record.From_Time__c!=null && record.To_Time__c!=null){
                List<Time_Entry__c> recordsForDate = existingRecordsByDate.get(record.Date__c);
                    if(recordsForDate != null){
                        for(Time_Entry__c existingRecord : recordsForDate){
                            if(checkTimeOverlap(record.From_Time__c, record.To_Time__c, existingRecord.From_Time__c, existingRecord.To_Time__c)){
                                record.addError('This time to overlap to the other Entries');
                            }
                        }
                    }
            }
        }
    }
    //Compare Logic 
    public static Boolean checkTimeOverlap(Time startTime1, Time EndTime1 ,Time startTime2, Time endTime2){
        return (startTime1 < endTime2 && endTime1 > startTime2);
    }
}
