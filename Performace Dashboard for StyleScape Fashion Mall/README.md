
 Business Overview/Problem

StyleScape relies heavily on its weekly sales performance to gauge market traction and devise future strategies. However, the Regional Sales Manager of StyleScape, Nigerian division, has been facing challenges in obtaining a clear and efficient view of these sales figures. The manager has identified the need for an organized and efficient way to monitor weekly sales performance. Current method involves manually computing sales, a process that is time-consuming, prone to inaccuracies, and lacks visual representation, making it difficult to see trends. 

 

Specific Obstacles:

 

    A. Limited Visual Analytics: Current reporting is more numeric, less visual, making it harder to spot trends.
     
    B. Manual Report Generation: Weekly reports were not generated automatically, leading to delays and possible inaccuracies.
     
    C. Undefined KPIs: Ambiguity in which performance metrics to consistently measure and monitor.
     
    D. Inconsistent Reporting: Variations in reporting metrics and formats.

Rationale for the Project

    A sales dashboard provides a visual representation of a business sales data and metrics. It provide an overview of a business sales performance at any given moment.

     

    Given StyleScrape’s presence across Africa, having immediate access to clear sales insights is important. A sales dashboard would streamline the current manual, error-prone process by providing visual, automated reporting with clearly defined sales metrics. This will ensure that StyleScape can quickly  identify trends, reduce manual reporting and make strategic decisions.

Aim of the Project

The aim of this project is to create an automated sales dashboard for StyleScrape sales department that meets the following requirements:


    A. Weekly Sales Breakdown: Create an intuitive dashboard to visualize sales performance for each week day, comparing it to the previous week.
     
    B. Auto-Updates: Ensure dashboard is automatically updated every week.
     
    C. Define KPIs: Identify number of customers each week, sales growth week-over-week, average sales value, top-selling products, and other important sales metrics.

Data Description

Sales Order:

    ✓ OrderID (PK): A unique identifier for each sales transaction.
    ✓ SalesDate: The date when the transaction took place.
    ✓ ProductID (FK): A foreign key referencing the ProductID in the Products table, indicating the product that was sold.
    ✓ CustomerID (FK): A foreign key referencing the CustomerID in the Customers table, indicating the customer who made the purchase.
    ✓ PersonnelID (FK): A foreign key referencing the PersonnelID in the Sales Personnel table, indicating the sales member who handled the transaction.
    ✓ SalesChannel: Specifies the medium through which the sale was made, e.g., "Online" or "In-store".
    ✓ Quantity: The number of units of the product sold in the transaction.
    ✓ SalesAmount: The total sales amount of the transaction.
    ✓ PaymentMode: The method used to pay for the transaction, e.g., "Debit Card" or "Cash".
    ✓ StoreID (FK): A foreign key that references the StoreID in the StoreLocation table, indicating the store where the transaction took place.

Tech Stack

    A. SQL: For querying the database to extract data.

 

    B. Power BI: Used to create an interactive dashboard providing day-by-day insights, pulling real-time data from SQL databases.

Project Scope

    A. Data Aggregation: Query SQL Server Database to extract data in required format
     
    B. Data Integration:  Connect Power BI to database, to ensure direct data feed
     
    C. Data Modelling: Create data models in Power BI
     
    D. Analysis & Visualization: Analyze data, define KPIs, and visualize it in Power BI
