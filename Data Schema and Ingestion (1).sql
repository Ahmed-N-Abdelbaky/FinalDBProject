DROP TABLE IF EXISTS Company CASCADE;
CREATE TABLE  Company (
    CID BIGINT PRIMARY KEY,
    "Name" TEXT,
    "Description" TEXT,
    Zipcode TEXT,
    Industry TEXT,
    Specialty TEXT,
    Employee_Count INT,
    Follower_Count INT
);

DROP TABLE IF EXISTS Job CASCADE;
CREATE TABLE Job (
    JID BIGINT PRIMARY KEY,
    CID BIGINT,
    Description TEXT,
    Title TEXT,
    Skill_Desc TEXT,
    Work_Type TEXT,
    FOREIGN KEY (CID) REFERENCES Company(CID)
);

DROP TABLE IF EXISTS Salary CASCADE;
CREATE TABLE Salary (
    SID BIGINT PRIMARY KEY,
    JID BIGINT,
    "Max" NUMERIC(15, 2),
    Med NUMERIC(15, 2),
    "Min" NUMERIC(15, 2),
    Currency VARCHAR(50),
    Pay_Period VARCHAR(255),
    FOREIGN KEY (JID) REFERENCES Job(JID)
);
CREATE TEMP TABLE temp_companies (
CID BIGINT,
"Name" TEXT,
"Description" TEXT,
Zipcode TEXT
);

CREATE TEMP TABLE temp_follower_count (
CID BIGINT,
employee_count INT,
follower_count INT
);

CREATE TEMP TABLE temp_speciality (
CID BIGINT,
speciality TEXT
);

CREATE TEMP TABLE temp_industry (
CID BIGINT,
Industry TEXT
);

COPY temp_companies
FROM 'C:\dp\companies_cleaned.csv'
DELIMITER ',' CSV HEADER;

COPY temp_speciality
FROM 'C:\dp\speciality_cleaned.csv'
DELIMITER ',' CSV HEADER;

COPY temp_industry
FROM 'C:\dp\Industries_cleaned.csv'
DELIMITER ',' CSV HEADER;

COPY temp_follower_count
FROM 'C:\dp\employee_count_cleaned1.csv'
DELIMITER ',' CSV HEADER;

INSERT INTO Company (CID, "Name", "Description", Zipcode, Industry, Specialty, Employee_Count, Follower_Count)
SELECT DISTINCT ON (CID)
    CID, "Name", "Description", Zipcode, Industry, Specialty, Employee_Count, Follower_Count
FROM (
    SELECT 
        co.CID, 
        co."Name",
        co."Description", 
        co.Zipcode, 
        ind.Industry, 
        sp.speciality AS Specialty, 
        fc.employee_count,
        fc.follower_count
    FROM temp_companies co
    LEFT JOIN temp_follower_count fc ON co.CID = fc.CID
    LEFT JOIN temp_speciality sp ON co.CID = sp.CID
    LEFT JOIN temp_industry ind ON co.CID = ind.CID

    UNION ALL

    SELECT 
        fc.CID, 
        co."Name",
        co."Description", 
        co.Zipcode, 
        ind.Industry, 
        sp.speciality AS Specialty, 
        fc.employee_count,
        fc.follower_count
    FROM temp_follower_count fc
    LEFT JOIN temp_companies co ON fc.CID = co.CID
    LEFT JOIN temp_speciality sp ON fc.CID = sp.CID
    LEFT JOIN temp_industry ind ON fc.CID = ind.CID

    UNION ALL

    SELECT 
        sp.CID, 
        co."Name",
        co."Description", 
        co.Zipcode, 
        ind.Industry, 
        sp.speciality AS Specialty, 
        fc.employee_count,
        fc.follower_count
    FROM temp_speciality sp
    LEFT JOIN temp_companies co ON sp.CID = co.CID
    LEFT JOIN temp_follower_count fc ON sp.CID = fc.CID
    LEFT JOIN temp_industry ind ON sp.CID = ind.CID

    UNION ALL

    SELECT 
        ind.CID, 
        co."Name",
        co."Description", 
        co.Zipcode, 
        ind.Industry, 
        sp.speciality AS Specialty, 
        fc.employee_count,
        fc.follower_count
    FROM temp_industry ind
    LEFT JOIN temp_companies co ON ind.CID = co.CID
    LEFT JOIN temp_follower_count fc ON ind.CID = fc.CID
    LEFT JOIN temp_speciality sp ON ind.CID = sp.CID
) AS combined
ORDER BY CID;


DROP TABLE temp_companies;
DROP TABLE temp_follower_count;
DROP TABLE temp_speciality;
DROP TABLE temp_industry;

CREATE TEMP TABLE temp_job (
	JID BIGINT,
    CID BIGINT,
    Description TEXT,
    Title TEXT,
    Skill_Desc TEXT,
    Work_Type TEXT
);

COPY temp_job
FROM 'C:\dp\job_posting_cleaned.csv'
DELIMITER ',' CSV HEADER;

--INSERTING TO Job Table

INSERT INTO Job (JID, CID, Description, Title, Skill_Desc, Work_Type)
SELECT JID, CID, Description, Title, Skill_Desc, Work_Type
FROM temp_job
WHERE CID IN (SELECT CID FROM Company);

--DELETING THE TEMP table
DROP TABLE temp_job;

---------------SALARY TABLE------------------
--TEMP Table
CREATE TEMP TABLE temp_salary (
    JID BIGINT,
    SID BIGINT,
    "max" BIGINT,
    med BIGINT,
    "min" BIGINT,
    currency VARCHAR(50),
    pay_period VARCHAR(255)
);
COPY temp_salary
FROM 'C:\dp\Salaries_cleaned.csv'
DELIMITER ',' CSV HEADER;

--INSERTING into Salary Table
INSERT INTO salary (SID, JID, "Max", Med, "Min", Currency, Pay_Period)
SELECT SID, JID, "max", med, "min", pay_period, currency
FROM temp_salary 
WHERE JID IN (SELECT JID FROM job);

--DROPING the TEMP table
DROP TABLE temp_salary;

SELECT * FROM company;

