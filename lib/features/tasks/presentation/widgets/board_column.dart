import 'package:flutter/material.dart';
import 'package:taskflow/core/constants/app_colors.dart';
import 'package:taskflow/core/constants/app_dimensions.dart';
import 'package:taskflow/core/utils/haptic_feedback.dart';
import 'package:taskflow/features/tasks/domain/entities/task_entity.dart';
import 'package:taskflow/features/tasks/presentation/widgets/task_card.dart';
import 'package:taskflow/shared/widgets/empty_state.dart';

/// Drag data passed between columns
class TaskDragData {
  final Task task;
  final TaskStatus sourceColumn;

  const TaskDragData({required this.task, required this.sourceColumn});
}

/// Widget displaying a column of tasks (Todo, In Progress, Done)
class BoardColumn extends StatefulWidget {
  final String title;
  final TaskStatus status;
  final List<Task> tasks;
  final void Function(int oldIndex, int newIndex)? onTaskReordered;
  final void Function(Task task, int toIndex)? onTaskMoved;
  final VoidCallback? onAddTask;

  const BoardColumn({
    super.key,
    required this.title,
    required this.status,
    required this.tasks,
    this.onTaskReordered,
    this.onTaskMoved,
    this.onAddTask,
  });

  @override
  State<BoardColumn> createState() => _BoardColumnState();
}

class _BoardColumnState extends State<BoardColumn> {
  bool _isDragOver = false;

  Color _getStatusColor() {
    switch (widget.status) {
      case TaskStatus.todo:
        return AppColors.todo;
      case TaskStatus.inProgress:
        return AppColors.inProgress;
      case TaskStatus.done:
        return AppColors.done;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<TaskDragData>(
      onWillAcceptWithDetails: (details) {
        setState(() => _isDragOver = true);
        HapticFeedbackUtil.light();
        return details.data.task.status != widget.status;
      },
      onLeave: (_) {
        setState(() => _isDragOver = false);
      },
      onAcceptWithDetails: (details) {
        setState(() => _isDragOver = false);
        HapticFeedbackUtil.medium();
        if (details.data.task.status != widget.status) {
          widget.onTaskMoved?.call(details.data.task, widget.tasks.length);
        }
      },
      builder: (context, candidateData, rejectedData) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: AppDimensions.columnWidth,
          margin: const EdgeInsets.symmetric(
            horizontal: AppDimensions.columnSpacing / 2,
          ),
          decoration: BoxDecoration(
            color: _getStatusColor(),
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
            border: Border.all(
              color: _isDragOver ? AppColors.primary : AppColors.border,
              width: _isDragOver ? 3 : 1,
            ),
            boxShadow: _isDragOver
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${widget.tasks.length}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Tasks list with reordering
              Expanded(
                child: widget.tasks.isEmpty
                    ? EmptyColumnState(
                        message: 'No tasks',
                        isDragOver: _isDragOver,
                      )
                    : ReorderableListView.builder(
                        padding: const EdgeInsets.only(
                          top: AppDimensions.paddingSmall,
                          bottom: AppDimensions.paddingLarge,
                        ),
                        itemCount: widget.tasks.length,
                        onReorder: (oldIndex, newIndex) {
                          widget.onTaskReordered?.call(oldIndex, newIndex);
                        },
                        itemBuilder: (context, index) {
                          final task = widget.tasks[index];
                          return _DraggableTaskCard(
                            key: ValueKey(task.id),
                            task: task,
                            sourceStatus: widget.status,
                            onTap: () {
                              // TODO: Show task details
                            },
                          );
                        },
                      ),
              ),

              // Add task button
              if (widget.onAddTask != null)
                Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                  child: OutlinedButton.icon(
                    onPressed: widget.onAddTask,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Task'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 40),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Draggable task card wrapper
class _DraggableTaskCard extends StatefulWidget {
  final Task task;
  final TaskStatus sourceStatus;
  final VoidCallback? onTap;

  const _DraggableTaskCard({
    super.key,
    required this.task,
    required this.sourceStatus,
    this.onTap,
  });

  @override
  State<_DraggableTaskCard> createState() => _DraggableTaskCardState();
}

class _DraggableTaskCardState extends State<_DraggableTaskCard> {
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<TaskDragData>(
      data: TaskDragData(task: widget.task, sourceColumn: widget.sourceStatus),
      feedback: Material(
        elevation: AppDimensions.cardElevationDragging,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        child: Opacity(
          opacity: 0.8,
          child: SizedBox(
            width: AppDimensions.columnWidth - 32,
            child: TaskCard(task: widget.task),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: TaskCard(task: widget.task),
      ),
      onDragStarted: () {
        setState(() => _isDragging = true);
        HapticFeedbackUtil.medium();
      },
      onDragEnd: (_) {
        setState(() => _isDragging = false);
        HapticFeedbackUtil.light();
      },
      child: TaskCard(task: widget.task, onTap: widget.onTap),
    );
  }
}
