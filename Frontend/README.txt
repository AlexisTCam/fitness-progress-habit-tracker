Fitness Progress and Habit Tracker Frontend
===========================================

This folder contains a beginner-friendly Flask frontend for the COP4710
database project. It connects to the existing MySQL database named my_project.

Important
---------
The SQL files were not changed. This frontend assumes the database, tables,
sample data, triggers, and views already exist in MySQL Workbench.

Files used before starting the app
----------------------------------
Run these SQL files in MySQL Workbench first:

1. Schema.sql
2. Project_Implementation/Queries/Project_Insert_Data.sql
3. Project_Implementation/Views/Project_Views.sql

If your instructor expects the implementation folder versions instead, you can
run:

1. Project_Implementation/Tables/Project_Tables.sql
2. Project_Implementation/Queries/Project_Insert_Data.sql
3. Project_Implementation/Views/Project_Views.sql

Install requirements
--------------------
Open a terminal in this Frontend folder and run:

    pip install -r requirements.txt

Update the MySQL password
-------------------------
Open app.py and find DB_CONFIG near the top of the file.

Change this line:

    "password": "YOUR_PASSWORD_HERE",

to your real MySQL root password from MySQL Workbench.

The database connection is:

    Host: localhost
    User: root
    Database: my_project

Start the Flask app
-------------------
From the Frontend folder, run:

    python app.py

Then open this address in a browser:

    http://127.0.0.1:5000

What each page demonstrates
---------------------------
Dashboard:
Shows project overview, table counts, and recent workouts using a JOIN.

Users:
Displays App_User records and inserts a new user. It also includes an optional
delete button with a cascade warning.

Workouts:
Displays workouts with user names using a JOIN. It inserts workouts, updates
workout notes, and filters by user, exercise type, or minimum calories burned.

Sleep:
Displays sleep records with user names. It inserts sleep records and filters
for low sleep quality scores.

Nutrition:
Displays Nutrition_Log totals and Nutrition_Each food entries. It inserts and
deletes food entries. The Nutrition_Log totals update automatically because of
the database triggers.

Habits:
Displays habits and habit completion records. It inserts new habits, inserts
completion logs, and filters for completed or incomplete logs.

Reports:
Shows report-style queries with joins and aggregate functions:
- total workout minutes and calories burned per user
- average sleep hours and sleep quality per user
- food category counts
- users with no habits

Views:
Displays the existing MySQL views:
- Workout_Summary
- Workout_and_Sleep_Correlation
- Gained_and_Burned_Calories

Beginner notes
--------------
Most database work happens in app.py. Each route matches one page. The HTML
files are in templates, and the design is in static/style.css.
