public class Product2Extension {

    public List<ProductWrapper> productsToInsert {get;set;}

    public Product2Extension(ApexPages.StandardController controller){
        this.productsToInsert = new List<ProductWrapper>();
        addRows();
    }

    public void AddRows(){
        for ( Integer i=0; i<Constants.DEFAULT_ROWS; i++ ){
            //productsToInsert.add( new Product2() );
            productsToInsert.add(new ProductWrapper());
        }
    }

    @AuraEnabled public List<ChartHelper.ChartData> GetInventory(){
        return ChartHelper.GetInventory();
    }

   /* override the standard button
    public PageReference Save(){
        try {
            insert productsToInsert;

            //If successful clear the list and display an informational message
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,productsToInsert.size()+' Inserted'));
            productsToInsert.clear();   //Do not remove
            addRows();  //Do not remove
        } catch (Exception e){

        }
        return null;
    }
*/
    public PageReference Save(){
        SavePoint sp1 = Database.setSavepoint();
     /*   try {
            Map<Integer, Product2> products = new Map<Integer, Product2>();
			Map<Integer, PriceBookEntry> priceBookEntries = new Map<Integer, PriceBookEntry>();    
            Integer index = 0;
            for(ProductWrapper prdWrapper : productsToInsert) {
                if(String.isNotBlank(prdWrapper.productRecord.Name) && prdWrapper.pricebookEntryRecord.UnitPrice!=null && 
                   prdWrapper.productRecord.Initial_Inventory__c!=null && prdWrapper.productRecord.isActive && 
                   prdWrapper.productRecord.Initial_Inventory__c != 0 && prdWrapper.pricebookEntryRecord.UnitPrice!=0){
                          
                	products.put(index,prdWrapper.productRecord);
                    priceBookEntries.put(index,prdWrapper.pricebookEntryRecord);
                    index ++;
                }
            }
            
            insert products.values();
            
            List<PriceBookEntry> pbList = new List<PriceBookEntry>();
            for(Integer mapIndex : products.keySet()) {
            	PriceBookEntry currentPBEntry = priceBookEntries.get(mapIndex);
                if(products.get(mapIndex).Id!=null) {
                    currentPBEntry.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
                	System.debug('' + products.get(mapIndex).Id);
                	currentPBEntry.Product2Id = products.get(mapIndex).Id;
                	currentPBEntry.IsActive = true;
                    pbList.add(currentPBEntry);
                }
                
            }
            
            insert pbList;
*/
        
        try {
            List<Product2> products = new List<Product2>();
            List<PricebookEntry> entries = new List<PricebookEntry>();
            
            for (ProductWrapper wrp : productsToInsert){
                if(null!=wrp.productRecord && null!=wrp.pricebookEntryRecord){
                    
                    if(null!=wrp.productRecord.Name && null!=wrp.productRecord.Family && constants.SELECT_ONE!=wrp.productRecord.Family
                       && null!=wrp.productRecord.Initial_Inventory__c && null!=wrp.pricebookEntryRecord.UnitPrice){
                        products.add(wrp.productRecord);
                           
                        PricebookEntry entry=wrp.pricebookEntryRecord;
                        entry.IsActive = true;
                        entry.Pricebook2Id = constants.STANDARD_PRICEBOOK_ID;
                        entries.add(entry);   
                    }
                }
            }
            insert products;            
            for (integer itr=0; itr<entries.size();itr++){
                entries[itr].Product2Id=products[itr].id;
            }
            insert entries;
            
            //If successful clear the list and display an informational message
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,productsToInsert.size()+' Inserted'));
            productsToInsert.clear();   //Do not remove
            addRows();  //Do not remove
        } catch (Exception e){
			apexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,Constants.ERROR_MESSAGE));
            Database.rollback(sp1);
        }
        return null;
    }
    
    
    public List<SelectOption> GetFamilyOptions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(Constants.SELECT_ONE,Constants.SELECT_ONE));
        for(Schema.PicklistEntry entry : Constants.PRODUCT_FAMILY){
			options.add(new SelectOption(entry.getLabel(),entry.getValue()));
        }
		return options;
    }
    
    public class ProductWrapper{
        public Product2 productRecord {get;set;}
        public PriceBookEntry pricebookEntryRecord {get;set;}
        
        public ProductWrapper() {
            productRecord = new Product2(Initial_Inventory__c =0);
            pricebookEntryRecord = new PricebookEntry(Unitprice=0.0);
        }
    }

}