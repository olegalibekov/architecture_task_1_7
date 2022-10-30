import 'package:architecture_task_1_7/exception_handler/exception_handler_model.dart';
import 'package:architecture_task_1_7/interfaces/command_interface.dart';
import 'package:collection/collection.dart';

class ExceptionHandler {
  final Set<ExceptionHandlerModel> _exceptionHandlerConfig = {};

  ExceptionHandler();

  void setup(
    Type commandType,
    Type exceptionType,
    Function(CommandInterface command, Object exception) function,
  ) {
    _exceptionHandlerConfig.add(ExceptionHandlerModel(
        commandType: commandType, exceptionType: exceptionType, function: function));
  }

  void handle(CommandInterface command, Object exception) {
    final exceptionHandlerObject = _exceptionHandlerConfig.firstWhereOrNull((element) =>
        element.commandType == command.runtimeType &&
        element.exceptionType == exception.runtimeType);

    if (exceptionHandlerObject != null) {
      exceptionHandlerObject.function.call(command, exception);
    }
  }
}
