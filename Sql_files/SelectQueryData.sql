-- OPIM 5272; UCONN COVID Positive Case Tracking
-- Group Five Project: Shaista Uman, Bajram Lumani, Junchi Ma, Godfrey Gelineau
-- Project Due Date: 12/14/20
-- Below are SQL Statements to Query Table Data

-- ===========================================================================
-- 1) Query to List COVID Positive Cases on UCONN Campuses
-- ===========================================================================

SELECT firstname, lastname, 
    (CASE WHEN title = 'stu' THEN 'Student' WHEN title = 'f' THEN 'Faculty' ELSE 'Staff' END) AS Title_Long, 
    email, phonenum, testresult, datetaken
    FROM person p INNER JOIN covidtest ct
    ON p.personid = ct.personid
WHERE testresult IN ('Pos', 'pos');

-- ===========================================================================
-- 2) List of Students living in same residence hall as COVID positive cases.
-- ===========================================================================

SELECT firstname, lastname, 
    (CASE WHEN title = 'stu' THEN 'Student' WHEN title = 'f' THEN 'Faculty' ELSE 'Staff' END) AS Title_Long, 
    email, phonenum, facilityname, campus, buildingnum
    FROM person p JOIN RoomAssignment ra
    ON p.personid = ra.personid
        JOIN Facility f
        ON ra.roomid = f.roomid
WHERE buildingnum IN 
    (SELECT buildingnum
        FROM person p INNER JOIN covidtest ct
        ON p.personid = ct.personid
            JOIN RoomAssignment ra
            ON p.personid = ra.personid
                JOIN Facility f
                ON ra.roomid = f.roomid
    WHERE testresult IN ('Pos', 'pos') AND title = 'stu')
;

-- ===========================================================================
-- 3) List contact information for persons on Campuses with Positive COVID cases
-- ===========================================================================

SELECT DISTINCT incase.firstname, incase.lastname, incase.email, incase.phonenum, 
    (CASE WHEN title = 'stu' THEN 'Student' WHEN title = 'f' THEN 'Faculty' ELSE 'Staff' END) AS Title_Long, pcase.campus 
    FROM 
        (SELECT firstname, lastname, email, phonenum, title, f.campus 
            FROM person p INNER JOIN cardscanlog csl
            ON p.personid = csl.personid
                INNER JOIN facility f
                ON csl.roomid = f.roomid) incase
                    INNER JOIN 
                    (SELECT campus
                        FROM person p INNER JOIN covidtest ct
                        ON p.personid = ct.personid
                            INNER JOIN cardscanlog csl 
                            ON ct.personid = csl.personid
                                INNER JOIN facility f
                                ON csl.roomid = f.roomid
                    WHERE testresult IN ('Pos', 'pos')) pcase
    ON incase.campus = pcase.campus;

-- ===========================================================================
-- 4) List of Emails and phone numbers of anyone needing to quarantine
--    because scan log shows they were exposed to someone with a positive COVID test
--    as they were in same room on same day around same time
-- ===========================================================================

SELECT DISTINCT a.firstname, a.lastname, a.email, a.phonenum, Title_Long, a.campus, a.personid
FROM
(SELECT firstname, lastname, email, phonenum, 
    (CASE WHEN title = 'stu' THEN 'Student' WHEN title = 'f' THEN 'Faculty' ELSE 'Staff' END) AS Title_Long, campus,
    TO_NUMBER(REPLACE(SUBSTR(logtime,1,2),':','')) AS LogTimeHourAsNum, logdate, csl.roomid, p.personid
    FROM person p INNER JOIN cardscanlog csl 
    ON p.personid = csl.personid
        INNER JOIN facility f
        ON csl.roomid = f.roomid) a
JOIN
(SELECT csl.roomid, logtime, logdate, TO_NUMBER(REPLACE(SUBSTR(logtime,1,2),':','')) AS LogTimeHourAsNum, p.personid
    FROM person p INNER JOIN covidtest ct
    ON p.personid = ct.personid
        INNER JOIN cardscanlog csl 
        ON ct.personid = csl.personid
            INNER JOIN facility f
            ON csl.roomid = f.roomid
WHERE testresult IN ('Pos', 'pos')) b
ON a.logdate = b.logdate AND a.roomid = b.roomid AND ABS(a.LogTimeHourAsNum - b.LogTimeHourAsNum) <= 1 
AND a.personid <> b.personid
;

-- ===========================================================================
-- 5) When can exposed persons come off quarantine?
-- ===========================================================================

