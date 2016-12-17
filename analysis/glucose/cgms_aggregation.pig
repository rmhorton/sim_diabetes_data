-- nohup pig cgms_aggregation.pig&

cgms = LOAD 'wasb:///epicdemo/data/sensor/glucose/*/*.csv' USING PigStorage(',','-tagFile')
	AS (file:chararray, timestamp:chararray, glucose:float);  
B = FILTER cgms BY timestamp != '"time"';  -- filter out header rows

C = FOREACH B GENERATE
        FLATTEN(STRSPLIT(file, '[\\._]')) AS (date:chararray,sensorid:chararray,csv:chararray),
        timestamp,
		glucose;

D = FOREACH C GENERATE sensorid, timestamp, glucose;
STORE D INTO 'wasb:///epicdemo/data/sensor/glucose_reformatted' USING org.apache.pig.piggybank.storage.CSVExcelStorage(',', 'NO_MULTILINE', 'WINDOWS', 'SKIP_OUTPUT_HEADER');

patient = GROUP C BY sensorid;

-- patient: {group: chararray,C: {(date: chararray,sensorid: chararray,csv: chararray,timestamp: chararray,glucose: float)}}

patient_stats = FOREACH patient {
	sum = SUM(C.glucose);
	glucose_sq = FOREACH C generate glucose * glucose;
	sumsq = SUM(glucose_sq);
	n = COUNT(C.glucose);
	avg = AVG(C.glucose);
	var = (n*sumsq - sum*sum)/(n*(n - 1));
	GENERATE group, sumsq, sum, n, sum/n AS mean, avg, var, SQRT(var) AS stdev;
};

STORE patient_stats INTO 'wasb:///epicdemo/data/sensor/glucose_stats' USING org.apache.pig.piggybank.storage.CSVExcelStorage(',', 'NO_MULTILINE', 'WINDOWS');

-- Input(s):
-- Successfully read 195486723 records from: "wasb:///epicdemo/data/sensor/glucose/*/*.csv"

-- Output(s):
-- Successfully stored 195384960 records (7044035985 bytes) in: "wasb:///epicdemo/data/sensor/glucose_reformatted"
-- Successfully stored 101246 records (4049840 bytes) in: "wasb:///epicdemo/data/sensor/glucose_stats"

