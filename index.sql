--Matthew Jester 103219809

--Task1

--Subject(SubjCode, Description)
--PK(SubjCode)
--
--Teacher(StaffID, Surname, GivenName)
--PK(StaffID)
--
--Student(StudentID, Surname, GivenName, Gender)
--PK(StudentID)
--
--SubjectOffering(SubjCode, Year, Semester,StaffID, Fee)
--PK(SubjCode, Year, Semester)
--FK(SubjCode) references Subject
--FK(StaffID) references Teacher
--
--
--Enrolement(StudentID, SubjCode, Year, Semester, DateEnrolled, Grade)
--PK(StudentID, SubjCode, Year, Semester)
--FK(StudentID) references Student
--FK(SubjCode, Year, Semester) references SubjectOffering
--
--
--
/* IF OBJECT_ID('Enrolement') IS NOT NULL
DROP TABLE Enrolement;

IF OBJECT_ID('SubjectOffering') IS NOT NULL
DROP TABLE SubjectOffering;

IF OBJECT_ID('Student') IS NOT NULL
DROP TABLE Student;

IF OBJECT_ID('Teacher') IS NOT NULL
DROP TABLE Teacher;

IF OBJECT_ID('Subject') IS NOT NULL
DROP TABLE Subject;

 CREATE TABLE Subject (
  SubjCode        NVARCHAR(100)  
, Description     NVARCHAR(500)
, PRIMARY KEY (SubjCode)
);

CREATE TABLE Teacher (
  StaffID        INT CHECK (len(StaffID) = 8)
, Surname        NVARCHAR(30) NOT NULL 
, GivenName      NVARCHAR(30) NOT NULL
, PRIMARY KEY (StaffID)
);

CREATE TABLE Student (
  StudentId         NVARCHAR(10)
, Surname           NVARCHAR(100)  NOT NULL
, GivenName         NVARCHAR(100)  NOT NULL
, Gender            NVARCHAR(1) CHECK (Gender IN('M','F','I'))
, PRIMARY KEY (StudentId)
);

CREATE TABLE SubjectOffering (
  SubjCode         NVARCHAR(100)
, Year             INT  CHECK (len(Year) = 4)
, Semester         INT  CHECK (Semester IN(1,2))
, StaffID          INT
, Fee              MONEY CHECK (Fee > 0) NOT NULL
, PRIMARY KEY (SubjCode, Year, Semester)
, FOREIGN KEY (SubjCode) references Subject
, FOREIGN KEY (StaffID) references Teacher
);

CREATE TABLE Enrolement (
  StudentId         NVARCHAR(10)
, SubjCode          NVARCHAR(100)
, Year              INT  CHECK (len(Year) = 4)  
, Semester          INT  CHECK (Semester IN(1,2))
, Grade             NVARCHAR(2) CHECK (Grade IN('N','P','C','D','HD')) DEFAULT NULL
, DateEnrolled      DATE
, PRIMARY KEY (StudentID, SubjCode, Year, Semester)
, FOREIGN KEY (StudentID) references Student
, FOREIGN KEY (SubjCode, Year, Semester) references SubjectOffering
);

GO


INSERT INTO Student (StudentId, Surname, GivenName, Gender) VALUES 
('103219809','Jester','Matthew','M')
,('s12233445','Morrison','Scott','M')
,('s23344556','Gillard','Julia','F')
,('s34455667','Whitlam','Gough','M')
;

INSERT INTO Subject (SubjCode, Description ) VALUES 
('ICTWEB425','Apply SQL to extract & manipulate data')
,('ICTDBS403','Create Basic Databases')
,('ICTDBS502','Design a Database')
;

INSERT INTO Teacher (StaffID, Surname, GivenName ) VALUES 
(98776655,'Starr', 'Ringo')
,(87665544, 'Lennon', 'John')
,(76554433,'McCartney', 'Paul')
;

INSERT INTO SubjectOffering (SubjCode, Year, Semester, Fee, StaffID) VALUES 
('ICTWEB425', 2018, 1,	200,	98776655)
,('ICTWEB425', 2019, 1,	225,	98776655)
,('ICTDBS403', 2019, 1,	200,	87665544)
,('ICTDBS403', 2019, 2,	200,	76554433)
,('ICTDBS502', 2018, 2,	225,	87665544)
;

INSERT INTO Enrolement (StudentID, SubjCode, Year, Semester, Grade) VALUES
('s12233445',	  'ICTWEB425',	2018,	1, 'D')
,('s23344556',	'ICTWEB425',	2018,	1, 'P')
,('s12233445',	  'ICTWEB425',	2019,	1, 'C')
,('s23344556',	'ICTWEB425',	2019,	1, 'HD')
,('s34455667',	'ICTWEB425',	2019,	1, 'P')
,('s12233445',	  'ICTDBS403',	2019,	1, 'C')
,('s23344556',	'ICTDBS403',	2019,	2, NULL)	
,('s34455667',	'ICTDBS403',	2019,	2, NULL)	
,('s23344556',	'ICTDBS502',	2018,	2, 'P')
,('s34455667',	'ICTDBS502',	2018,	2, 'N')
;

select *
from Student */

--Query 1
select ST.GivenName, ST.Surname, E.SubjCode, E.Year, E.Semester, SO.Fee, T.Surname, T.GivenName 
from Student ST 
LEFT JOIN Enrolement E
on ST.StudentID = E.StudentID
LEFT JOIN SubjectOffering SO
on E.SubjCode = SO.SubjCode
and E.Year = SO.Year
and E.Semester = SO.Semester
LEFT JOIN Teacher T
on SO.StaffID = T.StaffID

--Checking the amount of students to confirm all have been accounted for
Select count(*)
from Student
--Query 2
Select SO.Year, SO.Semester, count(*) as 'Num Enrollments'
from SubjectOffering SO
LEFT JOIN Enrolement E
on SO.SubjCode = E.SubjCode
and SO.Year = E.Year
and SO.Semester = E.Semester
GROUP BY SO.Year, SO.Semester

--Checking the above will bring over the correct amount of enrolements
Select Count(*)
from Enrolement

Select * 
from Enrolement

--Query 3
Select E.StudentID, E.SubjCode, E.Year, E.Semester, E.Grade, SO.Fee
from Enrolement E
left join SubjectOffering SO
on E.SubjCode = SO.SubjCode
and E.Year = SO.Year
and E.Semester = SO.Semester
where SO.Fee = (Select max(Fee) from SubjectOffering)