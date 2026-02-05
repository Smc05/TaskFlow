import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskflow/core/constants/app_colors.dart';
import 'package:taskflow/core/sync/sync_status.dart';
import 'package:taskflow/features/tasks/presentation/providers/task_repository_provider.dart';

/// Banner showing offline status
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.orange.shade700,
      child: Row(
        children: [
          const Icon(
            Icons.cloud_off,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Offline mode - Changes will sync when online',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.white,
              size: 18,
            ),
            onPressed: () {
              // Allow dismissing the banner
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

/// Banner showing sync status
class SyncStatusBanner extends ConsumerWidget {
  const SyncStatusBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnectedAsync = ref.watch(connectivityStreamProvider);
    final syncStatusAsync = ref.watch(syncStatusStreamProvider);

    return isConnectedAsync.when(
      data: (isConnected) {
        if (!isConnected) {
          return const OfflineBanner();
        }

        return syncStatusAsync.when(
          data: (syncStatus) {
            return _buildSyncStatusWidget(context, ref, syncStatus);
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildSyncStatusWidget(
    BuildContext context,
    WidgetRef ref,
    SyncStatus status,
  ) {
    switch (status.type) {
      case SyncStatusType.idle:
        return const SizedBox.shrink();
      case SyncStatusType.offline:
        return const OfflineBanner();

      case SyncStatusType.syncing:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.blue.shade600,
          child: const Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Syncing...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );

      case SyncStatusType.completed:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.green.shade600,
          child: const Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                'All changes synced',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );

      case SyncStatusType.failed:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: AppColors.error,
          child: Row(
            children: [
              const Icon(
                Icons.warning,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Sync failed: ${status.message ?? "Unknown error"}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Retry sync
                  ref.read(syncManagerProvider).syncAll();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                child: const Text('RETRY'),
              ),
            ],
          ),
        );
    }
  }
}

/// Small sync status indicator for app bar
class SyncStatusIndicator extends ConsumerWidget {
  const SyncStatusIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnectedAsync = ref.watch(connectivityStreamProvider);
    final syncStatusAsync = ref.watch(syncStatusStreamProvider);

    return isConnectedAsync.when(
      data: (isConnected) {
        if (!isConnected) {
          return const Tooltip(
            message: 'Offline',
            child: Icon(
              Icons.cloud_off,
              size: 20,
              color: Colors.orange,
            ),
          );
        }

        return syncStatusAsync.when(
          data: (syncStatus) {
            switch (syncStatus.type) {
              case SyncStatusType.idle:
                return const SizedBox.shrink();

              case SyncStatusType.offline:
                return const Tooltip(
                  message: 'Offline',
                  child: Icon(
                    Icons.cloud_off,
                    size: 20,
                    color: Colors.orange,
                  ),
                );

              case SyncStatusType.syncing:
                return const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                );

              case SyncStatusType.completed:
                return const Tooltip(
                  message: 'Synced',
                  child: Icon(
                    Icons.check_circle,
                    size: 20,
                    color: Colors.green,
                  ),
                );

              case SyncStatusType.failed:
                return Tooltip(
                  message: 'Sync failed: ${syncStatus.message}',
                  child: const Icon(
                    Icons.warning,
                    size: 20,
                    color: Colors.red,
                  ),
                );
            }
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

/// Floating action button with manual sync option
class SyncFAB extends ConsumerWidget {
  final VoidCallback? onAddTask;

  const SyncFAB({super.key, this.onAddTask});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnectedAsync = ref.watch(connectivityStreamProvider);

    return isConnectedAsync.when(
      data: (isConnected) {
        // Show sync button when offline
        if (!isConnected) {
          return FloatingActionButton(
            onPressed: () {
              // Try to sync when user explicitly requests it
              ref.read(syncManagerProvider).syncAll();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Attempting to sync...'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            tooltip: 'Sync now',
            child: const Icon(Icons.sync),
          );
        }

        // Show add button when online
        return FloatingActionButton(
          onPressed: onAddTask,
          tooltip: 'Add task',
          child: const Icon(Icons.add),
        );
      },
      loading: () => FloatingActionButton(
        onPressed: onAddTask,
        tooltip: 'Add task',
        child: const Icon(Icons.add),
      ),
      error: (_, __) => FloatingActionButton(
        onPressed: onAddTask,
        tooltip: 'Add task',
        child: const Icon(Icons.add),
      ),
    );
  }
}
