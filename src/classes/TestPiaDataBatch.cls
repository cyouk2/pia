public with sharing class TestPiaDataBatch {
    Public static String PIA_START_NO = System.Label.PIA_START_NO;

    /* 
        TestPiaDataBatch.insertHistories();
    */
    public static void insertHistories(){
        TestPiaData  newbatch = new TestPiaData(PIA_START_NO);
        Database.executeBatch(newbatch);
    }

    /* 
        TestPiaDataBatch.start_S();
    */
    // public static void start_S(){
    //     TestPiaData_Dankai newbatch = new TestPiaData_Dankai(PIA_START_NO);
    //     Database.executeBatch(newbatch);
    // }
    /* 
        TestPiaDataBatch.start_R();
    */

    //  public static void start_R(){
    //     TestPiaData_Dankai_R newbatch = new TestPiaData_Dankai_R(PIA_START_NO);
    //     Database.executeBatch(newbatch);
    // }
}