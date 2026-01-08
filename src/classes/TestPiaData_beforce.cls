global class TestPiaData_beforce implements Database.Batchable<sObject> {
    public String query;
    public String taiNo = '';
    Public static String PIA_START_NO = System.Label.PIA_START_NO;  
    Public static String PIA_END_NO = System.Label.PIA_END_NO;
    global TestPiaData_beforce(String taibangou) {
        this.taiNo = taibangou;
        this.query = 'SELECT id FROM PIADATA__c WHERE name=:taiNo ORDER BY tuujousort__c ASC' ;
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<PIADATA__c> scope) {
        Integer index2 = -1;

        for(PIADATA__c pia : scope){
            if(index2 >= 0){
                PIADATA__c piaTmp = (PIADATA__c)(scope.get(index2));
                pia.beforce__c = piaTmp.Id;
            }
            index2 = index2 + 1;
        }
        update scope;
    }

    global void finish(Database.BatchableContext BC) {
        Integer intTaiNo = Integer.valueOf(this.taiNo);
        String tmpTaiNo = String.valueOf(intTaiNo + 1);
        // if (tmpTaiNo == '705'){
        //     tmpTaiNo = '717';
        // }
        if (this.taiNo != PIA_END_NO){
            //　集計バッチを実行する
            TestPiaData_beforce newbatch = new TestPiaData_beforce(tmpTaiNo);
            Database.executeBatch(newbatch);
        } else {
            RunOver newbatch = new RunOver();
            Database.executeBatch(newbatch);
        }
    }
}