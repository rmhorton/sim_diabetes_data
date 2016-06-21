# sim_diabetes_data
Simulating a large-scale semi-synthetic healthcare dataset for education and demos

This is a collection of simulations to construct a large set of data for a health care analytics use case. Starting with published anonymized data about hospital readmission rates for diabetic patients we reverse-engineered admission histories, generated fictitious personal details (names, birthdates, zipcodes, weights), and simulated a variety of additional data sources from which we can engineer analytical features. These include grocery purchases (used to estimate percentage of calories from carbohydrates in the diet), continuous blood glucose monitoring measurements (used to calculate standard deviation), and wearable vital sign sensor data (to quantify activity). We used Hive, Pig, and Microsoft R Server on an HDInsight cluster to extract the features from these large datasets, and I will collect the analysis scripts here as well.

Since there are no privacy concerns with this simulated data, it should be useful for a variety of training exercises and demonstrations that bring together demographic information, wearable sensor data, and electronic medical records to predict a medical outcome.

Simulating data for analysis is a sort of "red team/blue team" exercise, where the simulation team embeds signals in the data and the analysis team tries to find them. The various RMarkdown files describe the approaches used to generate the simulated data such that the engineered features are predictive of the outcome.
