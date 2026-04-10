import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/di/repository_providers.dart';
import '../../../core/theme/edge_theme.dart';
import '../../../data/repositories/history_repository.dart';
import '../../../data/local/app_database.dart';

/// Premium Brainy.Ai History screen
class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final Set<int> _savedIds = {};

  Future<void> _clearAllHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: EdgeTheme.surfaceColor,
        title: const Text('Purge All Data?', style: TextStyle(color: Colors.white)),
        content: const Text('This action will permanently delete all local intelligence logs.', style: TextStyle(color: EdgeTheme.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: EdgeTheme.errorRed),
            child: const Text('Purge Database'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final repo = ref.read(historyRepositoryProvider);
      await repo.clearAllHistory();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Intelligence logs purged.')),
        );
      }
    }
  }

  Future<void> _deleteEntry(int id) async {
    final repo = ref.read(historyRepositoryProvider);
    await repo.deleteHistory(id);
    setState(() {});
  }

  void _toggleSaveEntry(int id) {
    setState(() {
      if (_savedIds.contains(id)) {
        _savedIds.remove(id);
      } else {
        _savedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EdgeTheme.primaryBackground,
      appBar: AppBar(
        title: const Text('Intelligence Logs'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const FaIcon(FontAwesomeIcons.barsStaggered, size: 18),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
          ),
        ),
        actions: [
          FutureBuilder<int>(
            future: ref.read(historyRepositoryProvider).getHistoryCount(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data! == 0) return const SizedBox.shrink();
              return IconButton(
                icon: const FaIcon(FontAwesomeIcons.trashCan, size: 18, color: EdgeTheme.errorRed),
                onPressed: _clearAllHistory,
                tooltip: 'Purge All',
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: FutureBuilder<List<CorrectionHistoryData>>(
        future: ref.read(historyRepositoryProvider).getHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: EdgeTheme.lavender));
          }

          final history = snapshot.data ?? [];
          if (history.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(FontAwesomeIcons.ghost, size: 48, color: EdgeTheme.textTertiary),
                  SizedBox(height: 24),
                  Text('No Logs Found', style: TextStyle(color: EdgeTheme.textTertiary, fontSize: 18)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final entry = history[index];
              final date = DateFormat('MMM d • h:mm a').format(entry.timestamp);
              final isSaved = _savedIds.contains(entry.id);

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: EdgeTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 1),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    collapsedIconColor: EdgeTheme.textTertiary,
                    iconColor: EdgeTheme.lavender,
                    leading: Container(
                      decoration: BoxDecoration(
                        color: isSaved ? EdgeTheme.lavender.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.05),
                        shape: BoxShape.circle,
                        boxShadow: isSaved ? EdgeTheme.purpleGlow(EdgeTheme.lavender) : [],
                      ),
                      padding: const EdgeInsets.all(10),
                      child: FaIcon(
                        isSaved ? FontAwesomeIcons.solidBookmark : FontAwesomeIcons.bookmark,
                        size: 14,
                        color: isSaved ? EdgeTheme.lavender : EdgeTheme.textSecondary,
                      ),
                    ),
                    title: Text(
                      entry.originalText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      date,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: EdgeTheme.textTertiary),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: FaIcon(
                            isSaved ? FontAwesomeIcons.solidStar : FontAwesomeIcons.star,
                            size: 16,
                            color: isSaved ? EdgeTheme.lavender : EdgeTheme.textTertiary,
                          ),
                          onPressed: () => _toggleSaveEntry(entry.id),
                        ),
                        PopupMenuButton<String>(
                          icon: const FaIcon(FontAwesomeIcons.ellipsisVertical, size: 16),
                          onSelected: (value) {
                            if (value == 'delete') _deleteEntry(entry.id);
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(children: [
                                FaIcon(FontAwesomeIcons.trash, color: EdgeTheme.errorRed, size: 14),
                                SizedBox(width: 12),
                                Text('Delete Log', style: TextStyle(color: EdgeTheme.errorRed)),
                              ]),
                            ),
                          ],
                        ),
                      ],
                    ),
                    children: [
                      const Divider(height: 32, color: Colors.white10),
                      // Message Content
                      _buildBubble(
                        context,
                        label: 'USER PROBE',
                        content: entry.originalText,
                        isUser: true,
                      ),
                      const SizedBox(height: 16),
                      _buildBubble(
                        context,
                        label: 'BRAINY.AI RESPONSE',
                        content: entry.correctedText,
                        isUser: false,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBubble(BuildContext context, {required String label, required String content, required bool isUser}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isUser ? EdgeTheme.textTertiary : EdgeTheme.lavender,
                letterSpacing: 1.2,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isUser ? Colors.white.withValues(alpha: 0.03) : EdgeTheme.primaryBackground.withValues(alpha: 0.5),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isUser ? 16 : 4),
              bottomRight: Radius.circular(isUser ? 4 : 16),
            ),
            border: Border.all(
              color: isUser ? Colors.white.withValues(alpha: 0.05) : EdgeTheme.lavender.withValues(alpha: 0.1),
            ),
          ),
          child: SelectableText(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: EdgeTheme.textPrimary,
                  height: 1.5,
                ),
          ),
        ),
      ],
    );
  }
}
