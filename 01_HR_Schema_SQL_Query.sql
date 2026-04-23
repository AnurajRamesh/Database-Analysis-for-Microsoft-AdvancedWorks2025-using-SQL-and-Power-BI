----------------------------------------------------------------------------------------------------------------
/*
Queries needed to analyse the HumanResources Schema
*/
/* 
Dashboard 1: Workforce structure & Growth 
*/
-- Key Insights
----------------------------------------------------------------------------------------------------------------
-- 1. Total Workforce Size (Current Employees)
SELECT 
    COUNT(*) AS TotalEmployees
FROM HumanResources.EmployeeDepartmentHistory
WHERE EndDate IS NULL;
----------------------------------------------------------------------------------------------------------------
-- 2. Annual Hiring Volume (Growth Speed)
SELECT 
    YEAR(HireDate) AS Year,
    COUNT(*) AS Hires
FROM HumanResources.Employee
WHERE YEAR(HireDate) = 2009
GROUP BY YEAR(HireDate);
----------------------------------------------------------------------------------------------------------------
-- 3. Largest Growing Department (Strategic Focus Area)
SELECT TOP 1
    d.Name AS DepartmentName,
    COUNT(*) AS EmployeeCount
FROM HumanResources.EmployeeDepartmentHistory edh
JOIN HumanResources.Department d
    ON edh.DepartmentID = d.DepartmentID
WHERE edh.EndDate IS NULL
GROUP BY d.Name
ORDER BY EmployeeCount DESC;
----------------------------------------------------------------------------------------------------------------
-- 3. Organizational Depth (Hierarchy Complexity)
SELECT 
    MAX(OrganizationLevel) AS MaxOrgDepth
FROM HumanResources.Employee;
----------------------------------------------------------------------------------------------------------------
-- 1. Organization architecture (Department -> JobTitle -> Count of employees)
SELECT 
    TOP 10
    d.Name AS DepartmentName,
    CASE
        WHEN e.JobTitle LIKE 'Production Supervisor%' THEN 'Production Supervisor'
        WHEN e.JobTitle LIKE 'Production Technician%' THEN 'Production Technician'
        ELSE e.JobTitle
    END AS JobTitleUnique,
    COUNT(*) AS EmployeeCount
FROM HumanResources.EmployeeDepartmentHistory edh
JOIN HumanResources.Department d
    ON d.DepartmentID = edh.DepartmentID
JOIN HumanResources.Employee e
    ON e.BusinessEntityID = edh.BusinessEntityID
WHERE edh.EndDate IS NULL
GROUP BY 
    d.Name,
    CASE
        WHEN e.JobTitle LIKE 'Production Supervisor%' THEN 'Production Supervisor'
        WHEN e.JobTitle LIKE 'Production Technician%' THEN 'Production Technician'
        ELSE e.JobTitle
    END
ORDER BY 
    EmployeeCount DESC;

----------------------------------------------------------------------------------------------------------------
-- 2. The trend of hiring over years.
SELECT 
    YEAR(HireDate) AS HiredYear, 
    COUNT(*) AS NoOfEmployees
FROM HumanResources.Employee
GROUP BY 
    YEAR(HireDate)
ORDER BY 
    HiredYear;

----------------------------------------------------------------------------------------------------------------
-- 3. Departments growth over time (Which departments are growing fastest?)
SELECT 
    d.Name AS DepartmentName,
    YEAR(edh.StartDate) AS Year,
    COUNT(*) AS NoOfEmployees
FROM HumanResources.EmployeeDepartmentHistory edh
JOIN HumanResources.Department d
    ON edh.DepartmentID = d.DepartmentID
GROUP BY 
    d.Name,
    YEAR(edh.StartDate)
ORDER BY 
    d.Name,
    Year;

----------------------------------------------------------------------------------------------------------------
-- 4. Workforce distribution per Organization level
SELECT 
    OrganizationLevel,
    COUNT(*) AS NoOfEmployeesOrgLevel,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS DECIMAL(3,1)) AS Percentage
FROM HumanResources.Employee
WHERE OrganizationLevel IS NOT NULL
GROUP BY 
    OrganizationLevel
ORDER BY 
    OrganizationLevel;

