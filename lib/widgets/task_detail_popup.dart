import 'package:flutter/material.dart';

import '../model/task_modal.dart';
import '../theme/appcolors.dart';
import '../theme/appfonts.dart';
import '../theme/appsizes.dart';

void showTaskDetailPopup(BuildContext context, Task task) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusXl)),
    ),
    builder: (ctx) => _TaskDetailPopup(task: task),
  );
}

class _TaskDetailPopup extends StatelessWidget {
  final Task task;

  const _TaskDetailPopup({required this.task});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.lg,
        AppSizes.lg,
        AppSizes.lg,
        AppSizes.xxl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.greyLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          Text(
            task.title,
            style: AppFonts.poppinsBold.copyWith(fontSize: 20),
          ),
          const SizedBox(height: AppSizes.sm),
          Row(
            children: [
              Icon(Icons.calendar_today_rounded, size: AppSizes.iconSm, color: AppColors.grey),
              const SizedBox(width: AppSizes.xs),
              Text(task.dateFormatee, style: AppFonts.interRegular.copyWith(fontSize: 13, color: AppColors.grey)),
              const SizedBox(width: AppSizes.md),
              Icon(
                task.isCompleted ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                size: AppSizes.iconSm,
                color: task.isCompleted ? AppColors.success : AppColors.grey,
              ),
              const SizedBox(width: AppSizes.xs),
              Text(
                task.isCompleted ? 'Completed' : 'Pending',
                style: AppFonts.interMedium.copyWith(
                  fontSize: 13,
                  color: task.isCompleted ? AppColors.success : AppColors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          const Divider(),
          const SizedBox(height: AppSizes.md),
          Text(
            'Description',
            style: AppFonts.poppinsMedium.copyWith(fontSize: 14, color: AppColors.greyDark),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            task.description?.isNotEmpty == true ? task.description! : 'No description provided.',
            style: AppFonts.interRegular.copyWith(
              fontSize: 14,
              color: task.description?.isNotEmpty == true ? null : AppColors.grey,
              fontStyle: task.description?.isNotEmpty == true ? FontStyle.normal : FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
