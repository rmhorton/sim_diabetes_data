sensor_table = LOAD 'wasb:///contosohealth/data/raw/sensor/*/' USING JsonLoader('sensor_id:chararray,bt:int,e:{(t:int,n:chararray,v:int)}');

sensor_csv = FOREACH sensor_table GENERATE sensor_id, bt, FLATTEN(e) as (t:int,n:chararray,v:int);

STORE sensor_csv INTO 'wasb:///contosohealth/data/sensor/' USING org.apache.pig.piggybank.storage.CSVExcelStorage(',', 'NO_MULTILINE', 'WINDOWS');
