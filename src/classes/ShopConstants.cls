public class ShopConstants {

    public static final Decimal PRODUCT_LIMIT = 20;

    public static final Decimal NULL_VALUE = 0;

    public static final Decimal DISCOUNT_VALUE = 501;

    public static final Decimal APPROVE_VALUE = 2000;

    public static final String CLOSED_STATUS= 'Closed';

    public static final String OPEN_STATUS = 'Open';

    public static final String PENDING_STATUS = 'Pending';

    public static final String DISCOUNT_STRING = '10%';

    public static final String ORDERS_LINK = 'https://sweet666-dev-ed--c.ap5.visual.force.com/apex/orders';

    public static final String SHOP_LINK = 'https://sweet666-dev-ed--c.ap5.visual.force.com/apex/productCatalog';

    public static final String INV_LIMIT_MESSAGE = 'Sorry, you cant buy more than inventory';

    public static final String PROD_LIMIT_MESSAGE = 'Sorry, you cant buy more than 20 products at time';

    public static final String DML_ERROR_MESSAGE = 'An unexpected error has occurred: ';

    public static final String REMOVE_CARD_MESSAGE = 'Products removed from card!';

    public static final String DISCOUNT_MESSAGE = 'You got 10% discount!';

    public static final String APPROVING_MESSAGE = 'Your order is processing by the manager. Please wait for approval.';

    public static final String BUYING_MESSAGE = 'Thank you for buying!';

    public static String cardMessage(String name, Decimal value){

        return 'Congratulations! You add '+ name +' to card. Your oder is ' + value + '$';
    }

    public static void setMessage(ApexPages.Severity NAME, String MESSAGE){
        ApexPages.Message msg = new ApexPages.Message(NAME, MESSAGE);
        ApexPages.addMessage(msg);
    }

    public static Decimal makeDiscount(Decimal value){
        return value * 0.9;
    }

}