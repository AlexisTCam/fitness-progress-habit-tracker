/*
Provides Report Queries
*/

USE my_project;

-- Average Sleep Per User, Decreasing
SELECT
u.first_name, 
u.last_name, 
round(avg(s.duration_hours), 2) AS avg_sleep_hours,
round(avg(s.quality_score), 2) AS avg_quality_score
FROM Sleep_Record s, App_User u
WHERE s.user_id = u.user_id
GROUP BY u.user_id
ORDER BY avg_sleep_hours DESC;

-- show exercise logs where user's last name ends with 'n'
SELECT 
CONCAT(u.first_name, ' ', u.last_name) AS full_name,
w.exercise_type,
w.duration_minutes, 
w.calories_burned,
w.intensity_level
FROM Workout w 
JOIN App_User u ON w.user_id = u.user_id
WHERE u.last_name LIKE '%n';

-- counts total inputs in each food category
SELECT 
ne.category,
COUNT(*) AS total_per_category
FROM Nutrition_Each ne
GROUP BY ne.category
ORDER BY total_per_category ASC;

-- find total minutes working out, sort descending
SELECT 
CONCAT(u.first_name, ' ', u.last_name) AS full_name,
SUM(w.duration_minutes) as total_minutes, 
SUM(w.calories_burned) as total_calories_burned
FROM Workout w, App_User u
WHERE w.user_id = u.user_id
GROUP BY full_name
ORDER BY total_minutes DESC;

-- show users who do not have any habits
SELECT 
CONCAT (u.first_name, ' ', u.last_name) as full_name 
FROM App_User u
LEFT JOIN Habit h ON u.user_id = h.user_id
WHERE h.user_id IS NULL;


