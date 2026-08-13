/// String konstan aplikasi.
class AppStrings {
  const AppStrings._();

  static const String appTitle = 'Remedial Task Tracker';
  static const String homeTitle = 'My Tasks';
  static const String addTaskTitle = 'Add Task';
  static const String editTaskTitle = 'Edit Task';
  static const String searchHint = 'Search tasks...';
  static const String filterAll = 'All';
  static const String filterPending = 'Pending';
  static const String filterOverdue = 'Overdue';
  static const String filterCompleted = 'Completed';
  static const String emptySearch = 'No tasks found for "{query}".';
  static const String emptyFiltered = 'No {status} tasks found.';
  static const String emptyFilteredAll = 'No tasks found.';
  static const String filterHigh = 'High';
  static const String filterMedium = 'Medium';
  static const String filterLow = 'Low';
  static const String fieldTitle = 'Title';
  static const String fieldTitleHint = 'e.g. Complete Math Assignment';
  static const String fieldDescription = 'Description';
  static const String fieldPriority = 'Priority';
  static const String fieldDueDate = 'Due date';
  static const String actionSave = 'Save';
  static const String actionDelete = 'Delete';
  static const String actionRetry = 'Retry';
  static const String actionCancel = 'Cancel';
  static const String actionSearch = 'Search';
  static const String detailTitle = 'Task Details';
  static const String dueLabel = 'Due';
  static const String priorityLabel = 'Priority';
  static const String statusLabel = 'Status';
  static const String statusPending = 'Pending';
  static const String statusOverdue = 'Overdue';
  static const String statusCompleted = 'Completed';
  static const String statusUnknown = 'Unknown';
  static const String priorityHigh = 'High';
  static const String priorityMedium = 'Medium';
  static const String priorityLow = 'Low';
  static const String detailNotFound = 'Task not found or has been deleted.';

  static const String emptyAll = 'No tasks yet. Tap + to add one.';
  static const String loading = 'Loading tasks...';
  static const String deleteConfirm = 'Delete this task?';

  static const String errTitleRequired = 'Title is required.';
  static const String errTitleTooShort = 'Title must be at least 3 characters.';
  static const String errDueDateInPast =
      'Tenggat waktu tidak boleh di masa lalu';

  // Mode indicator strings
  static const String modeMock = 'MOCK API';
  static const String modeLive = 'LIVE API';
}
