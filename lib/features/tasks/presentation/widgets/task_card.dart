import 'package:flutter/material.dart';
import 'package:taskflow/core/constants/app_colors.dart';
import 'package:taskflow/core/constants/app_dimensions.dart';
import 'package:taskflow/features/tasks/domain/entities/task_entity.dart';

/// Widget displaying a single task card
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const TaskCard({super.key, required this.task, this.onTap, this.onLongPress});

  Color _getPriorityColor() {
    switch (task.priority) {
      case Priority.low:
        return AppColors.priorityLow;
      case Priority.medium:
        return AppColors.priorityMedium;
      case Priority.high:
        return AppColors.priorityHigh;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppDimensions.cardElevation,
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMedium,
        vertical: AppDimensions.paddingSmall,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        side: BorderSide(
          color: _getPriorityColor(),
          width: AppDimensions.taskCardBorderWidth,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                task.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // Description (if exists)
              if (task.description != null && task.description!.isNotEmpty) ...[
                const SizedBox(height: AppDimensions.spacingSmall),
                Text(
                  task.description!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              // Priority indicator
              const SizedBox(height: AppDimensions.spacingSmall),
              Row(
                children: [
                  Icon(
                    Icons.flag,
                    size: AppDimensions.iconSizeSmall,
                    color: _getPriorityColor(),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    task.priority.value.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      color: _getPriorityColor(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
