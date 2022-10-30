import 'task_execution.dart';

void main(List<String> arguments) {
  try {
    CourseTask().run();
  } catch (e) {
    print(e);
  }
}
