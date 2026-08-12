import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:safe/core/design/app_colors.dart';
import 'package:safe/core/design/app_spacing.dart';
import 'package:safe/core/utils/app_logger.dart';
import 'package:safe/features/auth/data/repositories/auth_repository.dart';
import 'package:safe/features/habits/data/repositories/habit_repository.dart';
import 'package:safe/features/habits/domain/constants/habit_constants.dart';
import 'package:safe/features/habits/domain/models/habit.dart';
import 'package:safe/features/habits/presentation/widgets/color_picker.dart';
import 'package:safe/features/habits/presentation/widgets/emoji_picker.dart';

class EditHabitScreen extends ConsumerStatefulWidget {

  const EditHabitScreen({
    super.key,
    required this.habitId,
  });
  final String habitId;

  @override
  ConsumerState<EditHabitScreen> createState() => _EditHabitScreenState();
}

class _EditHabitScreenState extends ConsumerState<EditHabitScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _targetMinutesController;

  late String _selectedEmoji;
  late String _selectedColor;
  late String _selectedCategory;
  late bool _reminderEnabled;
  late String? _reminderTime;

  Habit? _habit;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _targetMinutesController = TextEditingController();
    _loadHabit();
  }

  Future<void> _loadHabit() async {
    try {
      final userId = ref.read(authRepositoryProvider).getCurrentUserId();
      if (userId == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'User not authenticated';
        });
        return;
      }

      final repository = ref.read(habitRepositoryProvider);
      final habit = await repository.getHabit(userId, widget.habitId);

      setState(() {
        _habit = habit;
        _titleController.text = habit.title;
        _descriptionController.text = habit.description ?? '';
        _selectedEmoji = habit.emoji;
        _selectedColor = habit.color;
        _selectedCategory = habit.category;
        _reminderEnabled = habit.reminderEnabled;
        _reminderTime = habit.reminderTime;
        _targetMinutesController.text = habit.targetMinutes.toString();
        _isLoading = false;
      });
    } catch (e, st) {
      log.e('❌ Failed to load habit: $e', stackTrace: st);
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load habit. Please try again.';
      });
    }
  }

  Future<void> _saveHabit() async {
    // Validation
    if (_titleController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Title is required');
      return;
    }

    if (_titleController.text.trim().length > HabitConstants.maxTitleLength) {
      setState(() => _errorMessage = 'Title is too long');
      return;
    }

    if (_descriptionController.text.length > HabitConstants.maxDescriptionLength) {
      setState(() => _errorMessage = 'Description is too long');
      return;
    }

    setState(() => _isSaving = true);

    try {
      final userId = ref.read(authRepositoryProvider).getCurrentUserId();
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final updatedHabit = _habit!.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        emoji: _selectedEmoji,
        color: _selectedColor,
        category: _selectedCategory,
        reminderEnabled: _reminderEnabled,
        reminderTime: _reminderEnabled ? _reminderTime : null,
        targetMinutes: int.tryParse(_targetMinutesController.text) ?? 0,
        updatedAt: DateTime.now(),
      );

      final repository = ref.read(habitRepositoryProvider);
      await repository.updateHabit(userId, updatedHabit);

      log.i('✅ Habit updated: ${updatedHabit.title}');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Habit updated successfully!')),
        );
        context.pop();
      }
    } catch (e, st) {
      log.e('❌ Failed to update habit: $e', stackTrace: st);
      setState(() {
        _isSaving = false;
        _errorMessage = 'Failed to update habit. Please try again.';
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _targetMinutesController.dispose();
    super.dispose();
  }

  void _showEmojiPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        child: EmojiPicker(
          selectedEmoji: _selectedEmoji,
          onEmojiSelected: (emoji) {
            setState(() => _selectedEmoji = emoji);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _showColorPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        child: ColorPickerWidget(
          selectedColor: _selectedColor,
          onColorSelected: (color) {
            setState(() => _selectedColor = color);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Habit')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_habit == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Habit')),
        body: Center(
          child: Text(_errorMessage ?? 'Habit not found'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Habit'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Error message
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),
                ],

                // Emoji and color selector row
                Row(
                  children: [
                    // Emoji selector
                    Expanded(
                      child: GestureDetector(
                        onTap: _showEmojiPicker,
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                            border: Border.all(
                              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                _selectedEmoji,
                                style: const TextStyle(fontSize: 48),
                              ),
                              SizedBox(height: AppSpacing.xs),
                              Text(
                                'Emoji',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSpacing.lg),

                    // Color selector
                    Expanded(
                      child: GestureDetector(
                        onTap: _showColorPicker,
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                            border: Border.all(
                              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Color(
                                    int.parse(
                                      _selectedColor.replaceFirst('#', '0xff'),
                                    ),
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(
                                        int.parse(
                                          _selectedColor.replaceFirst('#', '0xff'),
                                        ),
                                      ).withValues(alpha: 0.3),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: AppSpacing.xs),
                              Text(
                                'Color',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppSpacing.lg),

                // Title field
                TextField(
                  controller: _titleController,
                  enabled: !_isSaving,
                  decoration: InputDecoration(
                    labelText: 'Habit Title',
                    prefixIcon: const Icon(Icons.edit_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLength: HabitConstants.maxTitleLength,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: AppSpacing.lg),

                // Description field
                TextField(
                  controller: _descriptionController,
                  enabled: !_isSaving,
                  decoration: InputDecoration(
                    labelText: 'Description (optional)',
                    prefixIcon: const Icon(Icons.description_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 3,
                  maxLength: HabitConstants.maxDescriptionLength,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: AppSpacing.lg),

                // Category dropdown
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    prefixIcon: const Icon(Icons.category_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: HabitConstants.categories
                      .map(
                        (cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(HabitConstants.categoryLabels[cat]!),
                        ),
                      )
                      .toList(),
                  onChanged: _isSaving ? null : (value) {
                    if (value != null) {
                      setState(() => _selectedCategory = value);
                    }
                  },
                ),
                SizedBox(height: AppSpacing.lg),

                // Target minutes field
                TextField(
                  controller: _targetMinutesController,
                  enabled: !_isSaving,
                  decoration: InputDecoration(
                    labelText: 'Target Minutes (optional)',
                    hintText: '0 = no time target',
                    prefixIcon: const Icon(Icons.schedule_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: AppSpacing.lg),

                // Reminder toggle
                SwitchListTile(
                  value: _reminderEnabled,
                  onChanged: _isSaving ? null : (value) {
                    setState(() => _reminderEnabled = value);
                  },
                  title: const Text('Enable Reminder'),
                  contentPadding: EdgeInsets.zero,
                ),

                // Reminder time dropdown
                if (_reminderEnabled) ...[
                  SizedBox(height: AppSpacing.lg),
                  DropdownButtonFormField<String>(
                    initialValue: _reminderTime,
                    decoration: InputDecoration(
                      labelText: 'Reminder Time',
                      prefixIcon: const Icon(Icons.access_time_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: HabitConstants.reminderTimes
                        .map(
                          (time) => DropdownMenuItem(
                            value: time,
                            child: Text(time),
                          ),
                        )
                        .toList(),
                    onChanged: _isSaving ? null : (value) {
                      if (value != null) {
                        setState(() => _reminderTime = value);
                      }
                    },
                  ),
                ],

                SizedBox(height: AppSpacing.xl),

                // Save button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveHabit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primarySeed,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey,
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Save Changes',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
