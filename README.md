# Flutter Windows Task Manager

A Flutter desktop application for Windows that allows users to manage tasks locally using a SQLite database. Built with clean CRUD operations, search, filtering, and a desktop-friendly UI.

## How to Run

1. Install Flutter (make sure Windows desktop support is enabled).
2. Enable Windows desktop support (if not already enabled):
   ```
   flutter config --enable-windows-desktop
   ```
3. Get the dependencies:
   ```
   flutter pub get
   ```
4. Run the app:
   ```
   flutter run -d windows
   ```

## Database

This app uses a local **SQLite** database via the `sqflite_common_ffi` package, which enables SQLite support on Windows desktop (the standard `sqflite` package only supports mobile platforms).

The database file (`tasks.db`) is created automatically on first run and stored in the application's documents directory, so data persists across app restarts.

### Why `sqflite_common_ffi`?
- It's the recommended solution for using SQLite on Flutter desktop platforms (Windows, Linux, macOS).
- It provides the same API as `sqflite`, making the code familiar and easy to maintain.

## Features Implemented

- Add task (with validation for title, priority, and status)
- View tasks in a desktop-friendly table
- Edit task
- Delete task (with confirmation dialog)
- Search tasks (by title and description)
- Filter by status (All, Pending, In Progress, Completed)
- Filter by priority (All, Low, Medium, High)
- Dashboard summary (Total, Pending, In Progress, Completed, High Priority)
- Responsive desktop layout (adapts to window resizing)
- Light/Dark mode toggle
- Mark task as completed with one click
- Export tasks to CSV
- Error handling for database operations

## Project Structure

```
lib/
  core/
    database/
      database_helper.dart      # SQLite setup and table creation
    theme/
      theme_provider.dart        # Light/Dark mode state management
    utils/
      csv_exporter.dart          # CSV export logic
  features/
    tasks/
      models/
        task_model.dart          # Task data model
      repository/
        task_repository.dart     # Database operations (CRUD, search, filter)
      provider/
        task_provider.dart       # App state management (Provider)
      pages/
        home_screen.dart         # Main screen layout
      widget/
        task_form.dart           # Add/Edit task form
        task_list.dart           # Task table with actions
        task_summary.dart        # Dashboard summary cards
        filter_search_bar.dart   # Search and filter controls
        export_button.dart       # CSV export button
  main.dart                      # App entry point
```

## State Management

This project uses **Provider** for state management, chosen for its simplicity and clarity for an app of this scope.

## Assumptions & Known Limitations

- The app is designed exclusively for Windows desktop and has not been tested on mobile or web.
- Due dates are stored as ISO date strings and displayed in `YYYY-MM-DD` format.
- The search feature and filter feature work independently; applying a search clears the current filter selection (and vice versa) for simplicity.
- No user authentication or multi-user support — this is a single-user local task manager.
- Arabic (RTL) text is not specially formatted in the data table; text direction follows Flutter's default behavior.