public with sharing class ProjectTaskController {

    // Constructor
    public ProjectTaskController() {}

    // Fetch all the projects
    @AuraEnabled(cacheable=true)
    public static List<Project__c> getProjects() {
        ProjectTaskService projectTrackerService = new ProjectTaskService();
        return projectTrackerService.fetchProjects();
    }

    // Fetch all the tasks related to a project
    @AuraEnabled(cacheable=true)
    public static List<TaskList__c> getTasksByProject(Id projectId) {
        ProjectTaskService projectTrackerService = new ProjectTaskService();
        return projectTrackerService.fetchTasksByProject(projectId);
    }

    // Create time entry
    //@AuraEnabled
    //public static void createTimeEntry(Id taskId, Date dates, Time fromTime, Time toTime, String description) {
    //    ProjectTaskService projectTrackerService = new ProjectTaskService();
    //    projectTrackerService.createTimeEntry(taskId, dates, fromTime, toTime, description);
    //}

    // Fetch records for the DataTable
    @AuraEnabled(cacheable=true)
    public static List<Time_Entry__c> getRecords(Date startDate, Date endDate) {
        ProjectTaskService projectTrackerService = new ProjectTaskService();
        return projectTrackerService.fetchTimeEntries(startDate, endDate);
    }

    // Fetch favorite tasks for the logged-in user
    @AuraEnabled(cacheable=true)
    public static List<FavroiteTask__c> getFavTasks() {
        ProjectTaskService projectTrackerService = new ProjectTaskService();
        return projectTrackerService.fetchFavoriteTasks();
    }

    // Bulk create time entries
  //  @AuraEnabled
  //  public static void createTimeEntries(List<Time_Entry__c> timeEntries) {
  //      ProjectTaskService projectTrackerService = new ProjectTaskService();
 //       projectTrackerService.createTimeEntries(timeEntries);
  //  }
}