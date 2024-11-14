public with sharing class FavTaskSelector extends fflib_SObjectSelector {
    
    public FavTaskSelector() {
        // Initialize the selector with necessary configuration if required
    }

    // Define the fields to be selected
    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
            FavroiteTask__c.Id,
            FavroiteTask__c.Task_Name__c,
            FavroiteTask__c.User__r.Name,
            FavroiteTask__c.Project__c
        };
    }
    
    // Get the SObject Type
    public Schema.SObjectType getSObjectType(){
        return FavroiteTask__c.SObjectType;
    }
    
    // Fetch favorite tasks for the current user
    public List<FavroiteTask__c> fetchFavTasks() {
        Id userId = UserInfo.getUserId();
        String query = String.format(
            'SELECT {0} FROM {1} WHERE User__c = :userId', 
            new List<String> {
                getFieldListString(),
                getSObjectName()
            }
        );
        
        List<FavroiteTask__c> FavTask = Database.query(query);
        return FavTask;
    }
}