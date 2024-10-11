/**********************************************************************
 * 
 *
 * @url: /services/apexrest/rest
 * @data:
 *  {
        
    }
*************************************************************************/
@RestResource(urlMapping='/piadataupdate/*')
global with sharing class PiadataUpdate {
    @HttpPost
    global static String doPost(List<PiadataUpdateBean> beans) {

        if(beans != null && beans.size() > 0){
            List<PIADATA__c> uupdateList = new List<PIADATA__c>();

            for (PiadataUpdateBean bean : beans){
                List<PIADATA__c> list1 = [SELECT id,inputup163__c,inputup97__c,inputunder63__c FROM PIADATA__c 
                    WHERE Name =:beans.get(0).Name
                    AND atype__c = 2
                ];
                PIADATA__c pia = list1.get(0);
                
                pia.inputup163__c = bean.inputup163;
                pia.inputup97__c = bean.inputup97;
                pia.inputunder63__c = bean.inputunder63;
                uupdateList.add(pia);
            }
            try{
                 Database.update(uupdateList);
            }catch(Exception e){
                return String.valueOf(beans.get(0).Name) + '_NG';
            }
            return String.valueOf(beans.get(0).Name) + '_OK';
        }
        return '_OK';
    }

    global class PiadataUpdateBean {
        public PiadataUpdateBean () {}
        public String Name { get; set; }
        public Integer inputup163  { get; set; }
        public Integer inputup97  { get; set; }
        public Integer inputunder63  { get; set; }

    }
}