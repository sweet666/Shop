public class ShopController {

    private String usedId = UserInfo.getUserId();

    public Map<String, List<Product_Junction__c>> productsList {get; set;}

    public List<cCard> cardsList {get; set;}

    public Map<String, List<Product_Junction__c>> updateProducts() {

        productsList = new Map<String, List<Product_Junction__c>>();
        List<Category__c> categories = [SELECT Name FROM Category__c LIMIT 30];

        for (Category__c c : categories) {
            List<Product_Junction__c> p = [SELECT Shop_Product__r.id,
                                           Shop_Product__r.name,
                                           Shop_Product__r.Description__c,
                                           Shop_Product__r.Inventory__c,
                                           Shop_Product__r.Price__c,
                                           Shop_Product__r.Count__c,
                                           Category__r.name
                                           FROM Product_Junction__c
                                           WHERE Category__r.id = :c.id
                                           LIMIT 50];
            productsList.put(c.name, p);
        }

        return productsList;
    }

    public Map<String, List<Product_Junction__c>> getProductsByCategories() {

        if (productsList == null) {
            updateProducts();
        }

        return productsList;
    }

    public List<cCard> updateCards() {
        cardsList = new List<cCard>();

        for (Card__c c: [SELECT id,
                        Shop_Product__r.name,
                        Unit_Sold__c, 
                        Total_Value__c 
                        FROM Card__c
        				WHERE Status__c =:ShopConstants.OPEN_STATUS
                        AND OwnerId =:usedId
                        LIMIT 20
                        ]) {
            cardsList.add(new cCard(c));
        }
        
        return cardsList;
    }

    public List<cCard> getCards() {
        if (cardsList == null){
            updateCards();
        }
        
        return cardsList;
    }

    private PageReference returnPage(ApexPages.Severity NAME, String MESSAGE) {
        PageReference page = ApexPages.currentPage();
        ApexPages.Message msg = new ApexPages.Message(NAME, MESSAGE);
        ApexPages.addMessage(msg);
        
        return page;
    }

    public PageReference addToCard() {
        List<Shop_Product__c> updateList = new List<Shop_Product__c>();

        for(List<Product_Junction__c> item: getProductsByCategories().values()) {

            for (Product_Junction__c obj : item){

                if(obj.Shop_Product__r.Count__c > obj.Shop_Product__r.Inventory__c) {
                    obj.Shop_Product__r.Count__c = null;

                    return returnPage(ApexPages.Severity.ERROR, ShopConstants.INV_LIMIT_MESSAGE);
                }

                if (obj.Shop_Product__r.Count__c > ShopConstants.PRODUCT_LIMIT){
                    obj.Shop_Product__r.Count__c = null;

                    return returnPage(ApexPages.Severity.WARNING, ShopConstants.PROD_LIMIT_MESSAGE);
                }

                if (obj.Shop_Product__r.Count__c > ShopConstants.NULL_VALUE) {
                    Card__c card = new Card__c();
                    Decimal totalPrice = obj.Shop_Product__r.Count__c * obj.Shop_Product__r.Price__c;
                    card.Total_Value__c = totalPrice;
                    card.Unit_Sold__c = obj.Shop_Product__r.Count__c;
                    card.Shop_Product__c = obj.Shop_Product__c;
                    obj.Shop_Product__r.Inventory__c = obj.Shop_Product__r.Inventory__c - obj.Shop_Product__r.Count__c;
                    obj.Shop_Product__r.Count__c = null;
                    updateList.add(obj.Shop_Product__r);

                    try {
                        insert card;
                        upsert updateList;

                        cardsList = updateCards();

                        ShopConstants.setMessage(ApexPages.Severity.Info,
                                ShopConstants.cardMessage(obj.Shop_Product__r.Name, card.Total_Value__c));

                    } catch(DmlException e) {
                        System.debug(ShopConstants.DML_ERROR_MESSAGE + e.getMessage());
                    }
                }

                obj.Shop_Product__r.Count__c = null;
            }
        }

        return ApexPages.currentPage();
    }

    public PageReference removeSelected() {

        List<Card__c> selectedCards = new List<Card__c>();
        List<Shop_Product__c> productsToUpdate = new List<Shop_Product__c>();

        for (cCard cCrd: getCards()) {

            if (cCrd.selected == true) {
                selectedCards.add(cCrd.crd);
                Shop_Product__c shopProduct = [SELECT id, Inventory__c
                                               FROM Shop_Product__c
                                               WHERE id=:cCrd.crd.Shop_Product__r.id
                                               LIMIT 1];
                shopProduct.Inventory__c = shopProduct.Inventory__c + cCrd.crd.Unit_Sold__c;
                productsToUpdate.add(shopProduct);
            }
        }

        try {
            
            delete selectedCards;
            upsert productsToUpdate;

            cardsList = updateCards();
            productsList = updateProducts();

            ShopConstants.setMessage(ApexPages.Severity.Info, ShopConstants.REMOVE_CARD_MESSAGE);

        } catch(DmlException e) {
            System.debug(ShopConstants.DML_ERROR_MESSAGE + e.getMessage());
        }
        
        return ApexPages.currentPage();
    }

    public PageReference submitSelected() {

        List<Card__c> cardsToUpdate = new List<Card__c>();
        Shop_Order__c order = new Shop_Order__c(Total_Value__c = ShopConstants.NULL_VALUE,
                                                Unit_Sold__c = ShopConstants.NULL_VALUE);

        try {

            insert order;

            for(cCard cCrd: getCards()) {

                if(cCrd.selected == true) {
                    order.Total_Value__c = order.Total_Value__c + cCrd.crd.Total_Value__c;
                    order.Unit_Sold__c = order.Unit_Sold__c + cCrd.crd.Unit_Sold__c;
                    cCrd.crd.Status__c = ShopConstants.CLOSED_STATUS;
                    cCrd.crd.Shop_Order__c = order.Id;
                    cardsToUpdate.add(cCrd.crd);

                    if (order.Unit_Sold__c > ShopConstants.PRODUCT_LIMIT) {
                        delete order;
                        return returnPage(ApexPages.Severity.WARNING, ShopConstants.PROD_LIMIT_MESSAGE);
                    }

                    if (order.Total_Value__c > ShopConstants.DISCOUNT_VALUE) {
                        order.Discount__c = ShopConstants.DISCOUNT_STRING;
                        order.Total_Value__c = ShopConstants.makeDiscount(order.Total_Value__c);
                        ShopConstants.setMessage(ApexPages.Severity.Info, ShopConstants.DISCOUNT_MESSAGE);
                    }

                    if(order.Total_Value__c > ShopConstants.APPROVE_VALUE) {
                        order.Status__c = ShopConstants.PENDING_STATUS;
                        ShopConstants.setMessage(ApexPages.Severity.Info, ShopConstants.APPROVING_MESSAGE);
                    }

                    else {
                        order.Status__c = ShopConstants.CLOSED_STATUS;
                        ShopConstants.setMessage(ApexPages.Severity.Info, ShopConstants.BUYING_MESSAGE);
                    }
                }
            }

            upsert order;
            update cardsToUpdate;

            cardsList = updateCards();
            productsList = updateProducts();

        } catch(DmlException e) {
            System.debug(ShopConstants.DML_ERROR_MESSAGE + e.getMessage());
        }

        return ApexPages.currentPage();
    }

    public PageReference goOrders() {
        PageReference ordersURL = new PageReference(ShopConstants.ORDERS_LINK);
        ordersURL.setRedirect(true);
        return ordersURL;
    }
}