public with sharing class TimeEntrySelector extends fflib_SObjectSelector {
    
    public TimeEntrySelector() {
        // Initialize the selector with necessary configuration if required
    }

    // Define the fields to be selected
    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
            Time_Entry__c.Id,
            Time_Entry__c.Date__c,
            Time_Entry__c.From_Time__c,
            Time_Entry__c.To_Time__c,
            Time_Entry__c.Description__c,
            Time_Entry__c.projectName__c,
            Time_Entry__c.TaskList__c
        };
    }
    
    // Get the SObject Type
    public Schema.SObjectType getSObjectType(){
        return Time_Entry__c.SObjectType;
    }
    
    // Fetch time entries for a specific date range
    public List<Time_Entry__c> fetchTimeEntries(Date startDate, Date endDate) {
        String query = String.format(
            'SELECT {0} FROM {1} WHERE Date__c >= :startDate AND Date__c <= :endDate', 
            new List<String> {
                getFieldListString(),
                getSObjectName()
            }
        );
        
         List<Time_Entry__c> timeEntry = Database.query(query);
        return timeEntry;
    }
}