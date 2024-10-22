from pymongo import MongoClient

# Connect to MongoDB
client = MongoClient("mongodb://localhost:27017/")

# Databas
db = client["ecommerce_store"]
# Collections
categories_collection = db["categories"]
products_collection = db["products"]
customers_collection = db["customers"]
orders_collection = db["orders"]
 
categories = [
    {"category_name": "Electronics", "description": "Electronic gadgets and devices", "products": []},
    {"category_name": "Clothing", "description": "Apparel and fashion items", "products": []},
    {"category_name": "Books", "description": "Books and novels", "products": []}
]

products = [
    {"name": "Smartphone", "price": 699, "category": "Electronics", "stock_quantity": 50, "customer_reviews": []},
    {"name": "Laptop", "price": 1200, "category": "Electronics", "stock_quantity": 30, "customer_reviews": []},
    {"name": "T-shirt", "price": 20, "category": "Clothing", "stock_quantity": 100, "customer_reviews": []},
    {"name": "Jeans", "price": 50, "category": "Clothing", "stock_quantity": 60, "customer_reviews": []},
    {"name": "Headphones", "price": 150, "category": "Electronics", "stock_quantity": 80, "customer_reviews": []},
    {"name": "Python Programming", "price": 30, "category": "Books", "stock_quantity": 100, "customer_reviews": []},
    {"name": "JavaScript Programming", "price": 40, "category": "Books", "stock_quantity": 120, "customer_reviews": []},
    {"name": "Data Science", "price": 50, "category": "Books", "stock_quantity": 80, "customer_reviews": []}
]

customers = [
    {"name": "John Doe", "address": "123 Elm Street", "order_history": []},
    {"name": "Jane Smith", "address": "456 Oak Avenue", "order_history": []},
    {"name": "Emily Johnson", "address": "789 Pine Road", "order_history": []},
]

def insert_product(product):
    product_id = products_collection.insert_one(product).inserted_id
    categories_collection.update_one({"category_name": product["category"]}, {"$push": {"products": product_id}})


def get_all_products():
    products = products_collection.find()
    for product in products:
        print(f"{product['name']} - {product['price']} - {product['category']} - {product['stock_quantity']}")

def get_all_categories():
    categories = categories_collection.find()
    for category in categories:
        print(category)

def display_categories_names():
    categories = categories_collection.find()
    for category in categories:
        print(category["category_name"])

def get_products_by_category():
    display_categories_names()
    category_name = input("Enter category name: ")
    category = categories_collection.find_one({"category_name": category_name})
    if category:
        products = products_collection.find({"_id": {"$in": category["products"]}})
        for product in products:
            print(product)
    else:
        print("Category not found.")

def put_order_in_cart():
    cart = []

    while True:
        print("Add products to cart:")
        get_all_products()
        product_name = input("Enter product name: ")
        product = products_collection.find_one({"name": product_name})
        if product:
            if product["stock_quantity"] > 0:
                cart.append({
                    "_id": product["_id"],
                    "name": product["name"],
                    "category": product["category"],
                    "price": product["price"]
                })
                products_collection.update_one({"name": product_name}, {"$inc": {"stock_quantity": -1}})
                print("Product added to cart.")
            else:
                print("Product out of stock.")
        else:
            print("Product not found.")

        choice = input("Do you want to add more products to cart? (yes/no): ")
        if choice.lower() != "yes":
            break

    return cart

def add_order(customer_name, products_purchased, total_amount):
    customer = customers_collection.find_one({"name": customer_name})
    order = {"customer_id": customer["_id"], "products_purchased": products_purchased, "total_amount": total_amount, "status": "Pending"}
    orders_collection.insert_one(order)
    customers_collection.update_one({"name": customer_name}, {"$push": {"order_history": order}})
    print("Order added successfully.")

def choose_a_customer():
    print("Choose a customer to shop around with:")
    customers = list(customers_collection.find())
    for index, customer in enumerate(customers):
        print(f"{index + 1}. {customer['name']}")

    while True:
        try:
            customer_index = int(input("Enter customer number: "))
            if 1 <= customer_index <= len(customers):
                customer = customers[customer_index - 1]
                return customer["name"]
            else:
                print("Invalid customer number. Please try again.")
        except ValueError:
            print("Invalid input. Please enter a valid number.")

def view_orders():
    orders = orders_collection.find()
    for order in orders:
        print(order)


## Main code starts here ##
def init_app():
    if categories_collection.count_documents({}) == 0:
        categories_collection.insert_many(categories)
    if products_collection.count_documents({}) == 0:
        for product in products:
            insert_product(product)
    if customers_collection.count_documents({}) == 0:
        customers_collection.insert_many(customers)
    print("Database initialized with sample data.")

def close_app():
    products_collection.drop()
    categories_collection.drop()
    customers_collection.drop()
    orders_collection.drop()
    print("Database cleared. Goodbye!")


def display_menu():
    print("1. View Category")
    print("2. View Products")
    print("3. View Products by Category")
    print("4. Add Order")
    print("5. Wiev Orders")
    print("6. Exit")
    print("7. Exit and clear database")

    return int(input("Enter your choice: "))

def run_query2():
    is_running = True
    print("Welcome to the E-Commerce Store!")
    init_app()

    while is_running:
        print("")
        choise = display_menu()

        match choise:
            case 1:
                print("View Category")
                get_all_categories()
            case 2:
                print("View Products")
                get_all_products()
            case 3:
                print("View Products by Category")
                get_products_by_category()
            case 4:
                print("Add Order")
                customer_name = choose_a_customer()
                cart = put_order_in_cart()
                total_amount = sum([product["price"] for product in cart])
                add_order(customer_name, cart, total_amount)
            case 5:
                print("View Orders")
                view_orders()
            case 6:
                is_running = False
            case 7:
                is_running = False
                close_app()
            case _:
                print("Invalid choice. Please try again.")
                continue

run_query2()