import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
part 'task_model.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  DateTime time;

  @HiveField(3)
  bool isCompleated;

  Task({
    required this.id,
    required this.name,
    required this.time,
    required this.isCompleated,
  });
  factory Task.create({
    required String name,
    required DateTime time,
  }) {
    return Task(
      id: const Uuid().v1(),
      name: name,
      time: time,
      isCompleated: false,
    );
  }
}
