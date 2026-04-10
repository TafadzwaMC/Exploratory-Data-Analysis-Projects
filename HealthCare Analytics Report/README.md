<h1 align="center">National Health Report Dashboard — Healthcare Analytics | Power BI</h1>

<p align="center">
  <img src="https://www.statnews.com/wp-content/uploads/2020/09/AdobeStock_247572575-645x645.jpeg"
       alt="National Health Report Dashboard" width="65%" />
</p>

<br>

<h1 align="left">Business Overview / Problem</h1>

<p align="left">
Hospital management teams and healthcare administrators face significant challenges in gaining a unified, real-time view of patient admissions, treatment costs, and clinical outcomes across multiple facilities. Without centralized analytics, critical decisions around resource planning, budget allocation, and patient care remain reactive rather than proactive. Key challenges include:

    ✓ Siloed Patient Data: Admission records, billing information, discharge dates, and test results are stored separately, making it difficult to connect operational and clinical data for strategic decision-making.

    ✓ Inability to Track Performance Over Time: Hospital administrators lack the tools to monitor year-on-year changes in patient volumes, bed space utilization, doctor availability, and average costs — limiting their ability to identify growth trends or areas of concern.

    ✓ Limited Condition-Specific Insights: With patients presenting across six distinct medical conditions, there is no easy way to compare clinical outcomes, treatment costs, and resource usage by condition, hospital, or insurance provider simultaneously.
</p>

<br>

<h1 align="left">Project Rationale</h1>

<p align="left">
A centralized healthcare analytics dashboard empowers hospital leadership to move from fragmented reporting to data-driven decision-making across all levels of the organization. This project addresses the core business problems through:

    ✓ Data-Driven Decision Making: By consolidating 56,000+ patient records into a single Power BI model, administrators can access accurate, up-to-date KPIs on admissions, billing, length of stay, and doctor availability — all filterable by year, month, hospital, and medical condition.

    ✓ Patient Segmentation: Analytics enables a breakdown of patient demographics by age group, gender, and blood type — helping clinical teams identify population-level patterns and tailor care strategies to specific patient segments.

    ✓ Year-on-Year Performance Tracking: DAX-powered year-on-year comparison measures with directional indicators allow leadership to immediately identify whether key metrics are improving or declining relative to the prior year.

    ✓ Financial & Operational Transparency: By tracking total billing by hospital and insurance provider, and comparing average length of stay across admission types, the dashboard provides a clear picture of both financial performance and operational efficiency.
</p>

<br>

<h1 align="left">Project Aim</h1>

<p align="left">
The aim of this project is to develop a data challenge-winning, 3-page interactive Power BI report that transforms raw healthcare data into a strategic decision-making tool for hospital management and clinical teams.

The project seeks to overcome key challenges including fragmented patient data, limited trend visibility, and the absence of condition-specific clinical and financial benchmarking. A critical component involves the use of advanced Power BI techniques — including DAX measures, field parameters, bookmark navigation, and dynamic titles — to deliver a seamless, insightful, and interactive reporting experience.

By leveraging Power BI's full analytical and visualization capabilities, this dashboard aims to support resource planning, improve patient outcomes, and provide actionable insights across multiple hospitals and medical conditions.
</p>

<br>

<h1 align="left">About the Dataset</h1>

<p align="left">
The project uses records on <strong>56,000+ patients</strong> across multiple U.S. hospitals, covering admissions from 2019 to 2022.

<br><br>

<strong>Health Data (Fact Table):</strong>

    ✓ Patient_ID: A unique identifier for each patient.
    ✓ Age: The age of the patient.
    ✓ Age_Group: Categorized age bracket for demographic analysis.
    ✓ Gender: The gender of the patient (Male, Female, Non-Binary).
    ✓ Blood_Type: The blood group of the patient.
    ✓ Medical_Condition: The diagnosed condition (Arthritis, Asthma, Cancer, Diabetes, Hypertension, Obesity).
    ✓ Date_of_Admission: The date the patient was admitted to the facility.
    ✓ Discharge_Date: The date the patient was discharged from the facility.
    ✓ Length_of_Stay: Custom calculated column — number of days between admission and discharge using DATEDIFF.
    ✓ LOS_Bucket: Categorized stay duration — Short (1–3 days), Moderate (4–7 days), Long (8–14 days).
    ✓ Hospital: The name of the healthcare facility (abbreviated column also created for cleaner visuals).
    ✓ Doctor: The attending physician.
    ✓ Room_Number: The room assigned to the patient.
    ✓ Admission_Type: Type of admission (Emergency, Elective, Urgent).
    ✓ Billing_Amount: Total billed amount for the patient's stay.
    ✓ Insurance_Provider: The patient's insurance company.
    ✓ Medication: Medication prescribed during the stay.
    ✓ Test_Results: Outcome of clinical test (Normal, Inconclusive, Abnormal).

