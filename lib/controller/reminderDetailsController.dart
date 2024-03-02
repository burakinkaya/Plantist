import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailsModalController extends GetxController {
  RxBool isDateEnabled = false.obs;
  RxBool isTimeEnabled = false.obs;

  late Rx<DateTime> selectedDate = DateTime.now().obs;
  late Rx<TimeOfDay> selectedTime = TimeOfDay.now().obs;

  var tags = <String>[''].obs;

  RxInt selectedPriority = 4.obs;

  void toggleDateEnabled() {
    isDateEnabled.value = !isDateEnabled.value;
  }

  void toggleTimeEnabled() {
    isTimeEnabled.value = !isTimeEnabled.value;
  }

  void setSelectedDate(DateTime value) {
    selectedDate.value = value;
  }

  void setSelectedTime(TimeOfDay value) {
    selectedTime.value = value;
  }

  void updatePriority(int priority) {
    selectedPriority.value = priority;
  }

  void addTag(String tag) {
    tags.add(tag);
  }

  void removeTag(int index) {
    tags.removeAt(index);
  }
}
