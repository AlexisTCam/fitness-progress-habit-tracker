/*
Provides deletion, update, and insertion statements working with the database
*/

USE my_project;

/*
Deletion Statements
*/

-- deleting user 'Alexis'
DELETE 
FROM App_User 
WHERE first_name = 'Alexis';

-- shows no instance of user
SELECT *
FROM App_User;
SELECT *
FROM Nutrition_Log;

-- Deleting a nutrition entry, shows triggers working
-- view before deletion
SELECT *
FROM Nutrition_Log nl
WHERE nl.log_id = 4;

-- deletion statement
DELETE 
FROM Nutrition_Each ne
WHERE ne.entry_id = 9; 

-- view after deletion
SELECT *
FROM Nutrition_Log nl
WHERE nl.log_id = 4;

/*
Update Statements
*/

-- update the note in the first recorded workout
UPDATE Workout w 
SET notes = 'Felt a bit tired'
WHERE workout_id = 6;

SELECT * 
FROM Workout w 
WHERE workout_id = 6; 

-- update calories burned after inputting workout
UPDATE Workout w
SET calories_burned = 102
WHERE workout_id = 2;

SELECT *
FROM Workout w 
WHERE workout_id = 2;

-- update food entry, changes total amount in log
-- before update
SELECT * 
FROM Nutrition_Log nl, Nutrition_Each ne
WHERE nl.log_id = ne.log_id
AND ne.entry_id = 5;

UPDATE Nutrition_Each ne
SET calories = 694,
	protein = 4,
    fat = 24
WHERE ne.entry_id = 5; 

-- after update
SELECT * 
FROM Nutrition_Log nl, Nutrition_Each ne
WHERE nl.log_id = ne.log_id
AND ne.entry_id = 5;

/*
Insertion Statment
*/

-- shows working insertion and trigger statements into nutrition log
-- Insert into nutrition log
SELECT *
FROM Nutrition_Log nl
WHERE nl.log_id = 4;

INSERT INTO Nutrition_Each(log_id, food_item, category, calories, protein, fat, water)
VALUES
(4, 'Potato Chips', 'Snack', 240, 2, 8, 0);

-- shows change in total calories, protein, fat and water 
SELECT *
FROM Nutrition_Log nl
WHERE nl.log_id = 4;
