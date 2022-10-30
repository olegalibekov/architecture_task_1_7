import 'package:architecture_task_1_7/interfaces/command_interface.dart';

class CommandRepeatOnce implements CommandInterface {
  CommandInterface command;

  CommandRepeatOnce(this.command);

  @override
  void execute() {
    // print('CommandRepeatOnce');
    command.execute();
  }
}
