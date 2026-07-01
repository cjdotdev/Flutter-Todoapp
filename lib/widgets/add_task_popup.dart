import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cubit.dart';
import '../model/task_modal.dart';
import '../theme/appcolors.dart';
import '../theme/appfonts.dart';
import '../theme/appsizes.dart';
import '../theme/appstyles.dart';

class AddTaskPopup extends StatefulWidget {
  const AddTaskPopup({super.key});

  @override
  State<AddTaskPopup> createState() => _AddTaskPopupState();
}

class _AddTaskPopupState extends State<AddTaskPopup> {
  final _titleCtr = TextEditingController();
  final _descCtr = TextEditingController();
  bool _isTitleValid = false;

  @override
  void initState() {
    super.initState();
    _titleCtr.addListener(() {
      final valid = _titleCtr.text.trim().isNotEmpty;
      if (valid != _isTitleValid) setState(() => _isTitleValid = valid);
    });
  }

  @override
  void dispose() {
    _titleCtr.dispose();
    _descCtr.dispose();
    super.dispose();
  }

  void _save() {
    if (!_isTitleValid) return;
    final title = _titleCtr.text.trim();
    final desc = _descCtr.text.trim();
    context.read<TaskCubit>().saveTask(
          Task(title: title, description: desc.isEmpty ? null : desc),
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSizes.lg,
        right: AppSizes.lg,
        top: AppSizes.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.xl,
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
          Text('New Task', style: AppFonts.poppinsBold.copyWith(fontSize: 20)),
          const SizedBox(height: AppSizes.lg),
          TextField(
            controller: _titleCtr,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Title',
              hintText: 'What do you need to do?',
            ),
          ),
          const SizedBox(height: AppSizes.md),
          TextField(
            controller: _descCtr,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Description (optional)',
              hintText: 'Add more details...',
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _isTitleValid ? _save : null,
              style: FilledButton.styleFrom(
                padding: AppStyles.cardPadding,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
              ),
              child: Text(
                'Save Task',
                style: AppFonts.poppinsMedium.copyWith(fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
