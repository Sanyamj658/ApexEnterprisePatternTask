/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-18-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class ProjectTaskController {

    // Constructor
    public ProjectTaskController() {}

    // Fetch all the projects
    @AuraEnabled(cacheable=true)
    public static List<Project__c> getProjects() {
        ProjectTaskService projectTaskService = new ProjectTaskService();
        return projectTaskService.fetchProjects();
    }

    // Fetch all the tasks related to a project
    @AuraEnabled(cacheable=true)
    public static List<TaskList__c> getTasksByProject(Id projectId) {
        ProjectTaskService projectTaskService = new ProjectTaskService();
        return projectTaskService.fetchTasksByProject(projectId);
    }

    // Create time entry
    @AuraEnabled
    public static void createTimeEntry(Id taskId, Date dates, Time fromTime, Time toTime, String description) {
        ProjectTaskService projectTaskService = new ProjectTaskService();
        projectTaskService.createTimeEntry(taskId, dates, fromTime, toTime, description);
    }

    // Fetch records for the DataTable
    @AuraEnabled(cacheable=true)
    public static List<Time_Entry__c> getRecords(Date startDate, Date endDate) {
        System.debug('startDate and endDate'+startDate +'---'+startDate);
        ProjectTaskService projectTaskService = new ProjectTaskService();
        return projectTaskService.fetchTimeEntries(startDate, endDate);
    }

    // Fetch favorite tasks for the logged-in user
    @AuraEnabled(cacheable=true)
    public static List<FavroiteTask__c> getFavTasks() {
        ProjectTaskService projectTaskService = new ProjectTaskService();
        return projectTaskService.fetchFavoriteTasks();
    }

    // Bulk create time entries from the dataTable [Fav task]
    @AuraEnabled
    public static void createTimeEntries(List<Time_Entry__c> timeEntries) {
        ProjectTaskService projectTaskService = new ProjectTaskService();
        projectTaskService.createTimeEntr(timeEntries);
    }
}