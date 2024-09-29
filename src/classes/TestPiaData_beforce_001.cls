global class TestPiaData_beforce_001 implements Database.Batchable<sObject>,Database.Stateful {

    public String query;
    public String taiNo = '';
    Public static String PIA_END_NO = System.Label.PIA_END_NO;

    global TestPiaData_beforce_001(String taibangou) {
        this.taiNo = taibangou;
        this.query = 'SELECT' +
        ' id, ' +
        ' name, ' +
        ' adate__c, ' +
        ' asort__c, ' +
        ' kaiten__c, ' +
        ' kaiten_keisan__c, ' +
        ' aren__c, ' +
        ' atype__c, ' +
        ' sum_kaiten__c, ' +
        ' sum_atari__c, ' +
        ' sum_tuujou__c ' +
        ' FROM PIADATA__c' +
        ' WHERE name=:taiNo AND atype__c = 1 ORDER BY adate__c DESC, asort__c DESC';
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<PIADATA__c> scope) {
        // 単発数
        Decimal tuijyousu_x =0;
        // 確変当たり数
        Decimal tuijyousu_y =0;

        Decimal kaiten_max =0;

        // 通常当たり数
        Decimal tuijyousu_z = scope.size();
        
        Integer index = 1;

        for(PIADATA__c pia : scope){
            if(kaiten_max < pia.kaiten_keisan__c){
                kaiten_max = pia.kaiten_keisan__c;
            }

            if (pia.aren__c > 1){
                tuijyousu_y +=  pia.aren__c;   
            }else if (pia.aren__c == 1){
                tuijyousu_x += 1;
            }
            index = index + 1;
        }
        try {
            PIADATA__c firstData = [SELECT
            id, 
            kakuhennrennRate__c,
            totunyuuRate__c
            FROM PIADATA__c
            WHERE name=:taiNo AND atype__c = 2 LIMIT 1];

            // 確変連数
            firstData.kakuhennrennRate__c = tuijyousu_y.divide((tuijyousu_z - tuijyousu_x), 3,System.RoundingMode.UP);
            // 突入率
            firstData.totunyuuRate__c = (tuijyousu_z - tuijyousu_x).divide(tuijyousu_z, 3,System.RoundingMode.UP);
            firstData.kaiten_max__c = kaiten_max;
            update firstData;
        }catch (Exception e) {
            throw e;
        }
    }

    global void finish(Database.BatchableContext BC) {

        Integer intTaiNo = Integer.valueOf(this.taiNo);
        String tmpTaiNo = String.valueOf(intTaiNo + 1);
        // if (tmpTaiNo == '705'){
        //     tmpTaiNo = '717';
        // }
        if (this.taiNo != PIA_END_NO){
            // 前日関係設定
            TestPiaData_beforce_001 newbatch = new TestPiaData_beforce_001(tmpTaiNo);
            Database.executeBatch(newbatch);

        }else{
            RunOver newbatch = new RunOver();
            Database.executeBatch(newbatch);
        }
    }
    
}