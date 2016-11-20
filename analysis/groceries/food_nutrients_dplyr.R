# dplyr version by Seth Mottaghinejad, Microsoft

food_nutrient_table_long <- read.csv("food_nutrients.csv", header=FALSE, 
	col.names=c("food", "nutrient", "quantity"), stringsAsFactors=FALSE)
grocery_table <- read.csv("grocery_sample.csv", header=FALSE, 
	col.names=c("diet_id", "item", "quantity", "units"), stringsAsFactors=FALSE)

library(dplyr)
grocery_table %>%
  rename(food = item, quantity_bought = quantity) %>%
  inner_join(food_nutrient_table_long, by = 'food') %>%
  group_by(diet_id, nutrient) %>%
  summarize(quantity = sum(quantity * quantity_bought/100)) %>%
  group_by(diet_id) %>%
  mutate(is_carb = nutrient == 'carbs', is_energy = nutrient == 'energy') %>%
  summarize(carb_calories = sum(is_carb * 4.1 * quantity),
            calories = sum(is_energy * quantity)) %>%
  mutate(pct_calories_carbs = 100*carb_calories/calories) %>%
  select(diet_id, pct_calories_carbs) -> grocery_df

