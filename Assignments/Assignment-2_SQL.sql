-- Assignment 2

create table Dept ( 
	DeptNo int NOT NULL,
    Dname varchar(50) NOT NULL,
    Loc varchar(50),
    PRIMARY KEY (DeptNo)
);

INSERT INTO Dept VALUES ('20','IT','Delhi'),('30','Production','Chennai'),('40','Sales','Hyd' ), ('50','Admn','London') ;

select * from Dept;


EmpNo	Ename	Sal	Hire_Date	Commission	DeptNo	Mgr
1001	Sachin	19000	1-Jan-1980	2100	20	1003
1002	Kapil	15000	1-Jan-1970	2300	10	1003
1003	Stefen	12000	1-Jan-1990	500		20	1007
1004	Williams 9000	1-Jan-2001	NULL	30	1007
1005	John	5000	1-Jan-2005	NULL	30	1006
1006	Dravid	19000	1-Jan-1985	2400	10	1007
1007	Martin	21000	1-Jan-2000	1040	NULL	NULL


create table Emp ( 
	EmpNo int NOT NULL,
    Ename varchar(50) NOT NULL,
    Sal int,
    Hire_Date date,
    Commission int,
    DeptNo int,
    Mgr int,
    PRIMARY KEY (EmpNo),
    FOREIGN KEY (DeptNo) REFERENCES Dept(DeptNo)
);


-- 1. 	Select employee details  of dept number 10 or 30 
	SELECT *  FROM Emp WHERE DeptNo = “10” OR DeptNo = “30” ;


-- 2.	Write a query to fetch all the dept details with more than 1 Employee.
	SELECT * FROM Dept WHERE DeptNo IN ( SELECT DeptNo FROM Emp  GROUP BY DeptNo   HAVING COUNT(*) >1 );

-- 3.	Write a query to fetch employee details whose name starts with the letter “S”
	SELECT * FROM Emp WHERE Ename like 'S%';

-- 4.	Select Emp Details Whose experience is more than 2 years
	SELECT * FROM Emp WHERE (YEAR(CURDATE()) - YEAR(Hire_Date)) > 2;

-- 5.	Write a SELECT statement to replace the char “a” with “#” in Employee Name ( Ex:  Sachin as S#chin)
	SELECT REPLACE(Ename, 'a', '#') AS EmpName FROM Emp;
     
-- 6.	Write a query to fetch employee name and his/her manager name. 
	SELECT e.Ename AS EmpName, m.Ename AS MgrName FROM Emp e JOIN Emp m ON (m.Mgr = e.EmpNo);

-- 7.	Fetch Dept Name , Total Salry of the Dept
	SELECT d.Dname AS department_name, SUM(e.Sal) AS total_salary
	FROM Emp e, Dept d WHERE e.DeptNo = d.DeptNo GROUP BY d.Dname ;


-- 8.	Write a query to fetch ALL the  employee details along with department name, department location, irrespective of employee existance in the department.
	SELECT * FROM Emp e JOIN Dept d ON e.DeptNo = d.DeptNo ;

-- 9.	Write an update statement to increase the employee salary by 10 %
	UPDATE Emp SET Sal = Sal * 1.1;

-- 10.	Write a statement to delete employees belong to Chennai location.
	DELETE FROM Emp WHERE DeptNo IN (SELECT DeptNo FROM Dept WHERE Loc="Chennai");

-- 11.	Get Employee Name and gross salary (sal + comission) .
	SELECT Ename, SUM(Sal + Commission) as Gross_Salary FROM Emp group by Ename;

-- 12.	Increase the data length of the column Ename of Emp table from  100 to 250 using ALTER statement
	ALTER TABLE Emp MODIFY Ename VARCHAR(250);

-- 13.	Write query to get current datetime
	SELECT NOW( ) ;

-- 14.	Write a statement to create STUDENT table, with related 5 columns
	CREATE TABLE STUDENT (
		S_ID INT PRIMARY KEY,
		S_NAME VARCHAR(50) NOT NULL,
		S_DOB DATE,
		S_BRANCH CHAR(20),
		S_GENDER VARCHAR(10)
	);

