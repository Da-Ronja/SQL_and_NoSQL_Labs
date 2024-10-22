from pymongo import MongoClient

client = MongoClient("mongodb://localhost:27017/")

db = client["library_system"]
books_collection = db["books"]
authors_collection = db["authors"]
users_collection = db["users"]

# Författare
authors = [
    {"name": "J.K. Rowling", "birthdate": "1965-07-31", "nationality": "British"},
    {"name": "George Orwell", "birthdate": "1903-06-25", "nationality": "British"},
    {"name": "J.R.R. Tolkien", "birthdate": "1892-01-03", "nationality": "British"},
    {"name": "Haruki Murakami", "birthdate": "1949-01-12", "nationality": "Japanese"},
    {"name": "Gabriel Garcia Marquez", "birthdate": "1927-03-06", "nationality": "Colombian"}
]

# Böcker
books = [
    {"title": "Harry Potter and the Philosopher's Stone", "genre": "Fantasy", "published_year": 1997, "author": "J.K. Rowling"},
    {"title": "1984", "genre": "Dystopian", "published_year": 1949, "author": "George Orwell"},
    {"title": "Animal Farm", "genre": "Political Satire", "published_year": 1945, "author": "George Orwell"},
    {"title": "The Lord of the Rings", "genre": "Fantasy", "published_year": 1954, "author": "J.R.R. Tolkien"},
    {"title": "Norwegian Wood", "genre": "Fiction", "published_year": 1987, "author": "Haruki Murakami"},
    {"title": "Kafka on the Shore", "genre": "Fiction", "published_year": 2002, "author": "Haruki Murakami"},
    {"title": "1Q84", "genre": "Fiction", "published_year": 2009, "author": "Haruki Murakami"},
    {"title": "Colorless Tsukuru Tazaki and His Years of Pilgrimage", "genre": "Fiction", "published_year": 2014, "author": "Haruki Murakami"},
    {"title": "One Hundred Years of Solitude", "genre": "Magic Realism", "published_year": 1967, "author": "Gabriel Garcia Marquez"},
    {"title": "Love in the Time of Cholera", "genre": "Romance", "published_year": 1985, "author": "Gabriel Garcia Marquez"},
    {"title": "Chronicle of a Death Foretold", "genre": "Crime", "published_year": 1981, "author": "Gabriel Garcia Marquez"}
]

# Användare
users = [
    {"name": "Alice Johnson", "email": "alice@example.com", "borrowed_books": []},
    {"name": "Bob Smith", "email": "bob@example.com", "borrowed_books": []},
    {"name": "Charlie Brown", "email": "charlie@example.com", "borrowed_books": []},
    {"name": "Diana Prince", "email": "diana@example.com", "borrowed_books": []},
    {"name": "Eve Davis", "email": "eve@example.com", "borrowed_books": []}
]

def get_all_authors():
    authors = authors_collection.find()
    for author in authors:
        print(f"{author['name']} - {author['nationality']} (Born: {author['birthdate']})")

def get_all_books():
    books = books_collection.find()
    for book in books:
        print(f"{book['title']} - {book['genre']} ({book['published_year']}) by {book['author']}")

def get_books_by_author(author_name):
    books = books_collection.find({"author": author_name})
    for book in books:
        print(f"{book['title']} - {book['genre']} ({book['published_year']})")

def add_book(title, genre, published_year, author):
    books_collection.insert_one({"title": title, "genre": genre, "published_year": published_year, "author": author})
    print(f"Added book: {title}")


def borrow_book(user_name, book_title):
    user = users_collection.find_one({"name": user_name})
    book = books_collection.find_one({"title": book_title})

    if user and book:
        users_collection.update_one({"name": user_name}, {"$push": {"borrowed_books": book_title}})
        print(f"{user_name} has borrowed {book_title}.")
    else:
        print("User or book not found.")

def update_book_info(title, new_genre=None, new_published_year=None):
    update_fields = {}
    if new_genre:
        update_fields["genre"] = new_genre
    if new_published_year:
        update_fields["published_year"] = new_published_year

    books_collection.update_one({"title": title}, {"$set": update_fields})
    print(f"Updated book: {title}")

def get_books_after_year(year):
    books = books_collection.find({"published_year": {"$gt": year}})
    for book in books:
        print(f"{book['title']} - {book['author']} ({book['published_year']})")


def delete_book(title):
    books_collection.delete_one({"title": title})
    print(f"Deleted book: {title}")

def init_library_system():
    authors_collection.insert_many(authors)
    books_collection.insert_many(books)
    users_collection.insert_many(users)

def close_library_system():
    authors_collection.drop()
    books_collection.drop()
    users_collection.drop()


def display_menu():
    print("1. View All Authors")
    print("2. View All Books")
    print("3. View Books by Author")
    print("4. Add a New Book")
    print("5. Borrow a Book")
    print("6. Update Book Information")
    print("7. View Books Published After a Year")
    print("8. Delete a Book")
    print("9. Exit")
    print("10. Exit and clear database")

    return int(input("Enter your choice: "))

def main():
    in_library = True
    init_library_system()

    while in_library:
        choice = display_menu()

        match choice:
            case 1:
                get_all_authors()
            case 2:
                get_all_books()
            case 3:
                author_name = input("Enter author name: ")
                get_books_by_author(author_name)
            case 4:
                title = input("Enter title: ")
                genre = input("Enter genre: ")
                published_year = int(input("Enter published year: "))
                author = input("Enter author: ")
                add_book(title, genre, published_year, author)
            case 5:
                user_name = input("Enter user name: ")
                book_title = input("Enter book title: ")
                borrow_book(user_name, book_title)
            case 6:
                title = input("Enter title: ")
                new_genre = input("Enter new genre (leave empty to skip): ")
                new_published_year = input("Enter new published year (leave empty to skip): ")
                update_book_info(title, new_genre, new_published_year)
            case 7:
                year = int(input("Enter year: "))
                get_books_after_year(year)
            case 8:
                title = input("Enter title: ")
                delete_book(title)
            case 9:
                in_library = False
                print("Goodbye!")
            case 10:
                close_library_system()
                in_library = False
                print("Database cleared. Goodbye!")
            case _:
                print("Invalid choice. Please try again.")

main()