import 'package:flutter/material.dart';

import '../theme/appcolors.dart';
import '../theme/appfonts.dart';
import '../theme/appsizes.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 80,
              color: AppColors.grey.withValues(alpha: 0.4),
            ),
            const SizedBox(height: AppSizes.lg),
            Text(
              'No tasks yet',
              style: AppFonts.poppinsMedium.copyWith(
                fontSize: 18,
                color: AppColors.greyDark,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              'Tap the + button to create\nyour first task',
              textAlign: TextAlign.center,
              style: AppFonts.interRegular.copyWith(
                fontSize: 14,
                color: AppColors.grey,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
