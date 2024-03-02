import 'package:flutter/material.dart';
import 'package:plantist/controller/editReminderController.dart';
import '../customText.dart';
import 'package:get/get.dart';

class EditPriorityModal extends StatelessWidget {
  final EditReminderController controller = Get.find<EditReminderController>();
  final RxInt _tempSelectedPriority = RxInt(0);

  EditPriorityModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _tempSelectedPriority.value = controller.selectedPriority.value;

    return FractionallySizedBox(
      heightFactor: 0.6,
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
                  text: 'Choose Priority',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                TextButton(
                  onPressed: () {
                    controller.selectedPriority.value =
                        _tempSelectedPriority.value;
                    Navigator.pop(context);
                  },
                  child: const CustomText(
                    text: 'OK',
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildPriorityOption(
                context, "High Priority", 1, '😱', Colors.red.shade200),
            const SizedBox(height: 16),
            _buildPriorityOption(
                context, "Medium Priority", 2, '😳', Colors.yellow.shade200),
            const SizedBox(height: 16),
            _buildPriorityOption(
                context, "Low Priority", 3, '🤓', Colors.blue.shade200),
            const SizedBox(height: 16),
            _buildPriorityOption(
                context, "No Priority", 4, '🥱', Colors.grey.shade200),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityOption(BuildContext context, String text, int priority,
      String emoji, Color color) {
    return GestureDetector(
      onTap: () => _tempSelectedPriority.value =
          priority, // Temporarily store the selected priority
      child: Obx(() => Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              border: Border.all(
                  color: _tempSelectedPriority.value == priority
                      ? Colors.blue
                      : Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CustomText(
                    text: text, fontWeight: FontWeight.w600, fontSize: 16),
                Text(emoji, style: const TextStyle(fontSize: 24)),
              ],
            ),
          )),
    );
  }
}

void showEditPriorityModal(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) => EditPriorityModal(),
  );
}
