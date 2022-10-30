import 'package:architecture_task_1_7/interfaces/command_interface.dart';

class LogCommand extends CommandInterface {
  final CommandInterface command;
  final Object exception;

  LogCommand(this.command, this.exception);

  @override
  void execute() => print(exception);
}
