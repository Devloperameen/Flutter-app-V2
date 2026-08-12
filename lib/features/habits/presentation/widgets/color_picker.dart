import 'package:flutter/material.dart';
import 'package:safe/core/design/app_spacing.dart';
import 'package:safe/features/habits/domain/constants/habit_constants.dart';

/// Color picker widget for selecting habit colors
class ColorPickerWidget extends StatefulWidget {

  const ColorPickerWidget({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });
  final String selectedColor;
  final ValueChanged<String> onColorSelected;

  @override
  State<ColorPickerWidget> createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  late String _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.selectedColor;
  }

  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) {
      buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
    } else if (hexString.length == 8 || hexString.length == 9) {
      buffer.write(hexString.replaceFirst('#', ''));
    }
    return Color(int.parse(buffer.toString(), radix: 16));
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
                'Select Color',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'Choose a color theme for this habit',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        // Color grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: AppSpacing.lg,
              crossAxisSpacing: AppSpacing.lg,
            ),
            itemCount: HabitConstants.colorPresets.length,
            itemBuilder: (context, index) {
              final colorKey = HabitConstants.colorPresets.keys.elementAt(index);
              final colorHex = HabitConstants.colorPresets[colorKey]!;
              final colorLabel = HabitConstants.colorLabels[colorKey]!;
              final color = _hexToColor(colorHex);
              final isSelected = colorHex == _selectedColor;

              return GestureDetector(
                onTap: () {
                  setState(() => _selectedColor = colorHex);
                  widget.onColorSelected(colorHex);
                },
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                          width: isSelected ? 3 : 2,
                        ),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: color.withValues(alpha: 0.5),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                        ],
                      ),
                      child: isSelected
                          ? Center(
                              child: Icon(
                                Icons.check_rounded,
                                color: color.computeLuminance() > 0.5
                                    ? Colors.black
                                    : Colors.white,
                                size: 32,
                              ),
                            )
                          : null,
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      colorLabel,
                      style: theme.textTheme.labelSmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
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
