/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-18-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class ProjectTrackerController {

    //Fetch all the Project
    @AuraEnabled(cacheable=true)
    public static List<Project__c> getProjects() {
        return [SELECT Id, Name FROM Project__c]; 
    }

    //Fetch all the task related to the project
    @AuraEnabled(cacheable=true)
    public static List<TaskList__c> getTasksByProject(Id projectId) {
        return [SELECT Id, Name FROM TaskList__c WHERE Project__c = :projectId];
    }

    //create time entry 
    @AuraEnabled
    public static void createTimeEntry(Id taskId, Date dates, Time fromTime, Time toTime, String description) {
        TaskList__c existingTask = [SELECT Id, Name, Project__r.Name FROM TaskList__c WHERE Id = :taskId LIMIT 1];
        if (existingTask != null) {
            Time_Entry__c timeEntry = new Time_Entry__c();
            timeEntry.Name = existingTask.Name;
            timeEntry.TaskList__c = existingTask.Id; 
            timeEntry.Date__c = dates;
            timeEntry.Description__c = description;
            timeEntry.From_Time__c = fromTime;
            timeEntry.To_Time__c = toTime;
            timeEntry.projectName__c = existingTask.Project__r.Name;
            insert timeEntry;
        } else {
            throw new AuraHandledException('Task not found.');
        }
    }
    

    //DataTable Data
    @AuraEnabled(cacheable=true)
    public static List<Time_Entry__c> getRecords(Date startDate, Date endDate) {
            if(startDate == null && endDate == null){
                Date myDate = Date.today();
                 startDate = myDate.toStartofWeek();
                 endDate = myDate.toStartofWeek().addDays(6);
                
            }            
        return [
            SELECT  projectName__c, TaskList__c, Date__c, From_Time__c, To_Time__c, Description__c
            FROM Time_Entry__c
            WHERE Date__c >= :startDate AND Date__c <= :endDate
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<FavroiteTask__c> getFavTasks() {
        Id userId = UserInfo.getUserId(); 
        return [SELECT Id, Name, Task_Name__c, User__r.Name, Project__c FROM FavroiteTask__c WHERE User__c = :userId];
    }
    


    @AuraEnabled
    public static void createTimeEntr(List<Time_Entry__c> timeEntries) {
        System.debug(timeEntries);
        List<Time_Entry__c> timeEntriesToInsert = new List<Time_Entry__c>();
        System.debug('time entries -->'+ timeEntries);
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
            System.debug('inserted successfully -->'+timeEntriesToInsert);
        } catch (DmlException e) {
            throw new AuraHandledException('Error saving Time Entries: ' + e.getMessage());
        }
    }


}