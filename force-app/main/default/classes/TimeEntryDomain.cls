/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-18-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class TimeEntryDomain {

    public static void createTimeEntry(TaskList__c task, Date dates, Time fromTime, Time toTime, String description) {
        Time_Entry__c timeEntry = new Time_Entry__c();
        timeEntry.Name = task.Name;
        timeEntry.TaskList__c = task.Id;
        timeEntry.Date__c = dates;
        timeEntry.Description__c = description;
        timeEntry.From_Time__c = fromTime;
        timeEntry.To_Time__c = toTime;
        timeEntry.ProjectName__c = task.Project__r.Name;

        insert timeEntry;
    }
    
     public static void createTimeEntr(List<Time_Entry__c> timeEntries) {
        List<Time_Entry__c> timeEntriesToInsert = new List<Time_Entry__c>();

        for (Time_Entry__c entry : timeEntries) {
            Time_Entry__c timeEntry = new Time_Entry__c();
            timeEntry.Name = entry.Name;
            timeEntry.projectName__c = entry.projectName__c;
            timeEntry.Date__c = entry.Date__c;
            timeEntry.From_Time__c = entry.From_Time__c;
            timeEntry.To_Time__c = entry.To_Time__c;
            timeEntry.Description__c = entry.Description__c;
            
            timeEntriesToInsert.add(timeEntry);
        }
        try {
            insert timeEntriesToInsert;
            System.debug('Inserted successfully -->' + timeEntriesToInsert);
        } catch (DmlException e) {
            throw new AuraHandledException('Error saving Time Entries: ' + e.getMessage());
        }
    }
}