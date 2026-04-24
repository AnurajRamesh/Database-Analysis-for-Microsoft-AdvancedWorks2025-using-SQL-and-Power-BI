# Workforce Analytics Dashboard 
### Using MS SQL Server Management Studio And MS Power BI



## Project Overview



This project analyses the **AdvancedWorks2025** Database, with primary focus on workforce structure, growth, compensation and organizational hierarchy. The main objective of this analysis is to transform the raw data obtained from the HR Schema into **actionable business insights** that supports the **data driven strategic decision-making**.



The study is built on the **HumanResources Schema**, focusing on:



* Workforce distribution

* Hiring trends

* Growth over departments

* Organizational structure

* Compensation and Fairness



## Business Objectives



* Understand the workforce distribution across different departments and job roles
* Identify the hiring trend and growth patterns over years
* Find the strategic department driving expansion
* Analyse the organizational hierarchy
* Evaluate salary distribution and pay equity
* Calculate tenure of the employee and workforce stability



## Used Tools



* **MS SQL Server Management Studio (SSMS)**: Data extraction and transformation
* **MS Power BI**: Data visualization and creation of dashboards
* **DAX**: KPI calculations and dynamic measures



## Project Structure



	├── 01_HR_AdventureWorks2025.pbix
	
	├── 02_Visualization_Power_BI

		├── HR_Dashboards.pdf

		├── HR_Dashboard_1.png

		├── HR_Dashboard_2.png

	├── 01_HR_Schema_SQL_Query.sql
	
	├── README.md





---
## Dashboard 1: Workforce Structure \& Growth



## Key Insights



* Production dominates the workforce, confirming its role as the core operational function.
* Hiring peaked in 2009, indicating a major expansion phase.
* Growth was primarily driven by the Production department, highlighting it as a strategic focus area.
* The organization follows a **pyramidal hierarchy structure**, with most employees at lower levels and fewer at the top.





## Key Visuals



* Workforce distribution by Department \& Job Title
* Hiring trend over time
* Department-level growth trends
* Organization level distribution



## Dashboard 1 Preview



<img width="1149" height="643" alt="HR_Dashboard_1" src="https://github.com/user-attachments/assets/a193f574-513c-4498-b963-749a25b4ef1d" />






## Business Insights



* The organization is operationally heavy, with a strong dependency on production roles.
* Hiring patterns suggest periodic expansion cycles, not steady growth.
* The hierarchical structure indicates centralized decision-making.
* Opportunities exist for workforce balancing and planning
---





# Dashboard 2: Workforce Compensation, Tenure & Workforce Health

## Key Insights

- CEO compensation is significantly higher than all other roles, indicating executive pay concentration
- Salary inequality ratio suggests a noticeable gap across job titles
- No gender pay gap observed within comparable roles and departments
- Shipping & Receiving shows the highest employee retention
- Production department has the largest workforce (179 employees)

## Key Visuals

- Salary distribution across top 10 job roles
- Gender-based salary comparison (same job title across various departments)
- Average employee tenure by department
- Employee distribution across departments
- KPI Cards:
  - Highest Pay (CEO)
  - Salary Inequality Ratio
  - Average Employee Tenure
  - Internal Mobility Rate


## Preview

<img width="1411" height="791" alt="HR_Dashboard_2" src="https://github.com/user-attachments/assets/735d815c-ac63-48f6-99af-82d5c6d3c154" />

---

## Business Insights

- Executive salary is disproportionately high in comparison with other roles
- Equal pay across genders indicates strong compliance and fairness policies
- High retention in logistics-related roles suggests stable operational teams
- Higher workforce in Production indicates operational dependency
- Salary structure and tenure differences indicate opportunities for:
  - Retention strategy improvements
  - Compensation restructuring
  - Internal mobility optimization
  - Higher workforce needed in R&D

---

## SQL Analysis Approach

Key SQL operations used in this project include:

- Joins across HR tables for employee, department, and pay history data
- Window and subquery functions for ranking and salary comparison
- Aggregations for workforce distribution and tenure
- Date functions for hiring trend analysis















