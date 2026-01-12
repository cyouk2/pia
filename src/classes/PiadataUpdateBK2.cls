@RestResource(urlMapping='/piadataupdatebk2/*')
global with sharing class PiadataUpdateBK2 {
    @HttpPost
    global static String doPost(List<String> beans) {

        Map<String, String> maps= new Map<String, String>();
        system.debug(beans);
        if(beans != null && beans.size() > 0){
            for (String item : beans) {
                maps.put(getValueByKey(item,'Name'), item);
            }
            List<PIADATA__c> list1 = [SELECT id,name, data1__c,data2__c,data3__c,data4__c,data5__c FROM PIADATA__c 
                WHERE atype__c = 2 and name in :maps.keySet()
            ];
            
            for (PIADATA__c pia : list1){
                for(Integer i = 1; i <= 5; i++){
                    String colName = 'data'+i;
                    String data1 = getValueByKey(maps.get(pia.Name),colName);
                    if (data1 != null){
                        pia.put(colName+'__c',Integer.ValueOf(data1));
                    }
                }
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

    public static String getValueByKey(String itemMap, String strKey){
        // System.debug(itemMap);
        itemMap = itemMap.replace('\'','"');
        JSONParser parser = JSON.createParser(itemMap);

        while (parser.nextToken() != null) {
            // 2. 寻找特定字段
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                (parser.getText() == strKey)) {
                
                // 移动到下一个 Token 以获取值
                parser.nextToken();
                System.debug(strKey + ' : ' + parser.getText()); // 输出: success
                return parser.getText();
            }
        
        }
        return null;
    }
}