-- 15.	 Write a query to fetch number of employees in who is getting salary more than 10000
	SELECT COUNT(*) FROM Emp WHERE Sal > 10000;

-- 16.	Write a query to fetch minimum salary, maximum salary and average salary from emp table.
	SELECT MIN(Sal) AS min_salary, MAX(Sal) AS max_salary, AVG(Sal) AS avg_salary FROM Emp;

-- 17.	Write a query to fetch number of employees in each location
	SELECT Loc, COUNT(*) as num_employees FROM Emp e, Dept d WHERE e.DeptNo=d.DeptNo GROUP BY Loc;

-- 18.	Write a query to display emplyee names in descending order
	SELECT EName from Emp ORDER BY EName DESC ;
    
-- 19.	Write a statement to create a new table(EMP_BKP) from the existing EMP table 
	CREATE TABLE EMP_BKP AS SELECT * FROM Emp ;

-- 20.	 Write a query to fetch first 3 characters from employee name appended with salary.
	SELECT LEFT(Ename, 3) AS EmpName , Sal FROM Emp;

-- 21)	 Get the details of the employees whose name starts with S
	SELECT * FROM Emp WHERE Ename like 'S%';

-- 22)	 Get the details of the employees who works in Bangalore location
	SELECT * FROM Emp WHERE DeptNo IN (SELECT DeptNo FROM Dept WHERE Loc="Bangalore");

-- 23) 	Write the query to get the employee details whose name started within  any letter between  A and K
	SELECT * FROM Emp WHERE Ename LIKE '[A-K]%';

-- 24) 	Write a query in SQL to display the employees whose manager name is Stefen 
	SELECT Ename FROM Emp WHERE Mgr IN (Select EmpNo FROM Emp WHERE Ename="Stefen") ;

-- 25) 	Write a query in SQL to list the name of the managers who is having maximum number of employees working under him
	SELECT (SELECT Ename FROM Emp WHERE EmpNo = e.Mgr) as Manager_name 
    FROM Emp e GROUP BY Mgr 
    HAVING COUNT(*) = (
		SELECT MAX(employee_count) FROM (SELECT COUNT(*) as employee_count FROM Emp GROUP BY Mgr
        ) counts);

-- 26)	Write a query to display the employee details, department details and the manager details of the employee who has second highest salary
	SELECT 
		e.EmpNo AS employee_id,
		e.Ename AS employee_name, 
        e.Sal AS employee_salary, 
        d.Dname AS department_name, 
		(SELECT Ename FROM Emp WHERE EmpNo = e.Mgr) as Manager_name 
        FROM Emp e JOIN Dept d ON e.DeptNo = d.DeptNo WHERE e.Sal = (
			SELECT Sal FROM Emp GROUP BY Sal ORDER BY Sal DESC LIMIT 1, 1 
		) LIMIT 1;

-- 27) 	Write a query to list all details of all the managers
	SELECT M.EmpNo, M.Ename, M.Sal, D.Dname as Department 
    FROM Emp M JOIN Dept D ON M.DeptNo = D.DeptNo WHERE M.EmpNo IN ( 
			SELECT Mgr FROM Emp WHERE Mgr IS NOT NULL
        );

-- 28) Write a query to list the details and total experience of all the managers
	SELECT (SELECT Ename FROM Emp WHERE EmpNo = e.Mgr) as Manager_name,
	SUM(DATEDIFF(NOW(), e.Hire_Date) ) AS total_experience FROM Emp e GROUP BY Manager_name;

-- 29) 	Write a query to list the employees who is manager and  takes commission less than 1000 and works in Delhi
	SELECT (SELECT Ename FROM Emp WHERE EmpNo = e.Mgr) as Manager_name, e.Commission ,d.Loc 
    FROM Emp e, Dept d where Commission < 2500 AND e.DeptNo=d.DeptNo AND d.Loc="Delhi";

-- 30) 	Write a query to display the details of employees who are senior to Martin 
	SELECT * FROM Emp WHERE Hire_Date < ( SELECT Hire_Date FROM Emp WHERE Ename = "Martin" );

