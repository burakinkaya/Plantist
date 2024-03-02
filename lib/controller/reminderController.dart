import 'package:get/get.dart';
import '../services/databaseService.dart';
import '../src/models/todo.dart';

class ReminderController extends GetxController {
  final DatabaseService _databaseService = Get.find<DatabaseService>();

  RxList<Todo> reminders = <Todo>[].obs;

  void toggleReminderCompleted(Todo reminder) {
    reminder.isCompleted = !reminder.isCompleted;
    _databaseService.updateTodo(reminder.id, reminder);
    reminders.refresh();
  }

  void deleteReminder(String reminderId) {
    _databaseService.deleteTodo(reminderId);
  }

  void updateReminder(Todo updatedReminder) {
    _databaseService.updateTodo(updatedReminder.id, updatedReminder);
  }
}
