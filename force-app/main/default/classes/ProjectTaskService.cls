/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-18-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class ProjectTaskService {
    
    /* -----------------------------------------------------
			Fetch all the Project    
     -----------------------------------------------------*/
    public List<Project__c> fetchProjects(){
        ProjectTrackerSelector projectSelector = new ProjectTrackerSelector();
        System.debug('Instantiating TaskSelector');
        List<Project__c> projectList = projectSelector.fetchProjects();
         System.debug('Fetched Task List: ' + projectList);
        return projectList;
    }
    
    /* -----------------------------------------------------
			Fetch the Task related to the Project    
     -----------------------------------------------------*/
    
    public List<TaskList__c> fetchTasksByProject(Id projectId){
        TaskSelector taskSelector = new TaskSelector();
        List<TaskList__c> taskList = taskSelector.fetchTasksByProject(projectId);
        System.debug('Fetched Task List: ' + taskList);
        return taskList;
    }
    
     /* -----------------------------------------------------
			3. class me Dobut h Time Entry Create   
     -----------------------------------------------------*/
    public void createTimeEntry(Id taskId, Date dates, Time fromTime, Time toTime, String description){
        TaskSelector taskSelector = new TaskSelector();
		TaskList__c task = taskSelector.getTaskById(taskId);
        TimeEntryDomain.createTimeEntry(task, dates, fromTime, toTime, description);
    }  
	    
    
    
     /* -----------------------------------------------------
			       4. Fetch the Time Enrty    
     -----------------------------------------------------*/
    public List<Time_Entry__c> fetchTimeEntries(Date startDate, Date endDate){
        TimeEntrySelector TimeEntrySelector = new TimeEntrySelector();
        List<Time_Entry__c> taskList = TimeEntrySelector.fetchTimeEntries(startDate, endDate);
        return taskList;
    }
    
    /* -----------------------------------------------------
			    5. Fetch the User Favorite Task   
     -----------------------------------------------------*/
    public List<FavroiteTask__c> fetchFavoriteTasks() {
        FavTaskSelector favTaskSelector = new FavTaskSelector();
        List<FavroiteTask__c> FavTask = favTaskSelector.fetchFavTasks();
        return FavTask;
    }

     /* -------------------------------------------------------------
			    6. Create the bulk Time Entries for the Data Table   
     ---------------------------------------------------------------*/
        public void createTimeEntr(List<Time_Entry__c> timeEntries) {
        //TimeEntryDomain TED = new TimeEntryDomain();
        TimeEntryDomain.createTimeEntr(timeEntries);
    }
}