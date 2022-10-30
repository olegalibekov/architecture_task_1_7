import 'package:architecture_task_1_7/interfaces/command_interface.dart';

class ExceptionHandlerModel {
  final Type commandType;
  final Type exceptionType;
  final Function(CommandInterface command, Object exception) function;

  ExceptionHandlerModel(
      {required this.commandType, required this.exceptionType, required this.function});
}
