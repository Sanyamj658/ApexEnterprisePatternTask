/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-18-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class TaskSelector extends fflib_SObjectSelector {
    
    public TaskSelector() {
        // Initialize the selector with necessary configuration if required
    }

    // Define the fields to be selected
    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
            TaskList__c.Id,
            TaskList__c.Name,
            TaskList__c.Project__c
            
        };
    }
    
    // Get the SObject Type
    public Schema.SObjectType getSObjectType(){
        return TaskList__c.SObjectType;
    }
    
    // Fetch tasks related to a specific project
    public List<TaskList__c> fetchTasksByProject(Id projectId) {
        String query = String.format(
            'SELECT {0} FROM {1} WHERE Project__c = :projectId', 
            new List<String> {
                getFieldListString(),
                getSObjectName()
            }
        );
        
        List<TaskList__c> tasks = Database.query(query);
        return tasks;
    }
    
     public TaskList__c getTaskById(Id taskId) {
              String query = String.format(
            'SELECT {0} FROM {1} WHERE Id = :taskId LIMIT 1', 
            new List<String> {
                getFieldListString(),
                getSObjectName()
            }
        );
         
         TaskList__c task = Database.query(query);
         return task;
    }
}