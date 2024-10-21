import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eat_better/models/preference_model.dart';


const String TO_DO_COLLECTION_REF = 'preferences';

class DatabaseService{
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _todoRef;

  DatabaseService(){
    _todoRef = _firestore.collection(TO_DO_COLLECTION_REF).withConverter<Todo>(
      fromFirestore: (snapshots , _) => Todo.fromJson(
        snapshots.data()!,
      ), 

      toFirestore: (todo, _) => todo.toJson());
  }

  Stream<QuerySnapshot> getTodos(){
    return _todoRef.snapshots();
  }

  void addTodo(Todo todo) async {
    await _todoRef.add(todo);
  }

  void updateTodo(String todoId, Todo todo) async {
    await _todoRef.doc(todoId).update(todo.toJson());
  }

  void deleteTodo(String todoId)async {
    await _todoRef.doc(todoId).delete();
  }
}