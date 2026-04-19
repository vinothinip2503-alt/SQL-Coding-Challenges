-- =====================================================
-- 📘 SQL Coding Challenges (Day 28–35)
-- =====================================================

-- =====================================================
-- DDL Commands
-- =====================================================

-- CREATE TABLE
CREATE TABLE Patients (
PatientID INT PRIMARY KEY,
PatientName VARCHAR(50),
Age INT,
Gender VARCHAR(10),
AdmissionDate DATE
);

-- ALTER TABLE - ADD COLUMN
ALTER TABLE Patients
ADD DoctorAssigned VARCHAR(50);

-- ALTER TABLE - MODIFY COLUMN
ALTER TABLE Patients
MODIFY PatientName VARCHAR(100);

-- RENAME TABLE
ALTER TABLE Patients
RENAME TO Patient_Info;

-- TRUNCATE & DROP
TRUNCATE TABLE Patient_Info;
DROP TABLE Patient_Info;

-- =====================================================
-- Constraints
-- =====================================================

-- PRIMARY KEY & FOREIGN KEY
CREATE TABLE Books (
BookID INT PRIMARY KEY,
Title VARCHAR(100),
ISBN VARCHAR(20)
);

CREATE TABLE Orders (
OrderID INT PRIMARY KEY,
BookID INT,
FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

-- UNIQUE CONSTRAINT
ALTER TABLE Books
ADD CONSTRAINT unique_isbn UNIQUE (ISBN);

-- DELETE vs TRUNCATE
DELETE FROM Orders WHERE OrderID = 101;
TRUNCATE TABLE Orders;

-- =====================================================
-- Clauses & Operators
-- =====================================================

-- DISTINCT
SELECT DISTINCT Department FROM Students;

-- IS NULL / NOT NULL
SELECT * FROM Students WHERE Email IS NULL;
SELECT * FROM Students WHERE Email IS NOT NULL;

-- IN
SELECT * FROM Students WHERE CourseID IN (101, 102, 103);

-- BETWEEN
SELECT * FROM Students WHERE GPA BETWEEN 3.0 AND 4.0;

-- NOT BETWEEN
SELECT * FROM Students WHERE GPA NOT BETWEEN 2.0 AND 3.0;

-- =====================================================
-- Sorting & Aggregates
-- =====================================================

-- ORDER BY & LIMIT
SELECT * FROM Products
ORDER BY Price DESC
LIMIT 3;

-- AGGREGATE FUNCTIONS
SELECT
COUNT(*) AS TotalSales,
SUM(Amount) AS TotalRevenue,
AVG(Amount) AS AvgSales,
MAX(Amount) AS MaxSale,
MIN(Amount) AS MinSale
FROM Sales;

-- GROUP BY & HAVING
SELECT DepartmentID, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DepartmentID
HAVING COUNT(*) > 10;

-- =====================================================
-- Joins & Union
-- =====================================================

-- INNER JOIN
SELECT s.StudentName, c.CourseName
FROM Students s
INNER JOIN Enrollments e ON s.StudentID = e.StudentID
INNER JOIN Courses c ON e.CourseID = c.CourseID;

-- LEFT JOIN
SELECT s.StudentName, e.CourseID
FROM Students s
LEFT JOIN Enrollments e ON s.StudentID = e.StudentID;

-- RIGHT JOIN
SELECT s.StudentName, e.CourseID
FROM Students s
RIGHT JOIN Enrollments e ON s.StudentID = e.StudentID;

-- UNION
SELECT Name FROM CurrentEmployees
UNION
SELECT Name FROM PastEmployees;

-- UNION ALL
SELECT Name FROM CurrentEmployees
UNION ALL
SELECT Name FROM PastEmployees;

-- =====================================================
-- Functions
-- =====================================================

-- STRING FUNCTIONS
SELECT
UPPER(Name),
LOWER(Name),
SUBSTRING(Name, 1, 3),
CONCAT(FirstName, ' ', LastName)
FROM Employees;

-- DATE FUNCTIONS
SELECT
Name,
YEAR(NOW()) - YEAR(HireDate) AS Tenure,
DATEDIFF(NOW(), HireDate) AS DaysWorked
FROM Employees;

-- USER DEFINED FUNCTION
DELIMITER $$

CREATE FUNCTION GetFullName(fname VARCHAR(50), lname VARCHAR(50))
RETURNS VARCHAR(101)
DETERMINISTIC
BEGIN
RETURN CONCAT(fname, ' ', lname);
END $$

DELIMITER ;

-- =====================================================
-- Procedures & Views
-- =====================================================

-- STORED PROCEDURE
DELIMITER $$

CREATE PROCEDURE GetEmployeeByID(IN emp_id INT)
BEGIN
SELECT * FROM Employees WHERE EmployeeID = emp_id;
END $$

DELIMITER ;

-- SIMPLE VIEW
CREATE VIEW Employee_View AS
SELECT EmployeeName, DepartmentID
FROM Employees;

-- COMPLEX VIEW
CREATE VIEW Employee_Details AS
SELECT
e.EmployeeName,
d.DepartmentName,
s.Salary
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
JOIN Salaries s ON e.EmployeeID = s.EmployeeID;

-- =====================================================
-- Triggers & Transactions
-- =====================================================

-- TRIGGER
CREATE TABLE Order_History (
OrderID INT,
DeletedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$

CREATE TRIGGER before_order_delete
BEFORE DELETE ON Orders
FOR EACH ROW
BEGIN
INSERT INTO Order_History (OrderID)
VALUES (OLD.OrderID);
END $$

DELIMITER ;

-- DCL COMMANDS
GRANT SELECT, INSERT ON Employees TO 'junior_user';
REVOKE INSERT ON Employees FROM 'junior_user';

-- TCL COMMANDS
START TRANSACTION;

UPDATE Accounts SET Balance = Balance - 500 WHERE AccountID = 1;

SAVEPOINT after_debit;

UPDATE Accounts SET Balance = Balance + 500 WHERE AccountID = 2;

ROLLBACK TO after_debit;

COMMIT;
