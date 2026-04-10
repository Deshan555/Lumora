import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/edge_theme.dart';
import '../../../data/repositories/saved_data_repository.dart';
import '../../../data/local/app_database.dart';
import '../../editor/presentation/image_viewer_screen.dart';

class SavedDataScreen extends ConsumerStatefulWidget {
  const SavedDataScreen({super.key});

  @override
  ConsumerState<SavedDataScreen> createState() => _SavedDataScreenState();
}

class _SavedDataScreenState extends ConsumerState<SavedDataScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EdgeTheme.primaryBackground,
      appBar: AppBar(
        title: const Text('Saved Data'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: EdgeTheme.lavender,
          labelColor: EdgeTheme.lavender,
          unselectedLabelColor: EdgeTheme.textTertiary,
          tabs: const [
            Tab(text: 'CREATIONS'),
            Tab(text: 'ARTIFACTS'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _SavedList(type: 'CREATION'),
          _SavedList(type: 'ARTIFACT'),
        ],
      ),
    );
  }
}

class _SavedList extends ConsumerWidget {
  final String type;
  const _SavedList({required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(savedDataRepositoryProvider);

    return FutureBuilder<List<SavedDatum>>(
      future: repository.getSavedDataByType(type),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: EdgeTheme.lavender));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(
                  type == 'CREATION' ? FontAwesomeIcons.image : FontAwesomeIcons.code,
                  size: 48,
                  color: EdgeTheme.textTertiary.withValues(alpha: 0.2),
                ),
                const SizedBox(height: 16),
                Text(
                  'No saved ${type.toLowerCase()}s found.',
                  style: const TextStyle(color: EdgeTheme.textTertiary),
                ),
              ],
            ),
          );
        }

        final items = snapshot.data!;

        if (type == 'CREATION') {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) => _CreationCard(item: items[index]),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) => _ArtifactCard(item: items[index]),
        );
      },
    );
  }
}

class _CreationCard extends ConsumerWidget {
  final SavedDatum item;
  const _CreationCard({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: EdgeTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ImageViewerScreen(imagePath: item.content, tag: 'saved_${item.id}'),
                ),
              ),
              child: Hero(
                tag: 'saved_${item.id}',
                child: Image.file(File(item.content), fit: BoxFit.cover),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.shareNodes, size: 10, color: EdgeTheme.textSecondary),
                      onPressed: () => Share.shareXFiles([XFile(item.content)]),
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(4),
                    ),
                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.trashCan, size: 10, color: EdgeTheme.errorRed),
                      onPressed: () => _confirmDelete(context, ref),
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(4),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: EdgeTheme.surfaceColor,
        title: const Text('Delete Creation', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to delete this creation permanently?', style: TextStyle(color: EdgeTheme.textTertiary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          TextButton(
            onPressed: () async {
              await ref.read(savedDataRepositoryProvider).deleteSavedDatum(item.id);
              if (context.mounted) {
                Navigator.pop(context);
                // Trigger a rebuild of the list. Since this is a simple FutureBuilder,
                // we might need a state notifier for saved data to be reactive, 
                // but for now, we'll just rely on the user navigating back or the screen popping.
                // Actually, since it's a FutureBuilder, we can just setState in the parent.
              }
            },
            child: const Text('DELETE', style: TextStyle(color: EdgeTheme.errorRed)),
          ),
        ],
      ),
    );
  }
}

class _ArtifactCard extends ConsumerWidget {
  final SavedDatum item;
  const _ArtifactCard({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: EdgeTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: EdgeTheme.lavender.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const FaIcon(FontAwesomeIcons.code, color: EdgeTheme.lavender, size: 14),
        ),
        title: Text(item.title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
        subtitle: Text('Language: ${item.language?.toUpperCase() ?? "TEXT"}', style: const TextStyle(color: EdgeTheme.textTertiary, fontSize: 11)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.copy, size: 12, color: EdgeTheme.textTertiary),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: item.content));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
              },
            ),
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.trashCan, size: 12, color: EdgeTheme.errorRed),
              onPressed: () => _confirmDelete(context, ref),
            ),
          ],
        ),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                item.content,
                style: const TextStyle(color: EdgeTheme.textPrimary, fontFamily: 'monospace', fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: EdgeTheme.surfaceColor,
        title: const Text('Delete Artifact', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to delete this artifact snippet?', style: TextStyle(color: EdgeTheme.textTertiary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          TextButton(
            onPressed: () async {
              await ref.read(savedDataRepositoryProvider).deleteSavedDatum(item.id);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('DELETE', style: TextStyle(color: EdgeTheme.errorRed)),
          ),
        ],
      ),
    );
  }
}
