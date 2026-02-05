class AppStrings {
  AppStrings._();

  // App
  static const String appName = 'TaskFlow';

  // Board
  static const String board = 'Board';
  static const String boards = 'Boards';
  static const String createBoard = 'Create Board';
  static const String boardName = 'Board Name';
  static const String boardDescription = 'Board Description';

  // Task
  static const String task = 'Task';
  static const String tasks = 'Tasks';
  static const String createTask = 'Create Task';
  static const String editTask = 'Edit Task';
  static const String deleteTask = 'Delete Task';
  static const String taskTitle = 'Task Title';
  static const String taskDescription = 'Task Description';
  static const String noTasks = 'No tasks yet';

  // Status
  static const String todo = 'Todo';
  static const String inProgress = 'In Progress';
  static const String done = 'Done';

  // Priority
  static const String priorityLow = 'Low';
  static const String priorityMedium = 'Medium';
  static const String priorityHigh = 'High';

  // Actions
  static const String add = 'Add';
  static const String create = 'Create';
  static const String edit = 'Edit';
  static const String delete = 'Delete';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String confirm = 'Confirm';

  // Sync Status
  static const String synced = 'Synced';
  static const String syncing = 'Syncing...';
  static const String offline = 'Offline';
  static const String syncFailed = 'Sync Failed';
  static const String retrySync = 'Retry Sync';

  // Errors
  static const String errorGeneric = 'Something went wrong';
  static const String errorNetwork =
      'Network error. Please check your connection.';
  static const String errorServer = 'Server error. Please try again later.';
  static const String errorCache = 'Local storage error.';
  static const String errorNoInternet = 'No internet connection';

  // Validation
  static const String fieldRequired = 'This field is required';
  static const String titleTooShort = 'Title must be at least 3 characters';
  static const String titleTooLong = 'Title must be less than 100 characters';

  // Empty States
  static const String emptyBoards = 'No boards yet. Create your first board!';
  static const String emptyTasks = 'No tasks in this column';
}
