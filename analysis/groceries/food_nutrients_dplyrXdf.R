# dplyrXdf version by Seth Mottaghinejad and Ali-Kazim Zaidi, Microsoft

# Ali's note:
# Unfortunately, dplyrXdf isn’t as smart as dplyr in regrouping, especially when the xdf is piped 
# off to a mutate operation, which typically doesn’t want a grouped object. Adding an ungroup() 
# verb to the pipeline seems to fix the issues.

# devtools::install_github("Hong-Revo/dplyrXdf")
library(dplyrXdf)

food_nutrient_table_long <- read.csv("food_nutrients.csv", header=FALSE, 
	col.names=c("food", "nutrient", "quantity"), stringsAsFactors=FALSE)
grocery_table <- read.csv("grocery_sample.csv", header=FALSE, 
	col.names=c("diet_id", "item", "quantity", "units"), stringsAsFactors=FALSE)

grocery_table_xdf <- RxXdfData("grocery.xdf")
rxDataStep(grocery_table, grocery_table_xdf, overwrite = TRUE)

food_nutrient_table_long_xdf <- RxXdfData("foodnutrient.xdf")
rxDataStep(food_nutrient_table_long, food_nutrient_table_long_xdf, overwrite = TRUE)

grocery_table_xdf %>% 
  rename(food = item, quantity_bought = quantity) %>% 
  group_by(diet_id, nutrient) %>% 
  inner_join(food_nutrient_table_long_xdf, by = 'food') %>%
  ungroup() %>% 
  mutate(total_quantity = quantity * quantity_bought/100) %>% 
  group_by(diet_id, nutrient) %>% 
  summarize(quantity = sum(total_quantity)) %>%
  ungroup() %>% 
  mutate(is_carb = nutrient == 'carbs', is_energy = nutrient == 'energy',
         carb_calories = is_carb * 4.1 * quantity, calories = is_energy * quantity) %>%
  group_by(diet_id) %>%
  summarize(carb_calories = sum(carb_calories), calories = sum(calories)) %>%
  ungroup() %>% 
  mutate(pct_calories_carbs = 100*carb_calories/calories) %>%
  select(diet_id, pct_calories_carbs) -> grocery_xdf

grocery_xdf_check <- as.data.frame(grocery_xdf, stringsAsFactors=FALSE)

## compare to result from dplyr:
# grocery_check <- grocery_df %>% inner_join(grocery_xdf_check, by = "diet_id")
# all.equal(grocery_df$pct_calories_carbs, grocery_xdf_check$pct_calories_carbs) # TRUE

