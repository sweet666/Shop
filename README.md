Product Catalog Requirements

Overview:
Product Catalog is a web application which allows customers to navigate through categories, see product details, add to card, remove from card, make an order and see previous orders.
The web application can be used by Customers and Managers.
The Customer can view product details, list catalogs and make a product order. Products must be order by categories.
The Manager can add new products and categories to the catalog. The Manager can edit product details and categories. The Manager can add/remove products to/from a category. Standard or Custom Salesforce objects should be used in application.
Storefront and My Orders pages are only visible for the Customer.

•	Each product can be stored in a few categories.
•	Each category can have many products.

Default Categories list:
Antiques
Books
Clothing
Computers
Health & Beauty
Jewelry
Music
Sport

Storefront page
Storefront page lists all product categories. The Customer sees all products details. 
The Customer can add to card a product by clicking “Add” button near each product. The customers specify in column “Count” how many items of this product they want to order. When Customer click “Add” button, a “Remove” button becomes visible and “Add” button – invisible. The “Remove” button remove products from card.
When the Customer add product to card, he must see a message: what product he bought and total value his order.  The Customer cannot buy products more than total amount in a warehouse. After removing product from card, the message updated and total value his order recalculated.
  
The Customer can see a list of orders by clicking “My orders” button near “Submit” button at the foot of a page.
When the Customer chosen all products what he wants, he must click “Submit” button for making order. 
 
After this a notification with information to that product is sent to the manager by email

Notification format:
Greetings,
[CUSTOMER_NAME] has just made an order.
Order Date: [ORDER_DATE]
Total Price: [PRICE]
 
View My Orders page
The user can click “Back to Storefront” button to move the page Storefront.
My Orders page shows all important information of invoice statement and line items in the orders.
“Categories Summary” table below shows how many products are listed in each category.
Customer can see when he made the order, date of today, total value his orders and etc. (See the example)

Additional features
1.	Customer can expand/collapse any category to see its products on the Storefront page. All categories are collapsed by default.
2.	The Customers can view their orders on the My Orders page. The Manager can view all orders.
3.	The Customers cannot order more than 20 items of the product at a time.
4.	Provide customer discounts on products depending on how much he has already bought.
5.	Implement the approval process of the total value of orders > $ 2000 (Open, Pending, Closed) and displaying a message, notification with information to large order is sent to the manager by email
 
Notification format:
[CUSTOMER_NAME] submitted for approval an Invoice Statement that
totaled [PRICE] on [ORDER_DATE].
 
6.	Provide support posts for user: Wrong, Error.
 
