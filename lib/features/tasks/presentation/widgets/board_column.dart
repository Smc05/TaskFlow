import 'package:flutter/material.dart';
import 'package:taskflow/core/constants/app_colors.dart';
import 'package:taskflow/core/constants/app_dimensions.dart';
import 'package:taskflow/features/tasks/domain/entities/task_entity.dart';
import 'package:taskflow/features/tasks/presentation/widgets/task_card.dart';

/// Widget displaying a column of tasks (Todo, In Progress, Done)
class BoardColumn extends StatelessWidget {
  final String title;
  final TaskStatus status;
  final List<Task> tasks;
  final VoidCallback? onAddTask;

  const BoardColumn({
    super.key,
    required this.title,
    required this.status,
    required this.tasks,
    this.onAddTask,
  });

  Color _getStatusColor() {
    switch (status) {
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
    return Container(
      width: AppDimensions.columnWidth,
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.columnSpacing / 2,
      ),
      decoration: BoxDecoration(
        color: _getStatusColor(),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(color: AppColors.border),
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
                  title,
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
                    '${tasks.length}',
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

          // Tasks list
          Expanded(
            child: tasks.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppDimensions.paddingLarge),
                      child: Text(
                        'No tasks',
                        style: TextStyle(
                          color: AppColors.textHint,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(
                      top: AppDimensions.paddingSmall,
                      bottom: AppDimensions.paddingLarge,
                    ),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return TaskCard(
                        task: tasks[index],
                        onTap: () {
                          // TODO: Show task details
                        },
                      );
                    },
                  ),
          ),

          // Add task button
          if (onAddTask != null)
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              child: OutlinedButton.icon(
                onPressed: onAddTask,
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
  }
}
