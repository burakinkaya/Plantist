import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/editReminderController.dart';

import '../../../services/databaseService.dart';
import '../../models/todo.dart';
import '../customText.dart';
import 'editReminderPriorityModal.dart';

class editReminderModal extends StatelessWidget {
  final Todo existingTodo;

  const editReminderModal({
    Key? key,
    required this.existingTodo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EditReminderController controller = Get.put(EditReminderController());
    final TextEditingController titleController = TextEditingController();
    final TextEditingController noteController = TextEditingController();
    final TextEditingController categoryController = TextEditingController();

    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    late final DatabaseService _databaseService = DatabaseService(userId);

    controller.tags.assignAll(existingTodo.tags);

    Widget buildTagField(int index) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (value) {
                  var existingTags = controller.tags.toList();
                  existingTags[index] = value;
                  controller.tags.assignAll(existingTags);
                },
                decoration: InputDecoration(
                  hintText: controller.tags[index].isNotEmpty
                      ? controller.tags[index]
                      : 'Enter a tag',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                ),
                style: const TextStyle(color: Colors.black),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () => controller.removeTag(index),
            ),
          ],
        ),
      );
    }

    return FractionallySizedBox(
      heightFactor: 0.8,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
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
                    text: 'Edit Reminder',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  TextButton(
                    onPressed: () {
                      DateTime? combinedDateTime;
                      if (controller.isDateEnabled.value ||
                          controller.isTimeEnabled.value) {
                        combinedDateTime = DateTime(
                          controller.selectedDate.value.year,
                          controller.selectedDate.value.month,
                          controller.selectedDate.value.day,
                          controller.selectedTime.value.hour,
                          controller.selectedTime.value.minute,
                        );
                      }

                      Todo updatedTodo = existingTodo.copyWith(
                        title: titleController.text.isNotEmpty
                            ? titleController.text
                            : existingTodo.title,
                        note: noteController.text.isNotEmpty
                            ? noteController.text
                            : existingTodo.note,
                        category: categoryController.text.isNotEmpty
                            ? categoryController.text
                            : existingTodo.category,
                        dueDate: combinedDateTime != null
                            ? Timestamp.fromDate(combinedDateTime)
                            : existingTodo.dueDate,
                        priority: controller.selectedPriority.value,
                        tags: controller.tags.isNotEmpty
                            ? controller.tags.toList()
                            : existingTodo.tags,
                      );
                      _databaseService.updateTodo(existingTodo.id, updatedTodo);
                      Navigator.pop(context);
                    },
                    child: const CustomText(
                      text: 'Update',
                      fontSize: 16,
                      color: Colors.blue,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 2.0, horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: 'Title',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                          hintText: existingTodo.title,
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: 'Notes',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: noteController,
                        decoration: InputDecoration(
                          hintText: existingTodo.note,
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: 'Category',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: categoryController,
                        decoration: InputDecoration(
                          hintText: existingTodo.category,
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Row(
                  children: <Widget>[
                    const Icon(Icons.date_range, color: Colors.red),
                    const SizedBox(width: 16.0),
                    const CustomText(
                      text: 'Date',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    const Spacer(),
                    Obx(() => CupertinoSwitch(
                          value: controller.isDateEnabled.value,
                          onChanged: (bool value) {
                            controller.toggleDateEnabled();
                          },
                        )),
                  ],
                ),
              ),
              Obx(() {
                if (controller.isDateEnabled.value) {
                  return SizedBox(
                    height: 200,
                    child: CupertinoTheme(
                      data: const CupertinoThemeData(
                          textTheme: CupertinoTextThemeData(
                        dateTimePickerTextStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      )),
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        showDayOfWeek: true,
                        initialDateTime: existingTodo.dueDate.toDate(),
                        minimumDate:
                            DateTime.now().add(const Duration(minutes: -1)),
                        onDateTimeChanged: (DateTime newDate) {
                          controller.setSelectedDate(newDate);
                        },
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Row(
                  children: <Widget>[
                    const Icon(Icons.access_time, color: Colors.blue),
                    const SizedBox(width: 16.0),
                    const CustomText(
                      text: 'Time',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    const Spacer(),
                    Obx(() => CupertinoSwitch(
                          value: controller.isTimeEnabled.value,
                          onChanged: (bool value) {
                            controller.toggleTimeEnabled();
                          },
                        )),
                  ],
                ),
              ),
              Obx(() {
                if (controller.isTimeEnabled.value) {
                  return SizedBox(
                    height: 200,
                    child: CupertinoTheme(
                        data: const CupertinoThemeData(
                            textTheme: CupertinoTextThemeData(
                          dateTimePickerTextStyle: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        )),
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.time,
                          use24hFormat: true,
                          initialDateTime: DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                            existingTodo.dueDate.toDate().hour,
                            existingTodo.dueDate.toDate().minute,
                          ),
                          onDateTimeChanged: (DateTime dateTime) {
                            final TimeOfDay timeOfDay = TimeOfDay(
                                hour: dateTime.hour, minute: dateTime.minute);
                            controller.setSelectedTime(timeOfDay);
                          },
                        )),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
              const SizedBox(height: 16),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText(
                      text: 'Add Tags',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                      onPressed: () => controller.addTag(''),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Obx(() => Column(
                      children: List.generate(controller.tags.length,
                          (index) => buildTagField(index)),
                    )),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                  onTap: () => showEditPriorityModal(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CustomText(
                            text: 'Priority',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ],
                      ),
                      Row(children: [
                        Obx(() => CustomText(
                              text: controller.selectedPriority.value == 1
                                  ? 'High'
                                  : controller.selectedPriority.value == 2
                                      ? 'Medium'
                                      : controller.selectedPriority.value == 3
                                          ? 'Low'
                                          : controller.selectedPriority.value ==
                                                  4
                                              ? 'No'
                                              : 'None',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              fontSize: 15,
                            )),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                          size: 16,
                        ),
                      ])
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                  onTap: () async {},
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CustomText(
                            text: 'Attach a file',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ],
                      ),
                      Row(children: [
                        CustomText(
                          text: 'None',
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                        SizedBox(width: 6),
                        Icon(
                          Icons.attachment,
                          color: Colors.grey,
                          size: 18,
                        ),
                      ])
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
