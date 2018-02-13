-- Freckle_BIChallenge_Karan_Teckwani
-- SQL query summary

-- DDL query for creating the events_sample table
/*
CREATE TABLE events_sample
(
  idfa                TEXT,
  app_id              TEXT,
  source_data         TEXT,
  lat                 TEXT,
  lng                 TEXT,
  location_event_time TEXT,
  date_time           DATETIME(20),
  DataSource_AppID    VARCHAR(100)
);
*/

-- DML queries

-- Q1. Show the average number of events per user-id

SELECT ROUND(AVG(events),4) as avg_events_per_userid FROM
    (SELECT idfa,COUNT(DISTINCT location_event_time) as events from events_sample
        WHERE idfa IS NOT NULL
        GROUP BY idfa);

--Answer: 1.2044

/*
Q2. Construct a data model that normalizes the data into a fact table with the following hierarchical dimensions:
      a) Day :: Hour
      b) Data Source :: App ID

Add a column and parse out the date and times from the location_event_time column
*/

-- Create a new column date_time as datatype(datetime) for Day :: Hour hierarchy
ALTER TABLE events_sample ADD date_time datetime(20);

-- Parse the information from location_event_time and populate date_time
UPDATE events_sample
    SET date_time = SUBSTR(location_event_time,1,10) || '_' || SUBSTR(location_event_time,12,8);

-- Create a new column DataSource_AppID as datatype(varchar) for Data Source :: App ID
ALTER TABLE events_sample add DataSource_AppID varchar(100);

-- Parse the information from source_data and AppID for Source :: AppID hierarchy
UPDATE events_sample
    SET DataSource_AppID = source_data || '_' || app_id;

-- Create a fact table that summarizes the number of IDs with the specified hierarchy
CREATE TABLE events_fact
AS
    SELECT DataSource_AppID, date_time, COUNT(DISTINCT idfa) AS UniqueIDs
       FROM events_sample
       GROUP BY DataSource_AppID, date_time;

--Check the table
SELECT * FROM events_fact
ORDER BY UniqueIDs DESC;

-- DDL query for events_fact table
/*
CREATE TABLE events_fact
(
  DataSource_AppID TEXT,
  date_time        NUM,
  UniqueIDs
);
*/

/*
Q3. Using the data model constructed in 4,
   determine how many unique user-ids are represented in hour 1-2pm
   (13:00-14:00) for app_id 17, data_source twine
*/

SELECT COUNT(*)
    AS unique_user_ids
    FROM events_fact
    WHERE DataSource_AppID LIKE 'twine_17' AND date_time LIKE '%_13:%';

--Answer: 2,710 Unique IDs


/*
Q4. Determine what type of statistical distribution the population
    of events/idfa.
    Events per IDFA is determined by counting the total number of events
    per unique IDFA within the entire population
    (the data set already bounded at 24 hours).
*/

--Create a table having the number of events/idfa
CREATE TABLE EventsPerID
AS
    SELECT idfa,COUNT(DISTINCT location_event_time) AS events
    FROM events_sample
    WHERE idfa IS NOT NULL
    GROUP BY idfa;

-- DDL query for EventsPerID table
/*
CREATE TABLE EventsPerID
(
  idfa TEXT,
  events
);
*/
-- Calculate the average number of events
SELECT ROUND(AVG(events),3)
    AS avg_events
    FROM EventsPerID;
-- Answer: 1.2044

-- See the EventsPerID table
SELECT * FROM EventsPerID
ORDER BY events DESC;

/*
1. The Data set reveals that the events_sample have been for the period of 24 hours.
    Thus, the events are occurring within a given time - interval.

2. The number of events/id are likely to be discrete.

3. The table (EventsPerID) shows highest count as 108 which is the mode,
    average events/id is 1.2044, and thus proves to be positively skewed

4. The above pointer proves the best distribution for the population is Poisson
*/
