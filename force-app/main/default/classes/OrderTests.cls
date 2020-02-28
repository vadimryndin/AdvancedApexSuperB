@isTest (seeAllData=false)
 public  class OrderTests {
    
    @testSetup static void SetupTestData() {
		TestDataFactory.InsertTestData(5);
    }
       
@isTest static void OrderUpdate_UnitTest() {
        Test.startTest();
		Order ord = [SELECT id From Order LIMIT 1];
        ord.Status = Constants.ACTIVATED_ORDER_STATUS;
        Product2 p = [SELECT Family, Name, Quantity_Ordered__c, Quantity_Remaining__c FROM Product2 LIMIT 1];
        update ord;
        
        Product2 updP = [SELECT Family, Name, Quantity_Ordered__c, Quantity_Remaining__c FROM Product2 LIMIT 1];
        TestDataFactory.VerifyQuantityOrdered(p, updP, constants.DEFAULT_ROWS);
        Test.stopTest();
    }
     
   @isTest  static void OrderExtension_UnitTest() {
        PageReference reference = Page.OrderEdit;
        Test.setCurrentPage(reference);
        Order CurOrder = [SELECT Id,Status FROM Order LIMIT 1];
        ApexPages.StandardController controller = new Apexpages.StandardController(CurOrder);
        OrderExtension extension = new OrderExtension(controller);
        System.assertEquals(Constants.DEFAULT_ROWS, extension.orderItemList.size());
        extension.selectedFamily = 'Dessert';
        extension.SelectFamily();
        extension.OnFieldChange();
        extension.First();
        extension.Next();
        extension.Previous();
        extension.Last();
        extension.GetHasNext();
        extension.GetPageNumber();
        extension.GetHasPrevious();
        extension.GetTotalPages();
        extension.GetFamilyOptions();
        extension.Save();
        ChartHelper.GetInventory();
    } 


}