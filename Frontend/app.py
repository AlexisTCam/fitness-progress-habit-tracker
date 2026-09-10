from flask import Flask, flash, redirect, render_template, request, url_for
import mysql.connector
from mysql.connector import Error

app = Flask(__name__)
app.secret_key = "replace-this-with-any-random-text"

# Update the password before running the app.
DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "YOUR_PASSWORD_HERE",
    "database": "my_project",
}


def get_connection():
    return mysql.connector.connect(**DB_CONFIG)


def query_db(sql, params=None, fetch=True):
    connection = get_connection()
    cursor = connection.cursor(dictionary=True)
    try:
        cursor.execute(sql, params or ())
        if fetch:
            return cursor.fetchall()
        connection.commit()
        return None
    finally:
        cursor.close()
        connection.close()


def execute_action(sql, params=None, success_message="Action completed."):
    try:
        query_db(sql, params, fetch=False)
        flash(success_message, "success")
    except Error as error:
        flash(f"Database error: {error}", "error")


def next_id(table_name, id_column):
    rows = query_db(f"SELECT COALESCE(MAX({id_column}), 0) + 1 AS next_id FROM {table_name}")
    return rows[0]["next_id"]


def get_users():
    return query_db(
        """
        SELECT user_id, first_name, last_name, email
        FROM App_User
        ORDER BY first_name, last_name
        """
    )


@app.route("/")
def index():
    tables = [
        ("users", "App_User"),
        ("workouts", "Workout"),
        ("sleep_records", "Sleep_Record"),
        ("nutrition_logs", "Nutrition_Log"),
        ("habits", "Habit"),
        ("habit_logs", "Habit_Each"),
    ]
    counts = {}
    for key, table in tables:
        rows = query_db(f"SELECT COUNT(*) AS total FROM {table}")
        counts[key] = rows[0]["total"]

    recent_workouts = query_db(
        """
        SELECT CONCAT(u.first_name, ' ', u.last_name) AS full_name,
               w.workout_date, w.exercise_type, w.duration_minutes, w.intensity_level
        FROM Workout w
        JOIN App_User u ON w.user_id = u.user_id
        ORDER BY w.workout_date DESC, w.workout_id DESC
        LIMIT 5
        """
    )
    return render_template("index.html", counts=counts, recent_workouts=recent_workouts)


@app.route("/users", methods=["GET", "POST"])
def users():
    if request.method == "POST":
        new_user_id = next_id("App_User", "user_id")
        execute_action(
            """
            INSERT INTO App_User (user_id, first_name, last_name, email)
            VALUES (%s, %s, %s, %s)
            """,
            (
                new_user_id,
                request.form["first_name"],
                request.form["last_name"],
                request.form["email"],
            ),
            "User added.",
        )
        return redirect(url_for("users"))

    rows = query_db(
        """
        SELECT user_id, first_name, last_name, email, date_created
        FROM App_User
        ORDER BY user_id
        """
    )
    return render_template("users.html", users=rows)


@app.route("/users/<int:user_id>/delete", methods=["POST"])
def delete_user(user_id):
    execute_action(
        "DELETE FROM App_User WHERE user_id = %s",
        (user_id,),
        "User deleted. Related records may also have been removed because of cascade rules.",
    )
    return redirect(url_for("users"))


@app.route("/workouts", methods=["GET", "POST"])
def workouts():
    if request.method == "POST":
        execute_action(
            """
            INSERT INTO Workout
                (user_id, workout_date, exercise_type, duration_minutes,
                 calories_burned, intensity_level, notes)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
            """,
            (
                request.form["user_id"],
                request.form["workout_date"],
                request.form["exercise_type"],
                request.form["duration_minutes"],
                request.form.get("calories_burned") or None,
                request.form["intensity_level"],
                request.form.get("notes") or None,
            ),
            "Workout added.",
        )
        return redirect(url_for("workouts"))

    selected_user = request.args.get("user_id", "")
    exercise_type = request.args.get("exercise_type", "")
    min_calories = request.args.get("min_calories", "")

    filters = []
    params = []
    if selected_user:
        filters.append("w.user_id = %s")
        params.append(selected_user)
    if exercise_type:
        filters.append("w.exercise_type LIKE %s")
        params.append(f"%{exercise_type}%")
    if min_calories:
        filters.append("w.calories_burned >= %s")
        params.append(min_calories)

    where_clause = f"WHERE {' AND '.join(filters)}" if filters else ""
    rows = query_db(
        f"""
        SELECT w.workout_id, CONCAT(u.first_name, ' ', u.last_name) AS full_name,
               w.workout_date, w.exercise_type, w.duration_minutes,
               w.calories_burned, w.intensity_level, w.notes
        FROM Workout w
        JOIN App_User u ON w.user_id = u.user_id
        {where_clause}
        ORDER BY w.workout_date DESC, w.workout_id DESC
        """,
        params,
    )
    return render_template(
        "workouts.html",
        workouts=rows,
        users=get_users(),
        selected_user=selected_user,
        exercise_type=exercise_type,
        min_calories=min_calories,
    )


