@IsTest
public class TestOrderControllerClass {

    @isTest static void InsertCardAndOrderCompareGetOrderMethodWithNull() {
        List<Card__c> cards = new List<Card__c>();
        Shop_Order__c order = new Shop_Order__c(Status__c = 'Closed');

        Test.startTest();
        insert order;
        Card__c card = new Card__c(Total_Value__c = 100, Unit_Sold__c = 2, Status__c = 'Closed');
        card.Shop_Order__r = order;
        cards.add(card);
        insert cards;
        orderController controller = new orderController();
        System.assertNotEquals(null, controller.getOrders());
        Test.stopTest();

    }

    @isTest static void compareGoShopLinkWithConstant() {
        orderController controller = new orderController();
        String link = controller.goShop().getUrl();
        System.assertEquals(ShopConstants.SHOP_LINK, link);
    }

}