import 'package:flutter/material.dart';
import 'package:safe/core/design/app_spacing.dart';
import 'package:safe/features/habits/domain/constants/habit_constants.dart';

/// Emoji picker widget for selecting habit emojis
class EmojiPicker extends StatefulWidget {

  const EmojiPicker({
    super.key,
    required this.selectedEmoji,
    required this.onEmojiSelected,
  });
  final String selectedEmoji;
  final ValueChanged<String> onEmojiSelected;

  @override
  State<EmojiPicker> createState() => _EmojiPickerState();
}

class _EmojiPickerState extends State<EmojiPicker> {
  late String _selectedEmoji;

  @override
  void initState() {
    super.initState();
    _selectedEmoji = widget.selectedEmoji;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Emoji',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'Choose an emoji to represent this habit',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        // Selected emoji display
        Container(
          margin: const EdgeInsets.all(AppSpacing.lg),
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Center(
            child: Text(
              _selectedEmoji,
              style: const TextStyle(fontSize: 72),
            ),
          ),
        ),

        // Emoji grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
            ),
            itemCount: HabitConstants.popularEmojis.length,
            itemBuilder: (context, index) {
              final emoji = HabitConstants.popularEmojis[index];
              final isSelected = emoji == _selectedEmoji;

              return GestureDetector(
                onTap: () {
                  setState(() => _selectedEmoji = emoji);
                  widget.onEmojiSelected(emoji);
                },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary.withValues(alpha: 0.2)
                        : theme.colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
                    border: Border.all(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}
