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
			3. class me Dobut h Fetch all the Project    
     -----------------------------------------------------*/
    
    
    
    
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

}