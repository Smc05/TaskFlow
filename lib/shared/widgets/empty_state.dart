import 'package:flutter/material.dart';
import 'package:taskflow/core/constants/app_colors.dart';

/// Empty state widget for columns with no tasks
class EmptyColumnState extends StatelessWidget {
  final String message;
  final bool isDragOver;

  const EmptyColumnState({
    super.key,
    this.message = 'No tasks',
    this.isDragOver = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isDragOver ? Icons.add_circle_outline : Icons.inbox_outlined,
                key: ValueKey(isDragOver),
                size: 48,
                color: isDragOver ? AppColors.primary : AppColors.textHint,
              ),
            ),
            const SizedBox(height: 12),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: isDragOver ? AppColors.primary : AppColors.textHint,
                fontSize: 14,
                fontWeight: isDragOver ? FontWeight.w600 : FontWeight.normal,
              ),
              child: Text(isDragOver ? 'Drop task here' : message),
            ),
          ],
        ),
      ),
    );
  }
}

/// Drop indicator line shown when dragging within a column
class DropIndicator extends StatelessWidget {
  const DropIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}

/// Shimmer loading effect for tasks
class TaskLoadingShimmer extends StatefulWidget {
  const TaskLoadingShimmer({super.key});

  @override
  State<TaskLoadingShimmer> createState() => _TaskLoadingShimmerState();
}

class _TaskLoadingShimmerState extends State<TaskLoadingShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 200,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
