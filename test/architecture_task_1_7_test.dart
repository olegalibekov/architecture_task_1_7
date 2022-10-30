import 'package:architecture_task_1_7/commands/move_command.dart';
import 'package:architecture_task_1_7/exception_handler/exception_handler.dart';
import 'package:architecture_task_1_7/exception_handler_commands/log_command.dart';
import 'package:architecture_task_1_7/exception_handler_commands/repeat_command.dart';
import 'package:architecture_task_1_7/exception_handler_commands/repeat_twice_command.dart';
import 'package:architecture_task_1_7/queue/custom_queue.dart';
import 'package:architecture_task_1_7/utils/print_overriden.dart';
import 'package:test/test.dart';

var interceptedLogs = [];

void main() {
  group('Task tests', () {
    test(
        'Check if LogCommand prints log on exception',
        Utils.overridePrint(interceptedLogs, () {
          final moveCommand = MoveCommand();
          try {
            moveCommand.execute();
          } catch (exception) {
            LogCommand(moveCommand, exception).execute();
            expect(interceptedLogs, ['Exception: Move command is not implemented']);
          }
        }));

    test('Check if ExceptionHandler sets LogCommand into commandQueue', () {
      final CustomQueue commandQueue = CustomQueue();

      final exceptionHandler = ExceptionHandler();
      exceptionHandler.setup(MoveCommand, Exception().runtimeType,
          (command, exception) => commandQueue.add(LogCommand(command, exception)));

      final command = MoveCommand();
      try {
        command.execute();
      } catch (exception) {
        exceptionHandler.handle(command, exception);
      }

      expect(commandQueue.read().whereType<LogCommand>().isNotEmpty, true);
    });

    test('Check if CommandRepeatOnce repeats command on exception', () {
      final CustomQueue commandQueue = CustomQueue()..add(MoveCommand());

      final exceptionHandler = ExceptionHandler();
      exceptionHandler.setup(MoveCommand, Exception().runtimeType,
          (command, exception) => commandQueue.add(CommandRepeatOnce(command)));

      final executedCommands = [];
      while (commandQueue.isNotEmpty) {
        final command = commandQueue.pop();
        try {
          executedCommands.add(
              command is CommandRepeatOnce ? command.command.runtimeType : command.runtimeType);

          command.execute();
        } catch (exception) {
          exceptionHandler.handle(command, exception);
        }
      }

      expect(executedCommands, [MoveCommand, MoveCommand]);
    });

    test('Check if CommandRepeatOnce exists in CustomQueue on exception', () {
      final CustomQueue commandQueue = CustomQueue()..add(MoveCommand());

      final exceptionHandler = ExceptionHandler();
      exceptionHandler.setup(MoveCommand, Exception().runtimeType,
          (command, exception) => commandQueue.add(CommandRepeatOnce(command)));

      final command = commandQueue.pop();
      try {
        command.execute();
      } catch (exception) {
        exceptionHandler.handle(command, exception);
      }

      expect(commandQueue.read().whereType<CommandRepeatOnce>().isNotEmpty, true);
    });

    test(
        'Check if command with exception reinvoked and printed exception on failure',
        Utils.overridePrint(interceptedLogs, () {
          final CustomQueue commandQueue = CustomQueue()..add(MoveCommand());

          final exceptionHandler = ExceptionHandler();
          exceptionHandler.setup(MoveCommand, Exception().runtimeType,
              (command, exception) => commandQueue.add(CommandRepeatOnce(command)));

          exceptionHandler.setup(CommandRepeatOnce, Exception().runtimeType,
              (command, exception) => commandQueue.add(LogCommand(command, exception)));

          final executedCommands = [];
          while (commandQueue.isNotEmpty) {
            final command = commandQueue.pop();
            try {
              executedCommands.add(command is CommandRepeatOnce || command is CommandRepeatTwice
                  ? command.command.runtimeType
                  : command.runtimeType);

              command.execute();
            } catch (exception) {
              exceptionHandler.handle(command, exception);
            }
          }

          expect(executedCommands, [MoveCommand, MoveCommand, LogCommand]);
          expect(interceptedLogs, ['Exception: Move command is not implemented']);
        }));

    test(
        'Check if command with exception reinvoked twice and printed exception on failure',
        Utils.overridePrint(interceptedLogs, () {
          final CustomQueue commandQueue = CustomQueue()..add(MoveCommand());

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

          final executedCommands = [];
          while (commandQueue.isNotEmpty) {
            final command = commandQueue.pop();
            try {
              executedCommands.add(command is CommandRepeatOnce || command is CommandRepeatTwice
                  ? command.command.runtimeType
                  : command.runtimeType);

              command.execute();
            } catch (exception) {
              exceptionHandler.handle(command, exception);
            }
          }

          expect(executedCommands, [MoveCommand, MoveCommand, MoveCommand, LogCommand]);
          expect(interceptedLogs, ['Exception: Move command is not implemented']);
        }));
  });
}
