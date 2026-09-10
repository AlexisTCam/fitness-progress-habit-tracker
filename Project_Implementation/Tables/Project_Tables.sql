/*
Creates tables and provides trigger statements
*/

USE my_project; 

-- DROP DATABASE my_project;

CREATE TABLE App_User (
	user_id INTEGER PRIMARY KEY,
	first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    email VARCHAR(40) NOT NULL UNIQUE,
    date_created DATE NOT NULL DEFAULT (CURRENT_DATE)
);

CREATE TABLE Workout (
	workout_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    user_id INTEGER NOT NULL,
    workout_date DATE NOT NULL, 
    exercise_type VARCHAR(30) NOT NULL, 
    duration_minutes INTEGER NOT NULL CHECK (duration_minutes > 0),
    calories_burned INTEGER,
    intensity_level VARCHAR(10) NOT NULL
    CHECK (intensity_level IN ('Low', 'Medium', 'High')),
    notes TEXT,
    FOREIGN KEY (user_id) REFERENCES App_User(user_id)
    ON DELETE CASCADE
);

CREATE TABLE Sleep_Record (
	sleep_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    user_id INTEGER NOT NULL,
    sleep_date DATE NOT NULL,
    duration_hours INTEGER NOT NULL CHECK (duration_hours >= 0),
    quality_score INTEGER NOT NULL CHECK (quality_score BETWEEN 1 AND 10),
    FOREIGN KEY (user_id) REFERENCES App_User(user_id)
    ON DELETE CASCADE
);

CREATE TABLE Nutrition_Log (
	log_id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL, 
    log_date DATE NOT NULL, 
    calories_total INTEGER DEFAULT 0 CHECK (calories_total >= 0),
    protein_total INTEGER DEFAULT 0 CHECK (protein_total >= 0),
    fat_total INTEGER DEFAULT 0 CHECK (fat_total >= 0),
    water_total INTEGER DEFAULT 0 CHECK (water_total >= 0),
    FOREIGN KEY (user_id) REFERENCES App_User(user_id)
    ON DELETE CASCADE,
    UNIQUE (user_id, log_date)
);

CREATE TABLE Nutrition_Each (
	entry_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    log_id INTEGER NOT NULL, 
    food_item VARCHAR(30) NOT NULL, 
    category VARCHAR(20)NOT NULL
    CHECK (category IN ('Breakfast', 'Lunch', 'Dinner', 'Snack', 'Drink', 'Other')),
    calories INTEGER CHECK (calories IS NULL OR calories >= 0),
    protein INTEGER CHECK (protein IS NULL OR protein >= 0), 
    fat INTEGER CHECK (fat IS NULL OR fat >= 0),
    water FLOAT CHECK (water IS NULL OR water >= 0),
    FOREIGN KEY (log_id) REFERENCES Nutrition_Log(log_id)
    ON DELETE CASCADE
);

CREATE TABLE Habit (
	habit_id INTEGER PRIMARY KEY, 
    user_id INTEGER NOT NULL,
    habit_name VARCHAR(30) NOT NULL, 
    habit_type VARCHAR(30) NOT NULL
    CHECK (habit_type IN ('Health', 'Self-Care')),
    habit_description VARCHAR(100), 
    FOREIGN KEY (user_id) REFERENCES App_User(user_id)
    ON DELETE CASCADE
); 

CREATE TABLE Habit_Each (
	habit_log_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    habit_id INTEGER NOT NULL, 
    log_date DATE NOT NULL,
    completed BOOLEAN NOT NULL DEFAULT FALSE, 
    notes VARCHAR(100), 
    FOREIGN KEY (habit_id) REFERENCES Habit(habit_id)
    ON DELETE CASCADE
);

-- Triggers for calories_total, protein_total, fat_total, water_total
-- Insertion:
DELIMITER //

CREATE TRIGGER after_nutrition_insert
AFTER INSERT ON Nutrition_Each
FOR EACH ROW
BEGIN
	UPDATE Nutrition_Log
    SET
		calories_total = calories_total + NEW.calories,
        protein_total = protein_total + NEW.protein,
        fat_total = fat_total + NEW.fat,
        water_total = water_total + NEW.water
	WHERE log_id = NEW.log_id;
END //

DELIMITER ;

-- Update:
DELIMITER //
	
CREATE TRIGGER after_nutrition_update
AFTER UPDATE ON Nutrition_Each
FOR EACH ROW
BEGIN
	UPDATE Nutrition_Log
    SET
		calories_total = calories_total - OLD.calories + NEW.calories,
        protein_total = protein_total - OLD.protein + NEW.protein,
        fat_total = fat_total - OLD.fat + NEW.fat,
        water_total = water_total - OLD.water + NEW.water
	WHERE log_id = NEW.log_id;
END //

DELIMITER ;

-- Delete
DELIMITER //

CREATE TRIGGER after_nutrition_delete
AFTER DELETE ON Nutrition_Each
FOR EACH ROW
BEGIN
	UPDATE Nutrition_Log
    SET
		calories_total = calories_total - OLD.calories,
        protein_total = protein_total - OLD.protein,
        fat_total = fat_total - OLD.fat,
        water_total = water_total - OLD.water
	WHERE log_id = OLD.log_id;
END //

DELIMITER ;

