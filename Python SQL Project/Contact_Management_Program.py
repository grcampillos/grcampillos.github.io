import mysql.connector

# Database connection configuration (Varies to your server credentials)
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': 'sampleSQLtest', 
    'database': 'contacts_db'
}

# Establish a connection to MySQL
try:
    conn = mysql.connector.connect(**db_config)
    cursor = conn.cursor()
    print("Connected to MySQL database")
except mysql.connector.Error as err:
    print(f"Error connecting to MySQL: {err}")
    exit(1)

#Normalize data format in Phone column
cursor.execute("UPDATE contacts_test SET phone = CONCAT('+1-', SUBSTRING(phone,1,3), '-', SUBSTRING(phone,4,3), '-', SUBSTRING(phone,7,4)) WHERE phone REGEXP '^[0-9]{10}$' AND phone NOT LIKE '+1-%';")


# 1. Function to retrieve all contacts
def retrieve_all_contacts():
    query = "SELECT * FROM contacts_test"
    cursor.execute(query)
    contacts = cursor.fetchall()
    return contacts

# 2. Function to retrieve a specific contact by name or email
def retrieve_contact(name_or_email):
    pattern = f"%{name_or_email}%"
    query = "SELECT * FROM contacts_test WHERE name like %s OR email like %s"
    cursor.execute(query, (pattern, pattern))
    contact = cursor.fetchall()
    if contact:
        print("Contact/s found:")
        # Display each row in a readable format
        for name, email, phone in contact:
            print(f"Name: {name},   Email: {email},   Phone: {phone}")
    else:
        print("No contact found.")


# 3. Function to update the phone number of a specific contact by name or email
def update_contact_phone(name_or_email, new_phone):
    query = "UPDATE contacts_test SET phone = %s WHERE name = %s OR email = %s"
    cursor.execute(query, (new_phone, name_or_email, name_or_email))
    conn.commit()
    print("Contact updated successfully")

# 4. Function to delete a specific contact by name or email
def delete_contact(name_or_email):
    query = "DELETE FROM contacts_test WHERE name = %s OR email = %s"
    cursor.execute(query, (name_or_email, name_or_email))
    conn.commit()
    print("Contact deleted successfully")

# Main function to provide an interactive menu
def main():
    while True:
        print("\nContact Management System")
        print("1. Retrieve all contacts")
        print("2. Retrieve a specific contact")
        print("3. Update contact phone number")
        print("4. Delete a contact")
        print("5. Exit")

        choice = input("Enter your choice (1-5): ")

        if choice == '1':
            print("\nAll Contacts:")
            all_contacts = retrieve_all_contacts()
            for contact in all_contacts:
                print(contact)
        elif choice == '2':
            name_or_email = input("Enter name or email of the contact: ")
            contact = retrieve_contact(name_or_email)
        elif choice == '3':
            name_or_email = input("Enter name or email of the contact: ")
            new_phone = input("Enter new phone number: ")
            update_contact_phone(name_or_email, new_phone)
        elif choice == '4':
            name_or_email = input("Enter name or email of the contact to delete: ")
            delete_contact(name_or_email)
        elif choice == '5':
            print("Exiting program...")
            break
        else:
            print("Invalid choice. Please enter a number from 1 to 5.")

# Execute the main function
if __name__ == "__main__":
    main()

# Close cursor and connection
cursor.close()
conn.close()
