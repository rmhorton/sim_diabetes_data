Files and scripts for building predictive models.

The screenshot (MLStudio_model.png) shows the structure of the ML Studio model. The main data input file is simulated_readmission_data.csv (this would normally be replaced by a call to a SQL database source).

The file to look up the demographic statistics by zipcode (zip_grocery_convenience.zip) goes into the zip file input of an "Execute R Script" block. The code that goes in that block is in zip_grocery_convenience.R.

The Excel file (Hospital Readmission [Predictive Exp.]) calls the web service running on our demo account.
