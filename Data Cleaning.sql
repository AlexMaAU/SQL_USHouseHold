SELECT *
FROM ushouseholdincome;

SELECT *
FROM ushouseholdincome_statistics;

# Create staging tables
CREATE TABLE ushouseholdincome_staging
AS
SELECT *
FROM ushouseholdincome;

CREATE TABLE ushouseholdincome_statistics_staging
AS
SELECT *
FROM ushouseholdincome_statistics;

# Fix incorrect column name after importing table
ALTER TABLE ushouseholdincome_statistics_staging
RENAME COLUMN `锘縤d` TO `id`;

# Remove Duplicates - no Duplicates found, which is good
SELECT *
FROM ushouseholdincome_staging;

SELECT COUNT(id)
FROM ushouseholdincome_staging
GROUP BY id
HAVING COUNT(id) > 1;

SELECT *
FROM ushouseholdincome_statistics_staging;

SELECT COUNT(id)
FROM ushouseholdincome_statistics_staging
GROUP BY id
HAVING COUNT(id) > 1;

# Standardize Data
SELECT State_Name, COUNT(State_Name)
FROM ushouseholdincome_staging
GROUP BY State_Name;

UPDATE ushouseholdincome_staging
SET State_Name = 'Georgia'
WHERE State_Name = 'georia';

UPDATE ushouseholdincome_staging
SET State_Name = CONCAT(
        UPPER(SUBSTRING(State_Name, 1, 1)), 
        LOWER(SUBSTRING(State_Name, 2))
    );
    
SELECT State_ab, COUNT(State_ab)
FROM ushouseholdincome_staging
GROUP BY State_ab
HAVING COUNT(State_ab) > 1;

SELECT *
FROM ushouseholdincome_staging
WHERE Place = '';

UPDATE ushouseholdincome_staging
SET Place = 'Autaugaville'
WHERE City = 'Vinemont';

SELECT Type, COUNT(Type)
FROM ushouseholdincome_staging
GROUP BY Type;

UPDATE ushouseholdincome_staging
SET TYPE = 'CDP'
WHERE TYPE = 'CPD';

UPDATE ushouseholdincome_staging
SET TYPE = 'Borough'
WHERE TYPE = 'Boroughs';

SELECT *
FROM ushouseholdincome_staging
WHERE ALand = 0 OR ALand IS NULL;

SELECT DISTINCT(ALand)
FROM ushouseholdincome_staging
WHERE ALand = 0 OR ALand IS NULL;

SELECT *
FROM ushouseholdincome_staging
WHERE AWater = 0 OR AWater IS NULL;

SELECT DISTINCT(AWater)
FROM ushouseholdincome_staging
WHERE AWater = 0 OR AWater IS NULL;

SELECT *
FROM ushouseholdincome_staging
WHERE (AWater = 0 OR AWater IS NULL)
AND (ALand = 0 OR ALand IS NULL);

SELECT *
FROM ushouseholdincome_statistics_staging
WHERE Mean = 0 AND Median = 0 AND Stdev = 0;

DELETE FROM ushouseholdincome_statistics_staging
WHERE Mean = 0 AND Median = 0 AND Stdev = 0;

SELECT *
FROM ushouseholdincome_staging;

SELECT *
FROM ushouseholdincome_statistics_staging;