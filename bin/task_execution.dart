import 'package:architecture_task_1_7/commands/move_command.dart';
import 'package:architecture_task_1_7/commands/rotate_command.dart';
import 'package:architecture_task_1_7/exception_handler/exception_handler.dart';
import 'package:architecture_task_1_7/exception_handler_commands/log_command.dart';
import 'package:architecture_task_1_7/exception_handler_commands/repeat_command.dart';
import 'package:architecture_task_1_7/exception_handler_commands/repeat_twice_command.dart';
import 'package:architecture_task_1_7/queue/custom_queue.dart';

class CourseTask {
  final CustomQueue commandQueue = CustomQueue();

  ExceptionHandler setupExceptionHandler() {
    final exceptionHandler = ExceptionHandler();

    exceptionHandler.setup(MoveCommand, Exception().runtimeType,
        (command, exception) => commandQueue.add(CommandRepeatTwice(command)));

    exceptionHandler.setup(
        CommandRepeatTwice,
        Exception().runtimeType,
        (command, exception) =>
            commandQueue.add(CommandRepeatOnce((command as CommandRepeatTwice).command)));

    exceptionHandler.setup(CommandRepeatOnce, Exception().runtimeType,
        (command, exception) => commandQueue.add(LogCommand(command, exception)));

    return exceptionHandler;
  }

  void setupCommandQueue() {
    commandQueue.addAll([MoveCommand(), RotateCommand()]);
  }

  void run() {
    setupCommandQueue();
    final exceptionHandler = setupExceptionHandler();

    while (commandQueue.isNotEmpty) {
      final command = commandQueue.pop();
      try {
        command.execute();
      } catch (exception) {
        exceptionHandler.handle(command, exception);
      }
    }
  }
}
