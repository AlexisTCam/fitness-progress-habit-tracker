# Fitness Progress and Habit Tracker

A full-stack web application for tracking workouts, nutrition,
sleep, and daily habits.

Built with Flask, MySQL, SQL, HTML, and CSS as part of a
database systems project.

## Features

- Track workouts, nutrition, sleep, and habits
- Add, update, delete, and search records
- Generate user progress reports
- Filter workout and health data
- Automatically update nutrition totals using database triggers
- Display aggregated data using MySQL views and JOINs

## Technologies

- Python
- Flask
- MySQL
- SQL
- HTML/CSS
- MySQL Workbench

## Database Features

The database implementation includes:

- Relational tables
- Primary and foreign keys
- JOIN queries
- Aggregate queries
- Views
- Triggers
- CRUD operations

## Running the Application

1. Clone the repository.
2. Install dependencies:

   pip install -r Frontend/requirements.txt

3. Create the MySQL database using `Schema.sql`.
4. Import the provided SQL data and views.
5. Configure your local MySQL credentials in `Frontend/app.py`.
6. Run:

   python Frontend/app.py

7. Open `http://127.0.0.1:5000` in your browser.

## Project Structure

Frontend/                 Flask application and user interface
Project_Implementation/   SQL queries, tables, and views
Schema.sql                Database schema
ER_Diagram.pdf            Entity-relationship diagram
Project_Report.pdf         Project documentation
