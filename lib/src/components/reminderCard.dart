import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plantist/src/components/modals/editReminderModal.dart';
import '../../controller/reminderController.dart';

import '../models/todo.dart';
import 'customText.dart';

class ReminderCard extends StatelessWidget {
  final Todo reminder;
  ReminderCard({Key? key, required this.reminder}) : super(key: key);
  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.blue;
      case 4:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ReminderController reminderController = Get.put(ReminderController());

    return Slidable(
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            label: 'Edit',
            icon: Icons.edit,
            backgroundColor: Colors.grey,
            onPressed: (context) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: editReminderModal(existingTodo: reminder),
                  );
                },
              );
            },
          ),
          SlidableAction(
            label: 'Delete',
            icon: Icons.delete,
            backgroundColor: Colors.red,
            onPressed: (BuildContext context) =>
                reminderController.deleteReminder(reminder.id),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () =>
                        reminderController.toggleReminderCompleted(reminder),
                    child: Container(
                      width: 30.0,
                      height: 30.0,
                      decoration: BoxDecoration(
                        color: reminder.isCompleted
                            ? _getPriorityColor(reminder.priority)
                            : _getPriorityColor(reminder.priority)
                                .withOpacity(0.3),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _getPriorityColor(reminder.priority),
                          width: 2.0,
                        ),
                      ),
                      child: reminder.isCompleted
                          ? const Icon(Icons.check, color: Colors.white)
                          : const SizedBox(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: reminder.title,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: reminder.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                        const SizedBox(height: 4),
                        CustomText(
                          text: reminder.category,
                          fontSize: 16,
                          color: Colors.black.withOpacity(0.6),
                          decoration: reminder.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (reminder.dueDate
                          .toDate()
                          .isAfter(DateTime.now())) ...[
                        CustomText(
                          text: DateFormat('dd.MM.yyyy')
                              .format(reminder.dueDate.toDate()),
                          fontSize: 16,
                          color: Colors.black.withOpacity(0.6),
                        ),
                        const SizedBox(height: 4),
                        CustomText(
                          text: DateFormat('HH:mm')
                              .format(reminder.dueDate.toDate()),
                          fontSize: 16,
                          color: Colors.red.shade300,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // This container adds the bottom border
            Container(
              height: 1,
              color: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }
}