@app.route("/workouts/<int:workout_id>/notes", methods=["POST"])
def update_workout_notes(workout_id):
    execute_action(
        "UPDATE Workout SET notes = %s WHERE workout_id = %s",
        (request.form.get("notes") or None, workout_id),
        "Workout notes updated.",
    )
    return redirect(url_for("workouts"))


@app.route("/sleep", methods=["GET", "POST"])
def sleep():
    if request.method == "POST":
        execute_action(
            """
            INSERT INTO Sleep_Record (user_id, sleep_date, duration_hours, quality_score)
            VALUES (%s, %s, %s, %s)
            """,
            (
                request.form["user_id"],
                request.form["sleep_date"],
                request.form["duration_hours"],
                request.form["quality_score"],
            ),
            "Sleep record added.",
        )
        return redirect(url_for("sleep"))

    max_quality = request.args.get("max_quality", "")
    params = []
    where_clause = ""
    if max_quality:
        where_clause = "WHERE s.quality_score <= %s"
        params.append(max_quality)

    rows = query_db(
        f"""
        SELECT s.sleep_id, CONCAT(u.first_name, ' ', u.last_name) AS full_name,
               s.sleep_date, s.duration_hours, s.quality_score
        FROM Sleep_Record s
        JOIN App_User u ON s.user_id = u.user_id
        {where_clause}
        ORDER BY s.sleep_date DESC, s.sleep_id DESC
        """,
        params,
    )
    return render_template("sleep.html", sleep_records=rows, users=get_users(), max_quality=max_quality)


@app.route("/nutrition", methods=["GET", "POST"])
def nutrition():
    if request.method == "POST":
        execute_action(
            """
            INSERT INTO Nutrition_Each
                (log_id, food_item, category, calories, protein, fat, water)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
            """,
            (
                request.form["log_id"],
                request.form["food_item"],
                request.form["category"],
                request.form.get("calories") or 0,
                request.form.get("protein") or 0,
                request.form.get("fat") or 0,
                request.form.get("water") or 0,
            ),
            "Food entry added. The Nutrition_Log totals were updated by the trigger.",
        )
        return redirect(url_for("nutrition"))

    logs = query_db(
        """
        SELECT nl.log_id, CONCAT(u.first_name, ' ', u.last_name) AS full_name,
               nl.log_date, nl.calories_total, nl.protein_total, nl.fat_total, nl.water_total
        FROM Nutrition_Log nl
        JOIN App_User u ON nl.user_id = u.user_id
        ORDER BY nl.log_date DESC, nl.log_id DESC
        """
    )
    entries = query_db(
        """
        SELECT ne.entry_id, ne.log_id, CONCAT(u.first_name, ' ', u.last_name) AS full_name,
               nl.log_date, ne.food_item, ne.category, ne.calories, ne.protein, ne.fat, ne.water
        FROM Nutrition_Each ne
        JOIN Nutrition_Log nl ON ne.log_id = nl.log_id
        JOIN App_User u ON nl.user_id = u.user_id
        ORDER BY nl.log_date DESC, ne.entry_id DESC
        """
    )
    return render_template("nutrition.html", logs=logs, entries=entries)


@app.route("/nutrition/<int:entry_id>/delete", methods=["POST"])
def delete_food_entry(entry_id):
    execute_action(
        "DELETE FROM Nutrition_Each WHERE entry_id = %s",
        (entry_id,),
        "Food entry deleted. The Nutrition_Log totals were updated by the trigger.",
    )
    return redirect(url_for("nutrition"))


