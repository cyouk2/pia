/**********************************************************************
 * 
 *
 * @url: /services/apexrest/rest
 * @data:
 *  {
        
    }
*************************************************************************/
@RestResource(urlMapping='/piadata/*')
global with sharing class PiadataInset {
    @HttpPost
    global static String doPost(List<PiadataBean> beans) {

        if(beans != null && beans.size() > 0){
            List<PIADATA__c> list1 = [SELECT id FROM PIADATA__c 
                WHERE Name =:beans.get(0).Name 
                AND adate__c = : beans.get(0).adate
            ];
            if(list1 != null && list1.size() > 0){
                return String.valueOf(beans.get(0).adate) + '_'+ String.valueOf(beans.get(0).Name) + '_SAVED';
            }
        }
        List<PIADATA__c> insertList = new List<PIADATA__c>();
        for (PiadataBean bean : beans){

            PIADATA__c pia = new PIADATA__c();
            pia.adate__c = bean.adate;
            pia.Name = bean.Name;
            pia.asort__c = bean.asort;
            pia.kaiten__c = bean.kaiten;
            pia.atype__c = bean.atype;
            pia.aren__c = bean.aren;
            insertList.add(pia);
        }
        try{
            Database.insert(insertList);
            if (System.Label.PIA_END_NO == String.valueOf(beans.get(0).Name)){
                TestPiaDataBatch.insertHistories();
            }
        }catch(Exception e){
            return String.valueOf(beans.get(0).adate) + '_'+ String.valueOf(beans.get(0).Name) + '_NG';
        }
        return String.valueOf(beans.get(0).adate) + '_'+ String.valueOf(beans.get(0).Name) + '_OK';
    }

    global class PiadataBean {
        public PiadataBean () {}
        public Integer adate  { get; set; }
        public String Name { get; set; }
        public Integer asort  { get; set; }
        public Integer kaiten  { get; set; }
        public Integer atype  { get; set; }
        public Integer aren  { get; set; }

    }
}