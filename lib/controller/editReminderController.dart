import 'package:get/get.dart';
import 'package:flutter/material.dart';

class EditReminderController extends GetxController {
  RxList<String> tags = <String>[].obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<TimeOfDay> selectedTime = TimeOfDay.now().obs;
  RxBool isDateEnabled = false.obs;
  RxBool isTimeEnabled = false.obs;
  RxInt selectedPriority = 4.obs;

  void toggleDateEnabled() {
    isDateEnabled.toggle();
  }

  void toggleTimeEnabled() {
    isTimeEnabled.toggle();
  }

  void setSelectedDate(DateTime value) {
    selectedDate.value = value;
  }

  void setSelectedTime(TimeOfDay value) {
    selectedTime.value = value;
  }

  void addTag(String tag) {
    tags.add(tag);
  }

  void removeTag(int index) {
    tags.removeAt(index);
  }
}
