import 'package:cloud_firestore/cloud_firestore.dart';
import '../src/models/todo.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference<Todo> _todoappRef;

  DatabaseService(String userId) {
    _todoappRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('todoapp')
        .withConverter<Todo>(
          fromFirestore: (snapshot, _) =>
              Todo.fromJson(snapshot.data()!, snapshot.id),
          toFirestore: (todo, _) => todo.toJson(),
        );
  }

  Stream<List<Todo>> getTodos() {
    return _todoappRef
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<String> addTodoAndGetId(Todo todo) async {
    DocumentReference<Todo> ref = await _todoappRef.add(todo);
    return ref.id;
  }

  Future<void> addTodo(Todo todo) {
    return _todoappRef.add(todo);
  }

  Future<void> updateTodo(String id, Todo todo) {
    return _todoappRef.doc(id).update(todo.toJson());
  }

  Future<void> deleteTodo(String id) {
    return _todoappRef.doc(id).delete();
  }
}