<br>

<strong>Dim Condition (Dimension Table):</strong>

    ✓ Condition_ID: Unique identifier for each medical condition.
    ✓ Medical_Condition: The name of the condition.
    ✓ Description: A brief clinical description of the condition.
    ✓ Image_URL: A URL linking to a representative image for the condition, rendered dynamically in the report.
</p>

<br>

<h1 align="left">Project Scope</h1>

<p align="left">

    ✓ Data Importation: Healthcare data is imported into Power BI via a parameterized folder path (Data Folder parameter), enabling easy replication across different machines without hardcoded file paths.

    ✓ Data Cleaning & Transformation: Data is cleaned and transformed in Power Query — including custom column creation for Length of Stay (using DATEDIFF between admission and discharge dates), LOS bucket segmentation, data type corrections, and table-level transformations for both the Health Data and Dim Condition tables.

    ✓ Data Modeling: A star schema is established with Health Data as the central fact table, connected to a Calendar table (created in Power BI) and the Dim Condition dimension table. A dedicated DAX measures table is created to organize all measures by category (KPIs, Results, Titles, Year-on-Year).

    ✓ DAX Measures: 20+ measures are authored covering distinct count KPIs (admitted patients, rooms, doctors), averages (billing amount, length of stay, patient age), year-on-year percentage change with directional arrow indicators, filtered test result counts and percentages, and dynamic chart titles driven by selected field parameters.

    ✓ Data Visualization: The dataset is visualized across three interactive report pages — Patient Demographics, Key Trends, and Treatment & Cost — featuring bookmark navigation, field parameters, conditional formatting, and dynamic page titles, delivered as a fully interactive Power BI dashboard.
</p>

<br>

<h1 align="left">Tech Stack</h1>

<p align="left">
<strong>Power BI Desktop</strong> — Used end-to-end for data importation, transformation, modeling, DAX measure authoring, and interactive dashboard development across three report pages.

<br><br>

<strong>Power Query</strong> — Used for data cleaning and transformation, including custom column creation for length of stay and LOS bucket segmentation, data type corrections, and parameterized folder path configuration for portable data connection.

<br><br>

<strong>DAX (Data Analysis Expressions)</strong> — Used to author all KPI measures, year-on-year comparison logic with variable-based calculations, filtered test result measures, percentage calculations, and dynamic switch-based chart titles tied to active field parameters.
</p>

<br>

<h1 align="left">Report Pages</h1>

<p align="left">

<strong>1. Patient Demographics</strong>

    ✓ KPI cards: admitted patients, rooms/bed space, average billing amount, doctors, average length of stay, average patient age
    ✓ Year-on-year change indicators with directional arrows for each KPI — showing % increase or decrease vs. prior year, with "No Selection" and "No Data" states handled in DAX
    ✓ Bookmark-driven demographic breakdown (bookmark navigator): admitted patients by age group and gender, by medical condition, and by blood group — with data unchecked from bookmarks to preserve slicer selections on switch
    ✓ Dynamic medical condition panel: condition-specific image (rendered via table visual from Dim Condition URL), brief clinical description, and test result cards (Normal / Inconclusive / Abnormal — count and % of total)
    ✓ Slicers: Year, Month, Medical Condition

<strong>2. Key Trends</strong>

    ✓ Dynamic line chart with field parameter KPI switcher: Admitted Patients / Average Length of Stay / Average Billing Amount — with force selection enabled and dynamic title driven by active parameter via DAX switch function
    ✓ Breakdown by admission type (Emergency, Elective, Urgent) on the line chart legend
    ✓ Day type distribution — weekday vs. weekend (donut chart showing % of admitted patients)
    ✓ Length of stay bucket distribution (donut chart — Short, Moderate, Long stay)
    ✓ Monthly × weekly admitted patient matrix with conditional formatting using a purple color scale
    ✓ Slicers: Hospital, Medical Condition, Year

<strong>3. Treatment & Cost</strong>

    ✓ Clustered column chart: total billing and average length of stay by admission type and LOS bucket
    ✓ Dynamic column chart: total billing by hospital or insurance provider — toggled via field parameter with force selection and dynamic DAX title driven by selected medical condition
    ✓ Medical condition × medication matrix table showing admitted patient counts per medication type
    ✓ Slicers: Year, Medical Condition
</p>

