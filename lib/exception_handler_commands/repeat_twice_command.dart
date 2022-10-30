import 'package:architecture_task_1_7/interfaces/command_interface.dart';

class CommandRepeatTwice implements CommandInterface {
  CommandInterface command;

  CommandRepeatTwice(this.command);

  @override
  void execute() {
    // print('CommandRepeatTwice');
    command.execute();
  }
}
