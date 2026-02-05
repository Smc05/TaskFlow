import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskflow/core/constants/app_dimensions.dart';
import 'package:taskflow/features/tasks/domain/entities/task_entity.dart';
import 'package:taskflow/features/tasks/presentation/providers/tasks_notifier.dart';
import 'package:taskflow/features/tasks/presentation/widgets/board_column.dart';

/// Main board screen displaying the Kanban board
class BoardScreen extends ConsumerWidget {
  final String boardId;
  final String boardName;

  const BoardScreen({
    super.key,
    required this.boardId,
    this.boardName = 'My Board',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksByStatus = ref.watch(tasksByStatusProvider(boardId));

    return Scaffold(
      appBar: AppBar(title: Text(boardName), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.paddingLarge,
        ),
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingMedium,
          ),
          children: [
            // Todo Column
            BoardColumn(
              title: 'To Do',
              status: TaskStatus.todo,
              tasks: tasksByStatus[TaskStatus.todo] ?? [],
              onTaskReordered: (int oldIndex, int newIndex) {
                _handleReorder(ref, TaskStatus.todo, oldIndex, newIndex);
              },
              onTaskMoved: (Task task, int toIndex) {
                _handleMove(ref, task, TaskStatus.todo, toIndex);
              },
              onAddTask: () {
                // TODO: Show add task dialog
              },
            ),
            const SizedBox(width: AppDimensions.columnSpacing),

            // In Progress Column
            BoardColumn(
              title: 'In Progress',
              status: TaskStatus.inProgress,
              tasks: tasksByStatus[TaskStatus.inProgress] ?? [],
              onTaskReordered: (int oldIndex, int newIndex) {
                _handleReorder(ref, TaskStatus.inProgress, oldIndex, newIndex);
              },
              onTaskMoved: (Task task, int toIndex) {
                _handleMove(ref, task, TaskStatus.inProgress, toIndex);
              },
              onAddTask: () {
                // TODO: Show add task dialog
              },
            ),
            const SizedBox(width: AppDimensions.columnSpacing),

            // Done Column
            BoardColumn(
              title: 'Done',
              status: TaskStatus.done,
              tasks: tasksByStatus[TaskStatus.done] ?? [],
              onTaskReordered: (int oldIndex, int newIndex) {
                _handleReorder(ref, TaskStatus.done, oldIndex, newIndex);
              },
              onTaskMoved: (Task task, int toIndex) {
                _handleMove(ref, task, TaskStatus.done, toIndex);
              },
              onAddTask: () {
                // TODO: Show add task dialog
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Show add task dialog
        },
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _handleReorder(
    WidgetRef ref,
    TaskStatus status,
    int oldIndex,
    int newIndex,
  ) {
    final tasksByStatus = ref.read(tasksByStatusProvider(boardId));
    final tasks = tasksByStatus[status] ?? [];

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    if (oldIndex >= 0 && oldIndex < tasks.length) {
      final task = tasks[oldIndex];
      ref
          .read(tasksNotifierProvider(boardId).notifier)
          .reorderTask(
            taskId: task.id,
            status: status,
            oldIndex: oldIndex,
            newIndex: newIndex,
          );
    }
  }

  void _handleMove(WidgetRef ref, Task task, TaskStatus toStatus, int toIndex) {
    if (task.status != toStatus) {
      ref
          .read(tasksNotifierProvider(boardId).notifier)
          .moveTask(
            taskId: task.id,
            fromStatus: task.status,
            toStatus: toStatus,
            toIndex: toIndex,
          );
    }
  }
}
