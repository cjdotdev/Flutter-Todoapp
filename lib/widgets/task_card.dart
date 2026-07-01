import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../cubit/cubit.dart';
import '../theme/appcolors.dart';
import '../theme/appfonts.dart';
import '../theme/appsizes.dart';
import '../model/task_modal.dart';
import 'task_detail_popup.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TaskCubit>();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.xs,
      ),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => cubit.deleteTask(task.id),
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.white,
              icon: Icons.delete_rounded,
              label: 'Delete',
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
          ],
        ),
        child: Material(
          color: task.isCompleted
              ? AppColors.success.withValues(alpha: 0.08)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            onTap: () => showTaskDetailPopup(context, task),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.sm,
                vertical: AppSizes.sm,
              ),
              child: Row(
                children: [
                  SizedBox(
                    height: AppSizes.iconLg,
                    width: AppSizes.iconLg,
                    child: Checkbox(
                      value: task.isCompleted,
                      onChanged: (_) => cubit.toggleStatus(task.id),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      ),
                      activeColor: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: AppFonts.poppinsMedium.copyWith(
                            fontSize: 15,
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: task.isCompleted
                                ? AppColors.grey
                                : null,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          task.dateFormatee,
                          style: AppFonts.interRegular.copyWith(
                            fontSize: 12,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!task.isCompleted)
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.grey,
                      size: AppSizes.iconMd,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
