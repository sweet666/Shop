@IsTest
public class TestShopController {

    static Category__c category = new Category__c(name='category');

    static Product_Junction__c productJunction = new Product_Junction__c();

    static List<Product_Junction__c> productJunctions = new List<Product_Junction__c>();

    static Map<String, List<Product_Junction__c>> pj = new Map<String, List<Product_Junction__c>>();

    static List<cCard> cards = new List<cCard>();

    @isTest static void InsertCategoryProductCardCompareGetCardsAndGetProductsMethodsWithNull() {
        Shop_Product__c product = new Shop_Product__c(Name='product', Price__c=10, Inventory__c=30);
        Card__c card = new Card__c(Unit_Sold__c=2, Total_Value__c=100);

        Test.startTest();
        insert product;
        insert category;
        productJunction.Shop_Product__c = product.Id;
        productJunction.Category__c = category.id;
        insert productJunction;
        card.Shop_Product__c = product.Id;
        insert  card;
        shopController shopController = new shopController();
        System.assertNotEquals(null, shopController.getProductsByCategories());
        System.assertNotEquals(null, shopController.getCards());
        Test.stopTest();
    }

    @isTest static void InsertCategoryProductAddToCardCompareCardsWithNull() {
        Test.startTest();
        insert category;
        Shop_Product__c product = new Shop_Product__c(Name='product', Price__c=10, Inventory__c=10, Count__c=1);
        insert product;
        productJunction.Shop_Product__r = product;
        productJunction.Category__r = category;
        productJunctions.add(productJunction);
        pj.put(category.Name, productJunctions);
        shopController shopController = new shopController();
        shopController.productsList = pj;
        shopController.addToCard();
        System.assertNotEquals(new List<Card__c>(), [SELECT id FROM Card__c LIMIT 1]);
        Test.stopTest();
    }

    @isTest static void addCardWithSurplusInventoryLimitCompareCardsWithNull() {
        Test.startTest();
        insert category;
        Shop_Product__c product = new Shop_Product__c(Name='product', Price__c=10, Inventory__c=1, Count__c=10);
        insert product;
        productJunction.Shop_Product__r = product;
        productJunction.Category__r = category;
        productJunctions.add(productJunction);
        pj.put(category.Name, productJunctions);
        shopController shopController = new shopController();
        shopController.productsList = pj;
        shopController.addToCard();
        System.assertEquals(new List<Card__c>(), [SELECT id FROM Card__c LIMIT 1]);
        Test.stopTest();
    }

    @isTest static void addCardWithSurplusProductLimitCompareCardsWithNull() {
        Test.startTest();
        insert category;
        Shop_Product__c product = new Shop_Product__c(Name='product', Price__c=10, Inventory__c=200, Count__c=100);
        insert product;
        productJunction.Shop_Product__r = product;
        productJunction.Category__r = category;
        productJunctions.add(productJunction);
        pj.put(category.Name, productJunctions);
        shopController shopController = new shopController();
        shopController.productsList = pj;
        shopController.addToCard();
        System.assertEquals(new List<Card__c>(), [SELECT id FROM Card__c LIMIT 1]);
        Test.stopTest();
    }

    @isTest static void InsertCategoryProductCardRemoveCardCompareCardsWithNull() {

        Test.startTest();
        insert category;
        Shop_Product__c product = new Shop_Product__c(Name='product', Price__c=10, Inventory__c=10, Count__c=1);
        insert product;
        productJunction.Shop_Product__r = product;
        productJunction.Category__r = category;
        Card__c card = new Card__c(Unit_Sold__c=2, Total_Value__c=3000);
        card.Shop_Product__r = product;
        insert  card;
        cCard cCard = new cCard(card);
        cCard.selected = true;
        cards.add(cCard);
        shopController shopController = new shopController();
        shopController.cardsList = cards;
        shopController.removeSelected();
        System.assertEquals(new List<Card__c>(), [SELECT id FROM Card__c LIMIT 1]);
        Test.stopTest();
    }

    @isTest static void InsertCategoryProductCardSubmitCardCompareCardsWithNull() {
        Shop_Product__c product = new Shop_Product__c(Name='product', Price__c=10, Inventory__c=10, Count__c=1);
        Card__c card = new Card__c(Unit_Sold__c=2, Total_Value__c=3000);
        Card__c card1 = new Card__c(Unit_Sold__c=2, Total_Value__c=700);

        Test.startTest();
        insert product;
        insert category;
        productJunction.Shop_Product__c = product.Id;
        productJunction.Category__c = category.id;
        insert productJunction;
        card.Shop_Product__c = product.Id;
        insert  card;
        insert card1;
        cCard cCard = new cCard(card);
        cCard.selected = true;
        cCard cCard1 = new cCard(card1);
        cCard1.selected = true;
        cards.add(cCard);
        cards.add(cCard1);
        shopController shopController = new shopController();
        shopController.cardsList = cards;
        shopController.submitSelected();
        System.assertEquals(new List<Card__c>(), [SELECT id FROM Card__c WHERE Status__c = 'Open' LIMIT 1]);
        Test.stopTest();
    }

    @isTest static void compareOrdersLinkWithConstant() {
        shopController shopController = new shopController();
        String link = shopController.goOrders().getUrl();
        System.assertEquals(ShopConstants.ORDERS_LINK, link);
    }

}