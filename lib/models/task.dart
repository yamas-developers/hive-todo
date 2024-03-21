import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  Task(
      {required this.id,
      required this.name,
      required this.description,
      required this.createdAt,
      required this.isDone});

  @HiveField(0)
  final int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  bool isDone;

  factory Task.create({
    required String? name,
    required String? description,
    DateTime? createdAt,
  }) =>
      Task(
        id: DateTime.now().millisecondsSinceEpoch & 0xFFFFFFFF,
        name: name ?? "",
        description: description ?? "",
        isDone: false,
        createdAt: createdAt ?? DateTime.now(),
      );
}
