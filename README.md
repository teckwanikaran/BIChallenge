# Business Intelligence / Data Analyst Challenge

This is an open analytics challenge based on real data given to all Freckle IoT Data Analyst applicants. The work is easy but we want to see your SQL, Data Modelling, and statistics skills in action. You can complete this at any point in time prior to your on-site interview. 

Each entry in this data set is a "location-event", it is the raw feed from a . In this mini-assignment, we want to build a regular report of our ingested data so we understand when it is coming in and where from. 

**Data Dictionary:**

app_id - The identifier of the application the data event came from. There are many app_ids in 
data_source - The unique name of data source. There is a _mutually exclusive_ set of app_ids for each data source. 
lat - lattitude of the event
lng - longitude of the event
event_date - timestamp of the event
user_id - the unique user that generated the event. 

**Instructions:**

1. Fork this repo with your own id for our review.
2. Download the dataset here: https://s3.amazonaws.com/freckle-dataeng-challenge/bichallenge-loc-event-sample.csv.gz
3. Show the average number of events per user-id
4. Construct a data model that normalizes the data into a fact table with the following hierarchical dimensions:
  a) Day :: Hour
  b) Data Source :: App ID
5. Using the data model constructed in 4, determine how many unique user-ids are represented in hour 1-2pm (13:00-14:00) for app_id 17, data_source twine
6. Anything else you can tell us about this data that you think is relevant.

__Please show the SQL (including DDL & DML) for your answers__
__Please use the entire dataset provided__

Please complete as much of the assignment as you have time for. How long you had time to spend on the challenge and your experience will be considered. Have some fun with it!
