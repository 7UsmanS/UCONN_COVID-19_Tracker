/* OPIM 5272; UCONN COVID Positive Case Tracking
   Group Five Project: Shaista Uman, Bajram Lumani, Junchi Ma, Godfrey Gelineau
   Project Due Date: 12/14/20
   Below are SQL CREATE and INSERT statements
*/

-- ===========================================================================
-- Deleting Tables
-- ===========================================================================

DROP TABLE        Person             				CASCADE CONSTRAINTS;
DROP TABLE        CovidTest             			CASCADE CONSTRAINTS;
DROP TABLE        Facility             				CASCADE CONSTRAINTS;
DROP TABLE        CardScanLog             			CASCADE CONSTRAINTS;
DROP TABLE        Student             				CASCADE CONSTRAINTS;
DROP TABLE        Faculty             				CASCADE CONSTRAINTS;
DROP TABLE        Staff             				CASCADE CONSTRAINTS;
DROP TABLE        Course             				CASCADE CONSTRAINTS;
DROP TABLE        StudentCourse             		CASCADE CONSTRAINTS;
DROP TABLE        FacultyCourse             		CASCADE CONSTRAINTS;
DROP TABLE        CourseRoomAssignment             	CASCADE CONSTRAINTS;
DROP TABLE        RoomAssignment             		CASCADE CONSTRAINTS;
DROP TABLE        QuarantineList             		CASCADE CONSTRAINTS;

-- ===========================================================================
-- Deleting Sequences
-- ===========================================================================

DROP SEQUENCE     SEQ_Person_ID;  
--DROP SEQUENCE     SEQ_TEST_ID; 
--DROP SEQUENCE     SEQ_ROOM_ID; 
--DROP SEQUENCE     SEQ_SCAN_ID; 
--DROP SEQUENCE     SEQ_STUDENTCOURSE_ID; 
--DROP SEQUENCE     SEQ_FACULTYCOURSE_ID; 
--DROP SEQUENCE     SEQ_COURSEROOM_ID ;
--DROP SEQUENCE     SEQ_ROOMASSIGNMENT_ID; 
--DROP SEQUENCE     SEQ_QUARANTINE_ID;

-- ===========================================================================
-- Create table Person.
-- ===========================================================================

CREATE TABLE Person
    ( PersonID     NUMBER(6)     
    , FirstName    VARCHAR2(20) CONSTRAINT fname_nn NOT NULL
    , LastName     VARCHAR2(20) CONSTRAINT lname_nn NOT NULL
    , DOB          DATE
    , OnCampus     NUMBER(1)        --Boolean values; 1 - Yes, 0 - No
    , phoneNum     NUMBER(11)
    , Title        VARCHAR2(3)
    , email        VARCHAR2(40)
    , BadgeId      NUMBER(6)
    , CONSTRAINT person_id_pk PRIMARY KEY (PersonID)
    ) ;
	
-- ===========================================================================
-- Create table CovidTest.
-- ===========================================================================
CREATE TABLE CovidTest
	( TestID          NUMBER(7) 	PRIMARY KEY
    , TestResult      VARCHAR2(20)
    , DateTaken       DATE
    , DateResult      DATE
    , TestLocation    VARCHAR2(30)
    , PersonID        NUMBER(6)
    , ConsecNegTest   NUMBER(7)
    , CONSTRAINT PersonID_fk FOREIGN KEY(PersonID) REFERENCES Person(PersonID)
    , CONSTRAINT ConcecNegTest_fk FOREIGN KEY(ConsecNegTest) REFERENCES CovidTest(TestID)
	);
    
-- ===========================================================================
-- Create table Facility.
-- ===========================================================================

CREATE TABLE Facility
   (  RoomID                NUMBER(4) 	    PRIMARY KEY
    , FacilityName          VARCHAR2(35) 	CONSTRAINT facname_nn NOT NULL
    , StreetAddress         VARCHAR2(30) 	CONSTRAINT facadd_nn NOT NULL
    , CityAddress           VARCHAR2(30) 	CONSTRAINT faccitadd_nn NOT NULL
    , StateAddress          VARCHAR2(20) 	CONSTRAINT facstaadd_nn NOT NULL
    , ZipAddress            VARCHAR2(6) 	CONSTRAINT faczipadd_nn NOT NULL
    , Campus                VARCHAR2(20)
    , BuildingNum           VARCHAR2(9)
    , RoomNum               NUMBER(4)
    , FloorNum              NUMBER(2)
    , FacilityType          VARCHAR2(13) 
   );

-- ===========================================================================
-- Create table CardScanLog.
-- ===========================================================================

CREATE TABLE CardScanLog
    ( ScanID      NUMBER(7) 	PRIMARY KEY
    , LogTime     VARCHAR2(8)
    , LogDate     DATE
    , RoomID      NUMBER(6), 	CONSTRAINT RoomID_fk FOREIGN KEY(RoomID) REFERENCES Facility(RoomID)
    , PersonID    NUMBER(6), 	CONSTRAINT PersonID_CSlog_fk FOREIGN KEY(PersonID) REFERENCES Person(PersonID)
    );
	
-- ===========================================================================
-- Create table Student.
-- ===========================================================================

CREATE TABLE Student
    ( PersonID            NUMBER(6) 	PRIMARY KEY
    , GraduationDate      DATE
    , EnrollmentDate      DATE 			CONSTRAINT stud_EnrDate_nn NOT NULL
    , GraduationStatus    VARCHAR2(7)
    , Major               VARCHAR2(30)
    , Minor               VARCHAR2(30)
    , ActiveStudent       NUMBER(1)       --Boolean values; 1 - Yes, 0 - No
    , DegreeType          VARCHAR2(20)
    , CONSTRAINT PersonID_Stu_fk FOREIGN KEY(PersonID) REFERENCES Person(PersonID)
    );
	
-- ===========================================================================
-- Create table Faculty.
-- ===========================================================================

CREATE TABLE Faculty
    ( PersonID            NUMBER(6) 	PRIMARY KEY
    , ActiveProfessor     NUMBER(1)       --Boolean values; 1 - Yes, 0 - No
    , Department          VARCHAR2(30)
    , CONSTRAINT PersonID_Fac_fk FOREIGN KEY(PersonID) REFERENCES Person(PersonID)
    );

-- ===========================================================================
-- Create table Staff.
-- ===========================================================================

CREATE TABLE Staff
    ( PersonID    NUMBER(6) 		PRIMARY KEY
    , StaffRole   VARCHAR2(30)
    , CONSTRAINT PersonID_Stf_fk FOREIGN KEY(PersonID) REFERENCES Person(PersonID)
    );
	
-- ===========================================================================
-- Create table Course.
-- ===========================================================================

CREATE TABLE Course
    ( CourseID        NUMBER(6)    PRIMARY KEY
    , CourseModality  VARCHAR2(20) CONSTRAINT course_mode_nn NOT NULL
	, StartDate       DATE			-- Course Start Date 
	, EndDate		  DATE			-- Course END Date 
    , DAYOFWEEK       NUMBER(1)     -- 1 - Sunday, 2 - Monday, 3 - Tuesday, 4 - Wednesday, 5 - Thursday, 6 - Friday, 7 - Saturday
    , ClassStartTime  VARCHAR2(8)     -- Class start Time
    , ClassEndTime    VARCHAR2(8)    -- Class end Time
    , Semester        VARCHAR2(20)
    , Code            VARCHAR2(8)  CONSTRAINT course_code_nn NOT NULL
    , Section         VARCHAR2(4)  CONSTRAINT course_sec_nn NOT NULL
    );

-- ===========================================================================
-- Create table StudentCourse.
-- ===========================================================================

CREATE TABLE StudentCourse
    ( StudentCourseID     NUMBER(6) 	PRIMARY KEY
    , PersonID            NUMBER(6), 	CONSTRAINT PersonID_StCourse_fk FOREIGN KEY(PersonID) REFERENCES Person(PersonID)
    , CourseID            NUMBER(6), 	CONSTRAINT CourseID_StCourse_fk FOREIGN KEY(CourseID) REFERENCES Course(CourseID)
    , RegistrationDate    DATE 			CONSTRAINT course_reg_date_nn NOT NULL
    );

-- ===========================================================================
-- Create table FacultyCourse.
-- ===========================================================================

CREATE TABLE FacultyCourse
    ( FacultyCourseID     NUMBER(6) 	PRIMARY KEY
    , PersonID            NUMBER(6), 	CONSTRAINT PersonID_FctCourse_fk FOREIGN KEY(PersonID) REFERENCES Person(PersonID)
    , CourseID            NUMBER(6), 	CONSTRAINT CourseID_FctCourse_fk FOREIGN KEY(CourseID) REFERENCES Course(CourseID)
    , AssignDate          DATE 			CONSTRAINT course_assn_date_nn NOT NULL    
    );

-- ===========================================================================
-- Create table CourseRoomAssignment.
-- ===========================================================================

CREATE TABLE CourseRoomAssignment
    ( CourseRoomID    NUMBER(6) 	PRIMARY KEY
    , RoomID          NUMBER(6), 	CONSTRAINT RoomID_Cra_fk FOREIGN KEY(RoomID) REFERENCES Facility(RoomID)
    , CourseID        NUMBER(6), 	CONSTRAINT CourseID_Cra_fk FOREIGN KEY(CourseID) REFERENCES Course(CourseID)
    );

-- ===========================================================================
-- Create table RoomAssignment.
-- ===========================================================================

CREATE TABLE RoomAssignment
    ( RoomAssignmentID    NUMBER(6) 	PRIMARY KEY
	, RoomID              NUMBER(6), 	CONSTRAINT RoomID_ra_fk FOREIGN KEY(RoomID) REFERENCES Facility(RoomID)
	, PersonID            NUMBER(6), 	CONSTRAINT PersonID_ra_fk FOREIGN KEY(PersonID) REFERENCES Person(PersonID)
	);

-- ===========================================================================
-- Create table QuarantineList.
-- ===========================================================================

CREATE TABLE QuarantineList
	( QuarantineID    NUMBER(6) 	PRIMARY KEY
    , PersonID        NUMBER(6), 	CONSTRAINT PersonID_quarList_fk FOREIGN KEY(PersonID) REFERENCES Person(PersonID)    
	, QuarantineLoc   VARCHAR2(10)
	, StartDate       DATE
	, EndDate         DATE
	, TestID          NUMBER(7), 	CONSTRAINT TestID_fk FOREIGN KEY(TestID) REFERENCES CovidTest(TestID)
);

-- ===========================================================================
-- Create Sequences
-- ===========================================================================

CREATE SEQUENCE SEQ_Person_ID          	START WITH 100000   INCREMENT BY 1;
--CREATE SEQUENCE SEQ_TEST_ID             START WITH 1000000  INCREMENT BY 1;
--CREATE SEQUENCE SEQ_ROOM_ID             START WITH 1000     INCREMENT BY 1;
--CREATE SEQUENCE SEQ_SCAN_ID             START WITH 2000000  INCREMENT BY 1;
--CREATE SEQUENCE SEQ_STUDENTCOURSE_ID    START WITH 400000   INCREMENT BY 1;
--CREATE SEQUENCE SEQ_FACULTYCOURSE_ID    START WITH 500000   INCREMENT BY 1;
--CREATE SEQUENCE SEQ_COURSEROOM_ID       START WITH 600000   INCREMENT BY 1;
--CREATE SEQUENCE SEQ_ROOMASSIGNMENT_ID   START WITH 700000   INCREMENT BY 1;
--CREATE SEQUENCE SEQ_QUARANTINE_ID       START WITH 800000   INCREMENT BY 1;

-- ===========================================================================
-- INSERT: Person and Subtypes (Student, Faculty, Staff)
-- ===========================================================================

INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'John', 'Russel', TO_DATE('01-10-1995','dd-MM-yyyy'), 1, 12039799551, 'stu', 'JRussel@Uconn.edu', 200000);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('01-09-2024', 'dd-MM-yyyy'), TO_DATE('01-09-2020', 'dd-MM-yyyy'), 'current', 'Physics', 'Statistics', 1, 'Undergraduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Mark', 'Anderson', TO_DATE('15-09-1997','dd-MM-yyyy'), 1, 12039799552, 'stu', 'MAnderson@Uconn.edu', 200001);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('01-09-2023', 'dd-MM-yyyy'), TO_DATE('01-09-2019', 'dd-MM-yyyy'), 'current', 'Accounting', 'Mathematics', 1, 'Undergraduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Chris', 'Thompson', TO_DATE('19-06-1998','dd-MM-yyyy'), 1, 12039799553, 'stu', 'CThompson@Uconn.edu', 200002);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('01-09-2022', 'dd-MM-yyyy'), TO_DATE('01-09-2018', 'dd-MM-yyyy'), 'current', 'English', 'Chemistry', 1, 'Undergraduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Thomas', 'Smith', TO_DATE('03-02-1995','dd-MM-yyyy'), 1, 12039799554, 'stu', 'TSmith@Uconn.edu', 200003);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('01-09-2021', 'dd-MM-yyyy'), TO_DATE('01-09-2017', 'dd-MM-yyyy'), 'current', 'Art', 'None', 1, 'Undergraduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Lebron', 'James', TO_DATE('08-01-1988','dd-MM-yyyy'), 1, 12039799555, 'stu', 'LJames@Uconn.edu', 200004);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('01-09-2020', 'dd-MM-yyyy'), TO_DATE('01-09-2016', 'dd-MM-yyyy'), 'current', 'Kinesiology', 'Biology', 1, 'Undergraduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'James', 'Harden', TO_DATE('29-03-1990','dd-MM-yyyy'), 1, 12039799556, 'stu', 'JHarden@Uconn.edu', 200005);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('01-09-2019', 'dd-MM-yyyy'), TO_DATE('01-09-2015', 'dd-MM-yyyy'), 'current', 'Physics', 'Mathematics', 1, 'Undergraduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Michael', 'Jordan', TO_DATE('07-04-1975','dd-MM-yyyy'), 1, 12039799557, 'stu', 'MJordan@Uconn.edu', 200006);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('01-09-2018', 'dd-MM-yyyy'), TO_DATE('01-09-2014', 'dd-MM-yyyy'), 'current', 'Mathematics', 'Physics', 1, 'Undergraduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Kyrie', 'Irving', TO_DATE('21-06-1983','dd-MM-yyyy'), 1, 12039799558, 'stu', 'KIrving@Uconn.edu', 200007);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('01-09-2017', 'dd-MM-yyyy'), TO_DATE('01-09-2013', 'dd-MM-yyyy'), 'current', 'Art', 'Mechanical Engineering', 1, 'Undergraduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Kevin', 'Durant', TO_DATE('12-01-1991','dd-MM-yyyy'), 1, 12039799559, 'stu', 'KDurant@Uconn.edu', 200008);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('01-09-2016', 'dd-MM-yyyy'), TO_DATE('01-09-2012', 'dd-MM-yyyy'), 'current', 'Mathematics', 'Chemistry', 1, 'Undergraduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Larry', 'Bird', TO_DATE('16-08-1994','dd-MM-yyyy'), 1, 12039799560, 'stu', 'LBird@Uconn.edu', 200009);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('01-09-2015', 'dd-MM-yyyy'), TO_DATE('01-09-2011', 'dd-MM-yyyy'), 'current', 'Chemistry', 'English', 1, 'Undergraduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Magic', 'Johnson', TO_DATE('30-01-1997','dd-MM-yyyy'), 1, 12039799561, 'stu', 'MJohnson@Uconn.edu', 200010);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('31-08-2024', 'dd-MM-yyyy'), TO_DATE('31-08-2020', 'dd-MM-yyyy'), 'current', 'Accounting', 'Biology', 1, 'Undergraduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Muggsy', 'Bogues', TO_DATE('28-02-1978','dd-MM-yyyy'), 1, 12039799562, 'stu', 'MBogues@Uconn.edu', 200011);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('31-08-2023', 'dd-MM-yyyy'), TO_DATE('31-08-2019', 'dd-MM-yyyy'), 'current', 'Biology', 'Kinesiology', 1, 'Undergraduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Shaquille', 'Oneal', TO_DATE('23-04-1995','dd-MM-yyyy'), 1, 12039799563, 'stu', 'SOneal@Uconn.edu', 200012);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('31-08-2022', 'dd-MM-yyyy'), TO_DATE('31-08-2018', 'dd-MM-yyyy'), 'current', 'Mathematics', 'Mechanical Engineering', 1, 'Undergraduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Charles', 'Barkley', TO_DATE('14-07-2000','dd-MM-yyyy'), 1, 12039799564, 'stu', 'CBarkley@Uconn.edu', 200013);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('31-08-2021', 'dd-MM-yyyy'), TO_DATE('31-08-2017', 'dd-MM-yyyy'), 'current', 'Physics', 'None', 1, 'Graduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Kareem', 'AbdulJabbar', TO_DATE('12-03-1992','dd-MM-yyyy'), 1, 12039799565, 'stu', 'KAbdulJabbar@Uconn.edu', 200014);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('31-08-2020', 'dd-MM-yyyy'), TO_DATE('31-08-2016', 'dd-MM-yyyy'), 'current', 'Mechanical Engineering', 'Chemistry', 1, 'Undergraduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'James', 'Worthy', TO_DATE('13-05-1991','dd-MM-yyyy'), 1, 12039799566, 'stu', 'JWorthy@Uconn.edu', 200015);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('31-08-2019', 'dd-MM-yyyy'), TO_DATE('31-08-2015', 'dd-MM-yyyy'), 'current', 'Chemistry', 'Kinesiology', 1, 'Undergraduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Clint', 'Eastwood', TO_DATE('29-02-1988','dd-MM-yyyy'), 1, 12039799567, 'stu', 'CEastwood@Uconn.edu', 200016);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('31-08-2018', 'dd-MM-yyyy'), TO_DATE('31-08-2014', 'dd-MM-yyyy'), 'current', 'English', 'None', 1, 'Graduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'William', 'Smith', TO_DATE('12-09-1999','dd-MM-yyyy'), 1, 12039799568, 'stu', 'WSmith@Uconn.edu', 200017);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('31-08-2017', 'dd-MM-yyyy'), TO_DATE('31-08-2013', 'dd-MM-yyyy'), 'current', 'Biology', 'Physics', 1, 'Undergraduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Tiger', 'Woods', TO_DATE('19-11-1995','dd-MM-yyyy'), 1, 12039799569, 'stu', 'TWoods@Uconn.edu', 200018);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('31-08-2016', 'dd-MM-yyyy'), TO_DATE('31-08-2012', 'dd-MM-yyyy'), 'current', 'Kinesiology', 'Biology', 1, 'Undergraduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Denzel', 'Washington', TO_DATE('06-12-1990','dd-MM-yyyy'), 1, 12039799570, 'stu', 'DWashington@Uconn.edu', 200019);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('31-08-2015', 'dd-MM-yyyy'), TO_DATE('31-08-2011', 'dd-MM-yyyy'), 'current', 'Psychology', 'Art', 1, 'Undergraduate');

INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Leonardo', 'DiCaprio', TO_DATE('01-01-1993','dd-MM-yyyy'), 1, 12039799571, 'f', 'LDiCaprio@Uconn.edu', 200020);
INSERT INTO Faculty VALUES (SEQ_PERSON_ID.CURRVAL, 1, 'Physics');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Usain', 'Bolt', TO_DATE('11-02-1992','dd-MM-yyyy'), 1, 12039799572, 'f', 'UBolt@Uconn.edu', 200021);
INSERT INTO Faculty VALUES (SEQ_PERSON_ID.CURRVAL, 1, 'Accounting');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Jennifer', 'Aniston', TO_DATE('30-07-1992','dd-MM-yyyy'), 1, 12039799573, 'f', 'JAniston@Uconn.edu', 200022);
INSERT INTO Faculty VALUES (SEQ_PERSON_ID.CURRVAL, 1, 'English');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Jennifer', 'Lopez', TO_DATE('19-03-1989','dd-MM-yyyy'), 1, 12039799574, 'f', 'JLopez@Uconn.edu', 200023);
INSERT INTO Faculty VALUES (SEQ_PERSON_ID.CURRVAL, 1, 'Art');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Lindsay', 'Lohan', TO_DATE('04-06-1994','dd-MM-yyyy'), 1, 12039799575, 'f', 'LLohan@Uconn.edu', 200024);
INSERT INTO Faculty VALUES (SEQ_PERSON_ID.CURRVAL, 1, 'Kinesiology');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Julia', 'Roberts', TO_DATE('17-05-1984','dd-MM-yyyy'), 1, 12039799576, 'f', 'JRoberts@Uconn.edu', 200025);
INSERT INTO Faculty VALUES (SEQ_PERSON_ID.CURRVAL, 1, 'Physics');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Emma', 'Roberts', TO_DATE('21-10-1998','dd-MM-yyyy'), 1, 12039799577, 'f', 'ERoberts@Uconn.edu', 200026);
INSERT INTO Faculty VALUES (SEQ_PERSON_ID.CURRVAL, 1, 'Mathematics');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Selena', 'Gomez', TO_DATE('22-08-1997','dd-MM-yyyy'), 1, 12039799578, 'f', 'SGomez@Uconn.edu', 200027);
INSERT INTO Faculty VALUES (SEQ_PERSON_ID.CURRVAL, 1, 'Art');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Margot', 'Robbie', TO_DATE('07-12-1996','dd-MM-yyyy'), 1, 12039799579, 'f', 'MRobbie@Uconn.edu', 200028);
INSERT INTO Faculty VALUES (SEQ_PERSON_ID.CURRVAL, 1, 'Mathematics');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Justin', 'Bieber', TO_DATE('18-07-1997','dd-MM-yyyy'), 1, 12039799580, 'f', 'JBieber@Uconn.edu', 200029);
INSERT INTO Faculty VALUES (SEQ_PERSON_ID.CURRVAL, 1, 'Chemistry');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Nicole', 'Kidman', TO_DATE('24-04-1990','dd-MM-yyyy'), 1, 12039799581, 'f', 'NKidman@Uconn.edu', 200030);
INSERT INTO Faculty VALUES (SEQ_PERSON_ID.CURRVAL, 1, 'Accounting');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Scarlett', 'Johansson', TO_DATE('27-05-1991','dd-MM-yyyy'), 0, 12039799582, 'f', 'SJohansson@Uconn.edu', 200031);
INSERT INTO Faculty VALUES (SEQ_PERSON_ID.CURRVAL, 1, 'Biology');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Gal', 'Gadot', TO_DATE('08-03-1989','dd-MM-yyyy'), 0, 12039799583, 'f', 'GGadot@Uconn.edu', 200032);
INSERT INTO Faculty VALUES (SEQ_PERSON_ID.CURRVAL, 1, 'Mathematics');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Jessica', 'Biel', TO_DATE('14-01-1995','dd-MM-yyyy'), 0, 12039799584, 'f', 'JBiel@Uconn.edu', 200033);
INSERT INTO Faculty VALUES (SEQ_PERSON_ID.CURRVAL, 1, 'Physics');

INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Mila', 'Kunis', TO_DATE('08-08-1992','dd-MM-yyyy'), 1, 12039799585, 'sta', 'MKunis@Uconn.edu', 200034);
INSERT INTO Staff VALUES (SEQ_PERSON_ID.CURRVAL, 'Librarian');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Jennifer', 'Lawrence', TO_DATE('20-02-1992','dd-MM-yyyy'), 1, 12039799586, 'sta', 'JLawrence@Uconn.edu', 200035);
INSERT INTO Staff VALUES (SEQ_PERSON_ID.CURRVAL, 'Security');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Melanie', 'Iglesias', TO_DATE('12-06-1992','dd-MM-yyyy'), 1, 12039799587, 'sta', 'MIglesias@Uconn.edu', 200036);
INSERT INTO Staff VALUES (SEQ_PERSON_ID.CURRVAL, 'Custodian');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Emily', 'Ratajkowski', TO_DATE('30-03-1996','dd-MM-yyyy'), 1, 12039799588, 'sta', 'ERatajkowski@Uconn.edu', 200037);
INSERT INTO Staff VALUES (SEQ_PERSON_ID.CURRVAL, 'Chef');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Emma', 'Watson', TO_DATE('03-11-1989','dd-MM-yyyy'), 1, 12039799589, 'sta', 'EWatson@Uconn.edu', 200038);
INSERT INTO Staff VALUES (SEQ_PERSON_ID.CURRVAL, 'Bookstore Sales Representative');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Kate', 'Upton', TO_DATE('05-05-1988','dd-MM-yyyy'), 1, 12039799590, 'sta', 'KUpton@Uconn.edu', 200039);
INSERT INTO Staff VALUES (SEQ_PERSON_ID.CURRVAL, 'Sous-chef');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Megan', 'Fox', TO_DATE('09-11-1989','dd-MM-yyyy'), 1, 12039799591, 'sta', 'MFox@Uconn.edu', 200040);
INSERT INTO Staff VALUES (SEQ_PERSON_ID.CURRVAL, 'Security');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Avril', 'Lavigne', TO_DATE('17-09-1993','dd-MM-yyyy'), 1, 12039799592, 'sta', 'ALavigne@Uconn.edu', 200041);
INSERT INTO Staff VALUES (SEQ_PERSON_ID.CURRVAL, 'Parking Permit Representative');

INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Bradley', 'Beal', TO_DATE('07-10-1990','dd-MM-yyyy'), 1, 12039799593, 'stu', 'BBeal@Uconn.edu', 200042);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('30-08-2024', 'dd-MM-yyyy'), TO_DATE('30-08-2020', 'dd-MM-yyyy'), 'current', 'English', 'Biology', 1, 'Undergraduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'John', 'Wall', TO_DATE('19-08-1991','dd-MM-yyyy'), 0, 12039799594, 'stu', 'JWall@Uconn.edu', 200043);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('30-08-2023', 'dd-MM-yyyy'), TO_DATE('30-08-2019', 'dd-MM-yyyy'), 'current', 'Chemistry', 'Biology', 1, 'Undergraduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Russell', 'Westbrook', TO_DATE('14-03-1998','dd-MM-yyyy'), 0, 12039799595, 'stu', 'RWestbrook@Uconn.edu', 200044);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('30-08-2022', 'dd-MM-yyyy'), TO_DATE('30-08-2018', 'dd-MM-yyyy'), 'current', 'Mechanical Engineering', 'None', 1, 'Graduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Isiah', 'Thomas', TO_DATE('02-02-1988','dd-MM-yyyy'), 0, 12039799596, 'stu', 'IThomas@Uconn.edu', 200045);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('30-08-2021', 'dd-MM-yyyy'), TO_DATE('30-08-2017', 'dd-MM-yyyy'), 'current', 'Physics', 'Chemistry', 1, 'Undergraduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Mickey', 'Mouse', TO_DATE('20-01-1988','dd-MM-yyyy'), 0, 12039799597, 'stu', 'MMouse@Uconn.edu', 200046);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('30-08-2020', 'dd-MM-yyyy'), TO_DATE('30-08-2016', 'dd-MM-yyyy'), 'current', 'Biology', 'Physics', 1, 'Undergraduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Jerry', 'West', TO_DATE('28-05-1977','dd-MM-yyyy'), 0, 12039799598, 'stu', 'JWest@Uconn.edu', 200047);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('30-08-2019', 'dd-MM-yyyy'), TO_DATE('30-08-2015', 'dd-MM-yyyy'), 'current', 'Chemistry', 'Accounting', 1, 'Undergraduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Spongebob', 'Squarepants', TO_DATE('14-07-1986','dd-MM-yyyy'), 0, 12039799599, 'stu', 'SSquarepants@Uconn.edu', 200048);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('30-08-2018', 'dd-MM-yyyy'), TO_DATE('30-08-2014', 'dd-MM-yyyy'), 'current', 'Psychology', 'English', 1, 'Undergraduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Peppa', 'Pig', TO_DATE('17-11-1993','dd-MM-yyyy'), 0, 12039799600, 'stu', 'PPig@Uconn.edu', 200049);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('30-08-2017', 'dd-MM-yyyy'), TO_DATE('30-08-2013', 'dd-MM-yyyy'), 'current', 'Art', 'None', 1, 'Graduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Brad', 'Pitt', TO_DATE('28-02-2001','dd-MM-yyyy'), 1, 12039799601, 'stu', 'BPitt@Uconn.edu', 200050);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('01-09-2021', 'dd-MM-yyyy'), TO_DATE('01-09-2017', 'dd-MM-yyyy'), 'current', 'English', 'Political Science', 1, 'Undergraduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Humphrey', 'Bogart', TO_DATE('14-03-2000','dd-MM-yyyy'), 1, 12039799602, 'stu', 'HBogart@Uconn.edu', 200051);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('01-09-2020', 'dd-MM-yyyy'), TO_DATE('01-09-2016', 'dd-MM-yyyy'), 'current', 'Mathematics', 'Computer Science', 1, 'Undergraduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Cary', 'Grant', TO_DATE('02-06-2001','dd-MM-yyyy'), 1, 12039799603, 'stu', 'CGrant@Uconn.edu', 200052);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('01-09-2019', 'dd-MM-yyyy'), TO_DATE('01-09-2015', 'dd-MM-yyyy'), 'current', 'Chemistry', 'Biology', 1, 'Undergraduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'James', 'Stewart', TO_DATE('01-07-2000','dd-MM-yyyy'), 1, 12039799604, 'stu', 'JStewart@Uconn.edu', 200053);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('01-09-2018', 'dd-MM-yyyy'), TO_DATE('01-09-2014', 'dd-MM-yyyy'), 'current', 'Political Science', 'Pychology', 1, 'Undergraduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Marlon', 'Brando', TO_DATE('09-08-2000','dd-MM-yyyy'), 1, 12039799605, 'stu', 'MBrando@Uconn.edu', 200054);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('01-09-2017', 'dd-MM-yyyy'), TO_DATE('01-09-2013', 'dd-MM-yyyy'), 'current', 'Pychology', 'English', 1, 'Undergraduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Fred', 'Astaire', TO_DATE('27-06-2001','dd-MM-yyyy'), 1, 12039799606, 'stu', 'FAstaire@Uconn.edu', 200055);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('01-09-2016', 'dd-MM-yyyy'), TO_DATE('01-09-2012', 'dd-MM-yyyy'), 'current', 'Accounting', 'Mathematics', 1, 'Undergraduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Henry', 'Ford', TO_DATE('01-09-2000','dd-MM-yyyy'), 1, 12039799607, 'stu', 'HFord@Uconn.edu', 200056);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('01-09-2015', 'dd-MM-yyyy'), TO_DATE('01-09-2011', 'dd-MM-yyyy'), 'current', 'Finance', 'Marketing', 1, 'Undergraduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Clark', 'Gable', TO_DATE('26-03-1992','dd-MM-yyyy'), 1, 12039799608, 'stu', 'CGable@Uconn.edu', 200057);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('31-08-2024', 'dd-MM-yyyy'), TO_DATE('31-08-2020', 'dd-MM-yyyy'), 'current', 'Science', 'None', 1, 'Graduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'James', 'Cagney', TO_DATE('21-09-1991','dd-MM-yyyy'), 1, 12039799609, 'stu', 'JCagney@Uconn.edu', 200058);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('31-08-2023', 'dd-MM-yyyy'), TO_DATE('31-08-2019', 'dd-MM-yyyy'), 'current', 'Mathematics', 'None', 1, 'Graduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Spencer', 'Tracey', TO_DATE('15-09-1992','dd-MM-yyyy'), 1, 12039799610, 'stu', 'STracey@Uconn.edu', 200059);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('31-08-2022', 'dd-MM-yyyy'), TO_DATE('31-08-2018', 'dd-MM-yyyy'), 'current', 'Management', 'None', 1, 'Graduate');

INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Leslie', 'Jones', TO_DATE('25-01-1987','dd-MM-yyyy'), 1, 12039799611, 'f', 'LJones@Uconn.edu', 200060);
INSERT INTO Faculty VALUES (SEQ_PERSON_ID.CURRVAL, 1, 'Mathematics');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Charlie', 'Chaplan', TO_DATE('02-04-1986','dd-MM-yyyy'), 0, 12039799612, 'f', 'CChaplan@Uconn.edu', 200061);
INSERT INTO Faculty VALUES (SEQ_PERSON_ID.CURRVAL, 1, 'Chemistry');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Katharine', 'Hepburn', TO_DATE('22-03-1980','dd-MM-yyyy'), 0, 12039799613, 'f', 'KHepburn@Uconn.edu', 200062);
INSERT INTO Faculty VALUES (SEQ_PERSON_ID.CURRVAL, 1, 'Biology');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Bette', 'Davis', TO_DATE('12-10-1977','dd-MM-yyyy'), 0, 12039799614, 'f', 'BDavis@Uconn.edu', 200063);
INSERT INTO Faculty VALUES (SEQ_PERSON_ID.CURRVAL, 1, 'English');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Joan', 'Crawford', TO_DATE('28-02-1978','dd-MM-yyyy'), 1, 12039799615, 'f', 'JCrawford@Uconn.edu', 200064);
INSERT INTO Faculty VALUES (SEQ_PERSON_ID.CURRVAL, 1, 'Computer Science');

INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Ingrid', 'Bergman', TO_DATE('01-03-2001','dd-MM-yyyy'), 1, 12039799616, 'stu', 'IBergman@Uconn.edu', 200065);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('31-08-2021', 'dd-MM-yyyy'), TO_DATE('31-08-2017', 'dd-MM-yyyy'), 'current', 'English', 'Political Science', 1, 'Undergraduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Greta', 'Garbo', TO_DATE('15-03-2000','dd-MM-yyyy'), 1, 12039799617, 'stu', 'GGarbo@Uconn.edu', 200066);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('31-08-2020', 'dd-MM-yyyy'), TO_DATE('31-08-2016', 'dd-MM-yyyy'), 'current', 'Mathematics', 'Computer Science', 1, 'Undergraduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Marilyn', 'Monroe', TO_DATE('03-06-2001','dd-MM-yyyy'), 1, 12039799618, 'stu', 'MMonroe@Uconn.edu', 200067);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('31-08-2019', 'dd-MM-yyyy'), TO_DATE('31-08-2015', 'dd-MM-yyyy'), 'current', 'Chemistry', 'Biology', 1, 'Undergraduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Elizabeth', 'Taylor', TO_DATE('02-07-2000','dd-MM-yyyy'), 1, 12039799619, 'stu', 'ETaylor@Uconn.edu', 200068);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('31-08-2018', 'dd-MM-yyyy'), TO_DATE('31-08-2014', 'dd-MM-yyyy'), 'current', 'Political Science', 'Pychology', 1, 'Undergraduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Judy', 'Garland', TO_DATE('10-08-2000','dd-MM-yyyy'), 1, 12039799620, 'stu', 'JGarland@Uconn.edu', 200069);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('31-08-2017', 'dd-MM-yyyy'), TO_DATE('31-08-2013', 'dd-MM-yyyy'), 'current', 'Pychology', 'English', 1, 'Undergraduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'John', 'Wayne', TO_DATE('28-06-2001','dd-MM-yyyy'), 1, 12039799621, 'stu', 'JWayne@Uconn.edu', 200070);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('31-08-2016', 'dd-MM-yyyy'), TO_DATE('31-08-2012', 'dd-MM-yyyy'), 'current', 'Accounting', 'Mathematics', 1, 'Undergraduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Laurence', 'Olivier', TO_DATE('02-09-2000','dd-MM-yyyy'), 1, 12039799622, 'stu', 'LOlivier@Uconn.edu', 200071);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('31-08-2015', 'dd-MM-yyyy'), TO_DATE('31-08-2011', 'dd-MM-yyyy'), 'current', 'Finance', 'Marketing', 1, 'Undergraduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Danny', 'Kaye', TO_DATE('27-03-1992','dd-MM-yyyy'), 1, 12039799623, 'stu', 'DKaye@Uconn.edu', 200072);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('30-08-2024', 'dd-MM-yyyy'), TO_DATE('30-08-2020', 'dd-MM-yyyy'), 'current', 'Science', 'None', 1, 'Graduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Sidney', 'Poitier', TO_DATE('22-09-1991','dd-MM-yyyy'), 1, 12039799624, 'stu', 'SPoitier@Uconn.edu', 200073);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('30-08-2023', 'dd-MM-yyyy'), TO_DATE('30-08-2019', 'dd-MM-yyyy'), 'current', 'Mathematics', 'None', 1, 'Graduate');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'James', 'Dean', TO_DATE('16-09-1992','dd-MM-yyyy'), 1, 12039799625, 'stu', 'JDean@Uconn.edu', 200074);
INSERT INTO Student VALUES (SEQ_PERSON_ID.CURRVAL, TO_DATE('30-08-2022', 'dd-MM-yyyy'), TO_DATE('30-08-2018', 'dd-MM-yyyy'), 'current', 'Management', 'None', 1, 'Graduate');

INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Rita', 'Hayworth', TO_DATE('26-01-1987','dd-MM-yyyy'), 1, 12039799626, 'f', 'RHayworth@Uconn.edu', 200075);
INSERT INTO Faculty VALUES (SEQ_PERSON_ID.CURRVAL, 1, 'Mathematics');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Sophia', 'Loren', TO_DATE('03-04-1986','dd-MM-yyyy'), 1, 12039799627, 'f', 'SLoren@Uconn.edu', 200076);
INSERT INTO Faculty VALUES (SEQ_PERSON_ID.CURRVAL, 1, 'Chemistry');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Ava', 'Gardner', TO_DATE('23-03-1980','dd-MM-yyyy'), 1, 12039799628, 'f', 'AGardner@Uconn.edu', 200077);
INSERT INTO Faculty VALUES (SEQ_PERSON_ID.CURRVAL, 1, 'Biology');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Jean', 'Harlow', TO_DATE('13-10-1977','dd-MM-yyyy'), 1, 12039799629, 'f', 'JHarlow@Uconn.edu', 200078);
INSERT INTO Faculty VALUES (SEQ_PERSON_ID.CURRVAL, 1, 'English');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Ginger', 'Rogers', TO_DATE('01-03-1978','dd-MM-yyyy'), 1, 12039799630, 'f', 'GRogers@Uconn.edu', 200079);
INSERT INTO Faculty VALUES (SEQ_PERSON_ID.CURRVAL, 1, 'Computer Science');
INSERT INTO Person VALUES (SEQ_PERSON_ID.NEXTVAL, 'Robert', 'Redford', TO_DATE('09-06-1978','dd-MM-yyyy'), 0, 12039799631, 'f', 'RRedford@Uconn.edu', 200080);
INSERT INTO Faculty VALUES (SEQ_PERSON_ID.CURRVAL, 1, 'Mathematics');

-- ===========================================================================
-- INSERT: Course
-- ===========================================================================

INSERT 	INTO 	Course 	VALUES 	(	300000	, 	'hybrid'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	2	, 	'18:00:00'	, 	'21:00:00'	, 	'Fall 2020'	, 	'OPIM5270'	, 	'B13'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300001	, 	'distance learning'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	3	, 	'18:00:00'	, 	'21:00:00'	, 	'Fall 2020'	, 	'OPIM5603'	, 	'AP20'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300002	, 	'distance learning'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	4	, 	'18:00:00'	, 	'21:00:00'	, 	'Fall 2020'	, 	'OPIM5641'	, 	'AP20'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300003	, 	'hybrid'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	5	, 	'18:00:00'	, 	'21:00:00'	, 	'Fall 2020'	, 	'OPIM5770'	, 	'MS40'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300004	, 	'hybrid'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	6	, 	'18:00:00'	, 	'21:00:00'	, 	'Fall 2020'	, 	'MATH0100'	, 	'MS40'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300005	, 	'hybrid'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	2	, 	'18:00:00'	, 	'21:00:00'	, 	'Fall 2020'	, 	'OPIM5604'	, 	'MS40'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300006	, 	'distance learning'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	3	, 	'18:00:00'	, 	'21:00:00'	, 	'Fall 2020'	, 	'OPIM5603'	, 	'W30'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300007	, 	'In Person'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	4	, 	'18:00:00'	, 	'21:00:00'	, 	'Fall 2020'	, 	'OPIM5603'	, 	'B14'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300008	, 	'In Person'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	5	, 	'18:00:00'	, 	'21:00:00'	, 	'Fall 2020'	, 	'OPIM5671'	, 	'B14'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300009	, 	'In Person'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	6	, 	'18:00:00'	, 	'21:00:00'	, 	'Fall 2020'	, 	'MATH0100'	, 	'ST31'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300010	, 	'In Person'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	2	, 	'18:00:00'	, 	'21:00:00'	, 	'Fall 2020'	, 	'OPIM5604'	, 	'ST31'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300011	, 	'In Person'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	3	, 	'18:00:00'	, 	'21:00:00'	, 	'Fall 2020'	, 	'OPIM5668'	, 	'ST31'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300012	, 	'distance learning'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	4	, 	'18:00:00'	, 	'21:00:00'	, 	'Fall 2020'	, 	'OPIM5894'	, 	'MS40'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300013	, 	'distance learning'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	5	, 	'18:00:00'	, 	'21:00:00'	, 	'Fall 2020'	, 	'OPIM5601'	, 	'MS40'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300014	, 	'In Person'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	6	, 	'18:00:00'	, 	'21:00:00'	, 	'Fall 2020'	, 	'OPIM5620'	, 	'B12'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300015	, 	'In Person'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	2	, 	'18:00:00'	, 	'21:00:00'	, 	'Fall 2020'	, 	'OPIM5500'	, 	'MS40'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300016	, 	'In Person'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	3	, 	'18:00:00'	, 	'21:00:00'	, 	'Fall 2020'	, 	'OPIM5501'	, 	'MS40'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300017	, 	'In Person'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	4	, 	'18:00:00'	, 	'21:00:00'	, 	'Fall 2020'	, 	'OPIM5512'	, 	'MS40'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300018	, 	'In Person'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	5	, 	'18:00:00'	, 	'21:00:00'	, 	'Fall 2020'	, 	'OPIM5509'	, 	'B12'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300019	, 	'hybrid'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	2	, 	'10:00:00'	, 	'13:00:00'	, 	'Fall 2020'	, 	'MGMT5270'	, 	'MS40'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300020	, 	'hybrid'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	3	, 	'10:00:00'	, 	'13:00:00'	, 	'Fall 2020'	, 	'ENGL0210'	, 	'MS40'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300021	, 	'distance learning'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	4	, 	'10:00:00'	, 	'13:00:00'	, 	'Fall 2020'	, 	'BIO0120'	, 	'MS40'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300022	, 	'distance learning'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	5	, 	'10:00:00'	, 	'13:00:00'	, 	'Fall 2020'	, 	'ENGL0210'	, 	'MS40'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300023	, 	'hybrid'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	6	, 	'10:00:00'	, 	'13:00:00'	, 	'Fall 2020'	, 	'MGMT5272'	, 	'B12'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300024	, 	'hybrid'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	2	, 	'10:00:00'	, 	'13:00:00'	, 	'Fall 2020'	, 	'MGMT5604'	, 	'MS40'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300025	, 	'hybrid'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	3	, 	'10:00:00'	, 	'13:00:00'	, 	'Fall 2020'	, 	'ENGL0210'	, 	'ST33'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300026	, 	'hybrid'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	4	, 	'10:00:00'	, 	'13:00:00'	, 	'Fall 2020'	, 	'MGMT5603'	, 	'MS40'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300027	, 	'hybrid'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	5	, 	'10:00:00'	, 	'13:00:00'	, 	'Fall 2020'	, 	'MGMT5671'	, 	'MS40'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300028	, 	'In Person'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	6	, 	'10:00:00'	, 	'13:00:00'	, 	'Fall 2020'	, 	'MGMT5272'	, 	'MS40'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300029	, 	'In Person'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	2	, 	'10:00:00'	, 	'13:00:00'	, 	'Fall 2020'	, 	'CHEM0127'	, 	'ST31'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300030	, 	'In Person'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	3	, 	'10:00:00'	, 	'13:00:00'	, 	'Fall 2020'	, 	'CHEM0127'	, 	'MS40'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300031	, 	'In Person'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	4	, 	'10:00:00'	, 	'13:00:00'	, 	'Fall 2020'	, 	'MGMT5894'	, 	'MS40'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300032	, 	'In Person'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	5	, 	'10:00:00'	, 	'13:00:00'	, 	'Fall 2020'	, 	'MGMT5601'	, 	'MS40'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300033	, 	'In Person'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	6	, 	'10:00:00'	, 	'13:00:00'	, 	'Fall 2020'	, 	'MGMT5620'	, 	'MS40'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300034	, 	'In Person'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	2	, 	'10:00:00'	, 	'13:00:00'	, 	'Fall 2020'	, 	'MGMT5500'	, 	'MS40'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300035	, 	'In Person'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	3	, 	'10:00:00'	, 	'13:00:00'	, 	'Fall 2020'	, 	'MGMT5501'	, 	'MS40'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300036	, 	'In Person'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	4	, 	'10:00:00'	, 	'13:00:00'	, 	'Fall 2020'	, 	'MGMT5512'	, 	'MS40'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300037	, 	'In Person'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	5	, 	'10:00:00'	, 	'13:00:00'	, 	'Fall 2020'	, 	'MGMT5509'	, 	'MS40'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300038	, 	'hybrid'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	2	, 	'10:00:00'	, 	'13:00:00'	, 	'Fall 2020'	, 	'OPIM5894'	, 	'ST31'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300039	, 	'hybrid'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	3	, 	'10:00:00'	, 	'13:00:00'	, 	'Fall 2020'	, 	'OPIM5601'	, 	'ST31'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300040	, 	'hybrid'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	4	, 	'10:00:00'	, 	'13:00:00'	, 	'Fall 2020'	, 	'OPIM5620'	, 	'ST31'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300041	, 	'hybrid'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	5	, 	'10:00:00'	, 	'13:00:00'	, 	'Fall 2020'	, 	'OPIM5500'	, 	'ST31'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300042	, 	'hybrid'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	6	, 	'10:00:00'	, 	'13:00:00'	, 	'Fall 2020'	, 	'OPIM5501'	, 	'ST31'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300043	, 	'hybrid'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	2	, 	'10:00:00'	, 	'13:00:00'	, 	'Fall 2020'	, 	'OPIM5512'	, 	'B12'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300044	, 	'hybrid'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	3	, 	'18:00:00'	, 	'21:00:00'	, 	'Fall 2020'	, 	'OPIM5509'	, 	'ST31'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300045	, 	'In Person'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	2	, 	'18:00:00'	, 	'21:00:00'	, 	'Fall 2020'	, 	'MGMT5603'	, 	'ST33'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300046	, 	'In Person'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	3	, 	'18:00:00'	, 	'21:00:00'	, 	'Fall 2020'	, 	'MGMT5671'	, 	'ST33'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300047	, 	'In Person'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	4	, 	'18:00:00'	, 	'21:00:00'	, 	'Fall 2020'	, 	'MGMT5272'	, 	'ST31'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300048	, 	'In Person'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	5	, 	'18:00:00'	, 	'21:00:00'	, 	'Fall 2020'	, 	'MGMT5604'	, 	'ST31'	)	;
INSERT 	INTO 	Course 	VALUES 	(	300049	, 	'distance learning'	, 	TO_DATE('31-08-2020', 'dd-MM-yyyy')	, 	TO_DATE('18-12-2020', 'dd-MM-yyyy')	, 	6	, 	'18:00:00'	, 	'21:00:00'	, 	'Fall 2020'	, 	'MGMT5668'	, 	'B12'	)	;

