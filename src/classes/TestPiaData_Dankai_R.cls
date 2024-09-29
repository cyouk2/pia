global class TestPiaData_Dankai_R implements Database.Batchable<sObject>,Database.Stateful {

    public String query;
    public String taiNo = '';
    Public static Integer PIA_R = Integer.valueOf(System.Label.PIA_R);

    global TestPiaData_Dankai_R(String taibangou) {
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
        //' rkbn__c, ' +
        //' rkdrs__c ' +
        // ' skbn__c, ' +
        // ' skdrs__c ' +
        ' FROM PIADATA__c' +
        ' WHERE name=:taiNo AND atype__c = 1 ORDER BY adate__c DESC, asort__c DESC';
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<PIADATA__c> scope) {
        Decimal kaitennsu =0;
        Decimal souatarisu =0;
        Decimal tuijyousu =0;
        // 単発数
        Decimal tuijyousu_x =0;
        // 確変当たり数
        Decimal tuijyousu_y =0;

        Decimal kaiten_max =0;

        // 通常当たり数
        Decimal tuijyousu_z = scope.size();
        
        Integer index = 1;
        Integer index1 = 1;
        Integer indexTEST = 0;
        List<PIADATA__c> listPiatmp = new List<PIADATA__c>();
        List<PIA_SUM__c> pia_sum_list = new List<PIA_SUM__c>();

        List<List<PIADATA__c>> mapPiatmp = new List<List<PIADATA__c>>();


        for(PIADATA__c pia : scope){
            if(kaiten_max < pia.kaiten_keisan__c){
                kaiten_max = pia.kaiten_keisan__c;
            }

            if (pia.aren__c > 1){
                tuijyousu_y +=  pia.aren__c;   
            }else if (pia.aren__c == 1){
                tuijyousu_x += 1;
            }
            if (index == scope.size()) {   
                listPiatmp.add(pia);
                mapPiatmp.add(listPiatmp);     
            } else {
                if (Math.mod(index, PIA_R) == 0){
                    listPiatmp.add(pia);
                    mapPiatmp.add(listPiatmp);
                    
                    listPiatmp = new List<PIADATA__c>();
                } else{
                    listPiatmp.add(pia);
                }
            }
            index = index + 1;
        }
		List<PIADATA__c> listPiatmpFangchaForBK01 = new List<PIADATA__c>();
        for(List<PIADATA__c> listp1 : mapPiatmp){

            PIA_SUM__c sumTmp = new PIA_SUM__c();
            PIADATA__c pia2 = (PIADATA__c)listp1.get(0);
            
            kaitennsu = 0;
            souatarisu = 0;
            tuijyousu = 0;
            sumTmp.Name = pia2.Name;
            
            // 集計回転数
            sumTmp.sum_kaiten__c =pia2.sum_kaiten__c;
            // 集計当たり
            sumTmp.sum_atari__c = pia2.sum_atari__c;
            // 集計通常
            sumTmp.sum_tuujou__c = pia2.sum_tuujou__c;
            
            for(PIADATA__c pia : listp1){
                
                kaitennsu += NullToDecimal(pia.kaiten_keisan__c);
                souatarisu += pia.aren__c;
                if (pia.atype__c == 1){
                    tuijyousu += 1; 
                }
            } 
			// if (PIA_R * indexTEST < scope.size()){
   //              PIADATA__c piaTest = scope.get(PIA_R * indexTEST);
                //piaTest.rkbn__c = PIA_R;
                //piaTest.rkdrs__c = souatarisu;
                //listPiatmpFangchaForBK01.add(piaTest);
            // }
            // 回転数
            sumTmp.dankai_kaitensu__c = kaitennsu;
            // 当たり
            sumTmp.dankai_atari__c = souatarisu;
            // 通常数
            sumTmp.dankai_tuujyou__c = tuijyousu;
            // 表示順
            sumTmp.hyoujijunn__c = index1;
            if(index1 <= 15) {
                pia_sum_list.add(sumTmp);
            } 
			indexTEST += 1;
            index1 += 1;
        }
        INSERT pia_sum_list;
        //UPDATE listPiatmpFangchaForBK01;
        try {
            PIADATA__c firstData = [SELECT
            id,  
            // BK01_PINGJUN_kaiten__c, 
            // BK01_PINGJUN_aren__c, 
            // BK01_STDEV_kaiten__c, 
            // BK01_STDEV_aren__c,
            kakuhennrennRate__c,
            totunyuuRate__c
            FROM PIADATA__c
            WHERE name=:taiNo AND atype__c = 2 LIMIT 1];

            // updateDataForStdev(listPiatmpFangchaForBK01, firstData, 'BK01');

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
        // 前日関係設定
        TestPiaData_Dankai_beforce_R newbatch = new TestPiaData_Dankai_beforce_R(this.taiNo);
        Database.executeBatch(newbatch);
    }

    public Decimal NullToDecimal (Decimal param){
        if (param != null) return param;
        return 0;
    }
}