@app.route("/habits", methods=["GET", "POST"])
def habits():
    if request.method == "POST":
        new_habit_id = next_id("Habit", "habit_id")
        execute_action(
            """
            INSERT INTO Habit (habit_id, user_id, habit_name, habit_type, habit_description)
            VALUES (%s, %s, %s, %s, %s)
            """,
            (
                new_habit_id,
                request.form["user_id"],
                request.form["habit_name"],
                request.form["habit_type"],
                request.form.get("habit_description") or None,
            ),
            "Habit added.",
        )
        return redirect(url_for("habits"))

    completed_filter = request.args.get("completed", "")
    params = []
    where_clause = ""
    if completed_filter in ["0", "1"]:
        where_clause = "WHERE he.completed = %s"
        params.append(completed_filter)

    habit_rows = query_db(
        """
        SELECT h.habit_id, CONCAT(u.first_name, ' ', u.last_name) AS full_name,
               h.habit_name, h.habit_type, h.habit_description
        FROM Habit h
        JOIN App_User u ON h.user_id = u.user_id
        ORDER BY u.first_name, h.habit_name
        """
    )
    habit_logs = query_db(
        f"""
        SELECT he.habit_log_id, h.habit_id, CONCAT(u.first_name, ' ', u.last_name) AS full_name,
               h.habit_name, he.log_date, he.completed, he.notes
        FROM Habit_Each he
        JOIN Habit h ON he.habit_id = h.habit_id
        JOIN App_User u ON h.user_id = u.user_id
        {where_clause}
        ORDER BY he.log_date DESC, he.habit_log_id DESC
        """,
        params,
    )
    return render_template(
        "habits.html",
        habits=habit_rows,
        habit_logs=habit_logs,
        users=get_users(),
        completed_filter=completed_filter,
    )


@app.route("/habits/log", methods=["POST"])
def add_habit_log():
    completed = 1 if request.form.get("completed") == "1" else 0
    execute_action(
        """
        INSERT INTO Habit_Each (habit_id, log_date, completed, notes)
        VALUES (%s, %s, %s, %s)
        """,
        (
            request.form["habit_id"],
            request.form["log_date"],
            completed,
            request.form.get("notes") or None,
        ),
        "Habit completion log added.",
    )
    return redirect(url_for("habits"))


@app.route("/reports")
def reports():
    workout_totals = query_db(
        """
        SELECT CONCAT(u.first_name, ' ', u.last_name) AS full_name,
               COALESCE(SUM(w.duration_minutes), 0) AS total_minutes,
               COALESCE(SUM(w.calories_burned), 0) AS total_calories_burned
        FROM App_User u
        LEFT JOIN Workout w ON w.user_id = u.user_id
        GROUP BY u.user_id, full_name
        ORDER BY total_minutes DESC
        """
    )
    sleep_averages = query_db(
        """
        SELECT CONCAT(u.first_name, ' ', u.last_name) AS full_name,
               ROUND(AVG(s.duration_hours), 2) AS avg_sleep_hours,
               ROUND(AVG(s.quality_score), 2) AS avg_quality_score
        FROM App_User u
        LEFT JOIN Sleep_Record s ON s.user_id = u.user_id
        GROUP BY u.user_id, full_name
        ORDER BY avg_sleep_hours DESC
        """
    )
    food_categories = query_db(
        """
        SELECT category, COUNT(*) AS total_per_category
        FROM Nutrition_Each
        GROUP BY category
        ORDER BY total_per_category DESC, category
        """
    )
    users_without_habits = query_db(
        """
        SELECT CONCAT(u.first_name, ' ', u.last_name) AS full_name, u.email
        FROM App_User u
        LEFT JOIN Habit h ON u.user_id = h.user_id
        WHERE h.user_id IS NULL
        ORDER BY u.first_name, u.last_name
        """
    )
    return render_template(
        "reports.html",
        workout_totals=workout_totals,
        sleep_averages=sleep_averages,
        food_categories=food_categories,
        users_without_habits=users_without_habits,
    )


@app.route("/views")
def views():
    workout_summary = query_db("SELECT * FROM Workout_Summary")
    sleep_correlation = query_db("SELECT * FROM Workout_and_Sleep_Correlation")
    calories = query_db("SELECT * FROM Gained_and_Burned_Calories")
    return render_template(
        "views.html",
        workout_summary=workout_summary,
        sleep_correlation=sleep_correlation,
        calories=calories,
    )


@app.errorhandler(Error)
def handle_database_error(error):
    return render_template("base.html", database_error=error), 500


if __name__ == "__main__":
    app.run(debug=True)
