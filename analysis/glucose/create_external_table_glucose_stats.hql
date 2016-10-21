CREATE EXTERNAL TABLE glucose_summaries (sensorid STRING, Means FLOAT, StdDev FLOAT, Min FLOAT, Max FLOAT, ValidObs INT )
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY ','
    STORED AS TEXTFILE LOCATION 'wasb:///contosohealth/data/sensor/glucose_summaries';

