import 'package:architecture_task_1_7/interfaces/command_interface.dart';

class MoveCommand implements CommandInterface {
  @override
  void execute() {
    throw Exception('Move command is not implemented');
  }
}
