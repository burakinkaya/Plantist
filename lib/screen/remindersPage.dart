import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/databaseService.dart';
import '../src/components/customText.dart';
import '../src/components/modals/newReminderModal.dart';
import '../src/components/reminderCard.dart';
import '../src/models/todo.dart';
import 'package:intl/intl.dart';

import 'home.dart';

class GroupedReminders {
  bool isHeader;
  String? header;
  Todo? reminder;

  GroupedReminders({this.isHeader = false, this.header, this.reminder});
}

class RemindersPage extends StatelessWidget {
  RemindersPage({Key? key}) : super(key: key);

  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  late final DatabaseService _databaseService = DatabaseService(userId);

  List<GroupedReminders> sortAndGroupReminders(List<Todo> reminders) {
    reminders.sort((a, b) {
      int compareDate = a.dueDate.compareTo(b.dueDate);
      if (compareDate == 0) {
        return a.priority.compareTo(b.priority);
      }
      return compareDate;
    });

    Map<String, List<Todo>> groupedMap = {};
    for (var reminder in reminders) {
      String formattedDate =
          DateFormat('yyyy-MM-dd').format(reminder.dueDate.toDate());
      if (!groupedMap.containsKey(formattedDate)) {
        groupedMap[formattedDate] = [];
      }
      groupedMap[formattedDate]!.add(reminder);
    }

    List<GroupedReminders> groupedRemindersList = [];
    groupedMap.forEach((date, remindersList) {
      DateTime headerDate = DateFormat('yyyy-MM-dd').parse(date);
      String headerString = getHeaderFromDate(headerDate);
      groupedRemindersList
          .add(GroupedReminders(isHeader: true, header: headerString));
      remindersList.sort((a, b) => a.priority.compareTo(b.priority));
      groupedRemindersList.addAll(remindersList
          .map((reminder) => GroupedReminders(reminder: reminder)));
    });

    return groupedRemindersList;
  }

  String getHeaderFromDate(DateTime date) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime tomorrow = DateTime(now.year, now.month, now.day + 1);

    if (date.isAtSameMomentAs(today)) {
      return 'Today';
    } else if (date.isAtSameMomentAs(tomorrow)) {
      return 'Tomorrow';
    } else {
      return DateFormat('d, MMMM').format(date); // 29, February
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const CustomText(
          text: 'Plantist',
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: false,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(bottom: kToolbarHeight + 30),
        child: StreamBuilder<List<Todo>>(
          stream: _databaseService.getTodos(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(
                child: CustomText(
                  text: 'An error has occurred!',
                  fontSize: 16,
                ),
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: CustomText(
                  text: "You don't have any reminders, create a new one!👇",
                  fontSize: 16,
                  color: Colors.grey,
                ),
              );
            }
            List<GroupedReminders> groupedReminders =
                sortAndGroupReminders(snapshot.data!);

            return ListView.builder(
              itemCount: groupedReminders.length,
              itemBuilder: (context, index) {
                final item = groupedReminders[index];
                if (item.isHeader) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        text: item.header!,
                        fontSize: 16,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                } else {
                  return ReminderCard(
                    reminder: item.reminder!,
                  );
                }
              },
            );
          },
        ),
      ),
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[900],
          foregroundColor: Colors.grey[600],
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          padding:
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 125.0),
        ),
        onPressed: () => newReminderModal(
          context,
          onTodoComplete: (newTodo) {
            _databaseService.addTodo(newTodo);
          },
        ),
        child: const CustomText(
          text: 'New Reminder',
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