-- ===========================================================================
-- INSERT: FacultyCourse
-- ===========================================================================

INSERT INTO FacultyCourse VALUES (500000, 100029, 300000, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO FacultyCourse VALUES (500001, 100029, 300007, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO FacultyCourse VALUES (500002, 100022, 300008, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO FacultyCourse VALUES (500003, 100024, 300014, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO FacultyCourse VALUES (500004, 100026, 300018, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO FacultyCourse VALUES (500005, 100022, 300023, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO FacultyCourse VALUES (500006, 100024, 300043, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO FacultyCourse VALUES (500007, 100060, 300004, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO FacultyCourse VALUES (500008, 100027, 300020, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO FacultyCourse VALUES (500009, 100076, 300030, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO FacultyCourse VALUES (500010, 100023, 300016, TO_DATE('28-05-2020', 'dd-MM-yyyy'));
INSERT INTO FacultyCourse VALUES (500011, 100020, 300017, TO_DATE('28-05-2020', 'dd-MM-yyyy'));
INSERT INTO FacultyCourse VALUES (500012, 100025, 300009, TO_DATE('28-05-2020', 'dd-MM-yyyy'));
INSERT INTO FacultyCourse VALUES (500013, 100021, 300025, TO_DATE('28-05-2020', 'dd-MM-yyyy'));
INSERT INTO FacultyCourse VALUES (500014, 100030, 300029, TO_DATE('28-05-2020', 'dd-MM-yyyy'));
INSERT INTO FacultyCourse VALUES (500015, 100028, 300039, TO_DATE('28-05-2020', 'dd-MM-yyyy'));
INSERT INTO FacultyCourse VALUES (500016, 100032, 300012, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO FacultyCourse VALUES (500017, 100033, 300013, TO_DATE('28-05-2020', 'dd-MM-yyyy'));
INSERT INTO FacultyCourse VALUES (500018, 100031, 300049, TO_DATE('28-05-2020', 'dd-MM-yyyy'));
INSERT INTO FacultyCourse VALUES (500019, 100062, 300021, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO FacultyCourse VALUES (500020, 100061, 300001, TO_DATE('28-05-2020', 'dd-MM-yyyy'));
INSERT INTO FacultyCourse VALUES (500021, 100064, 300005, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO FacultyCourse VALUES (500022, 100063, 300022, TO_DATE('28-05-2020', 'dd-MM-yyyy'));
INSERT INTO FacultyCourse VALUES (500023, 100077, 300040, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO FacultyCourse VALUES (500024, 100079, 300011, TO_DATE('28-05-2020', 'dd-MM-yyyy'));
INSERT INTO FacultyCourse VALUES (500025, 100078, 300041, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO FacultyCourse VALUES (500026, 100075, 300042, TO_DATE('28-05-2020', 'dd-MM-yyyy'));
INSERT INTO FacultyCourse VALUES (500027, 100079, 300044, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO FacultyCourse VALUES (500028, 100078, 300045, TO_DATE('28-05-2020', 'dd-MM-yyyy'));
INSERT INTO FacultyCourse VALUES (500029, 100075, 300046, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO FacultyCourse VALUES (500030, 100080, 300006, TO_DATE('28-05-2020', 'dd-MM-yyyy'));
INSERT INTO FacultyCourse VALUES (500031, 100061, 300002, TO_DATE('01-09-2020', 'dd-MM-yyyy'));

-- ===========================================================================
-- INSERT: StudentCourse
-- ===========================================================================

INSERT INTO StudentCourse VALUES (400000, 100002, 300000, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400001, 100007, 300000, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400002, 100011, 300000, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400003, 100013, 300007, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400004, 100016, 300007, TO_DATE('25-08-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400005, 100013, 300008, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400006, 100016, 300008, TO_DATE('25-08-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400007, 100016, 300014, TO_DATE('25-08-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400008, 100016, 300018, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400009, 100002, 300023, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400010, 100012, 300023, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400011, 100017, 300023, TO_DATE('25-08-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400012, 100013, 300043, TO_DATE('25-08-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400013, 100016, 300043, TO_DATE('25-08-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400014, 100001, 300004, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400015, 100006, 300004, TO_DATE('31-08-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400016, 100008, 300004, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400017, 100015, 300020, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400018, 100051, 300020, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400019, 100010, 300030, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400020, 100000, 300009, TO_DATE('31-08-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400021, 100003, 300009, TO_DATE('31-08-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400022, 100004, 300009, TO_DATE('31-08-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400023, 100005, 300009, TO_DATE('31-08-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400024, 100065, 300025, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400025, 100066, 300025, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400026, 100067, 300025, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400027, 100009, 300029, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400028, 100070, 300029, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400029, 100049, 300001, TO_DATE('31-08-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400030, 100045, 300002, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400031, 100048, 300002, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400032, 100046, 300006, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400033, 100047, 300006, TO_DATE('25-08-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400034, 100057, 300005, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400035, 100058, 300005, TO_DATE('31-08-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400036, 100059, 300005, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400037, 100050, 300016, TO_DATE('31-08-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400038, 100051, 300017, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400039, 100052, 300016, TO_DATE('31-08-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400040, 100053, 300017, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400041, 100054, 300016, TO_DATE('31-08-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400042, 100055, 300017, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400043, 100056, 300016, TO_DATE('31-08-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400044, 100072, 300011, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400045, 100073, 300011, TO_DATE('31-08-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400046, 100074, 300011, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400047, 100014, 300039, TO_DATE('31-08-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400048, 100018, 300040, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400049, 100019, 300041, TO_DATE('31-08-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400050, 100068, 300042, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400051, 100069, 300044, TO_DATE('31-08-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400052, 100070, 300045, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400053, 100071, 300046, TO_DATE('31-08-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400054, 100044, 300049, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400055, 100043, 300012, TO_DATE('31-08-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400056, 100043, 300013, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400057, 100043, 300021, TO_DATE('31-08-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400058, 100043, 300022, TO_DATE('01-09-2020', 'dd-MM-yyyy'));
INSERT INTO StudentCourse VALUES (400059, 100042, 300044, TO_DATE('31-08-2020', 'dd-MM-yyyy'));

-- ===========================================================================
-- INSERT: Facility
-- ===========================================================================

INSERT INTO Facility VALUES (1000, 'Main Campus - Stamford', '1 University Place', 'Stamford', 'Connecticut', '06901', 'Stamford', 'Sta0001', 101, 1, 'non-residence');
INSERT INTO Facility VALUES (1001, 'Main Campus - Stamford', '1 University Place', 'Stamford', 'Connecticut', '06901', 'Stamford', 'Sta0001', 105, 1, 'non-residence');
INSERT INTO Facility VALUES (1002, 'Main Campus - Stamford', '1 University Place', 'Stamford', 'Connecticut', '06901', 'Stamford', 'Sta0001', 203, 2, 'non-residence');
INSERT INTO Facility VALUES (1003, 'Main Campus - Stamford', '1 University Place', 'Stamford', 'Connecticut', '06901', 'Stamford', 'Sta0001', 214, 2, 'non-residence');
INSERT INTO Facility VALUES (1004, 'Main Campus - Stamford', '1 University Place', 'Stamford', 'Connecticut', '06901', 'Stamford', 'Sta0001', 310, 3, 'non-residence');
INSERT INTO Facility VALUES (1005, 'Lilian Residential Hall', '87 Franklin Street', 'Stamford', 'Connecticut', '06901', 'Stamford', 'Sta0002', 104, 1, 'residence');
INSERT INTO Facility VALUES (1006, 'Lilian Residential Hall', '87 Franklin Street', 'Stamford', 'Connecticut', '06901', 'Stamford', 'Sta0002', 203, 2, 'residence');
INSERT INTO Facility VALUES (1007, 'Lilian Residential Hall', '87 Franklin Street', 'Stamford', 'Connecticut', '06901', 'Stamford', 'Sta0002', 206, 2, 'residence');
INSERT INTO Facility VALUES (1008, 'Lilian Residential Hall', '87 Franklin Street', 'Stamford', 'Connecticut', '06901', 'Stamford', 'Sta0002', 302, 3, 'residence');
INSERT INTO Facility VALUES (1009, 'Lilian Residential Hall', '87 Franklin Street', 'Stamford', 'Connecticut', '06901', 'Stamford', 'Sta0002', 317, 3, 'residence');
INSERT INTO Facility VALUES (1010, 'WB Residential Hall', '900 Washington Boulevard', 'Stamford', 'Connecticut', '06901', 'Stamford', 'Sta0003', 112, 1, 'residence');
INSERT INTO Facility VALUES (1011, 'WB Residential Hall', '900 Washington Boulevard', 'Stamford', 'Connecticut', '06901', 'Stamford', 'Sta0003', 124, 1, 'residence');
INSERT INTO Facility VALUES (1012, 'WB Residential Hall', '900 Washington Boulevard', 'Stamford', 'Connecticut', '06901', 'Stamford', 'Sta0003', 211, 2, 'residence');
INSERT INTO Facility VALUES (1013, 'WB Residential Hall', '900 Washington Boulevard', 'Stamford', 'Connecticut', '06901', 'Stamford', 'Sta0003', 219, 2, 'residence');
INSERT INTO Facility VALUES (1014, 'WB Residential Hall', '900 Washington Boulevard', 'Stamford', 'Connecticut', '06901', 'Stamford', 'Sta0003', 227, 2, 'residence');
INSERT INTO Facility VALUES (1015, 'PS Residential Hall', '65 Prospect Street', 'Stamford', 'Connecticut', '06901', 'Stamford', 'Sta0004', 107, 1, 'residence');
INSERT INTO Facility VALUES (1016, 'PS Residential Hall', '65 Prospect Street', 'Stamford', 'Connecticut', '06901', 'Stamford', 'Sta0004', 109, 1, 'residence');
INSERT INTO Facility VALUES (1017, 'PS Residential Hall', '65 Prospect Street', 'Stamford', 'Connecticut', '06901', 'Stamford', 'Sta0004', 213, 2, 'residence');
INSERT INTO Facility VALUES (1018, 'PS Residential Hall', '65 Prospect Street', 'Stamford', 'Connecticut', '06901', 'Stamford', 'Sta0004', 312, 3, 'residence');
INSERT INTO Facility VALUES (1019, 'PS Residential Hall', '65 Prospect Street', 'Stamford', 'Connecticut', '06901', 'Stamford', 'Sta0004', 414, 4, 'residence');
INSERT INTO Facility VALUES (1020, 'Chemistry Building', '55 North Eagleville Road', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0001', 103, 1, 'non-residence');
INSERT INTO Facility VALUES (1021, 'Chemistry Building', '55 North Eagleville Road', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0001', 129, 1, 'non-residence');
INSERT INTO Facility VALUES (1022, 'Chemistry Building', '55 North Eagleville Road', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0001', 226, 2, 'non-residence');
INSERT INTO Facility VALUES (1023, 'Chemistry Building', '55 North Eagleville Road', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0001', 305, 3, 'non-residence');
INSERT INTO Facility VALUES (1024, 'Chemistry Building', '55 North Eagleville Road', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0001', 311, 3, 'non-residence');
INSERT INTO Facility VALUES (1025, 'Dairy Barn', '17 Manter Road, Unit 4263', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0002', 102, 1, 'non-residence');
INSERT INTO Facility VALUES (1026, 'Dairy Barn', '17 Manter Road, Unit 4263', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0002', 104, 1, 'non-residence');
INSERT INTO Facility VALUES (1027, 'Dairy Barn', '17 Manter Road, Unit 4263', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0002', 106, 1, 'non-residence');
INSERT INTO Facility VALUES (1028, 'Dairy Barn', '17 Manter Road, Unit 4263', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0002', 108, 1, 'non-residence');
INSERT INTO Facility VALUES (1029, 'Dairy Barn', '17 Manter Road, Unit 4263', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0002', 110, 1, 'non-residence');
INSERT INTO Facility VALUES (1030, 'ARJ Building', '337 Mansfield Road', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0003', 126, 1, 'non-residence');
INSERT INTO Facility VALUES (1031, 'ARJ Building', '337 Mansfield Road', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0003', 219, 2, 'non-residence');
INSERT INTO Facility VALUES (1032, 'ARJ Building', '337 Mansfield Road', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0003', 324, 3, 'non-residence');
INSERT INTO Facility VALUES (1033, 'ARJ Building', '337 Mansfield Road', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0003', 417, 4, 'non-residence');
INSERT INTO Facility VALUES (1034, 'ARJ Building', '337 Mansfield Road', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0003', 409, 4, 'non-residence');
INSERT INTO Facility VALUES (1035, 'AUST Building', '215 Glenbrook Road, Unit 4098', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0004', 106, 1, 'non-residence');
INSERT INTO Facility VALUES (1036, 'AUST Building', '215 Glenbrook Road, Unit 4098', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0004', 117, 1, 'non-residence');
INSERT INTO Facility VALUES (1037, 'AUST Building', '215 Glenbrook Road, Unit 4098', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0004', 209, 2, 'non-residence');
INSERT INTO Facility VALUES (1038, 'AUST Building', '215 Glenbrook Road, Unit 4098', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0004', 211, 2, 'non-residence');
INSERT INTO Facility VALUES (1039, 'AUST Building', '215 Glenbrook Road, Unit 4098', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0004', 324, 3, 'non-residence');
INSERT INTO Facility VALUES (1040, 'Werth Residence Hall', '2378 Alumni Drive', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0005', 112, 1, 'residence');
INSERT INTO Facility VALUES (1041, 'Werth Residence Hall', '2378 Alumni Drive', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0005', 123, 1, 'residence');
INSERT INTO Facility VALUES (1042, 'Werth Residence Hall', '2378 Alumni Drive', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0005', 201, 2, 'residence');
INSERT INTO Facility VALUES (1043, 'Werth Residence Hall', '2378 Alumni Drive', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0005', 222, 2, 'residence');
INSERT INTO Facility VALUES (1044, 'Werth Residence Hall', '2378 Alumni Drive', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0005', 322, 3, 'residence');
INSERT INTO Facility VALUES (1045, 'Tolland Residence Hall', '82 North Eagleville Road', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0006', 114, 1, 'residence');
INSERT INTO Facility VALUES (1046, 'Tolland Residence Hall', '82 North Eagleville Road', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0006', 201, 2, 'residence');
INSERT INTO Facility VALUES (1047, 'Tolland Residence Hall', '82 North Eagleville Road', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0006', 207, 2, 'residence');
INSERT INTO Facility VALUES (1048, 'Tolland Residence Hall', '82 North Eagleville Road', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0006', 304, 3, 'residence');
INSERT INTO Facility VALUES (1049, 'Tolland Residence Hall', '82 North Eagleville Road', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0006', 325, 3, 'residence');
INSERT INTO Facility VALUES (1050, 'Academic Building - Avery', '1084 Shennecossett Road', 'Groton', 'Connecticut', '06340', 'Avery Point', 'A0001', 105, 1, 'non-residence');
INSERT INTO Facility VALUES (1051, 'Academic Building - Avery', '1084 Shennecossett Road', 'Groton', 'Connecticut', '06340', 'Avery Point', 'A0001', 217, 2, 'non-residence');
INSERT INTO Facility VALUES (1052, 'Academic Building - Avery', '1084 Shennecossett Road', 'Groton', 'Connecticut', '06340', 'Avery Point', 'A0001', 304, 3, 'non-residence');
INSERT INTO Facility VALUES (1053, 'Academic Building - Avery', '1084 Shennecossett Road', 'Groton', 'Connecticut', '06340', 'Avery Point', 'A0001', 323, 3, 'non-residence');
INSERT INTO Facility VALUES (1054, 'Academic Building - Avery', '1084 Shennecossett Road', 'Groton', 'Connecticut', '06340', 'Avery Point', 'A0001', 409, 4, 'non-residence');
INSERT INTO Facility VALUES (1055, 'Academic Building - Waterbury', '99 East Main Street', 'Waterbury', 'Connecticut', '06702', 'Waterbury', 'W0001', 116, 1, 'non-residence');
INSERT INTO Facility VALUES (1056, 'Academic Building - Waterbury', '99 East Main Street', 'Waterbury', 'Connecticut', '06702', 'Waterbury', 'W0001', 205, 2, 'non-residence');
INSERT INTO Facility VALUES (1057, 'Academic Building - Waterbury', '99 East Main Street', 'Waterbury', 'Connecticut', '06702', 'Waterbury', 'W0001', 217, 2, 'non-residence');
INSERT INTO Facility VALUES (1058, 'Academic Building - Waterbury', '99 East Main Street', 'Waterbury', 'Connecticut', '06702', 'Waterbury', 'W0001', 309, 3, 'non-residence');
INSERT INTO Facility VALUES (1059, 'Academic Building - Waterbury', '99 East Main Street', 'Waterbury', 'Connecticut', '06702', 'Waterbury', 'W0001', 314, 3, 'non-residence');
INSERT INTO Facility VALUES (1060, 'Main Campus - Hartford', '10 Prospect Street', 'Hartford', 'Connecticut', '06103', 'Hartford', 'H0001', 101, 1, 'non-residence');
INSERT INTO Facility VALUES (1061, 'Main Campus - Hartford', '10 Prospect Street', 'Hartford', 'Connecticut', '06103', 'Hartford', 'H0001', 111, 1, 'non-residence');
INSERT INTO Facility VALUES (1062, 'Main Campus - Hartford', '10 Prospect Street', 'Hartford', 'Connecticut', '06103', 'Hartford', 'H0001', 204, 2, 'non-residence');
INSERT INTO Facility VALUES (1063, 'Main Campus - Hartford', '10 Prospect Street', 'Hartford', 'Connecticut', '06103', 'Hartford', 'H0001', 221, 2, 'non-residence');
INSERT INTO Facility VALUES (1064, 'Main Campus - Hartford', '10 Prospect Street', 'Hartford', 'Connecticut', '06103', 'Hartford', 'H0001', 309, 3, 'non-residence');
INSERT INTO Facility VALUES (1065, 'Graduate Business Learning Center', '100 Constitution Plaza', 'Hartford', 'Connecticut', '06103', 'Hartford', 'H0002', 109, 1, 'non-residence');
INSERT INTO Facility VALUES (1066, 'Graduate Business Learning Center', '100 Constitution Plaza', 'Hartford', 'Connecticut', '06103', 'Hartford', 'H0002', 117, 1, 'non-residence');
INSERT INTO Facility VALUES (1067, 'Graduate Business Learning Center', '100 Constitution Plaza', 'Hartford', 'Connecticut', '06103', 'Hartford', 'H0002', 209, 2, 'non-residence');
INSERT INTO Facility VALUES (1068, 'Graduate Business Learning Center', '100 Constitution Plaza', 'Hartford', 'Connecticut', '06103', 'Hartford', 'H0002', 222, 2, 'non-residence');
INSERT INTO Facility VALUES (1069, 'Graduate Business Learning Center', '100 Constitution Plaza', 'Hartford', 'Connecticut', '06103', 'Hartford', 'H0002', 309, 3, 'non-residence');
INSERT INTO Facility VALUES (1070, 'Main Campus - Stamford', '1 University Place', 'Stamford', 'Connecticut', '06901', 'Stamford', 'Sta0001', 324, 3, 'non-residence');
INSERT INTO Facility VALUES (1071, 'Main Campus - Stamford', '1 University Place', 'Stamford', 'Connecticut', '06901', 'Stamford', 'Sta0001', 109, 1, 'non-residence');
INSERT INTO Facility VALUES (1072, 'Main Campus - Stamford', '1 University Place', 'Stamford', 'Connecticut', '06901', 'Stamford', 'Sta0001', 123, 1, 'non-residence');
INSERT INTO Facility VALUES (1073, 'Main Campus - Stamford', '1 University Place', 'Stamford', 'Connecticut', '06901', 'Stamford', 'Sta0001', 129, 1, 'non-residence');
INSERT INTO Facility VALUES (1074, 'Main Campus - Stamford', '1 University Place', 'Stamford', 'Connecticut', '06901', 'Stamford', 'Sta0001', 202, 2, 'non-residence');
INSERT INTO Facility VALUES (1075, 'Main Campus - Stamford', '1 University Place', 'Stamford', 'Connecticut', '06901', 'Stamford', 'Sta0001', 208, 2, 'non-residence');
INSERT INTO Facility VALUES (1076, 'Main Campus - Stamford', '1 University Place', 'Stamford', 'Connecticut', '06901', 'Stamford', 'Sta0001', 232, 2, 'non-residence');
INSERT INTO Facility VALUES (1077, 'Main Campus - Stamford', '1 University Place', 'Stamford', 'Connecticut', '06901', 'Stamford', 'Sta0001', 314, 3, 'non-residence');
INSERT INTO Facility VALUES (1078, 'Main Campus - Stamford', '1 University Place', 'Stamford', 'Connecticut', '06901', 'Stamford', 'Sta0001', 333, 3, 'non-residence');
INSERT INTO Facility VALUES (1079, 'ARJ Building', '337 Mansfield Road', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0003', 101, 1, 'non-residence');
INSERT INTO Facility VALUES (1080, 'ARJ Building', '337 Mansfield Road', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0003', 105, 1, 'non-residence');
INSERT INTO Facility VALUES (1081, 'ARJ Building', '337 Mansfield Road', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0003', 111, 1, 'non-residence');
INSERT INTO Facility VALUES (1082, 'ARJ Building', '337 Mansfield Road', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0003', 227, 2, 'non-residence');
INSERT INTO Facility VALUES (1083, 'ARJ Building', '337 Mansfield Road', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0003', 243, 2, 'non-residence');
INSERT INTO Facility VALUES (1084, 'ARJ Building', '337 Mansfield Road', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0003', 306, 3, 'non-residence');
INSERT INTO Facility VALUES (1085, 'ARJ Building', '337 Mansfield Road', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0003', 319, 3, 'non-residence');
INSERT INTO Facility VALUES (1086, 'ARJ Building', '337 Mansfield Road', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0003', 404, 4, 'non-residence');
INSERT INTO Facility VALUES (1087, 'ARJ Building', '337 Mansfield Road', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0003', 412, 4, 'non-residence');
INSERT INTO Facility VALUES (1088, 'ARJ Building', '337 Mansfield Road', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0003', 423, 4, 'non-residence');
INSERT INTO Facility VALUES (1089, 'ARJ Building', '337 Mansfield Road', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0003', 441, 4, 'non-residence');
INSERT INTO Facility VALUES (1090, 'AUST Building', '215 Glenbrook Road, Unit 4098', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0004', 154, 1, 'non-residence');
INSERT INTO Facility VALUES (1091, 'AUST Building', '215 Glenbrook Road, Unit 4098', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0004', 142, 1, 'non-residence');
INSERT INTO Facility VALUES (1092, 'AUST Building', '215 Glenbrook Road, Unit 4098', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0004', 138, 1, 'non-residence');
INSERT INTO Facility VALUES (1093, 'AUST Building', '215 Glenbrook Road, Unit 4098', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0004', 202, 2, 'non-residence');
INSERT INTO Facility VALUES (1094, 'AUST Building', '215 Glenbrook Road, Unit 4098', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0004', 234, 2, 'non-residence');
INSERT INTO Facility VALUES (1095, 'AUST Building', '215 Glenbrook Road, Unit 4098', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0004', 246, 2, 'non-residence');
INSERT INTO Facility VALUES (1096, 'AUST Building', '215 Glenbrook Road, Unit 4098', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0004', 207, 2, 'non-residence');
INSERT INTO Facility VALUES (1097, 'AUST Building', '215 Glenbrook Road, Unit 4098', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0004', 319, 3, 'non-residence');
INSERT INTO Facility VALUES (1098, 'AUST Building', '215 Glenbrook Road, Unit 4098', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0004', 325, 3, 'non-residence');
INSERT INTO Facility VALUES (1099, 'AUST Building', '215 Glenbrook Road, Unit 4098', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0004', 328, 3, 'non-residence');
INSERT INTO Facility VALUES (1100, 'AUST Building', '215 Glenbrook Road, Unit 4098', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0004', 334, 3, 'non-residence');
INSERT INTO Facility VALUES (1101, 'AUST Building', '215 Glenbrook Road, Unit 4098', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0004', 342, 3, 'non-residence');
INSERT INTO Facility VALUES (1102, 'AUST Building', '215 Glenbrook Road, Unit 4098', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0004', 348, 3, 'non-residence');
INSERT INTO Facility VALUES (1103, 'Werth Residence Hall', '2378 Alumni Drive', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0005', 102, 1, 'residence');
INSERT INTO Facility VALUES (1104, 'Werth Residence Hall', '2378 Alumni Drive', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0005', 108, 1, 'residence');
INSERT INTO Facility VALUES (1105, 'Werth Residence Hall', '2378 Alumni Drive', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0005', 119, 1, 'residence');
INSERT INTO Facility VALUES (1106, 'Werth Residence Hall', '2378 Alumni Drive', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0005', 204, 2, 'residence');
INSERT INTO Facility VALUES (1107, 'Werth Residence Hall', '2378 Alumni Drive', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0005', 216, 2, 'residence');
INSERT INTO Facility VALUES (1108, 'Werth Residence Hall', '2378 Alumni Drive', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0005', 226, 2, 'residence');
INSERT INTO Facility VALUES (1109, 'Werth Residence Hall', '2378 Alumni Drive', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0005', 304, 3, 'residence');
INSERT INTO Facility VALUES (1110, 'Werth Residence Hall', '2378 Alumni Drive', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0005', 308, 3, 'residence');
INSERT INTO Facility VALUES (1111, 'Werth Residence Hall', '2378 Alumni Drive', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0005', 310, 3, 'residence');
INSERT INTO Facility VALUES (1112, 'Werth Residence Hall', '2378 Alumni Drive', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0005', 315, 3, 'residence');
INSERT INTO Facility VALUES (1113, 'Tolland Residence Hall', '82 North Eagleville Road', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0006', 103, 1, 'residence');
INSERT INTO Facility VALUES (1114, 'Tolland Residence Hall', '82 North Eagleville Road', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0006', 107, 1, 'residence');
INSERT INTO Facility VALUES (1115, 'Tolland Residence Hall', '82 North Eagleville Road', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0006', 117, 1, 'residence');
INSERT INTO Facility VALUES (1116, 'Tolland Residence Hall', '82 North Eagleville Road', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0006', 213, 2, 'residence');
INSERT INTO Facility VALUES (1117, 'Tolland Residence Hall', '82 North Eagleville Road', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0006', 218, 2, 'residence');
INSERT INTO Facility VALUES (1118, 'Tolland Residence Hall', '82 North Eagleville Road', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0006', 223, 2, 'residence');
INSERT INTO Facility VALUES (1119, 'Tolland Residence Hall', '82 North Eagleville Road', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0006', 307, 3, 'residence');
INSERT INTO Facility VALUES (1120, 'Tolland Residence Hall', '82 North Eagleville Road', 'Storrs', 'Connecticut', '06269', 'Storrs', 'Sto0006', 315, 3, 'residence');

-- ===========================================================================
-- INSERT: RoomAssignment
-- ===========================================================================

INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700000, 1040, 100000);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700001, 1012, 100001);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700002, 1041, 100003);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700003, 1042, 100004);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700004, 1043, 100005);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700005, 1013, 100006);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700006, 1014, 100008);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700007, 1046, 100009);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700008, 1007, 100010);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700009, 1047, 100014);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700010, 1005, 100015);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700011, 1048, 100018);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700012, 1049, 100019);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700013, 1002, 100020);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700014, 1032, 100021);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700015, 1061, 100022);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700016, 1003, 100023);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700017, 1062, 100024);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700018, 1033, 100025);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700019, 1065, 100026);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700020, 1004, 100027);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700021, 1034, 100028);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700022, 1064, 100029);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700023, 1039, 100030);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700024, 1035, 100034);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700025, 1000, 100035);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700026, 1036, 100036);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700027, 1000, 100037);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700028, 1037, 100038);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700029, 1000, 100039);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700030, 1063, 100040);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700031, 1068, 100041);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700032, 1103, 100042);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700033, 1006, 100050);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700034, 1008, 100051);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700035, 1009, 100052);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700036, 1010, 100053);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700037, 1011, 100054);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700038, 1115, 100055);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700039, 1116, 100056);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700040, 1117, 100057);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700041, 1118, 100058);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700042, 1119, 100059);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700043, 1001, 100060);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700044, 1076, 100064);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700045, 1105, 100065);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700046, 1109, 100066);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700047, 1112, 100067);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700048, 1115, 100068);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700049, 1118, 100069);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700050, 1120, 100070);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700051, 1119, 100071);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700052, 1104, 100072);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700053, 1117, 100073);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700054, 1110, 100074);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700055, 1082, 100075);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700056, 1070, 100076);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700057, 1089, 100077);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700058, 1098, 100078);
INSERT INTO RoomAssignment (RoomAssignmentID, RoomID, PersonID) Values (700059, 1102, 100079);

-- ===========================================================================
-- INSERT: CourseRoomAssignment
-- ===========================================================================

INSERT INTO CourseRoomAssignment VALUES (600000, 1060, 300000);
INSERT INTO CourseRoomAssignment VALUES (600001, 1071, 300003);
INSERT INTO CourseRoomAssignment VALUES (600002, 1071, 300004);
INSERT INTO CourseRoomAssignment VALUES (600003, 1071, 300005);
INSERT INTO CourseRoomAssignment VALUES (600004, 1061, 300007);
INSERT INTO CourseRoomAssignment VALUES (600005, 1062, 300008);
INSERT INTO CourseRoomAssignment VALUES (600006, 1085, 300009);
INSERT INTO CourseRoomAssignment VALUES (600007, 1080, 300010);
INSERT INTO CourseRoomAssignment VALUES (600008, 1090, 300011);
INSERT INTO CourseRoomAssignment VALUES (600009, 1063, 300014);
INSERT INTO CourseRoomAssignment VALUES (600010, 1072, 300015);
INSERT INTO CourseRoomAssignment VALUES (600011, 1071, 300016);
INSERT INTO CourseRoomAssignment VALUES (600012, 1071, 300017);
INSERT INTO CourseRoomAssignment VALUES (600013, 1064, 300018);
INSERT INTO CourseRoomAssignment VALUES (600014, 1073, 300019);
INSERT INTO CourseRoomAssignment VALUES (600015, 1072, 300020);
INSERT INTO CourseRoomAssignment VALUES (600016, 1065, 300023);
INSERT INTO CourseRoomAssignment VALUES (600017, 1074, 300024);
INSERT INTO CourseRoomAssignment VALUES (600018, 1080, 300025);
INSERT INTO CourseRoomAssignment VALUES (600019, 1072, 300026);
INSERT INTO CourseRoomAssignment VALUES (600020, 1072, 300027);
INSERT INTO CourseRoomAssignment VALUES (600021, 1072, 300028);
INSERT INTO CourseRoomAssignment VALUES (600022, 1079, 300029);
INSERT INTO CourseRoomAssignment VALUES (600023, 1073, 300030);
INSERT INTO CourseRoomAssignment VALUES (600024, 1073, 300031);
INSERT INTO CourseRoomAssignment VALUES (600025, 1073, 300032);
INSERT INTO CourseRoomAssignment VALUES (600026, 1073, 300033);
INSERT INTO CourseRoomAssignment VALUES (600027, 1075, 300034);
INSERT INTO CourseRoomAssignment VALUES (600028, 1074, 300035);
INSERT INTO CourseRoomAssignment VALUES (600029, 1074, 300036);
INSERT INTO CourseRoomAssignment VALUES (600030, 1074, 300037);
INSERT INTO CourseRoomAssignment VALUES (600031, 1090, 300038);
INSERT INTO CourseRoomAssignment VALUES (600032, 1091, 300039);
INSERT INTO CourseRoomAssignment VALUES (600033, 1080, 300040);
INSERT INTO CourseRoomAssignment VALUES (600034, 1080, 300041);
INSERT INTO CourseRoomAssignment VALUES (600035, 1080, 300042);
INSERT INTO CourseRoomAssignment VALUES (600036, 1066, 300043);
INSERT INTO CourseRoomAssignment VALUES (600037, 1084, 300044);
INSERT INTO CourseRoomAssignment VALUES (600038, 1085, 300045);
INSERT INTO CourseRoomAssignment VALUES (600039, 1092, 300046);
INSERT INTO CourseRoomAssignment VALUES (600040, 1090, 300047);
INSERT INTO CourseRoomAssignment VALUES (600041, 1090, 300048);

-- ===========================================================================
-- INSERT: CardScanLog
-- ===========================================================================

INSERT INTO CardScanLog VALUES (2000000, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1040, 100000);
INSERT INTO CardScanLog VALUES (2000001, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1012, 100001);
INSERT INTO CardScanLog VALUES (2000002, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1041, 100003);
INSERT INTO CardScanLog VALUES (2000003, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1042, 100004);
INSERT INTO CardScanLog VALUES (2000004, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1043, 100005);
INSERT INTO CardScanLog VALUES (2000005, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1013, 100006);
INSERT INTO CardScanLog VALUES (2000006, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1014, 100008);
INSERT INTO CardScanLog VALUES (2000007, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1046, 100009);
INSERT INTO CardScanLog VALUES (2000008, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1007, 100010);
INSERT INTO CardScanLog VALUES (2000009, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1047, 100014);
INSERT INTO CardScanLog VALUES (2000010, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1005, 100015);
INSERT INTO CardScanLog VALUES (2000011, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1048, 100018);
INSERT INTO CardScanLog VALUES (2000012, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1049, 100019);
INSERT INTO CardScanLog VALUES (2000013, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1002, 100020);
INSERT INTO CardScanLog VALUES (2000014, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1032, 100021);
INSERT INTO CardScanLog VALUES (2000015, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1061, 100022);
INSERT INTO CardScanLog VALUES (2000016, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1003, 100023);
INSERT INTO CardScanLog VALUES (2000017, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1062, 100024);
INSERT INTO CardScanLog VALUES (2000018, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1033, 100025);
INSERT INTO CardScanLog VALUES (2000019, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1065, 100026);
INSERT INTO CardScanLog VALUES (2000020, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1004, 100027);
INSERT INTO CardScanLog VALUES (2000021, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1034, 100028);
INSERT INTO CardScanLog VALUES (2000022, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1064, 100029);
INSERT INTO CardScanLog VALUES (2000023, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1039, 100030);
INSERT INTO CardScanLog VALUES (2000024, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1035, 100034);
INSERT INTO CardScanLog VALUES (2000025, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1000, 100035);
INSERT INTO CardScanLog VALUES (2000026, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1036, 100036);
INSERT INTO CardScanLog VALUES (2000027, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1000, 100037);
INSERT INTO CardScanLog VALUES (2000028, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1037, 100038);
INSERT INTO CardScanLog VALUES (2000029, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1000, 100039);
INSERT INTO CardScanLog VALUES (2000030, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1063, 100040);
INSERT INTO CardScanLog VALUES (2000031, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1068, 100041);
INSERT INTO CardScanLog VALUES (2000032, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1103, 100042);
INSERT INTO CardScanLog VALUES (2000033, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1006, 100050);
INSERT INTO CardScanLog VALUES (2000034, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1008, 100051);
INSERT INTO CardScanLog VALUES (2000035, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1009, 100052);
INSERT INTO CardScanLog VALUES (2000036, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1010, 100053);
INSERT INTO CardScanLog VALUES (2000037, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1011, 100054);
INSERT INTO CardScanLog VALUES (2000038, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1115, 100055);
INSERT INTO CardScanLog VALUES (2000039, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1116, 100056);
INSERT INTO CardScanLog VALUES (2000040, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1117, 100057);
INSERT INTO CardScanLog VALUES (2000041, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1118, 100058);
INSERT INTO CardScanLog VALUES (2000042, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1119, 100059);
INSERT INTO CardScanLog VALUES (2000043, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1001, 100060);
INSERT INTO CardScanLog VALUES (2000044, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1076, 100064);
INSERT INTO CardScanLog VALUES (2000045, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1105, 100065);
INSERT INTO CardScanLog VALUES (2000046, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1109, 100066);
INSERT INTO CardScanLog VALUES (2000047, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1112, 100067);
INSERT INTO CardScanLog VALUES (2000048, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1115, 100068);
INSERT INTO CardScanLog VALUES (2000049, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1118, 100069);
INSERT INTO CardScanLog VALUES (2000050, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1120, 100070);
INSERT INTO CardScanLog VALUES (2000051, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1119, 100071);
INSERT INTO CardScanLog VALUES (2000052, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1104, 100072);
INSERT INTO CardScanLog VALUES (2000053, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1117, 100073);
INSERT INTO CardScanLog VALUES (2000054, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1110, 100074);
INSERT INTO CardScanLog VALUES (2000055, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1082, 100075);
INSERT INTO CardScanLog VALUES (2000056, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1070, 100076);
INSERT INTO CardScanLog VALUES (2000057, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1089, 100077);
INSERT INTO CardScanLog VALUES (2000058, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1098, 100078);
INSERT INTO CardScanLog VALUES (2000059, '9:00:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1102, 100079);
INSERT INTO CardScanLog VALUES (2000060, '17:55:00', TO_DATE('04-09-2020', 'dd-MM-yyyy'), 1085, 100025);
INSERT INTO CardScanLog VALUES (2000061, '17:55:00', TO_DATE('04-09-2020', 'dd-MM-yyyy'), 1085, 100000);
INSERT INTO CardScanLog VALUES (2000062, '17:55:00', TO_DATE('04-09-2020', 'dd-MM-yyyy'), 1085, 100003);
INSERT INTO CardScanLog VALUES (2000063, '17:55:00', TO_DATE('04-09-2020', 'dd-MM-yyyy'), 1085, 100004);
INSERT INTO CardScanLog VALUES (2000064, '17:55:00', TO_DATE('04-09-2020', 'dd-MM-yyyy'), 1085, 100005);
INSERT INTO CardScanLog VALUES (2000065, '17:55:00', TO_DATE('23-10-2020', 'dd-MM-yyyy'), 1085, 100000);
INSERT INTO CardScanLog VALUES (2000066, '17:55:00', TO_DATE('25-09-2020', 'dd-MM-yyyy'), 1071, 100001);
INSERT INTO CardScanLog VALUES (2000067, '17:55:00', TO_DATE('07-09-2020', 'dd-MM-yyyy'), 1060, 100002);
INSERT INTO CardScanLog VALUES (2000068, '9:55:00', TO_DATE('04-09-2020', 'dd-MM-yyyy'), 1065, 100002);
INSERT INTO CardScanLog VALUES (2000069, '17:55:00', TO_DATE('25-09-2020', 'dd-MM-yyyy'), 1071, 100006);
INSERT INTO CardScanLog VALUES (2000070, '9:55:00', TO_DATE('08-09-2020', 'dd-MM-yyyy'), 1091, 100014);
INSERT INTO CardScanLog VALUES (2000071, '9:55:00', TO_DATE('06-10-2020', 'dd-MM-yyyy'), 1072, 100015);
INSERT INTO CardScanLog VALUES (2000072, '9:55:00', TO_DATE('08-10-2020', 'dd-MM-yyyy'), 1080, 100019);
INSERT INTO CardScanLog VALUES (2000073, '17:55:00', TO_DATE('07-09-2020', 'dd-MM-yyyy'), 1060, 100029);
INSERT INTO CardScanLog VALUES (2000074, '17:55:00', TO_DATE('25-09-2020', 'dd-MM-yyyy'), 1071, 100060);
INSERT INTO CardScanLog VALUES (2000075, '17:55:00', TO_DATE('23-10-2020', 'dd-MM-yyyy'), 1085, 100025);
INSERT INTO CardScanLog VALUES (2000076, '9:55:00', TO_DATE('06-10-2020', 'dd-MM-yyyy'), 1072, 100027);
INSERT INTO CardScanLog VALUES (2000077, '9:55:00', TO_DATE('04-09-2020', 'dd-MM-yyyy'), 1065, 100022);
INSERT INTO CardScanLog VALUES (2000078, '9:55:00', TO_DATE('08-09-2020', 'dd-MM-yyyy'), 1091, 100028);
INSERT INTO CardScanLog VALUES (2000079, '9:55:00', TO_DATE('08-10-2020', 'dd-MM-yyyy'), 1080, 100078);
INSERT INTO CardScanLog VALUES (2000080, '17:55:00', TO_DATE('07-09-2020', 'dd-MM-yyyy'), 1060, 100007);
INSERT INTO CardScanLog VALUES (2000081, '17:55:00', TO_DATE('07-09-2020', 'dd-MM-yyyy'), 1060, 100011);
INSERT INTO CardScanLog VALUES (2000082, '17:55:00', TO_DATE('25-09-2020', 'dd-MM-yyyy'), 1071, 100008);
INSERT INTO CardScanLog VALUES (2000083, '17:55:00', TO_DATE('23-10-2020', 'dd-MM-yyyy'), 1085, 100003);
INSERT INTO CardScanLog VALUES (2000084, '17:55:00', TO_DATE('23-10-2020', 'dd-MM-yyyy'), 1085, 100004);
INSERT INTO CardScanLog VALUES (2000085, '17:55:00', TO_DATE('23-10-2020', 'dd-MM-yyyy'), 1085, 100005);
INSERT INTO CardScanLog VALUES (2000086, '9:55:00', TO_DATE('06-10-2020', 'dd-MM-yyyy'), 1072, 100051);
INSERT INTO CardScanLog VALUES (2000087, '9:55:00', TO_DATE('04-09-2020', 'dd-MM-yyyy'), 1065, 100012);
INSERT INTO CardScanLog VALUES (2000088, '9:55:00', TO_DATE('04-09-2020', 'dd-MM-yyyy'), 1065, 100017);
INSERT INTO CardScanLog VALUES (2000089, '17:55:00', TO_DATE('11-09-2020', 'dd-MM-yyyy'), 1071, 100001);
INSERT INTO CardScanLog VALUES (2000090, '17:55:00', TO_DATE('11-09-2020', 'dd-MM-yyyy'), 1071, 100006);
INSERT INTO CardScanLog VALUES (2000091, '17:55:00', TO_DATE('11-09-2020', 'dd-MM-yyyy'), 1071, 100060);
INSERT INTO CardScanLog VALUES (2000092, '17:55:00', TO_DATE('11-09-2020', 'dd-MM-yyyy'), 1071, 100008);
INSERT INTO CardScanLog VALUES (2000093, '9:55:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1071, 100057);
INSERT INTO CardScanLog VALUES (2000094, '9:55:00', TO_DATE('01-09-2020', 'dd-MM-yyyy'), 1071, 100058);
INSERT INTO CardScanLog VALUES (2000095, '9:55:00', TO_DATE('02-09-2020', 'dd-MM-yyyy'), 1071, 100059);
INSERT INTO CardScanLog VALUES (2000096, '9:55:00', TO_DATE('05-09-2020', 'dd-MM-yyyy'), 1061, 100013);
INSERT INTO CardScanLog VALUES (2000097, '9:55:00', TO_DATE('30-08-2020', 'dd-MM-yyyy'), 1061, 100016);
INSERT INTO CardScanLog VALUES (2000098, '9:55:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1062, 100013);
INSERT INTO CardScanLog VALUES (2000099, '9:55:00', TO_DATE('01-09-2020', 'dd-MM-yyyy'), 1062, 100016);
INSERT INTO CardScanLog VALUES (2000100, '9:55:00', TO_DATE('02-09-2020', 'dd-MM-yyyy'), 1090, 100072);
INSERT INTO CardScanLog VALUES (2000101, '9:55:00', TO_DATE('03-09-2020', 'dd-MM-yyyy'), 1090, 100073);
INSERT INTO CardScanLog VALUES (2000102, '9:55:00', TO_DATE('04-09-2020', 'dd-MM-yyyy'), 1090, 100074);
INSERT INTO CardScanLog VALUES (2000103, '9:55:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1063, 100016);
INSERT INTO CardScanLog VALUES (2000104, '9:55:00', TO_DATE('01-09-2020', 'dd-MM-yyyy'), 1071, 100050);
INSERT INTO CardScanLog VALUES (2000105, '9:55:00', TO_DATE('02-09-2020', 'dd-MM-yyyy'), 1071, 100052);
INSERT INTO CardScanLog VALUES (2000106, '9:55:00', TO_DATE('03-09-2020', 'dd-MM-yyyy'), 1071, 100054);
INSERT INTO CardScanLog VALUES (2000107, '9:55:00', TO_DATE('04-09-2020', 'dd-MM-yyyy'), 1071, 100056);
INSERT INTO CardScanLog VALUES (2000108, '9:55:00', TO_DATE('05-09-2020', 'dd-MM-yyyy'), 1071, 100051);
INSERT INTO CardScanLog VALUES (2000109, '9:55:00', TO_DATE('30-08-2020', 'dd-MM-yyyy'), 1071, 100053);
INSERT INTO CardScanLog VALUES (2000110, '9:55:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1071, 100055);
INSERT INTO CardScanLog VALUES (2000111, '9:55:00', TO_DATE('01-09-2020', 'dd-MM-yyyy'), 1064, 100016);
INSERT INTO CardScanLog VALUES (2000112, '9:55:00', TO_DATE('04-09-2020', 'dd-MM-yyyy'), 1080, 100065);
INSERT INTO CardScanLog VALUES (2000113, '9:55:00', TO_DATE('05-09-2020', 'dd-MM-yyyy'), 1080, 100066);
INSERT INTO CardScanLog VALUES (2000114, '9:55:00', TO_DATE('30-08-2020', 'dd-MM-yyyy'), 1080, 100067);
INSERT INTO CardScanLog VALUES (2000115, '9:55:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1079, 100009);
INSERT INTO CardScanLog VALUES (2000116, '9:55:00', TO_DATE('01-09-2020', 'dd-MM-yyyy'), 1079, 100070);
INSERT INTO CardScanLog VALUES (2000117, '9:55:00', TO_DATE('02-09-2020', 'dd-MM-yyyy'), 1073, 100010);
INSERT INTO CardScanLog VALUES (2000118, '9:55:00', TO_DATE('03-09-2020', 'dd-MM-yyyy'), 1080, 100018);
INSERT INTO CardScanLog VALUES (2000119, '9:55:00', TO_DATE('04-09-2020', 'dd-MM-yyyy'), 1080, 100068);
INSERT INTO CardScanLog VALUES (2000120, '9:55:00', TO_DATE('05-09-2020', 'dd-MM-yyyy'), 1066, 100013);
INSERT INTO CardScanLog VALUES (2000121, '9:55:00', TO_DATE('30-08-2020', 'dd-MM-yyyy'), 1066, 100016);
INSERT INTO CardScanLog VALUES (2000122, '9:55:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1084, 100042);
INSERT INTO CardScanLog VALUES (2000123, '9:55:00', TO_DATE('01-09-2020', 'dd-MM-yyyy'), 1084, 100069);
INSERT INTO CardScanLog VALUES (2000124, '9:55:00', TO_DATE('02-09-2020', 'dd-MM-yyyy'), 1085, 100070);
INSERT INTO CardScanLog VALUES (2000125, '9:55:00', TO_DATE('03-09-2020', 'dd-MM-yyyy'), 1092, 100071);
INSERT INTO CardScanLog VALUES (2000126, '9:55:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1071, 100064);
INSERT INTO CardScanLog VALUES (2000127, '9:55:00', TO_DATE('02-09-2020', 'dd-MM-yyyy'), 1061, 100029);
INSERT INTO CardScanLog VALUES (2000128, '9:55:00', TO_DATE('03-09-2020', 'dd-MM-yyyy'), 1062, 100022);
INSERT INTO CardScanLog VALUES (2000129, '9:55:00', TO_DATE('04-09-2020', 'dd-MM-yyyy'), 1090, 100079);
INSERT INTO CardScanLog VALUES (2000130, '9:55:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1063, 100024);
INSERT INTO CardScanLog VALUES (2000131, '9:55:00', TO_DATE('01-09-2020', 'dd-MM-yyyy'), 1071, 100023);
INSERT INTO CardScanLog VALUES (2000132, '9:55:00', TO_DATE('02-09-2020', 'dd-MM-yyyy'), 1071, 100020);
INSERT INTO CardScanLog VALUES (2000133, '9:55:00', TO_DATE('03-09-2020', 'dd-MM-yyyy'), 1064, 100026);
INSERT INTO CardScanLog VALUES (2000134, '9:55:00', TO_DATE('30-08-2020', 'dd-MM-yyyy'), 1080, 100021);
INSERT INTO CardScanLog VALUES (2000135, '9:55:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1079, 100030);
INSERT INTO CardScanLog VALUES (2000136, '9:55:00', TO_DATE('01-09-2020', 'dd-MM-yyyy'), 1073, 100076);
INSERT INTO CardScanLog VALUES (2000137, '9:55:00', TO_DATE('02-09-2020', 'dd-MM-yyyy'), 1080, 100077);
INSERT INTO CardScanLog VALUES (2000138, '9:55:00', TO_DATE('03-09-2020', 'dd-MM-yyyy'), 1080, 100075);
INSERT INTO CardScanLog VALUES (2000139, '9:55:00', TO_DATE('04-09-2020', 'dd-MM-yyyy'), 1066, 100024);
INSERT INTO CardScanLog VALUES (2000140, '9:55:00', TO_DATE('05-09-2020', 'dd-MM-yyyy'), 1084, 100079);
INSERT INTO CardScanLog VALUES (2000141, '9:55:00', TO_DATE('30-08-2020', 'dd-MM-yyyy'), 1085, 100078);
INSERT INTO CardScanLog VALUES (2000142, '9:55:00', TO_DATE('31-08-2020', 'dd-MM-yyyy'), 1092, 100075);

-- ===========================================================================
-- INSERT: CovidTest
-- ===========================================================================

INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000000, 'Neg', TO_DATE('25-08-2020','dd-MM-yyyy'), TO_DATE('27-08-2020','dd-MM-yyyy'), 'Off Campus', 100000);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000001, 'Neg', TO_DATE('26-08-2020','dd-MM-yyyy'), TO_DATE('28-08-2020','dd-MM-yyyy'), 'Off Campus', 100001);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000002, 'Neg', TO_DATE('27-08-2020','dd-MM-yyyy'), TO_DATE('29-08-2020','dd-MM-yyyy'), 'Off Campus', 100002);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000003, 'Neg', TO_DATE('28-08-2020','dd-MM-yyyy'), TO_DATE('30-08-2020','dd-MM-yyyy'), 'Off Campus', 100003);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000004, 'Neg', TO_DATE('25-08-2020','dd-MM-yyyy'), TO_DATE('27-08-2020','dd-MM-yyyy'), 'Off Campus', 100004);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000005, 'Neg', TO_DATE('26-08-2020','dd-MM-yyyy'), TO_DATE('28-08-2020','dd-MM-yyyy'), 'Off Campus', 100005);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000006, 'Neg', TO_DATE('27-08-2020','dd-MM-yyyy'), TO_DATE('29-08-2020','dd-MM-yyyy'), 'Off Campus', 100006);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000007, 'Neg', TO_DATE('28-08-2020','dd-MM-yyyy'), TO_DATE('30-08-2020','dd-MM-yyyy'), 'Off Campus', 100007);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000008, 'Neg', TO_DATE('25-08-2020','dd-MM-yyyy'), TO_DATE('27-08-2020','dd-MM-yyyy'), 'Off Campus', 100008);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000009, 'Neg', TO_DATE('26-08-2020','dd-MM-yyyy'), TO_DATE('28-08-2020','dd-MM-yyyy'), 'Off Campus', 100009);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000010, 'Neg', TO_DATE('27-08-2020','dd-MM-yyyy'), TO_DATE('29-08-2020','dd-MM-yyyy'), 'Off Campus', 100010);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000011, 'Neg', TO_DATE('28-08-2020','dd-MM-yyyy'), TO_DATE('30-08-2020','dd-MM-yyyy'), 'Off Campus', 100011);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000012, 'Neg', TO_DATE('25-08-2020','dd-MM-yyyy'), TO_DATE('27-08-2020','dd-MM-yyyy'), 'Off Campus', 100012);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000013, 'Neg', TO_DATE('26-08-2020','dd-MM-yyyy'), TO_DATE('28-08-2020','dd-MM-yyyy'), 'Off Campus', 100013);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000014, 'Neg', TO_DATE('27-08-2020','dd-MM-yyyy'), TO_DATE('29-08-2020','dd-MM-yyyy'), 'Off Campus', 100014);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000015, 'Neg', TO_DATE('28-08-2020','dd-MM-yyyy'), TO_DATE('30-08-2020','dd-MM-yyyy'), 'Off Campus', 100015);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000016, 'Neg', TO_DATE('25-08-2020','dd-MM-yyyy'), TO_DATE('27-08-2020','dd-MM-yyyy'), 'Off Campus', 100016);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000017, 'Neg', TO_DATE('26-08-2020','dd-MM-yyyy'), TO_DATE('28-08-2020','dd-MM-yyyy'), 'Off Campus', 100017);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000018, 'Neg', TO_DATE('27-08-2020','dd-MM-yyyy'), TO_DATE('29-08-2020','dd-MM-yyyy'), 'Off Campus', 100018);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000019, 'Neg', TO_DATE('28-08-2020','dd-MM-yyyy'), TO_DATE('30-08-2020','dd-MM-yyyy'), 'Off Campus', 100019);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000020, 'Neg', TO_DATE('25-08-2020','dd-MM-yyyy'), TO_DATE('27-08-2020','dd-MM-yyyy'), 'Off Campus', 100020);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000021, 'Neg', TO_DATE('26-08-2020','dd-MM-yyyy'), TO_DATE('28-08-2020','dd-MM-yyyy'), 'Off Campus', 100021);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000022, 'Neg', TO_DATE('27-08-2020','dd-MM-yyyy'), TO_DATE('29-08-2020','dd-MM-yyyy'), 'Off Campus', 100022);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000023, 'Neg', TO_DATE('28-08-2020','dd-MM-yyyy'), TO_DATE('30-08-2020','dd-MM-yyyy'), 'Off Campus', 100023);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000024, 'Neg', TO_DATE('25-08-2020','dd-MM-yyyy'), TO_DATE('27-08-2020','dd-MM-yyyy'), 'Off Campus', 100024);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000025, 'Neg', TO_DATE('26-08-2020','dd-MM-yyyy'), TO_DATE('28-08-2020','dd-MM-yyyy'), 'Off Campus', 100025);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000026, 'Neg', TO_DATE('27-08-2020','dd-MM-yyyy'), TO_DATE('29-08-2020','dd-MM-yyyy'), 'Off Campus', 100026);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000027, 'Neg', TO_DATE('28-08-2020','dd-MM-yyyy'), TO_DATE('30-08-2020','dd-MM-yyyy'), 'Off Campus', 100027);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000028, 'Neg', TO_DATE('25-08-2020','dd-MM-yyyy'), TO_DATE('27-08-2020','dd-MM-yyyy'), 'Off Campus', 100028);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000029, 'Neg', TO_DATE('26-08-2020','dd-MM-yyyy'), TO_DATE('28-08-2020','dd-MM-yyyy'), 'Off Campus', 100029);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000030, 'Neg', TO_DATE('27-08-2020','dd-MM-yyyy'), TO_DATE('29-08-2020','dd-MM-yyyy'), 'Off Campus', 100030);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000031, 'Neg', TO_DATE('27-08-2020','dd-MM-yyyy'), TO_DATE('29-08-2020','dd-MM-yyyy'), 'Off Campus', 100034);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000032, 'Neg', TO_DATE('28-08-2020','dd-MM-yyyy'), TO_DATE('30-08-2020','dd-MM-yyyy'), 'Off Campus', 100035);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000033, 'Neg', TO_DATE('25-08-2020','dd-MM-yyyy'), TO_DATE('27-08-2020','dd-MM-yyyy'), 'Off Campus', 100036);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000034, 'Neg', TO_DATE('26-08-2020','dd-MM-yyyy'), TO_DATE('28-08-2020','dd-MM-yyyy'), 'Off Campus', 100037);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000035, 'Neg', TO_DATE('27-08-2020','dd-MM-yyyy'), TO_DATE('29-08-2020','dd-MM-yyyy'), 'Off Campus', 100038);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000036, 'Neg', TO_DATE('28-08-2020','dd-MM-yyyy'), TO_DATE('30-08-2020','dd-MM-yyyy'), 'Off Campus', 100039);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000037, 'Neg', TO_DATE('25-08-2020','dd-MM-yyyy'), TO_DATE('27-08-2020','dd-MM-yyyy'), 'Off Campus', 100040);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000038, 'Neg', TO_DATE('26-08-2020','dd-MM-yyyy'), TO_DATE('28-08-2020','dd-MM-yyyy'), 'Off Campus', 100041);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000039, 'Neg', TO_DATE('25-08-2020','dd-MM-yyyy'), TO_DATE('27-08-2020','dd-MM-yyyy'), 'Off Campus', 100042);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000040, 'Neg', TO_DATE('26-08-2020','dd-MM-yyyy'), TO_DATE('28-08-2020','dd-MM-yyyy'), 'Off Campus', 100050);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000041, 'Neg', TO_DATE('27-08-2020','dd-MM-yyyy'), TO_DATE('29-08-2020','dd-MM-yyyy'), 'Off Campus', 100051);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000042, 'Neg', TO_DATE('28-08-2020','dd-MM-yyyy'), TO_DATE('30-08-2020','dd-MM-yyyy'), 'Off Campus', 100052);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000043, 'Neg', TO_DATE('25-08-2020','dd-MM-yyyy'), TO_DATE('27-08-2020','dd-MM-yyyy'), 'Off Campus', 100053);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000044, 'Neg', TO_DATE('26-08-2020','dd-MM-yyyy'), TO_DATE('28-08-2020','dd-MM-yyyy'), 'Off Campus', 100054);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000045, 'Neg', TO_DATE('27-08-2020','dd-MM-yyyy'), TO_DATE('29-08-2020','dd-MM-yyyy'), 'Off Campus', 100055);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000046, 'Neg', TO_DATE('28-08-2020','dd-MM-yyyy'), TO_DATE('30-08-2020','dd-MM-yyyy'), 'Off Campus', 100056);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000047, 'Neg', TO_DATE('25-08-2020','dd-MM-yyyy'), TO_DATE('27-08-2020','dd-MM-yyyy'), 'Off Campus', 100057);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000048, 'Neg', TO_DATE('26-08-2020','dd-MM-yyyy'), TO_DATE('28-08-2020','dd-MM-yyyy'), 'Off Campus', 100058);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000049, 'Neg', TO_DATE('27-08-2020','dd-MM-yyyy'), TO_DATE('29-08-2020','dd-MM-yyyy'), 'Off Campus', 100059);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000050, 'Neg', TO_DATE('28-08-2020','dd-MM-yyyy'), TO_DATE('30-08-2020','dd-MM-yyyy'), 'Off Campus', 100060);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000051, 'Neg', TO_DATE('25-08-2020','dd-MM-yyyy'), TO_DATE('27-08-2020','dd-MM-yyyy'), 'Off Campus', 100064);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000052, 'Neg', TO_DATE('26-08-2020','dd-MM-yyyy'), TO_DATE('28-08-2020','dd-MM-yyyy'), 'Off Campus', 100065);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000053, 'Neg', TO_DATE('27-08-2020','dd-MM-yyyy'), TO_DATE('29-08-2020','dd-MM-yyyy'), 'Off Campus', 100066);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000054, 'Neg', TO_DATE('28-08-2020','dd-MM-yyyy'), TO_DATE('30-08-2020','dd-MM-yyyy'), 'Off Campus', 100067);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000055, 'Neg', TO_DATE('25-08-2020','dd-MM-yyyy'), TO_DATE('27-08-2020','dd-MM-yyyy'), 'Off Campus', 100068);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000056, 'Neg', TO_DATE('26-08-2020','dd-MM-yyyy'), TO_DATE('28-08-2020','dd-MM-yyyy'), 'Off Campus', 100069);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000057, 'Neg', TO_DATE('27-08-2020','dd-MM-yyyy'), TO_DATE('29-08-2020','dd-MM-yyyy'), 'Off Campus', 100070);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000058, 'Neg', TO_DATE('28-08-2020','dd-MM-yyyy'), TO_DATE('30-08-2020','dd-MM-yyyy'), 'Off Campus', 100071);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000059, 'Neg', TO_DATE('25-08-2020','dd-MM-yyyy'), TO_DATE('27-08-2020','dd-MM-yyyy'), 'Off Campus', 100072);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000060, 'Neg', TO_DATE('26-08-2020','dd-MM-yyyy'), TO_DATE('28-08-2020','dd-MM-yyyy'), 'Off Campus', 100073);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000061, 'Neg', TO_DATE('27-08-2020','dd-MM-yyyy'), TO_DATE('29-08-2020','dd-MM-yyyy'), 'Off Campus', 100074);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000062, 'Neg', TO_DATE('28-08-2020','dd-MM-yyyy'), TO_DATE('30-08-2020','dd-MM-yyyy'), 'Off Campus', 100075);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000063, 'Neg', TO_DATE('25-08-2020','dd-MM-yyyy'), TO_DATE('27-08-2020','dd-MM-yyyy'), 'Off Campus', 100076);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000064, 'Neg', TO_DATE('26-08-2020','dd-MM-yyyy'), TO_DATE('28-08-2020','dd-MM-yyyy'), 'Off Campus', 100077);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000065, 'Neg', TO_DATE('27-08-2020','dd-MM-yyyy'), TO_DATE('29-08-2020','dd-MM-yyyy'), 'Off Campus', 100078);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID) Values (1000066, 'Neg', TO_DATE('28-08-2020','dd-MM-yyyy'), TO_DATE('30-08-2020','dd-MM-yyyy'), 'Off Campus', 100079);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID, ConsecNegTest) Values (1000067, 'Pos', TO_DATE('10-09-2020','dd-MM-yyyy'), TO_DATE('12-09-2020','dd-MM-yyyy'), 'Hartford', 100002, 1000002);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID, ConsecNegTest) Values (1000068, 'Neg', TO_DATE('22-09-2020','dd-MM-yyyy'), TO_DATE('24-09-2020','dd-MM-yyyy'), 'Off Campus', 100002, 1000067);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID, ConsecNegTest) Values (1000069, 'Neg', TO_DATE('26-09-2020','dd-MM-yyyy'), TO_DATE('28-09-2020','dd-MM-yyyy'), 'Off Campus', 100002, 1000068);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID, ConsecNegTest) Values (1000070, 'Pos', TO_DATE('14-09-2020','dd-MM-yyyy'), TO_DATE('16-09-2020','dd-MM-yyyy'), 'Stamford', 100006, 1000006);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID, ConsecNegTest) Values (1000071, 'Neg', TO_DATE('26-09-2020','dd-MM-yyyy'), TO_DATE('28-09-2020','dd-MM-yyyy'), 'Off Campus', 100006, 1000070);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID, ConsecNegTest) Values (1000072, 'Neg', TO_DATE('30-09-2020','dd-MM-yyyy'), TO_DATE('02-10-2020','dd-MM-yyyy'), 'Off Campus', 100006, 1000071);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID, ConsecNegTest) Values (1000073, 'Pos', TO_DATE('09-09-2020','dd-MM-yyyy'), TO_DATE('11-09-2020','dd-MM-yyyy'), 'Storrs', 100025, 1000025);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID, ConsecNegTest) Values (1000074, 'Neg', TO_DATE('21-09-2020','dd-MM-yyyy'), TO_DATE('23-09-2020','dd-MM-yyyy'), 'Storrs', 100025, 1000073);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID, ConsecNegTest) Values (1000075, 'Neg', TO_DATE('25-09-2020','dd-MM-yyyy'), TO_DATE('27-09-2020','dd-MM-yyyy'), 'Storrs', 100025, 1000074);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID, ConsecNegTest) Values (1000076, 'Pos', TO_DATE('12-09-2020','dd-MM-yyyy'), TO_DATE('14-09-2020','dd-MM-yyyy'), 'Storrs', 100014, 1000014);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID, ConsecNegTest) Values (1000077, 'Neg', TO_DATE('24-09-2020','dd-MM-yyyy'), TO_DATE('26-09-2020','dd-MM-yyyy'), 'Storrs', 100014, 1000076);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID, ConsecNegTest) Values (1000078, 'Neg', TO_DATE('28-09-2020','dd-MM-yyyy'), TO_DATE('30-09-2020','dd-MM-yyyy'), 'Storrs', 100014, 1000077);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID, ConsecNegTest) Values (1000079, 'Pos', TO_DATE('12-10-2020','dd-MM-yyyy'), TO_DATE('14-10-2020','dd-MM-yyyy'), 'Storrs', 100019, 1000019);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID, ConsecNegTest) Values (1000080, 'Neg', TO_DATE('24-10-2020','dd-MM-yyyy'), TO_DATE('26-10-2020','dd-MM-yyyy'), 'Storrs', 100019, 1000079);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID, ConsecNegTest) Values (1000081, 'Neg', TO_DATE('28-10-2020','dd-MM-yyyy'), TO_DATE('30-10-2020','dd-MM-yyyy'), 'Storrs', 100019, 1000080);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID, ConsecNegTest) Values (1000082, 'Pos', TO_DATE('01-10-2020','dd-MM-yyyy'), TO_DATE('03-10-2020','dd-MM-yyyy'), 'Stamford', 100001, 1000001);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID, ConsecNegTest) Values (1000083, 'Neg', TO_DATE('13-10-2020','dd-MM-yyyy'), TO_DATE('15-10-2020','dd-MM-yyyy'), 'Off Campus', 100001, 1000082);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID, ConsecNegTest) Values (1000084, 'Neg', TO_DATE('17-10-2020','dd-MM-yyyy'), TO_DATE('19-10-2020','dd-MM-yyyy'), 'Off Campus', 100001, 1000083);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID, ConsecNegTest) Values (1000085, 'Pos', TO_DATE('13-10-2020','dd-MM-yyyy'), TO_DATE('15-10-2020','dd-MM-yyyy'), 'Stamford', 100015, 1000015);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID, ConsecNegTest) Values (1000086, 'Neg', TO_DATE('25-10-2020','dd-MM-yyyy'), TO_DATE('27-10-2020','dd-MM-yyyy'), 'Stamford', 100015, 1000085);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID, ConsecNegTest) Values (1000087, 'Neg', TO_DATE('29-10-2020','dd-MM-yyyy'), TO_DATE('31-10-2020','dd-MM-yyyy'), 'Stamford', 100015, 1000086);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID, ConsecNegTest) Values (1000088, 'Pos', TO_DATE('29-10-2020','dd-MM-yyyy'), TO_DATE('31-10-2020','dd-MM-yyyy'), 'Storrs', 100000, 1000000);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID, ConsecNegTest) Values (1000089, 'Neg', TO_DATE('10-11-2020','dd-MM-yyyy'), TO_DATE('12-11-2020','dd-MM-yyyy'), 'Storrs', 100000, 1000088);
INSERT INTO CovidTest (TestID, TestResult, DateTaken, DateResult, TestLocation, PersonID, ConsecNegTest) Values (1000090, 'Neg', TO_DATE('14-11-2020','dd-MM-yyyy'), TO_DATE('16-11-2020','dd-MM-yyyy'), 'Storrs', 100000, 1000089);

