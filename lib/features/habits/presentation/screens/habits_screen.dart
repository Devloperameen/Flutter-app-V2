import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:safe/core/design/app_spacing.dart';
import 'package:safe/core/utils/app_logger.dart';
import 'package:safe/features/habits/domain/constants/habit_constants.dart';
import 'package:safe/features/habits/presentation/providers/habit_actions_provider.dart';
import 'package:safe/features/habits/presentation/providers/habits_stream_provider.dart';
import 'package:safe/features/habits/presentation/widgets/color_picker.dart';
import 'package:safe/features/habits/presentation/widgets/emoji_picker.dart';
import 'package:safe/features/habits/presentation/widgets/habit_card.dart';

class HabitsScreen extends ConsumerStatefulWidget {
  const HabitsScreen({super.key});

  @override
  ConsumerState<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends ConsumerState<HabitsScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _searchController;

  String _selectedEmoji = '✨';
  String _selectedColor = '#FF6B6B';
  String _selectedCategory = 'mindfulness';
  String _searchQuery = '';
  String? _filterCategory;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _createHabit() async {
    if (_titleController.text.trim().isEmpty) {
      _showError('Please enter a habit title');
      return;
    }

    try {
      log.i('➕ Creating habit: ${_titleController.text}');
      
      await ref.read(
        createHabitActionProvider(
          title: _titleController.text.trim(),
          emoji: _selectedEmoji,
          color: _selectedColor,
          category: _selectedCategory,
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
        ).future,
      );

      log.i('✅ Habit created');

      if (mounted) {
        // Reset form
        _titleController.clear();
        _descriptionController.clear();
        _selectedEmoji = '✨';
        _selectedColor = '#FF6B6B';
        _selectedCategory = 'mindfulness';

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Habit created! 🎉')),
        );
      }
    } catch (e, st) {
      log.e('❌ Failed to create habit: $e', stackTrace: st);
      _showError('Failed to create habit');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Future<void> _completeHabit(String habitId) async {
    try {
      await ref.read(completeHabitActionProvider(habitId).future);
      log.i('✅ Habit completed');
    } catch (e, st) {
      log.e('❌ Failed to complete habit: $e', stackTrace: st);
      _showError('Failed to complete habit');
    }
  }

  Future<void> _undoHabit(String habitId) async {
    try {
      await ref.read(undoHabitActionProvider(habitId).future);
      log.i('↩️ Completion undone');
    } catch (e, st) {
      log.e('❌ Failed to undo habit: $e', stackTrace: st);
      _showError('Failed to undo habit');
    }
  }

  Future<void> _deleteHabit(String habitId) async {
    final confirmed = await _showConfirmDialog(
      'Delete Habit',
      'Are you sure you want to delete this habit?',
    );

    if (!confirmed) return;

    try {
      await ref.read(deleteHabitActionProvider(habitId).future);
      log.i('🗑️ Habit deleted');
      _showError('Habit deleted');
    } catch (e, st) {
      log.e('❌ Failed to delete habit: $e', stackTrace: st);
      _showError('Failed to delete habit');
    }
  }

  Future<void> _archiveHabit(String habitId) async {
    try {
      await ref.read(archiveHabitActionProvider(habitId).future);
      log.i('📦 Habit archived');
      _showError('Habit archived');
    } catch (e, st) {
      log.e('❌ Failed to archive habit: $e', stackTrace: st);
      _showError('Failed to archive habit');
    }
  }

  Future<bool> _showConfirmDialog(String title, String message) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    ) ??
        false;
  }

  void _showCreateDialog() {
    _titleController.clear();
    _descriptionController.clear();
    _selectedEmoji = '✨';
    _selectedColor = '#FF6B6B';
    _selectedCategory = 'mindfulness';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final theme = Theme.of(context);
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                top: AppSpacing.lg,
                bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create Habit',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),

                  // Emoji and color selection
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
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
                          },
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                            ),
                            child: Column(
                              children: [
                                Text(_selectedEmoji, style: const TextStyle(fontSize: 40)),
                                SizedBox(height: AppSpacing.xs),
                                Text('Emoji', style: theme.textTheme.labelSmall),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
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
                          },
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Color(
                                      int.parse(_selectedColor.replaceFirst('#', '0xff')),
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(height: AppSpacing.xs),
                                Text('Color', style: theme.textTheme.labelSmall),
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
                    decoration: InputDecoration(
                      labelText: 'Habit Title',
                      hintText: 'e.g., Morning Run',
                      prefixIcon: const Icon(Icons.edit_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: AppSpacing.lg),

                  // Description field
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description (optional)',
                      prefixIcon: const Icon(Icons.description_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 2,
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
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedCategory = value);
                      }
                    },
                  ),
                  SizedBox(height: AppSpacing.xl),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      SizedBox(width: AppSpacing.md),
                      FilledButton.icon(
                        onPressed: _createHabit,
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Create'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final habitsAsync = ref.watch(habitsStreamProvider);
    final completedCount = ref.watch(completedHabitsTodayProvider).length;
    final pendingCount = ref.watch(pendingHabitsTodayProvider).length;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Habits'),
        centerTitle: false,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: _showCreateDialog,
          ),
        ],
      ),
      body: habitsAsync.when(
        data: (habits) {
          // Filter habits based on search and category
          final filteredHabits = habits.where((h) {
            final matchesSearch = h.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                h.category.toLowerCase().contains(_searchQuery.toLowerCase());
            final matchesCategory = _filterCategory == null || h.category == _filterCategory;
            return matchesSearch && matchesCategory && !h.archived;
          }).toList();

          if (habits.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, size: 64, color: theme.colorScheme.tertiary.withValues(alpha: 0.5)),
                  SizedBox(height: AppSpacing.lg),
                  Text('No habits yet', style: theme.textTheme.headlineSmall),
                  SizedBox(height: AppSpacing.sm),
                  Text('Create your first habit', style: theme.textTheme.bodyMedium),
                  SizedBox(height: AppSpacing.xl),
                  FilledButton.icon(
                    onPressed: _showCreateDialog,
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Create Habit'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(habitsStreamProvider);
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
              // Progress Card
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                      theme.colorScheme.secondaryContainer.withValues(alpha: 0.3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Today's Progress", style: theme.textTheme.labelMedium),
                        SizedBox(height: AppSpacing.md),
                        Text(
                          '$completedCount/${ completedCount + pendingCount}',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: (completedCount + pendingCount) == 0
                                ? 0
                                : completedCount / (completedCount + pendingCount),
                            strokeWidth: 6,
                          ),
                          Text(
                            '${((completedCount / (completedCount + pendingCount == 0 ? 1 : completedCount + pendingCount)) * 100).round()}%',
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(),
              SizedBox(height: AppSpacing.xl),

              // Search field
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search habits',
                  prefixIcon: const Icon(Icons.search_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  setState(() => _searchQuery = value);
                },
              ),
              SizedBox(height: AppSpacing.lg),

              // Category filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // All categories chip
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: FilterChip(
                        label: const Text('All'),
                        selected: _filterCategory == null,
                        onSelected: (selected) {
                          setState(() => _filterCategory = null);
                        },
                      ),
                    ),
                    // Category chips
                    ...HabitConstants.categories.map(
                      (cat) => Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.sm),
                        child: FilterChip(
                          label: Text(HabitConstants.categoryLabels[cat]!),
                          selected: _filterCategory == cat,
                          onSelected: (selected) {
                            setState(() => _filterCategory = selected ? cat : null);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.lg),

              // Habits list
              if (filteredHabits.isEmpty)
                Center(
                  child: Text(
                    'No habits found',
                    style: theme.textTheme.bodyMedium,
                  ),
                )
              else
                ...filteredHabits.asMap().entries.map((entry) {
                  final index = entry.key;
                  final habit = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: HabitCard(
                      habit: habit,
                      onTap: () => habit.completedToday
                          ? _undoHabit(habit.id)
                          : _completeHabit(habit.id),
                      onEdit: () => context.push('/habits/edit/${habit.id}'),
                      onDelete: () => _deleteHabit(habit.id),
                      onArchive: () => _archiveHabit(habit.id),
                      onViewHistory: () {
                        context.push(
                          '/habits/calendar/${habit.id}',
                          extra: {'habit': habit},
                        );
                      },
                    ).animate(
                      delay: Duration(milliseconds: 100 + (index * 50)),
                    ),
                  );
                }),

              SizedBox(height: AppSpacing.xl),
            ],
          ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
