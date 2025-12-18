import json
import mysql.connector


json_data = open(r"D:\CAREER\DATA ANALYST FUNDAMENTALS\DATA ENG FUNDAMENTALS\Python OOP\JSON practice\json_to_SQL\contact_list.json").read()
data = json.loads(json_data)

contacts = data.get('contacts', [])


# Connecting to the Database
con = mysql.connector.connect(host="localhost",
                              user ="root",
                              password="sampleSQLtest",
                              db="contact_json")

cursor = con.cursor()

#To create the table and to check if it is existing already
cursor.execute("""
CREATE TABLE IF NOT EXISTS json_contact (
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20)
);
""")

#Loading the json objects to the TABLE under contact_json 
for item in contacts:
    name = item.get('name')
    email = item.get('email')
    phone = item.get('phone')

    cursor.execute(
        "SELECT 1 FROM json_contact WHERE email = %s",
        (email,)
    )
    # To check if the data is already existing
    if cursor.fetchone() is None:
        cursor.execute("INSERT INTO json_contact (name, email, phone) VALUES (%s, %s, %s)",(name, email, phone))

#Normalize data format in Phone column
cursor.execute("UPDATE json_contact SET phone = CONCAT('+1-', SUBSTRING(phone,1,3), '-', SUBSTRING(phone,4,3), '-', SUBSTRING(phone,7,4)) WHERE phone REGEXP '^[0-9]{10}$' AND phone NOT LIKE '+1-%';")

def displayContacts():
    query = "SELECT * FROM json_contact"
    cursor.execute(query)
    results = cursor.fetchall()
    x = 1
    for name, email, phone in results:
        print(f"{x}. Name: {name},   Email: {email},   Phone: {phone}")
        x += 1

def displayUser(name_email):
    pattern = f"%{name_email}%"
    query = "SELECT * FROM json_contact WHERE name like %s OR email like %s"
    cursor.execute(query, (pattern, pattern))
    results = cursor.fetchall()
    if results:
        print("User/s found:")
        # Display each row in a readable format
        for name, email, phone in results:
            print(f"Name: {name},   Email: {email},   Phone: {phone}")
    else:
        print("No users found.")


while True:
    print("\nContact Management System")
    print("1. Retrieve all contacts")
    print("2. Retrieve a specific contact")
    print("3. Exit")
    option = input("Option 1-4: ")
    if option == '1':
        displayContacts()
    elif option == '2':
        find = input("Name or Email: ")
        displayUser(find)
    elif option == '3':
        print("Thank you for using our services!")
        break
    else:
        print("Invalid input!")

    


con.commit()
con.close()



#Impending
#1. NORMALIZE the phone column to +1-XXX-XXX-XXXX  

# conn.commit() permanently saves all changes made in the current database transaction so they are written to the database. 