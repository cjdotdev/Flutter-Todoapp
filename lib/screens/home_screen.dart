import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../cubit/cubit.dart';
import '../cubit/state.dart';
import '../model/task_modal.dart';
import '../theme/appcolors.dart';
import '../theme/appfonts.dart';
import '../theme/appsizes.dart';
import '../widgets/add_task_popup.dart';
import '../widgets/empty_state.dart';
import '../widgets/task_card.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDark;

  const HomeScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDark,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TaskCubit>().watchAllTasks();
  }

  void _showAddTask() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusXl)),
      ),
      builder: (_) => const AddTaskPopup(),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskCubit, TaskCubitState>(
      listener: (context, state) {
        if (state is TaskFailureState) _showError(state.message);
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'My Tasks',
              style: AppFonts.poppinsBold.copyWith(fontSize: 22),
            ),
            actions: [
              IconButton(
                onPressed: widget.onToggleTheme,
                icon: Icon(
                  widget.isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                ),
              ),
            ],
          ),
          body: _buildBody(state),
          floatingActionButton: FloatingActionButton(
            onPressed: _showAddTask,
            child: const Icon(Icons.add_rounded),
          ),
        );
      },
    );
  }

  Widget _buildBody(TaskCubitState state) {
    if (state is TaskLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is TaskFailureState) {
      return const SizedBox.shrink();
    }

    if (state is TaskMainState && state.tasks.isEmpty) {
      return const EmptyState();
    }

    if (state is TaskMainState) {
      return _buildTaskList(state.tasks);
    }

    return const SizedBox.shrink();
  }

  Widget _buildTaskList(List<Task> allTasks) {
    final active = allTasks.where((t) => !t.isCompleted).toList();
    final completed = allTasks.where((t) => t.isCompleted).toList();

    final grouped = <String, List<Task>>{};
    for (final task in active) {
      grouped.putIfAbsent(task.dateFormatee, () => []).add(task);
    }
    final sortedDates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return AnimationLimiter(
      child: ListView(
        padding: const EdgeInsets.only(top: AppSizes.sm, bottom: AppSizes.xxl),
        children: [
          for (final date in sortedDates) ...[
            _SectionHeader(
              label: 'Tasks',
              count: grouped[date]!.length,
            ),
            for (final task in grouped[date]!)
              AnimationConfiguration.staggeredList(
                position: sortedDates.indexOf(date) * 100 + grouped[date]!.indexOf(task),
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  horizontalOffset: 50,
                  child: FadeInAnimation(child: TaskCard(task: task)),
                ),
              ),
          ],
          if (completed.isNotEmpty) ...[
            _SectionHeader(
              label: 'Completed',
              count: completed.length,
              color: AppColors.success,
            ),
            for (final task in completed)
              AnimationConfiguration.staggeredList(
                position: active.length + completed.indexOf(task),
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  horizontalOffset: 50,
                  child: FadeInAnimation(child: TaskCard(task: task)),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final int count;
  final Color? color;

  const _SectionHeader({
    required this.label,
    required this.count,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.pink;
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.md, AppSizes.md, AppSizes.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label - $count',
            style: AppFonts.poppinsBold.copyWith(
              fontSize: 16,
              color: c,
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          Container(height: 2, color: c.withValues(alpha: 0.3)),
        ],
      ),
    );
  }
}
