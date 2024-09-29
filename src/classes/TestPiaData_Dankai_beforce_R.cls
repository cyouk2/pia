global class TestPiaData_Dankai_beforce_R implements Database.Batchable<sObject>,Database.Stateful {

    public String query;
    public String taiNo = '';
    Public static String PIA_END_NO = System.Label.PIA_END_NO;
    global TestPiaData_Dankai_beforce_R(String taibangou) {
        this.taiNo = taibangou;
        this.query = 'SELECT id FROM PIA_SUM__c WHERE name=:taiNo ORDER BY hyoujijunn__c DESC' ;
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<PIA_SUM__c> scope) {
        Integer index2 = -1;

        for(PIA_SUM__c pia : scope){
            if(index2 >= 0){
                PIA_SUM__c piaTmp = (PIA_SUM__c)(scope.get(index2));
                pia.beforce__c = piaTmp.Id;
            }
            index2 = index2 + 1;
        }
        update scope;
    }

    global void finish(Database.BatchableContext BC) {
        TestPiaData_Dankai_After_R newbatch = new TestPiaData_Dankai_After_R(this.taiNo);
        Database.executeBatch(newbatch);
    }
}