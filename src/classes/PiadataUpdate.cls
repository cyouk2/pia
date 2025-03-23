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
        
        delete [SELECT id FROM PIA_R__c];
        if(beans != null && beans.size() > 0){
            for (PiadataUpdateBean bean : beans){
                PIA_R__c robj = new PIA_R__c();



            }
            
            for (PIADATA__c pia : list1){
                pia.inputup163__c = maps.get(pia.Name).inputup163;
                pia.inputup97__c = maps.get(pia.Name).inputup97;
                pia.inputunder63__c = maps.get(pia.Name).inputunder63;
                pia.inputunder40__c = maps.get(pia.Name).inputunder40;
                pia.inputup80__c = maps.get(pia.Name).inputup80;
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