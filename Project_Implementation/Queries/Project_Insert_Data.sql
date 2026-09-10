/*
Inserts data into tables
*/

USE my_project;

INSERT INTO App_User (user_id, first_name, last_name, email)
VALUES 
(1, 'Alexis', 'Cameron', 'alexis@gmail.com'),
(2, 'John', 'Taylor', 'john@gmail.com'), 
(3, 'Myers', 'Hoffman', 'myers@outlook.com'), 
(4, 'Ella', 'Lambert', 'ella@hotmail.com'), 
(5, 'Lori', 'Taylor', 'lori@gmail.com'); 

-- going to have varied data: active, moderate, light, vary

INSERT INTO Nutrition_Log (log_id, user_id, log_date)
VALUES
(1, 1, '2026-04-21'), 
(2, 1, '2026-04-22'), 
(3, 1, '2026-04-23'),
(4, 2, '2026-04-23'),
(5, 2, '2026-04-24'), 
(6, 3, '2026-04-01'), 
(7, 3, '2026-04-05'),
(8, 4, '2026-03-28'), 
(9, 5, '2026-02-11'), 
(10, 5, '2026-04-24');

INSERT INTO Nutrition_Each (log_id, food_item, category, calories, protein, fat, water)
VALUES
-- User 1, Day 1
(1, 'Chicken Breast', 'Dinner', 300, 40, 10, 0), 
(1, 'Water', 'Drink', 0, 0, 0, 16),

-- User 1, Day 2
(2, 'Eggs and Toast', 'Breakfast', 450, 20, 5, 0), 
(2, 'Water', 'Drink', 0, 0, 0, 8), 
(2, 'Turkey Sandwich', 'Lunch', 500, 15, 10, 0), 

-- User 1, Day 3
(3, 'Twix', 'Snack', 250, 0, 0, 0), 
(3, 'Pasta Salad', 'Lunch', 300, 15, 10, 0), 
(3, 'Water', 'Drink', 0, 0, 0, 20),

-- User 2, Day 1
(4, 'Pancakes', 'Breakfast', 600, 5, 5, 0), 
(4, 'Coffee', 'Drink', 200, 0, 0, 0), 
(4, 'Chips', 'Snack', 300, 0, 10, 0), 

-- User 2, Day 2
(5, 'Meatball Sub', 'Lunch', 600, 20, 10, 0),
(5, 'Water', 'Drink', 0, 0, 0, 20), 
(5, 'Ice Cream', 'Snack', 300, 10, 20, 0), 
(5, 'Spaghetti', 'Dinner', 500, 15, 5, 0), 

-- User 3, Day 1
(6, 'Bacon', 'Breakfast', 200, 20, 15, 0), 
(6, 'Apple', 'Snack', 100, 0, 0, 0), 
(6, 'Sprite', 'Drink', 240, 0, 0, 0), 
(6, 'Pizza', 'Dinner', 550, 10, 10, 0), 

-- User 3, Day 2
(7, 'Cheese and Crackers', 'Snack', 305, 5, 5, 0), 
(7, 'Chicken Lo Mein', 'Lunch', 630, 15, 7, 0), 

-- User 4, Day 1
(8, 'Doritos', 'Snack', 450, 0, 3, 0), 
(8, 'Monster Energy Drink', 'Drink', 250, 0, 0, 0), 
(8, 'Pepperoni Pizza', 'Dinner', 1050, 10, 20, 0), 

-- User 5, Day 1
(9, 'Decaf Coffee', 'Drink', 100, 0, 0, 0), 
(9, 'Cheese Pastry', 'Snack', 200, 2, 5, 0), 

-- User 5 Day 2
(10, 'Cottage Cheese and Eggs', 'Breakfast', 260, 25, 5, 0), 
(10, 'Steak', 'Dinner', 500, 45, 5, 0),
(10, 'Water', 'Drink', 0, 0, 0, 30);

INSERT INTO Workout (user_id, workout_date, exercise_type, duration_minutes, calories_burned, intensity_level, notes)
VALUES
(1, '2026-04-21', 'Running', 30, 250, 'High', 'Felt good, not tired'), 
(1, '2026-04-21', 'Weightlifting', 60, NULL, 'Medium', NULL), 
(2, '2026-04-21', 'Tennis', 120, 300, 'High', 'Outdoors, very hot'), 
(2, '2026-04-22', 'Soccer', 100, NULL, 'Medium', NULL),
(3, '2026-04-01', 'Pickleball', 30, NULL, 'Medium', NULL), 
(4, '2026-03-28', 'Walking', 150, 200, 'Low', 'Walked the local park'), 
(5, '2026-02-11', 'Stairmaster', 40, 300, 'High', 'Did intervals, 6-9 intensity');

INSERT INTO Habit(habit_id, user_id, habit_name, habit_type, habit_description)
VALUES 
-- User 1
(1, 1, 'Take Vitamins', 'Health', 'Need to do every day'), 
(2, 1, 'Wash Face Morning and Night', 'Self-Care', NULL), 

-- User 2
(3, 2, 'Smoking', 'Health', 'Only periodically'), 
(4, 2, 'Biting Nails', 'Health', NULL), 

-- omitting user 3 to show its not required

-- User 4
(5, 4, 'Makeup in the Mornings', 'Self-Care', NULL), 

-- User 5
(6, 5, 'Take Medication', 'Health', NULL), 
(7, 5, 'Doomscrolling on Phone', 'Self-Care', 'Trying to stop');

INSERT INTO Habit_Each(habit_id, log_date, completed, notes)
VALUES
-- Habit 1: (User 1: Take Vitamins)
(1, '2026-04-21', TRUE, NULL), 
(1, '2026-04-22', FALSE, 'Put a reminder for next time'), 
(1, '2026-04-23', TRUE, NULL), 

-- Habit 2: (User 1: Wash Face Morning)
(2, '2026-04-21', FALSE, NULL), 
(2, '2026-04-22', TRUE, NULL), 

-- Habit 3: (User 2: Smoking)
(3, '2026-04-21', TRUE, "Half a pack smoked, hard day"), 

-- Habit 4 (User 2,: Biting Nails)
(4, '2026-04-21', TRUE, NULL), 
(4, '2026-04-22', TRUE, NULL), 

-- Habit 5: (User 4: Makeup in Mornings)
(5, '2026-03-28', TRUE, 'Did a whole face of makeup'), 

-- Habit 6: (User 5: Take Medication)
(6, '2026-02-11', TRUE, NULL), 
(6, '2026-04-24', TRUE, NULL), 

-- Habit  7: (User 5: Doomscrolling)
(7, '2026-02-11', TRUE, NULL);

INSERT INTO Sleep_Record(user_id, sleep_date, duration_hours, quality_score)
VALUES 
(1, '2026-04-21', 8, 7),
(1, '2026-04-22', 5, 2),
(1, '2026-04-23', 10, 9),
(2, '2026-04-21', 7, 8), 
(2, '2026-04-22', 7, 7), 
(3, '2026-04-01', 2, 1), 
(3, '2026-04-05', 12, 7), 
(4, '2026-03-28', 6, 4), 
(5, '2026-02-11', 4, 4), 
(5, '2026-04-24', 10, 8);





