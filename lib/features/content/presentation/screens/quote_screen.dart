import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safe/features/content/domain/models/content_models.dart';
import 'package:safe/features/content/presentation/providers/content_providers.dart';

/// Quote Screen
/// Displays motivational quotes with random refresh
class QuoteScreen extends ConsumerWidget {
  const QuoteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedQuoteCategoryProvider);
    final todayQuote = ref.watch(todayQuoteProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Motivation'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
            tooltip: 'About Quotes',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),

            // Today's Featured Quote
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "✨ Today's Quote",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 16),

            todayQuote.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ),
              error: (err, stack) => Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Error loading quote: $err'),
              ),
              data: (quoteData) {
                final quote = Quote.fromJson(quoteData);
                return _buildQuoteCard(context, quote, isFeatured: true);
              },
            ),
            const SizedBox(height: 32),

            // Category filter
            _buildCategoryFilter(context, ref, selectedCategory),
            const SizedBox(height: 24),

            // Random quote section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '🎲 Random Quote',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      ref.refresh(randomQuoteProvider(selectedCategory));
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('New Quote'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Consumer(
              builder: (context, ref, _) {
                final randomQuote = ref.watch(randomQuoteProvider(selectedCategory));
                return randomQuote.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                  error: (err, stack) => Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Error: $err'),
                  ),
                  data: (quoteData) {
                    final quote = Quote.fromJson(quoteData);
                    return _buildQuoteCard(context, quote);
                  },
                );
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(
    BuildContext context,
    WidgetRef ref,
    String? selectedCategory,
  ) {
    final categories = [
      (null, 'All'),
      ('motivation', 'Motivation'),
      ('fitness', 'Fitness'),
      ('productivity', 'Productivity'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: categories.map((cat) {
          final value = cat.$1;
          final label = cat.$2;
          final isSelected = value == selectedCategory;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (_) {
                ref.read(selectedQuoteCategoryProvider.notifier).state = value;
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildQuoteCard(
    BuildContext context,
    Quote quote, {
    bool isFeatured = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: isFeatured
              ? LinearGradient(
                  colors: [
                    Colors.blue.shade50,
                    Colors.purple.shade50,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isFeatured ? null : Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isFeatured ? Colors.blue.withValues(alpha: 0.3) : Colors.grey[300]!,
            width: isFeatured ? 2 : 1,
          ),
          boxShadow: isFeatured
              ? [
                  BoxShadow(
                    color: Colors.blue.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quote icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.format_quote,
                color: Colors.blue,
                size: 24,
              ),
            ),
            const SizedBox(height: 16),

            // Quote text
            Text(
              quote.text,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                    fontWeight: isFeatured ? FontWeight.w600 : FontWeight.normal,
                  ),
            ),
            const SizedBox(height: 16),

            // Author
            Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '— ${quote.author}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Category tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
              ),
              child: Text(
                quote.category.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.copy, size: 20),
                  onPressed: () => _copyQuote(context, quote),
                  tooltip: 'Copy',
                ),
                IconButton(
                  icon: const Icon(Icons.share, size: 20),
                  onPressed: () => _shareQuote(context, quote),
                  tooltip: 'Share',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _copyQuote(BuildContext context, Quote quote) {
    Clipboard.setData(ClipboardData(
      text: '"${quote.text}" — ${quote.author}',
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Quote copied to clipboard')),
    );
  }

  void _shareQuote(BuildContext context, Quote quote) {
    // In a real app, use share_plus package
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share feature coming soon!')),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Quotes'),
        content: const Text(
          'Daily quotes are selected to inspire and motivate you on your fitness journey. '
          'A new featured quote is displayed each day for all users. '
          'Use the random button to discover more quotes from different categories.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
