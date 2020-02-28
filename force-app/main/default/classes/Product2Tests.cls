@isTest (seeAllData=false)
private class Product2Tests {

    /**
     * @name product2Extension_UnitTest
     * @description UnitTest for product2Extension
    **/
    @isTest static void Product2Extension_UnitTest(){
        Test.startTest();
            PageReference pageRef = Page.Product2New;
            Test.setCurrentPage(pageRef);
        
            Product2 prod = new Product2(name='Test',isActive=true);
     		ApexPages.StandardController stdcontroller = new ApexPages.StandardController(prod);
        
            Product2Extension ext = new Product2Extension(stdcontroller);
        	System.assertEquals(constants.DEFAULT_ROWS, ext.productsToInsert.size());
            ext.addRows();
       		System.assertEquals(2*constants.DEFAULT_ROWS, ext.productsToInsert.size());
            
            for(Integer i=0; i< Constants.DEFAULT_ROWS; i++) {
                Product2Extension.ProductWrapper wrapper = ext.productsToInsert[i];
                
                Product2 newProduct = new Product2(Name='Product'+i, Initial_Inventory__c = 10, isActive=true, 
                                                   Family = Constants.PRODUCT_FAMILY[0].getValue());
                wrapper.productRecord = newProduct;
                
                PriceBookEntry entry = new PriceBookEntry(UnitPrice = 100, isActive=true);
                wrapper.pricebookEntryRecord = entry;
                
            }
            ext.save();
            ext.GetFamilyOptions();
        	ext.GetInventory();
        Test.stopTest();
             List<Product2> createdProducts = [SELECT Id FROM Product2];
             System.assertEquals(5, createdProducts.size());                              
    }
    
		@isTest static void Product2Trigger_UnitTest(){

        Test.startTest();
        Product2 p = new Product2(
            Name = 'TestProduct',
            Family = 'Side',
            IsActive = true,
            Quantity_Ordered__c = 50,
            Initial_Inventory__c = 100
        );
        insert p;
    
        CollaborationGroup c = new CollaborationGroup(
            Name = 'TEST' + Constants.INVENTORY_ANNOUNCEMENTS,
            Description = 'test',
            CollaborationType = 'Public'
        );
        insert c;
    
        p.Quantity_Ordered__c=96;
        update p;
        Test.stopTest();
      }
}