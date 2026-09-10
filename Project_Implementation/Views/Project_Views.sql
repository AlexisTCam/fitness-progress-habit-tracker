/*
Provides the creation and viewing of 3 different views
*/

USE my_project;

-- create view of a workout summary for each user
CREATE VIEW Workout_Summary AS
SELECT
	u.user_id,
    CONCAT(u.first_name, ' ', u.last_name) as full_name,
    SUM(w.duration_minutes) AS total_minutes,
    ROUND(AVG(w.calories_burned), 2) AS avg_calories_burned
FROM Workout w, App_User u
WHERE w.user_id = u.user_id
GROUP BY u.user_id;

-- view Workout_Summary
SELECT *
FROM Workout_Summary;

-- DROP VIEW Workout_Summary;

-- creates view to show correlation between workout and sleep
CREATE VIEW Workout_and_Sleep_Correlation AS
SELECT 
	CONCAT(u.first_name, ' ', u.last_name) AS full_name, 
    s.sleep_date,
    s.duration_hours,
    s.quality_score,
    w.exercise_type,
    w.duration_minutes,
    w.intensity_level,
    w.calories_burned
FROM Sleep_Record s, Workout w, App_User u
WHERE s.user_id = u.user_id
AND w.user_id = u.user_id
AND w.workout_date = s.sleep_date
ORDER BY s.quality_score DESC;

-- view Workout_and_Sleep_Correlation
SELECT *
FROM Workout_and_Sleep_Correlation;

-- DROP VIEW Workout_and_Sleep_Correlation;

-- creates view of total calories eaten in a day and burned on the same day 
CREATE VIEW Gained_and_Burned_Calories AS
SELECT
	CONCAT(u.first_name, ' ', u.last_name) AS full_name,
    w.workout_date,
    nl.calories_total,
    w.calories_burned
FROM Workout w, Nutrition_Log nl, App_User u
WHERE w.user_id = u.user_id
AND nl.user_id = u.user_id
AND w.workout_date = nl.log_date
AND w.calories_burned IS NOT NULL;

-- view Gained_and_Burned_Calories
SELECT *
FROM Gained_and_Burned_Calories;

-- DROP VIEW Gained_and_Burned_Calories;