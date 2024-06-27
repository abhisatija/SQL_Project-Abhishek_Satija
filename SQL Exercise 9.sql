-- Used SQLite3 for this example
create database expeople;
use expeople;

-- table PEOPLE: containing unique ID and corresponding names.
CREATE TABLE PEOPLE (id INTEGER, name CHAR);

INSERT INTO PEOPLE VALUES(1, "A");
INSERT INTO PEOPLE VALUES(2, "B");
INSERT INTO PEOPLE VALUES(3, "C");
INSERT INTO PEOPLE VALUES(4, "D");

-- ADDRESS: containing the history of address information of each ID.
CREATE TABLE ADDRESS (id INTEGER, address varchar(255), updatedate date);

INSERT INTO ADDRESS VALUES(1, "address-1-1", "2016-01-01");
INSERT INTO ADDRESS VALUES(1, "address-1-2", "2016-09-02");
INSERT INTO ADDRESS VALUES(2, "address-2-1", "2015-11-01");
INSERT INTO ADDRESS VALUES(3, "address-3-1", "2016-12-01");
INSERT INTO ADDRESS VALUES(3, "address-3-2", "2014-09-11");
INSERT INTO ADDRESS VALUES(3, "address-3-3", "2015-01-01");
INSERT INTO ADDRESS VALUES(4, "address-4-1", "2010-05-21");
INSERT INTO ADDRESS VALUES(4, "address-4-2", "2012-02-11");
INSERT INTO ADDRESS VALUES(4, "address-4-3", "2015-04-27");
INSERT INTO ADDRESS VALUES(4, "address-4-4", "2014-01-01");


-- 10.1 Join table PEOPLE and ADDRESS, but keep only one address information for each person (we don't mind which record we take for each person). 
    -- i.e., the joined table should have the same number of rows as table PEOPLE
  WITH AddressRanked AS (
    SELECT 
        id, 
        address, 
        updatedate,
        ROW_NUMBER() OVER (PARTITION BY id) as rn
    FROM 
        ADDRESS
)
SELECT 
    P.id,
    P.name,
    A.address,
    A.updatedate
FROM 
    PEOPLE P
LEFT JOIN 
    AddressRanked A
ON 
    P.id = A.id
WHERE 
    A.rn = 1;


-- 10.2 Join table PEOPLE and ADDRESS, but ONLY keep the LATEST address information for each person. 
    -- i.e., the joined table should have the same number of rows as table PEOPLE
     WITH AddressRanked AS (
    SELECT 
        id, 
        address, 
        updatedate,
        ROW_NUMBER() OVER (PARTITION BY id order by updatedate desc) as rn
    FROM 
        ADDRESS
)
SELECT 
    P.id,
    P.name,
    A.address,
    A.updatedate
FROM 
    PEOPLE P
LEFT JOIN 
    AddressRanked A
ON 
    P.id = A.id
WHERE 
    A.rn = 1;