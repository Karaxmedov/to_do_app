import 'package:hive/hive.dart';
import 'package:to_do_app/model/task_model.dart';

abstract class LocalStorage {
  Future<void> addTask({
    required Task task,
  });
  Future<Task?>? getTask({
    required String id,
  });
  Future<List<Task>> getAllTask();

  Future<bool> deleteTask({
    required Task task,
  });
  Future<void> updateTask({
    required Task task,
  });
}

class HiveLocalStorage implements LocalStorage {
  late Box<Task> _tasks;
  HiveLocalStorage() {
    _tasks = Hive.box<Task>("tasks");
  }
  @override
  Future<void> addTask({required Task task}) async {
    await _tasks.put(task.id, task);
  }

  @override
  Future<bool> deleteTask({required Task task}) async {
    task.delete();
    return true;
  }

  @override
  Future<List<Task>> getAllTask() async {
    List<Task> allTask = <Task>[];
    allTask = _tasks.values.toList();

    return allTask;
  }

  @override
  Future<Task?>? getTask({required String id}) async {
    if (_tasks.containsKey(id)) {
      return _tasks.get(id);
    } else {
      return null;
    }
  }

  @override
  Future<void> updateTask({required Task task}) {
    return task.save();
  }
}
