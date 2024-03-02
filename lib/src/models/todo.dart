import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Todo {
  String id;
  String title;
  String note;
  int priority;
  Timestamp dueDate;
  String category;
  List<String> tags;
  bool isCompleted;

  Todo({
    required this.id,
    required this.title,
    required this.note,
    required this.priority,
    required this.dueDate,
    required this.category,
    required this.tags,
    required this.isCompleted,
  });

  Todo.fromJson(Map<String, dynamic> json, String documentId)
      : id = documentId,
        title = json['title'] ?? '',
        note = json['note'] ?? '',
        priority = json['priority'] ?? 0,
        dueDate =
            json['dueDate'] is Timestamp ? json['dueDate'] : Timestamp.now(),
        category = json['category'] ?? '',
        tags = List<String>.from(json['tags'] ?? []),
        isCompleted = json['isCompleted'] ?? false;

  Todo copyWith({
    String? id,
    String? title,
    String? note,
    int? priority,
    Timestamp? dueDate,
    String? category,
    List<String>? tags,
    bool? isCompleted,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'note': note,
      'priority': priority,
      'dueDate': dueDate,
      'category': category,
      'tags': tags,
      'isCompleted': isCompleted,
    };
  }

  @override
  String toString() {
    return 'Todo{id: $id,title: $title, note: $note, priority: $priority, dueDate: $dueDate, category: $category, tags: $tags, isCompleted: $isCompleted}';
  }

  String get formattedDate {
    final DateTime date = dueDate.toDate();
    final DateFormat dateFormatter = DateFormat('dd.MM.yyyy');
    return dateFormatter.format(date);
  }

  String get formattedTime {
    final DateTime date = dueDate.toDate();
    final DateFormat timeFormatter = DateFormat('HH:mm');
    return timeFormatter.format(date);
  }
}
