Hi! Welcome to my small project used to manage Member Contacts

To setup the program and database please follow the instructions below:

DATABASE setup:
In this project I used MySQL as my workbench in handling the database.

There are two ways you can import the data:
1. Through Table Data Import Wizard
2. Executing the 'contact_list_query' sql file 

Through Table Data Import Wizard:
1. Create a schema named 'contacts_db'
2. Right click the schema created and click 'Table Data Import Wizard'
3. Choose the 'contact_list_import' JSON file
4. Import with the following data types as text


Executing the 'contact_list_query'
1. Create a schema named 'contacts_db'
2. Execute the step by step queries in the 'contact_list_query' SQL file
3. Run the 'SELECT * FROM contacts_test' to check if imported correctly



PYTHON PROGRAM:
1. Open the Contact_Management_Program in any Python IDE
2. Change the SQL credentials in the 'db_config' dictionary to match with yours
3. Run the program and execute the processes


Thank you!

