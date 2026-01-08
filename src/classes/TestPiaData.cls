global class TestPiaData implements Database.Batchable<sObject>,Database.Stateful {

    public String query;
    public String taiNo = '';
    Public static String PIA_END_NO = System.Label.PIA_END_NO;
    Public static String PIA_START_NO = System.Label.PIA_START_NO;
    Public static Integer MAXLINES = Integer.valueOf(System.Label.MAXLINES);
    
    global TestPiaData(String taibangou) {
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
            ' kaiten_keisan__c ' +
            ' FROM PIADATA__c' +
            ' WHERE name=:taiNo' +
            ' ORDER BY adate__c ASC, asort__c ASC';
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<PIADATA__c> scope) {
        updateData1(scope);
        update scope;

        List<PIADATA__c> klist = [
            SELECT id
            FROM PIADATA__c
            WHERE Name = :taiNo
            AND atype__c = 2
            ORDER BY adate__c DESC, asort__c DESC
        ];

        if(klist != null && klist.size() > 1){
            klist.remove(0);
            DELETE klist;
            Database.emptyRecycleBin(klist);
        }
        List<PIADATA__c> ellist = [
            SELECT id FROM PIADATA__c 
            WHERE name=:taiNo AND atype__c = 1
            ORDER BY adate__c DESC, asort__c DESC];
        List<PIADATA__c> dellist = new List<PIADATA__c>();

        Integer index = 1;

        for(PIADATA__c pia : ellist){
            if (index > MAXLINES){
                dellist.add(pia);
            }
            index = index + 1;
        }

        if(dellist.size() > 0){
            Delete dellist;
            Database.emptyRecycleBin(dellist);
        }

        List<PIADATA__c> updatelist = Database.query(this.query);
        updateData2(updatelist);
        update updatelist;
    }

    global void finish(Database.BatchableContext BC) {

        Integer intTaiNo = Integer.valueOf(this.taiNo);
        String tmpTaiNo = String.valueOf(intTaiNo + 1);

        if (this.taiNo != PIA_END_NO){
            //　集計バッチを実行する
            TestPiaData newbatch = new TestPiaData(tmpTaiNo);
            Database.executeBatch(newbatch);
        } else {
            TestPiaData_beforce newbatch = new TestPiaData_beforce(PIA_START_NO);
            Database.executeBatch(newbatch);
        }
    }

    
    private void updateData1(List<PIADATA__c> scope){

        Decimal X2 = 0;

        Integer index = 1;
        for(PIADATA__c pia : scope){

            if (index > 1){
                if (pia.atype__c == 2){
                    X2 += pia.kaiten__c;
                    if (index == scope.size()){
                        if (pia.kaiten_keisan__c == 0){
                            pia.kaiten_keisan__c = X2;
                            pia.kaiten__c = pia.kaiten_keisan__c;
                        }
                    }
                }else if (pia.asort__c == 1 && pia.atype__c == 1){
                	pia.kaiten_keisan__c = (pia.kaiten__c + X2) ;
                    pia.kaiten__c = pia.kaiten_keisan__c;
                    X2 = 0;
                }else{
                    pia.kaiten_keisan__c = pia.kaiten__c;
                }
            } else {
                if (pia.atype__c == 2){
                    X2 += pia.kaiten__c;
                }else{
                    pia.kaiten_keisan__c = pia.kaiten__c;
                }
            }
            index = index + 1;
        }
    }

    private void updateData2(List<PIADATA__c> scope){
        Integer listsize = scope.size();
        Decimal kaitennsu =0;
        Decimal souatarisu =0;
        Decimal tuijyousu =0;

        Decimal BK_kaitennsu =0;

        Decimal BK_tuijyousu =0;

        Integer index = 1;
        PIADATA__c pia1 = scope.get(0);

        kaitennsu += pia1.kaiten_keisan__c;
        souatarisu += pia1.aren__c;
        tuijyousu +=  (pia1.atype__c == 1? 1:0); 
        
        pia1.sum_kaiten__c = kaitennsu;
        pia1.sum_atari__c = souatarisu;
        pia1.sum_tuujou__c = tuijyousu;
        
        for(PIADATA__c pia : scope){
                
            if (index > 1){
                kaitennsu += pia.kaiten_keisan__c;
                souatarisu += pia.aren__c;
                tuijyousu +=  (pia.atype__c == 1? 1:0); 
                pia.sum_kaiten__c = kaitennsu;
                pia.sum_atari__c = souatarisu;
                pia.sum_tuujou__c = tuijyousu;
            }
            index = index + 1;
        }

        for(PIADATA__c pia2 : scope){
            if (pia2.atype__c == 1){
                pia2.tuujousort__c = pia2.sum_tuujou__c;
            } else {
                pia2.tuujousort__c = pia2.sum_tuujou__c + 1;
            }
        }
    }

}