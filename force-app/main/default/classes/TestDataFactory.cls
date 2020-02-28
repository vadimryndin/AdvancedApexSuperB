/**
 * @name TestDataFactory
 * @description Contains methods to construct and/or validate commonly used records
**/
public with sharing class TestDataFactory {

    /**
     * @name ConstructCollaborationGroup
     * @description
    **/
    public static CollaborationGroup ConstructCollaborationGroup(){
        //ToDo: Ensure this method returns a single Chatter CollaborationGroup
        //    whose Name starts with 'TEST' followed by the INVENTORY_ANNOUNCEMENTS constant
        //    and configured so anyone can join, see and post updates.
        CollaborationGroup Collgroup = new CollaborationGroup(
        	Name = 'TEST' + constants.INVENTORY_ANNOUNCEMENTS,
            CollaborationType = 'Public'
        );
        
        return Collgroup;
    }

    /**
     * @name CreateProducts
     * @description Constructs a list of Product2 records for unit tests
    **/
    public static List<Product2> ConstructProducts(Integer cnt){
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Product2 records
        //  with all the required fields populated
        //  and IsActive = true
        //  an Initial Inventory set to 10
        //  and iterating through the product family picklist values throughout the list.
        List<Product2> prodList = new List<Product2>();
        for(Integer i = 0; i<cnt; i++){
			Product2 pVar = new Product2(
                Name = 'Product' + i,
                IsActive = true,
                Initial_Inventory__c = 10,
            	Family = Constants.PRODUCT_FAMILY[Math.mod(i, Constants.PRODUCT_FAMILY.size())].getValue()
       		);
           prodList.add(pVar); 
        }
        return prodList; 
    }

    /**
     * @name CreatePricebookEntries
     * @description Constructs a list of PricebookEntry records for unit tests
    **/
    public static List<PricebookEntry> ConstructPricebookEntries(List<Product2> prods){
        //ToDo: Ensure this method returns a corresponding list of PricebookEntries records
        //  related to the provided Products
        //  with all the required fields populated
        //  and IsActive = true
        //  and belonging to the standard Pricebook
        List<PricebookEntry> prbList = new List<PricebookEntry>();
        for(Product2 prodVar : prods) {
			PricebookEntry pbEntry = new PricebookEntry(
            	IsActive = true,
                Pricebook2Id = constants.STANDARD_PRICEBOOK_ID,
                Product2Id = prodVar.Id,
                UnitPrice = 10
            );
            prbList.add(pbEntry);
        }
        return prbList;
    }

    /**
     * @name CreateAccounts
     * @description Constructs a list of Account records for unit tests
    **/
    public static List<Account> ConstructAccounts(Integer cnt){
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Account records
        //  with all of the required fields populated.
        List<Account> accList = new List<Account>();
        for(Integer i = 0; i<cnt; i++) {
			Account acc = new Account(
            	Name = 'Acc' + i
            );
            accList.add(acc);
        }
        return accList;
    }

    /**
     * @name CreateContacts
     * @description Constructs a list of Contacxt records for unit tests
    **/
    public static List<Contact> ConstructContacts(Integer cnt, List<Account> accts){
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Contact records
        //  related to the provided Accounts
        //  with all of the required fields populated.
        List<Contact> cntList = new List<Contact>();
        for(Integer i = 0; i<cnt; i++) {
        cntList.add(new Contact(LastName = 'Cnt'+i, AccountId = accts[i].Id));
        }
        return cntList;
    }

    /**
     * @name CreateOrders
     * @description Constructs a list of Order records for unit tests
    **/
    public static List<Order> ConstructOrders(Integer cnt, List<Account> accts){
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Order records
        //  related to the provided Accounts
        //  with all of the required fields populated.
        List<Order> ordList = new List<Order>();
        for (Integer i = 0; i < cnt; i++) {
      		ordList.add(new Order(
              Name = 'Order ' + i,
              AccountId = accts[Math.mod(i, accts.size())].Id,
              EffectiveDate = Date.today(),
              Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID,
              Status = Constants.DRAFT_ORDER_STATUS
      ));
    }

    	return ordList;
    }

    /**
     * @name CreateOrderItems
     * @description Constructs a list of OrderItem records for unit tests
    **/
    public static List<OrderItem> ConstructOrderItems(integer cnt, list<pricebookentry> pbes, list<order> ords){
        //ToDo: Ensure this method returns a list of size cnt of OrderItem records
        //  related to the provided Pricebook Entries
        //  and related to the provided Orders
        //  with all of the required fields populated.
        //  Hint: Use the DEFAULT_ROWS constant for Quantity as it will be used in the next challenge
        List<OrderItem> orderItems = new List<OrderItem>();

        for (Integer i = 0; i < cnt; i++) {
          orderItems.add(new OrderItem(
              OrderId = ords[Math.mod(i, ords.size())].Id,
              PriceBookEntryId = pbes[Math.mod(i, pbes.size())].Id,
              Quantity = Constants.DEFAULT_ROWS,
              UnitPrice = 10
          ));
        }
    
        return orderItems;
    }

    /**
     * @name SetupTestData
     * @description Inserts accounts, contacts, Products, PricebookEntries, Orders, and OrderItems.
    **/
    public static void InsertTestData(Integer cnt){
        //ToDo: Ensure this method calls each of the construct methods
        //  and inserts the results for use as test data.
         	insert constructCollaborationGroup();

            List<Product2> products = constructProducts(cnt);
            insert products;
        
            List<PricebookEntry> pbes = constructPricebookEntries(products);
            insert pbes;
        
            List<Account> accounts = constructAccounts(cnt);
            insert accounts;
        
             List<Contact> contacts = TestDataFactory.ConstructContacts(cnt, accounts);
      		 insert contacts;
        
            List<Order> orders = constructOrders(cnt, accounts);
            insert orders;
        
            insert constructOrderItems(cnt, pbes, orders);
    }
    public static void VerifyQuantityOrdered(Product2 originalProduct, Product2 updatedProduct, Integer qtyOrdered) {
		Integer sumQuantity = Integer.valueOf(originalProduct.Quantity_Ordered__c) + qtyOrdered;
    	System.assertEquals(updatedProduct.Quantity_Ordered__c, sumQuantity);
    }

}