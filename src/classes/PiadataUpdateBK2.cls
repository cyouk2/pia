@RestResource(urlMapping='/piadataupdatebk2/*')
global with sharing class PiadataUpdateBK2 {
    @HttpPost
    global static String doPost(List<PiadataUpdateBean> beans) {
        Map<String, PiadataUpdateBean> maps= new Map<String, PiadataUpdateBean>();
        if(beans != null && beans.size() > 0){
            for (PiadataUpdateBean bean : beans){
                maps.put(bean.Name,bean);
            }
            List<PIADATA__c> list1 = [SELECT id,name, data1__c,data2__c,data3__c,data4__c,data5__c FROM PIADATA__c 
                    WHERE atype__c = 2 and name in :maps.keySet()
            ];
            for (PIADATA__c pia : list1){
                pia.data1__c = maps.get(pia.Name).data1;
                pia.data2__c = maps.get(pia.Name).data2;
                pia.data3__c = maps.get(pia.Name).data3;
                pia.data4__c = maps.get(pia.Name).data4;
                pia.data5__c = maps.get(pia.Name).data5;
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
        public Integer data1  { get; set; }
        public Integer data2  { get; set; }
        public Integer data3  { get; set; }
        public Integer data4  { get; set; }
        public Integer data5 { get; set; }
    }
}