SELECT DISTINCT a.firstname, a.lastname, a.email, a.phonenum, Title_Long, a.campus, a.personid, a.logdate,
    (a.logdate + 14) AS quarantine_end_date
FROM
(SELECT firstname, lastname, email, phonenum, 
    (CASE WHEN title = 'stu' THEN 'Student' WHEN title = 'f' THEN 'Faculty' ELSE 'Staff' END) AS Title_Long, campus,
    TO_NUMBER(REPLACE(SUBSTR(logtime,1,2),':','')) AS LogTimeHourAsNum, logdate, csl.roomid, p.personid
    FROM person p INNER JOIN cardscanlog csl 
    ON p.personid = csl.personid
        INNER JOIN facility f
        ON csl.roomid = f.roomid) a
JOIN
(SELECT csl.roomid, logtime, logdate, TO_NUMBER(REPLACE(SUBSTR(logtime,1,2),':','')) AS LogTimeHourAsNum, p.personid
    FROM person p INNER JOIN covidtest ct
    ON p.personid = ct.personid
        INNER JOIN cardscanlog csl 
        ON ct.personid = csl.personid
            INNER JOIN facility f
            ON csl.roomid = f.roomid
WHERE testresult IN ('Pos', 'pos')) b
ON a.logdate = b.logdate AND a.roomid = b.roomid AND ABS(a.LogTimeHourAsNum - b.LogTimeHourAsNum) <= 1 
AND a.personid <> b.personid
;

-- ===========================================================================
-- 6) Positive COVID test counts by Campus
-- ===========================================================================

SELECT campus, COUNT(*)
FROM
(SELECT DISTINCT firstname, lastname, 
    (CASE WHEN title = 'stu' THEN 'Student' WHEN title = 'f' THEN 'Faculty' ELSE 'Staff' END) AS Title_Long, 
    email, phonenum, testresult, datetaken, campus
    FROM person p INNER JOIN covidtest ct
    ON p.personid = ct.personid
        JOIN cardscanlog csl
        ON p.personid = csl.personid
            JOIN facility f
            ON csl.roomid = f.roomid
WHERE testresult IN ('Pos', 'pos'))
GROUP BY campus
;

-- ===========================================================================
-- 7) Positive Student COVID test counts by Campus and Dorm
-- ===========================================================================

SELECT campus, facilityname, COUNT(*)
FROM
(SELECT DISTINCT p.personid, campus, facilityname
    FROM person p INNER JOIN covidtest ct
    ON p.personid = ct.personid
        JOIN cardscanlog csl
        ON p.personid = csl.personid
            JOIN facility f
            ON csl.roomid = f.roomid
WHERE testresult IN ('Pos', 'pos') AND facilitytype = 'residence')
GROUP BY campus, facilityname
ORDER BY campus, facilityname
;

-- ===========================================================================
-- 8) Students and Instructors (Faculty) by Course; for Hyrbrid and In Person Courses.
-- ===========================================================================

SELECT c.code, stud.courseid, c.coursemodality,  
    stud.firstname AS Student_First_Name, stud.lastname AS Student_Last_Name, 
    fac.firstname AS Faculty_First_Name, fac.lastname AS Faculty_Last_Name
FROM
    (SELECT p.firstname, p.lastname, p.title, sc.courseid
    FROM person p INNER JOIN studentCourse sc
    ON p.personid = sc.personid) stud 
    INNER JOIN 
    (SELECT p.firstname, p.lastname, p.title, fc.courseid
    FROM person p INNER JOIN facultyCourse fc
    ON p.personid = fc.personid) fac
ON stud.courseid = fac.courseid
INNER JOIN course c ON fac.courseid =c.courseid
WHERE c.coursemodality IN ('hybrid','In Person')
ORDER BY c.courseid;

-- ===========================================================================
-- 9) List of professors or staff that have been assigned to work from the same building.
-- ===========================================================================

SELECT BuildingNum, FacilityName, FirstName, LastName, 
    (CASE WHEN title = 'stu' THEN 'Student' WHEN title = 'f' THEN 'Faculty' ELSE 'Staff' END) AS Title_Long, 
    PhoneNum, Email
FROM 
    person p INNER JOIN roomassignment ra 
    ON p.personid = ra.personid
    INNER JOIN facility f 
    ON ra.roomid = f.roomid
WHERE FacilityType LIKE 'non-residence'
ORDER BY BuildingNum;

-- ===========================================================================
-- 10) List of students registered for a course in fall sorted by course modality and course code.
-- ===========================================================================

