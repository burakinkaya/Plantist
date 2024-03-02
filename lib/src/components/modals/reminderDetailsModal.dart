import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/reminderDetailsController.dart';
import '../../models/todo.dart';
import '../customText.dart';
import './priorityModal.dart';

class DetailsModal extends StatelessWidget {
  final Function(Todo todo) onTodoComplete;
  final String title;
  final String note;
  final String category;

  const DetailsModal({
    Key? key,
    required this.onTodoComplete,
    required this.title,
    required this.note,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DetailsModalController controller = Get.put(DetailsModalController());

    DateTime getCombinedDateTime() {
      final DateTime date = controller.selectedDate.value;
      final TimeOfDay time = controller.selectedTime.value;
      return DateTime(date.year, date.month, date.day, time.hour, time.minute);
    }

    void onAddPressed() async {
      final combinedDateTime = getCombinedDateTime();

      List<String> filteredTags =
          controller.tags.where((tag) => tag.isNotEmpty).toList();

      Todo newTodo = Todo(
        id: '',
        title: title,
        note: note,
        priority: controller.selectedPriority.value,
        dueDate: Timestamp.fromDate(combinedDateTime),
        category: category,
        tags: filteredTags,
        isCompleted: false,
      );

      onTodoComplete(newTodo);

      Navigator.pop(context);
    }

    Widget buildTagField(int index) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
                decoration: const InputDecoration(
                  hintText: 'Enter a tag',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
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
                    text: 'Details',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  TextButton(
                    onPressed: () {
                      onAddPressed();
                      Navigator.pop(context);
                      controller.isDateEnabled.value = false;
                      controller.isTimeEnabled.value = false;
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
                        initialDateTime: DateTime.now(),
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
                  onTap: () => showPriorityModal(context),
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

void showDetailsModal(
  BuildContext context, {
  required String title,
  required String note,
  required String category,
  required Function(Todo) onTodoComplete,
}) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (context) => DetailsModal(
      title: title,
      note: note,
      category: category,
      onTodoComplete: onTodoComplete,
    ),
  );
}
