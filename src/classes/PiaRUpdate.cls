/**********************************************************************
 * 
 *
 * @url: /services/apexrest/rest
 * @data:
 *  {
        
    }
*************************************************************************/
@RestResource(urlMapping='/PiaRUpdate/*')
global with sharing class PiaRUpdate {
    @HttpPost
    global static String doPost(List<PiaRUpdateBean> beans) {

        List<PIA_R__c> objlst = new List<PIA_R__c> ();

        if(beans != null && beans.size() > 0){
            if(beans.get(0).Name == '585'){
                System.debug(beans.get(0).Name);
                 
                List<PIA_R__c> objlsts = [SELECT id FROM PIA_R__c];
                delete objlsts;
                Database.emptyRecycleBin(objlsts);
            }
            for (PiaRUpdateBean bean : beans){
                List<String> lst = bean.inputupString.split('#');
             
                for(Integer i = 0; i < lst.size();i++){
                    PIA_R__c robj = new PIA_R__c();
                    robj.Name = bean.Name;
                    robj.index__c = lst.size()-i;
                    robj.step1__c = Integer.valueOf(lst.get(i));
                    objlst.add(robj);
                }
            }
            try{
                 Database.Insert(objlst);
                
            }catch(Exception e){
                return 'RUNRESULT_NG';
            }
            return 'RUNRESULT_OK';
        }
        return 'OK';
    }

    global class PiaRUpdateBean {
        public PiaRUpdateBean () {}
        public String Name { get; set; }
        public String inputupString  { get; set; }

    }
}