-- ===========================================================================
-- INSERT: QuarantineList
-- ===========================================================================

INSERT INTO QuarantineList Values (800000, 100025, 'Off Campus', TO_DATE('11-09-2020', 'dd-MM-yyyy'), TO_DATE('25-09-2020', 'dd-MM-yyyy'), 1000073);
INSERT INTO QuarantineList Values (800001, 100000, 'On Campus', TO_DATE('31-10-2020', 'dd-MM-yyyy'), TO_DATE('14-11-2020', 'dd-MM-yyyy'), 1000088);
INSERT INTO QuarantineList Values (800002, 100001, 'On Campus', TO_DATE('03-10-2020', 'dd-MM-yyyy'), TO_DATE('17-10-2020', 'dd-MM-yyyy'), 1000082);
INSERT INTO QuarantineList Values (800003, 100002, 'On Campus', TO_DATE('12-09-2020', 'dd-MM-yyyy'), TO_DATE('26-09-2020', 'dd-MM-yyyy'), 1000067);
INSERT INTO QuarantineList Values (800004, 100006, 'On Campus', TO_DATE('16-09-2020', 'dd-MM-yyyy'), TO_DATE('30-09-2020', 'dd-MM-yyyy'), 1000070);
INSERT INTO QuarantineList Values (800005, 100014, 'On Campus', TO_DATE('14-09-2020', 'dd-MM-yyyy'), TO_DATE('28-09-2020', 'dd-MM-yyyy'), 1000076);
INSERT INTO QuarantineList Values (800006, 100015, 'On Campus', TO_DATE('15-10-2020', 'dd-MM-yyyy'), TO_DATE('29-10-2020', 'dd-MM-yyyy'), 1000085);
INSERT INTO QuarantineList Values (800007, 100019, 'On Campus', TO_DATE('14-10-2020', 'dd-MM-yyyy'), TO_DATE('28-10-2020', 'dd-MM-yyyy'), 1000079);

-- ===========================================================================
-- END
-- ===========================================================================
