global class TestPiaData_Dankai_After_R implements Database.Batchable<sObject>, Database.Stateful {

    public String query;
    public String taiNo = '';
    public Decimal adate = 0;

    Public static String PIA_END_NO = System.Label.PIA_END_NO;

    global TestPiaData_Dankai_After_R(String taibangou) {
        // 台番号設定
        this.taiNo = taibangou;
    	this.query = 'SELECT' +
        ' renritucompare__c,' +
        ' renritucompare2__c,' +
        ' renritucompare3__c,' +
        ' renritucompare4__c,' +
        ' renritucompare5__c,' +
        ' renritucompare6__c,' +
        ' renritucompare7__c,' +
        ' renritucompare8__c,' +
        ' renritucompare9__c,' +
        ' renritucompare10__c,' +
        ' renritucompare11__c,' +
        ' renritucompare12__c,' +
        ' renritucompare13__c,' +
        ' renritucompare14__c,' +
        ' dankai_atari__c,' +
        ' dankai_atari2__c,' +
        ' dankai_atari3__c,' +
        ' dankai_atari4__c,' +
        ' dankai_atari5__c,' +
        ' dankai_atari6__c,' +
        ' dankai_atari7__c,' +
        ' dankai_atari8__c,' +
        ' dankai_atari9__c,' +
        ' dankai_atari10__c,' +
        ' dankai_atari11__c,' +
        ' dankai_atari12__c,' +
        ' dankai_atari13__c,' +
        ' dankai_atari14__c,' +
        ' sum_atari__c,' +
        ' sum_kaiten__c,' +
        ' sum_tuujou__c,' +
        ' Name,' +
        ' Id ' +
        ' FROM PIA_SUM__c' +
        ' WHERE Name = :taiNo' +
        ' AND hyoujijunn__c = 1';

        // 最新データの日付を取得する
        PIADATA__c pia =[SELECT id, adate__c FROM piadata__c where Name = :taibangou ORDER BY adate__c DESC LIMIT 1];
        this.adate = pia.adate__c;
        // 既存の最新データを物理削除する
		List<PIA_R__c> dellist = [SELECT Id FROM PIA_R__c WHERE adate__c = :adate AND Name = :taibangou];
        // 削除処理
		if (dellist.size() > 0){
		    Delete dellist;
		    Database.emptyRecycleBin(dellist);
        } 
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<PIA_SUM__c> scope) {

        List<PIA_R__c> listb = new List<PIA_R__c>();
        for(PIA_SUM__c piasum : scope){
            PIA_R__c pia_r = new PIA_R__c();
            pia_r.renritucompare__c = piasum.renritucompare__c;
            pia_r.renritucompare2__c = piasum.renritucompare2__c;
            pia_r.renritucompare3__c= piasum.renritucompare3__c;
            pia_r.renritucompare4__c= piasum.renritucompare4__c;
            pia_r.renritucompare5__c= piasum.renritucompare5__c;
            pia_r.renritucompare6__c= piasum.renritucompare6__c;
            pia_r.renritucompare7__c= piasum.renritucompare7__c;
            pia_r.renritucompare8__c= piasum.renritucompare8__c;
            pia_r.renritucompare9__c= piasum.renritucompare9__c;
            pia_r.renritucompare10__c= piasum.renritucompare10__c;
            pia_r.renritucompare11__c= piasum.renritucompare11__c;
            pia_r.renritucompare12__c= piasum.renritucompare12__c;
            pia_r.renritucompare13__c= piasum.renritucompare13__c;
            pia_r.renritucompare14__c= piasum.renritucompare14__c;
            pia_r.dankai_atari__c= piasum.dankai_atari__c;
            pia_r.dankai_atari2__c= piasum.dankai_atari2__c;
            pia_r.dankai_atari3__c= piasum.dankai_atari3__c;
            pia_r.dankai_atari4__c= piasum.dankai_atari4__c;
            pia_r.dankai_atari5__c= piasum.dankai_atari5__c;
            pia_r.dankai_atari6__c= piasum.dankai_atari6__c;
            pia_r.dankai_atari7__c= piasum.dankai_atari7__c;
            pia_r.dankai_atari8__c= piasum.dankai_atari8__c;
            pia_r.dankai_atari9__c= piasum.dankai_atari9__c;
            pia_r.dankai_atari10__c= piasum.dankai_atari10__c;
            pia_r.dankai_atari11__c= piasum.dankai_atari11__c;
            pia_r.dankai_atari12__c= piasum.dankai_atari12__c;
            pia_r.dankai_atari13__c= piasum.dankai_atari13__c;
            pia_r.dankai_atari14__c= piasum.dankai_atari14__c;
            pia_r.sum_atari__c= piasum.sum_atari__c;
            pia_r.sum_kaiten__c= piasum.sum_kaiten__c;
            pia_r.sum_tuujou__c= piasum.sum_tuujou__c;
            pia_r.Name= piasum.Name;
            pia_r.adate__c= this.adate;
            listb.add(pia_r);
        }
        insert listb;
    }

    global void finish(Database.BatchableContext BC) {

        //３日前のデータを残る
		Decimal adateTmp = getDataTimeByStrYm(this.adate, 8);
        // 台番号
		String taibangouTmp = this.taiNo;

        List<PIA_R__c> dellist = [SELECT Id FROM PIA_R__c WHERE adate__c <= :adateTmp AND Name = :taibangouTmp];
        if (dellist.size() > 0){
            Delete dellist;
            Database.emptyRecycleBin(dellist);
        }
        // サマリーデータを削除する
        List<PIA_SUM__c> dellistSum = [SELECT Id FROM PIA_SUM__c WHERE Name = :taibangouTmp];
        if (dellistSum.size() > 0){
            Delete dellistSum;
            Database.emptyRecycleBin(dellistSum);
        } 


        //次の台の処理へ
        String tmpTaiNo = String.valueOf(Integer.valueOf(taibangouTmp) + 1);
        // if (tmpTaiNo == '705'){
        //     tmpTaiNo = '717';
        // }
        if (this.taiNo != PIA_END_NO){
            TestPiaData_Dankai_R newbatch = new TestPiaData_Dankai_R(tmpTaiNo);
            Database.executeBatch(newbatch);
        }else{
   
            RunOver newbatch = new RunOver();
            Database.executeBatch(newbatch);
        }
    }

    private Decimal getDataTimeByStrYm(Decimal ym, Integer plusMonthNum) {
        String strYm = '20' + String.valueOf(ym.intValue());
        Date inputDate = Date.newInstance(Integer.valueof(strYm.substring(0,4)), Integer.valueof(strYm.substring(4,6)), Integer.valueof(strYm.substring(6)));
        inputDate = inputDate.addDays(plusMonthNum * -1);
        DateTime rs = DateTime.newInstance(inputDate, Time.newInstance(0, 0, 0, 0));
        return Decimal.valueOf(rs.format('yyMMdd'));
    }
}