import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/todo.dart';
import '../customText.dart';
import 'reminderDetailsModal.dart';

void newReminderModal(BuildContext context,
    {required Function(Todo newTodo) onTodoComplete}) {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  final size = MediaQuery.of(context).size;
  showModalBottomSheet(
    backgroundColor: Colors.white,
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const CustomText(
                      text: 'Cancel',
                      fontSize: 16,
                      color: Colors.blue,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const CustomText(
                    text: 'New Reminder',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  TextButton(
                    onPressed: () {
                      final Todo newTodo = Todo(
                        id: '',
                        title: titleController.text.trim(),
                        note: noteController.text.trim(),
                        priority: 4,
                        dueDate: Timestamp.fromDate(DateTime.now()
                            .subtract(const Duration(minutes: 1))),
                        category: categoryController.text.trim(),
                        tags: [],
                        isCompleted: false,
                      );

                      onTodoComplete(newTodo);
                      Navigator.pop(context);
                    },
                    child: const CustomText(
                      text: 'Add',
                      fontSize: 16,
                      color: Colors.blue,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              TextField(
                autofocus: true,
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Title',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              TextField(
                autofocus: true,
                controller: categoryController,
                decoration: const InputDecoration(
                  hintText: 'Category',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              TextField(
                autofocus: true,
                controller: noteController,
                decoration: const InputDecoration(
                  hintText: 'Notes',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 50),
              InkWell(
                onTap: () => showDetailsModal(context,
                    title: titleController.text,
                    note: noteController.text,
                    category: categoryController.text,
                    onTodoComplete: onTodoComplete),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CustomText(
                            text: 'Details',
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          SizedBox(height: 4),
                          CustomText(
                            text: 'Today',
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.05),
            ],
          ),
        ),
      );
    },
  );
}