SELECT semester, code, section, --section is different by campus
    (CASE WHEN SUBSTR(section,1,1) = 'M' THEN 'Stamford' 
        WHEN SUBSTR(section,1,1) = 'W' THEN 'Waterbury'
        WHEN SUBSTR(section,1,1) = 'A' THEN 'Avery Point'
        WHEN SUBSTR(section,1,1) = 'B' THEN 'Hartford'
        ELSE 'Storrs' END) AS Campus_From_Section, 
    coursemodality, firstname, lastname, PhoneNum, Email
    FROM person p INNER JOIN studentcourse sc 
    ON p.personid = sc.personid 
        INNER JOIN course c 
        ON sc.courseid = c.courseid
ORDER BY coursemodality, code;

-- ===========================================================================
-- 11) Identify who was in a room on a specific day.  User inputs room number and date.
-- ===========================================================================

SELECT roomid, logdate, logtime, firstname, lastname, phonenum, email
    FROM person p INNER JOIN cardscanlog csl
    ON p.personid = csl.personid
    WHERE roomid = &userinput_RoomID AND logdate = &userinput_LogDate --User Input examples: RoomID: 1085, LogDate: '04-SEP-20'
    ORDER BY roomid;

-- ===========================================================================
-- 12) List of Dorm Rooms or Offices assigned to a Person who tested positive for COVID.
-- ===========================================================================

SELECT campus, facilityname, BuildingNum, RoomNum
    FROM covidtest ct INNER JOIN person p 
    ON ct.personid = p.personid
        INNER JOIN roomassignment ra 
        ON p.personid =ra.personid
            INNER JOIN facility f 
            ON ra.roomid = f.roomid
WHERE testresult IN ('pos', 'Pos');

-- ===========================================================================
-- 13) Students who tested positive for COVID, and expected Graduation Date
-- ===========================================================================

SELECT p.personid, firstname, lastname, graduationdate AS Expected_Gratuation_Date, graduationstatus 
    FROM person p JOIN covidtest ct 
    ON p.personid = ct.personid 
        JOIN student s
        ON p.personid = s.personid
WHERE p.personid = ct.personid AND ct.testresult = 'Pos';

-- ===========================================================================
-- 14) Positive COVID test counts by Month (month associated with positive test date)
-- ===========================================================================

SELECT Test_Result_Month, COUNT(*)
FROM
(SELECT DISTINCT firstname, lastname, 
    (CASE WHEN title = 'stu' THEN 'Student' WHEN title = 'f' THEN 'Faculty' ELSE 'Staff' END) AS Title_Long, 
    email, phonenum, testresult, datetaken, dateresult,
    dateresult, (SUBSTR(dateresult,4,3)||' '||'20'||SUBSTR(dateresult,8,2)) AS Test_Result_Month
    FROM person p INNER JOIN covidtest ct
    ON p.personid = ct.personid
        JOIN cardscanlog csl
        ON p.personid = csl.personid
WHERE testresult IN ('Pos', 'pos'))
GROUP BY Test_Result_Month
;

-- ===========================================================================
-- 15) To understand rooms needing a deep clean, rooms used (with date) by positive covid cases.
-- ===========================================================================

SELECT DISTINCT campus, logdate AS Date_Of_Exposure, csl.roomid 
    FROM person p INNER JOIN covidtest ct
    ON p.personid = ct.personid
        JOIN cardscanlog csl
        ON p.personid = csl.personid
            JOIN facility f
            ON csl.roomid = f.roomid
WHERE testresult IN ('Pos', 'pos')
ORDER BY campus, logdate, roomid;

-- ===========================================================================
-- 16) If those 70 and older are considered high risk, define who in Person table may be high risk.
-- ===========================================================================

--NOTE: No Person table records have an age over 70, so first ammend three faculty DOB records

UPDATE Person
SET DOB = '24-APR-50'
WHERE PersonID = '100030';

UPDATE Person
SET DOB = '26-JAN-50'
WHERE PersonID = '100075';

UPDATE Person
SET DOB = '01-MAR-50'
WHERE PersonID = '100079';

--Now, the query to find High Risk Person records

SELECT FirstName, LastName, Age, 
CASE 
    WHEN Age >= 70 THEN 'High Risk' 
    ELSE 'Low Risk' 
END AS RiskLevel, Title_Long, PersonID, PhoneNum, Email 
FROM (SELECT FirstName, LastName, floor(months_between(sysdate,DOB)/12) AS Age, PersonID,
    (CASE WHEN title = 'stu' THEN 'Student' WHEN title = 'f' THEN 'Faculty' ELSE 'Staff' END) AS Title_Long, 
    PhoneNum, Email
    FROM Person)
ORDER BY RiskLevel, PersonID;
