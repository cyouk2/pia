global class RunOver implements Database.Batchable<sObject> {
    public String query;

    global RunOver() {
        this.query = 'SELECT ID FROM PIA_SUM__c';
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Sobject> scope) {
        
    }

    global void finish(Database.BatchableContext BC) {

    }
}