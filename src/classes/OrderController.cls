public class OrderController {

    private String usedId = UserInfo.getUserId();

    private List<Shop_Order__c> ordersList = [SELECT id, name, Status__c
                                              FROM Shop_Order__c
                                              WHERE OwnerId =:usedId
                                              LIMIT 50];

    private Map<String, List<Card__c>> orderMap {get; set;}

    public Map<String, List<Card__c>> getOrders() {

        orderMap = new Map<String, List<Card__c>>();

        for (Shop_Order__c order: ordersList) {

            List<Card__c> cards = [SELECT Shop_Product__r.Name,
                                   Shop_Product__r.Price__c, 
                                   Unit_Sold__c, 
                                   Total_Value__c, 
                                   Created__c,
                    			   Shop_Order__r.Status__c, 
                                   Shop_Order__r.Total_Value__c 
                                   FROM Card__c
                                   WHERE Shop_Order__r.id =:order.Id
                                   AND Status__c =:ShopConstants.CLOSED_STATUS
                                   LIMIT 20];
            orderMap.put(order.Name, cards);
        }
        
        return orderMap;
    }

    public PageReference goShop() {
        PageReference shopURL = new PageReference(ShopConstants.SHOP_LINK);
        shopURL.setRedirect(true);

        return shopURL;
    }

}