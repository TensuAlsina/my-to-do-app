import 'package:hive/hive.dart';

part 'todo.g.dart';


@HiveType(typeId: 0)
class Todo {
  @HiveField(0)
  final String name;
  @HiveField(1)
  bool isDone;

  Todo(this.name, this.isDone);

  void toggleDone(bool value) {
    isDone = value;
  }
}
