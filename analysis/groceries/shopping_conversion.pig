
grocery_table = LOAD 'wasb:///contosohealth/data/emr/shopping' USING JsonLoader('id:chararray,groceries:{(item:chararray,quantity:int,units:chararray)}');

grocery_A = FOREACH grocery_table GENERATE id, FLATTEN(groceries) 
		as (item:chararray, quantity:int, units:chararray);

grocery_csv = FOREACH (FILTER grocery_A BY quantity IS NOT NULL) GENERATE id, REPLACE(item, ',', '') as food_item, quantity, units;

STORE grocery_csv INTO 'wasb:///contosohealth/data/emr/shopping_csv' USING org.apache.pig.piggybank.storage.CSVExcelStorage(',', 'NO_MULTILINE', 'WINDOWS');
