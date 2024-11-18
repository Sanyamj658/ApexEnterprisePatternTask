/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-18-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class ProjectTrackerSelector extends fflib_sobjectSelector {
    public ProjectTrackerSelector() {

    }
    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField>{
            Project__c.Id,
            Project__c.CreatedById,
            Project__c.Name
        };
    }
    

    public Schema.SObjectType getSObjectType(){
        return Project__c.SObjectType;
    }
    
    public List<Project__c> fetchProjects(){
        String query = String.format('SELECT {0} FROM {1}  WHERE Id IN (Select ParentId FROM Project__Share)', 
                    new List<String>{
                        getFieldListString(),
                        getSObjectName()
                    });
        List<Project__c> projects = Database.query(query);
		SYSTEM.DEBUG('projects>>' + projects);
        return projects;
    }
    
 
}