import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/constants/model_catalog.dart';
import '../../../domain/entities/model_info.dart';
import '../../../core/di/state_providers.dart';
import '../../../core/di/repository_providers.dart';
import '../../../core/theme/edge_theme.dart';
import '../../../core/utils/checksum_utils.dart';
import '../../../data/datasources/download_manager.dart';
import '../../../data/datasources/external_model_storage.dart';

/// Models screen with categories
class ModelsScreen extends ConsumerStatefulWidget {
  const ModelsScreen({super.key});

  @override
  ConsumerState<ModelsScreen> createState() => _ModelsScreenState();
}

class _ModelsScreenState extends ConsumerState<ModelsScreen> with SingleTickerProviderStateMixin {
  late DownloadManager _downloadManager;
  final Map<String, double> _downloadProgress = {};
  final Map<String, bool> _isDownloading = {};
  late TabController _tabController;
  String _selectedCategory = ModelCategories.text;
  List<ModelInfo> _downloadedModels = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: AvailableModels.getCategories().length, vsync: this);
    _downloadManager = DownloadManager(ref.read(dioProvider));
    _loadModels();
    _loadDownloadedModels();
  }

  @override
  void dispose() {
    _downloadManager.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadModels() async {
    final repo = ref.read(modelRepositoryProvider);
    final models = await repo.getAvailableModels();
    ref.read(modelsListProvider.notifier).updateModels(models);
  }

  Future<void> _loadDownloadedModels() async {
    await ExternalModelStorageService.initialize();
    final files = await ExternalModelStorageService.getModelFiles();
    
    setState(() {
      _downloadedModels = files.map((file) {
        final filename = file.uri.pathSegments.last;
        return ModelInfo(
          id: filename.split('.').first.toLowerCase().replaceAll(' ', '_'),
          name: filename.split('.').first,
          description: 'Imported model',
          filename: filename,
          sizeBytes: file.lengthSync(),
          category: ModelCategories.text,
          recommendedRamGB: 4,
          isDownloaded: true,
          localPath: file.path,
          downloadedAt: file.lastModifiedSync(),
        );
      }).toList();
    });
  }

  Future<void> _downloadModel(ModelInfo model) async {
    if (_isDownloading[model.id] == true) return;

    setState(() => _isDownloading[model.id] = true);

    try {
      await ExternalModelStorageService.initialize();
      final modelsDir = ExternalModelStorageService.modelsDirectory;
      if (modelsDir == null) throw Exception('Storage not initialized');

      final destPath = '${modelsDir.path}/${model.filename}';

      await _downloadManager.download(
        modelId: model.id,
        url: model.downloadUrl ?? '',
        destinationPath: destPath,
        onProgress: (progress) {
          if (mounted) setState(() => _downloadProgress[model.id] = progress);
        },
        onComplete: () async {
          if (mounted) {
            setState(() {
              _isDownloading[model.id] = false;
              _downloadProgress.remove(model.id);
            });
            await _loadDownloadedModels();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${model.name} downloaded!'), backgroundColor: EdgeTheme.successGreen),
              );
            }
          }
        },
        onError: (error) {
          if (mounted) {
            setState(() => _isDownloading[model.id] = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Download failed: $error'), backgroundColor: EdgeTheme.errorRed),
            );
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() => _isDownloading[model.id] = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _pauseDownload(String modelId) async {
    _downloadManager.pauseDownload(modelId);
    setState(() => _isDownloading[modelId] = false);
  }

  Future<void> _deleteModel(ModelInfo model) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: EdgeTheme.surfaceColor,
        title: const Text('Delete Model'),
        content: Text('Delete ${model.name}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: EdgeTheme.errorRed),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (model.localPath != null) {
        final file = File(model.localPath!);
        if (await file.exists()) await file.delete();
      }
      await _loadDownloadedModels();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${model.name} deleted')));
      }
    }
  }

  Future<void> _importModel() async {
    final repo = ref.read(modelRepositoryProvider);
    final importedModel = await repo.importModelFromDevice();
    
    if (importedModel != null && mounted) {
      await _loadDownloadedModels();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${importedModel.name} imported!'), backgroundColor: EdgeTheme.successGreen),
      );
    }
  }

  Future<void> _setActiveModel(ModelInfo model) async {
    String? modelPath = model.localPath;
    
    if (modelPath == null && model.isDownloaded) {
      await ExternalModelStorageService.initialize();
      final modelsDir = ExternalModelStorageService.modelsDirectory;
      if (modelsDir != null) {
        modelPath = '${modelsDir.path}/${model.filename}';
      }
    }

    if (modelPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Model file not found')),
      );
      return;
    }

    ref.read(activeModelProvider.notifier).state = model;
    ref.read(settingsProvider.notifier).updateActiveModel(model.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Loading ${model.name}...'), duration: const Duration(seconds: 30)),
    );

    try {
      final correctionRepo = ref.read(correctionRepositoryProvider);
      await correctionRepo.initializeModel(modelPath);
      
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const FaIcon(FontAwesomeIcons.circleCheck, color: Colors.white, size: 16),
                const SizedBox(width: 12),
                Text('${model.name} ready!'),
              ],
            ),
            backgroundColor: EdgeTheme.successGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load: $e'), backgroundColor: EdgeTheme.errorRed),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeModel = ref.watch(activeModelProvider);
    final categories = AvailableModels.getCategories();
    final categoryModels = AvailableModels.getByCategory(_selectedCategory);

    return Scaffold(
      backgroundColor: EdgeTheme.primaryBackground,
      appBar: AppBar(
        title: const Text('Node Management'),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.plus, size: 18),
            onPressed: _importModel,
            tooltip: 'Import',
          ),
          Builder(
            builder: (context) => IconButton(
              icon: const FaIcon(FontAwesomeIcons.barsStaggered, size: 18),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: EdgeTheme.lavender,
          onTap: (index) => setState(() => _selectedCategory = categories[index]),
          tabs: categories.map((cat) {
            final icon = ModelInfo(
              id: '', name: '', description: '', filename: '',
              sizeBytes: 0, category: cat, recommendedRamGB: 0,
            ).categoryIcon;
            return Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(icon, size: 12),
                  const SizedBox(width: 8),
                  Text(cat.split(' ').first),
                ],
              ),
            );
          }).toList(),
        ),
      ),
      body: Column(
        children: [
          // Downloaded models summary
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: EdgeTheme.lavender.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: EdgeTheme.lavender.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const FaIcon(FontAwesomeIcons.microchip, color: EdgeTheme.lavender, size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_downloadedModels.length} NODES SYNCED',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      FutureBuilder<int>(
                        future: ExternalModelStorageService.getStorageUsed(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return const SizedBox.shrink();
                          return Text(
                            'STORAGE USED: ${ChecksumUtils.formatFileSize(snapshot.data!)}',
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 11, letterSpacing: 0.5),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                if (activeModel != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: EdgeTheme.successGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('ACTIVE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
          ),

          // Models list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categoryModels.length,
              itemBuilder: (context, index) {
                final model = categoryModels[index];
                final isDownloaded = _downloadedModels.any((m) => m.filename == model.filename);
                final downloadedModel = isDownloaded 
                    ? _downloadedModels.firstWhere((m) => m.filename == model.filename)
                    : null;
                final isActive = activeModel?.id == model.id;
                final progress = _downloadProgress[model.id] ?? 0.0;
                final downloading = _isDownloading[model.id] ?? false;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: EdgeTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isActive ? EdgeTheme.lavender : Colors.white.withValues(alpha: 0.05),
                      width: isActive ? 2 : 1,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(20),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: (isActive ? EdgeTheme.lavender : EdgeTheme.textTertiary).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: FaIcon(
                          model.categoryIcon,
                          size: 18,
                          color: isActive ? EdgeTheme.lavender : EdgeTheme.textTertiary,
                        ),
                      ),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            model.name,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (isActive)
                          const FaIcon(FontAwesomeIcons.bolt, color: EdgeTheme.lavender, size: 14),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        Text(model.description, style: const TextStyle(color: EdgeTheme.textTertiary, fontSize: 12)),
                        const SizedBox(height: 8),
                        Text(
                          '${model.sizeFormatted} • ${model.recommendedRamGB}GB RAM • ${model.contextWindow} CTX',
                          style: const TextStyle(color: EdgeTheme.textTertiary, fontSize: 10),
                        ),
                        if (downloading) ...[
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 4,
                              backgroundColor: Colors.white.withValues(alpha: 0.05),
                              valueColor: const AlwaysStoppedAnimation<Color>(EdgeTheme.lavender),
                            ),
                          ),
                        ],
                      ],
                    ),
                    trailing: isDownloaded
                        ? PopupMenuButton<String>(
                            icon: const FaIcon(FontAwesomeIcons.ellipsisVertical, size: 16),
                            color: EdgeTheme.surfaceColor,
                            onSelected: (value) {
                              if (value == 'activate') _setActiveModel(downloadedModel!);
                              if (value == 'delete') _deleteModel(downloadedModel!);
                            },
                            itemBuilder: (context) => [
                              if (!isActive)
                                const PopupMenuItem(
                                  value: 'activate',
                                  child: Row(children: [
                                    FaIcon(FontAwesomeIcons.play, size: 14),
                                    SizedBox(width: 12),
                                    Text('Calibrate'),
                                  ]),
                                ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(children: [
                                  FaIcon(FontAwesomeIcons.trashCan, size: 14, color: EdgeTheme.errorRed),
                                  SizedBox(width: 12),
                                  Text('Purge', style: TextStyle(color: EdgeTheme.errorRed)),
                                ]),
                              ),
                            ],
                          )
                        : downloading
                            ? IconButton(
                                icon: const FaIcon(FontAwesomeIcons.circlePause, size: 18),
                                onPressed: () => _pauseDownload(model.id),
                              )
                            : model.downloadUrl != null
                                ? IconButton(
                                    icon: const FaIcon(FontAwesomeIcons.cloudArrowDown, size: 18),
                                    onPressed: () => _downloadModel(model),
                                  )
                                : const FaIcon(FontAwesomeIcons.linkSlash, size: 16, color: EdgeTheme.textTertiary),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
