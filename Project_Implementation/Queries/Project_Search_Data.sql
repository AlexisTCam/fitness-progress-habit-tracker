/*
Provides search/filter queries
*/

USE my_project;

-- shows all workouts from user_id 1
SELECT *
FROM Workout
WHERE user_id = 1; 

-- selects all rows where total calories are over 500
SELECT * 
FROM Nutrition_Log 
WHERE calories_total > 500;

-- shows all habits of user_id = 1
SELECT *
FROM Habit h 
JOIN Habit_Each he ON h.habit_id = he.habit_id
WHERE h.user_id = 1;

-- shows all logged food from user_id 2
SELECT n.log_date, ne.food_item, ne.category, ne.calories, ne.protein, ne.fat, ne.water
FROM Nutrition_Log n, Nutrition_Each ne
WHERE n.log_id = ne.log_id
AND n.user_id = 2;

-- shows names, food item, and log date for users who had "Lunch"
SELECT u.first_name, u.last_name, n.food_item, ne.log_date
FROM Nutrition_Each n, Nutrition_Log ne, App_User u
WHERE n.log_id = ne.log_id 
AND ne.user_id = u.user_id
AND n.category = "Lunch";

-- shows all users who have "self-care" habits and if it's completed
SELECT he.log_date, u.first_name, u.last_name, h.habit_name, he.completed
FROM Habit h, Habit_Each he, App_User u
WHERE h.habit_id = he.habit_id
AND h.user_id = u.user_id
AND h.habit_type = "Self-Care";

-- Shows users with a sleep record below a score of 6
-- also combines first and last name
SELECT 
CONCAT(u.first_name, ' ', u.last_name) AS full_name,
s.quality_score, 
s.duration_hours, 
s.sleep_date
FROM Sleep_Record s, App_User u
WHERE s.user_id = u.user_id
AND s.quality_score < 6;