----------------------------------------------------------------------------------------------------------------
/* 
Dashboard 2: Workforce Health, Pay & Fairness 
*/
----------------------------------------------------------------------------------------------------------------
-- 1. Salary distribution across job roles (JobTitle -> Salary)
With LatestPay AS(
    SELECT
        BusinessEntityId,
        Rate,
        ROW_NUMBER() OVER(
            PARTITION BY BusinessEntityId
            ORDER BY RateChangeDate DESC
        ) AS rn
    FROM HumanResources.EmployeePayHistory
)
SELECT
    e.JobTitle,
    ROUND(lp.Rate,2) AS CurrentSalary
FROM LatestPay lp
JOIN HumanResources.Employee e
    ON lp.BusinessEntityID=e.BusinessEntityID
WHERE lp.rn = 1
ORDER BY 
    CurrentSalary DESC;

----------------------------------------------------------------------------------------------------------------
-- 2. Average salary difference between men and women within the same job role and department
WITH LatestPay AS(
    SELECT
        BusinessEntityID,
        Rate,
        ROW_NUMBER() OVER(
        PARTITION BY BusinessEntityId
        ORDER BY RateChangeDate DESC
    ) AS rn
    FROM HumanResources.EmployeePayHistory
)
SELECT 
    d.Name AS DepartmentName,
    e.Gender,
    e.JobTitle,
    ROUND(AVG(lp.Rate),2) AS AverageSalary
FROM LatestPay lp
JOIN HumanResources.Employee e
    ON e.BusinessEntityID=lp.BusinessEntityID
JOIN HumanResources.EmployeeDepartmentHistory edh
    ON edh.BusinessEntityID=e.BusinessEntityID
JOIN HumanResources.Department d
    ON d.DepartmentID=edh.DepartmentID
WHERE lp.rn=1 AND edh.EndDate IS NULL
GROUP BY 
    e.JobTitle, 
    d.Name, 
    e.Gender
ORDER BY 
    e.JobTitle, 
    d.Name, 
    e.Gender;

------------------------------------------------------------------------------------------------------------------ 1. Workforce distribution per Department Name
-- 3. Average tenure by department
SELECT 
    d.Name AS DepartmentName,
    CAST(AVG(
        DATEDIFF(day, edh.StartDate, 
            ISNULL(edh.EndDate, GETDATE())
        ) / 365.0
    ) AS DECIMAL(4,2)) AS AvgTenureYears
FROM HumanResources.EmployeeDepartmentHistory edh
JOIN HumanResources.Department d
    ON edh.DepartmentID = d.DepartmentID
GROUP BY d.Name
ORDER BY AvgTenureYears DESC;

----------------------------------------------------------------------------------------------------------------
-- 4. Workforce Distribution per Department Name
WITH RankedData AS (
    SELECT 
        edh.BusinessEntityID, 
        edh.DepartmentID, 
        d.Name,
        ROW_NUMBER() OVER (
                PARTITION BY edh.BusinessEntityID 
                ORDER BY edh.StartDate DESC -- or any column that defines order
            ) AS rn
    FROM HumanResources.EmployeeDepartmentHistory edh
    JOIN HumanResources.Department d
        ON edh.DepartmentID = d.DepartmentID)
SELECT 
    DepartmentID, 
    Name AS DepartmentName, 
    COUNT(*) AS NoOfEmployeesPerDept
FROM RankedData
WHERE rn=1
GROUP BY 
    DepartmentID, 
    Name
ORDER BY 
    DepartmentID;

----------------------------------------------------------------------------------------------------------------
-- Workforce distribution per Job titles (TOP 5)
/* Select a new column called 'JobTitleUnique', to aggregate all Production Supervisor 
and Production Technician JobTitles to one. */

SELECT TOP 5
    CASE
        WHEN JobTitle LIKE 'Production Supervisor%' THEN 'Production Supervisor'
        WHEN JobTitle LIKE 'Production Technician%' THEN 'Production Technician'
        ELSE JobTitle
    END AS JobTitleUnique,
    COUNT(*) AS NoOfEmployeesPerTitle
FROM HumanResources.Employee
GROUP BY 
    CASE
        WHEN JobTitle LIKE 'Production Supervisor%' THEN 'Production Supervisor'
        WHEN JobTitle LIKE 'Production Technician%' THEN 'Production Technician'
        ELSE JobTitle
    END
ORDER BY 
    NoOfEmployeesPerTitle DESC;

----------------------------------------------------------------------------------------------------------------
