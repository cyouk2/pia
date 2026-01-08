public with sharing class TestPiaDataBatch {
    Public static String PIA_START_NO = System.Label.PIA_START_NO;

    /* 
        TestPiaDataBatch.insertHistories();
    */
    public static void insertHistories(){
        TestPiaData  newbatch = new TestPiaData(PIA_START_NO);
        Database.executeBatch(newbatch);
    }
}