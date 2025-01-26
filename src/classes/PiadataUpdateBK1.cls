@RestResource(urlMapping='/piadataupdatebk1/*')
global with sharing class PiadataUpdateBK1 {
    @HttpPost
    global static String doPost(List<PiadataUpdateBean> beans) {
        Map<String, PiadataUpdateBean> maps= new Map<String, PiadataUpdateBean>();
        if(beans != null && beans.size() > 0){
            for (PiadataUpdateBean bean : beans){
                maps.put(bean.Name,bean);
            }
            List<PIADATA__c> list1 = [SELECT id,name, bk_inputup163__c,bk_inputup97__c,bk_inputunder63__c,bk_inputup80__c,bk_inputunder40__c FROM PIADATA__c 
                    WHERE atype__c = 2
            ];
            for (PIADATA__c pia : list1){
                pia.bk_inputup163__c = maps.get(pia.Name).inputup163;
                pia.bk_inputup97__c = maps.get(pia.Name).inputup97;
                pia.bk_inputunder63__c = maps.get(pia.Name).inputunder63;
                pia.bk_inputunder40__c = maps.get(pia.Name).inputunder40;
                pia.bk_inputup80__c = maps.get(pia.Name).inputup80;
            }
            
            try{
                 Database.update(list1);
            }catch(Exception e){
                return 'RUNRESULT_NG';
            }
            return 'RUNRESULT_OK';
        }
        return 'OK';
    }

    global class PiadataUpdateBean {
        public PiadataUpdateBean () {}
        public String Name { get; set; }
        public Integer inputup163  { get; set; }
        public Integer inputup97  { get; set; }
        public Integer inputunder63  { get; set; }
        public Integer inputunder40  { get; set; }
        public Integer inputup80  { get; set; }

    }
}