global class TestPiaData_Stdev implements Database.Batchable<sObject>,Database.Stateful {

    public String query;
    public String taiNo = '';
    Public static String PIA_END_NO = System.Label.PIA_END_NO;
    Public static String PIA_START_NO = System.Label.PIA_START_NO;

    global TestPiaData_Stdev(String taibangou) {
        this.taiNo = taibangou;
        this.query = 'SELECT' +
            ' id,' +
            ' name,' +
            ' adate__c,' +
            ' asort__c,' +
            ' kaiten__c,' +
            ' aren__c,' +
            ' atype__c,' +
            ' sum_kaiten__c,' +
            ' sum_atari__c,' +
            ' sum_tuujou__c,' +
            ' tuujousort__c,' +
            ' bk_sum_kaiten__c,' +
            ' bk_sum_atari__c,' +
            ' bk_sum_tuujou__c,' +
            ' bk_tuujousort__c' +
            ' FROM PIADATA__c' +
            ' WHERE name=:taiNo' +
            ' ORDER BY adate__c DESC, asort__c DESC';
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<PIADATA__c> scope) {
        updateData1(scope);
        update scope;

    }

    global void finish(Database.BatchableContext BC) {

        // List<PIADATA__c> klist = [SELECT id FROM PIADATA__c
        //     WHERE Name = :taiNo AND kaiten_keisan__c = null AND atype__c = 2];
        // if(klist != null && klist.size() > 0){
        //     DELETE klist;
        //     Database.emptyRecycleBin(klist);
        // }

        // Integer intTaiNo = Integer.valueOf(this.taiNo);
        // String tmpTaiNo = String.valueOf(intTaiNo + 1);
        // if (this.taiNo != PIA_END_NO){
        //     //　集計バッチを実行する
        //     TestPiaData newbatch = new TestPiaData(tmpTaiNo);
        //     Database.executeBatch(newbatch);
        // } else {
        //     // 昨日参照関係を作成する
        //     TestPiaData_Delete newbatch2 = new TestPiaData_Delete(2);
        //     Database.executeBatch(newbatch2);
        // }
    }

    
    private void updateData1(List<PIADATA__c> scope){
        Decimal kaitennsu =0;
        Decimal souatarisu =0;
        Decimal re_rows = scope.size();

        for(PIADATA__c pia : scope){    
            kaitennsu += pia.kaiten__c;
            souatarisu += pia.aren__c;
        }
        // pijun 
		Decimal kaitennsu_pingjun = kaitennsu/re_rows;
		Decimal souatarisu_pingjun = souatarisu/re_rows;
		Double kaitennsu_fangcha = 0;
		Double souatarisu_fangcha = 0;
        for(PIADATA__c pia : scope){
        	kaitennsu_fangcha += (pia.kaiten__c-kaitennsu_pingjun).pow(2);
        	souatarisu_fangcha += (pia.aren__c-souatarisu_pingjun).pow(2);
        }

        Decimal kaitennsu_biaozhuncha = Math.sqrt(kaitennsu_fangcha / re_rows);
        Decimal souatarisu_biaozhuncha = Math.sqrt(souatarisu_fangcha / re_rows);
        System.debug('kaitennsu_biaozhuncha');
        System.debug(kaitennsu_biaozhuncha.divide(1, 2,System.RoundingMode.UP));
        System.debug('souatarisu_biaozhuncha');
        System.debug(souatarisu_biaozhuncha.divide(1, 2,System.RoundingMode.UP));

        System.debug('kaitennsu_pingjun');
        System.debug(kaitennsu_pingjun.divide(1, 2,System.RoundingMode.UP));
        System.debug('souatarisu_pingjun');
        System.debug(souatarisu_pingjun.divide(1, 2,System.RoundingMode.UP));

    }
}