import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/di/repository_providers.dart';
import '../../../core/di/state_providers.dart';
import '../../../core/theme/edge_theme.dart';
import '../../../core/utils/system_info.dart';
import '../../../core/utils/ram_history.dart';
import '../../../data/datasources/llm_service.dart';

/// System info screen with RAM usage and model controls
class SystemScreen extends ConsumerStatefulWidget {
  const SystemScreen({super.key});

  @override
  ConsumerState<SystemScreen> createState() => _SystemScreenState();
}

class _SystemScreenState extends ConsumerState<SystemScreen> {
  Map<String, dynamic>? _deviceInfo;
  List<RamUsageEntry>? _ramHistory;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    _deviceInfo = await SystemInfoService.getDeviceInfo();
    _ramHistory = await RamHistoryTracker.getHistory();
    
    setState(() => _isLoading = false);
  }

  Future<void> _recordRamUsage() async {
    final activeModel = ref.read(activeModelProvider);
    await RamHistoryTracker.recordUsage(activeModel: activeModel?.name);
    await _loadData();
  }

  Future<void> _clearHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: EdgeTheme.surfaceColor,
        title: const Text('Clear History', style: TextStyle(color: Colors.white)),
        content: const Text('Clear RAM usage history?', style: TextStyle(color: EdgeTheme.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: EdgeTheme.errorRed),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await RamHistoryTracker.clearHistory();
      await _loadData();
    }
  }

  Future<void> _stopModel() async {
    final activeModel = ref.read(activeModelProvider);
    if (activeModel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No model loaded')),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: EdgeTheme.surfaceColor,
        title: const Text('Stop Model', style: TextStyle(color: Colors.white)),
        content: Text('Stop ${activeModel.name} and free memory?', style: const TextStyle(color: EdgeTheme.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: EdgeTheme.errorRed),
            child: const Text('Stop'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final correctionRepo = ref.read(correctionRepositoryProvider);
        await correctionRepo.unloadModel();
        ref.read(activeModelProvider.notifier).state = null;
        ref.read(settingsProvider.notifier).updateActiveModel('');
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${activeModel.name} stopped')),
          );
          await _loadData();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to stop model: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeModel = ref.watch(activeModelProvider);

    return Scaffold(
      backgroundColor: EdgeTheme.primaryBackground,
      appBar: AppBar(
        title: const Text('Intelligence Prototype'),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const FaIcon(FontAwesomeIcons.barsStaggered, size: 18),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.arrowsRotate, size: 16),
            onPressed: _loadData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: EdgeTheme.lavender))
          : RefreshIndicator(
              onRefresh: _loadData,
              color: EdgeTheme.lavender,
              backgroundColor: EdgeTheme.surfaceColor,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Status Badge
                    _buildStatusBadge(),
                    const SizedBox(height: 24),
                    
                    // RAM Usage Card
                    _buildRamCard(),
                    
                    const SizedBox(height: 24),

                    // Model Control Card
                    _buildModelControlCard(activeModel),
                    
                    const SizedBox(height: 24),

                    // Device Info Card
                    _buildDeviceInfoCard(),
                    
                    const SizedBox(height: 24),

                    // RAM History
                    if (_ramHistory != null && _ramHistory!.isNotEmpty)
                      _buildRamHistoryCard(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: EdgeTheme.lavender.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: EdgeTheme.lavender.withValues(alpha: 0.1)),
      ),
      child: const Row(
        children: [
          FaIcon(FontAwesomeIcons.solidCircle, color: EdgeTheme.lavender, size: 8),
          SizedBox(width: 12),
          Text(
            'NEURAL ENGINE OPERATIONAL',
            style: TextStyle(
              color: EdgeTheme.lavender,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRamCard() {
    if (_deviceInfo == null) return const SizedBox.shrink();

    final total = _deviceInfo!['totalRam'] as int;
    final used = _deviceInfo!['usedRam'] as int;
    final percent = double.parse(_deviceInfo!['ramUsagePercent']);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: EdgeTheme.surfaceColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: EdgeTheme.lavender.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(12),
                child: const FaIcon(FontAwesomeIcons.microchip, color: EdgeTheme.lavender, size: 20),
              ),
              const SizedBox(width: 16),
              const Text(
                'NEURAL MEMORY',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${used ~/ 1024} GB',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'OF ${total ~/ 1024} GB ALLOCATED',
                    style: const TextStyle(
                      color: EdgeTheme.textTertiary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${percent.toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: percent > 80 ? EdgeTheme.errorRed : EdgeTheme.lavender,
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Text(
                    'LOAD',
                    style: TextStyle(
                      color: EdgeTheme.textTertiary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: percent / 100,
              minHeight: 12,
              backgroundColor: Colors.white.withValues(alpha: 0.03),
              valueColor: AlwaysStoppedAnimation<Color>(
                percent > 80 ? EdgeTheme.errorRed : EdgeTheme.lavender,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: _recordRamUsage,
                icon: const FaIcon(FontAwesomeIcons.floppyDisk, size: 14),
                label: const Text('RECORD SNAPSHOT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                style: TextButton.styleFrom(foregroundColor: EdgeTheme.textSecondary),
              ),
              TextButton.icon(
                onPressed: _loadData,
                icon: const FaIcon(FontAwesomeIcons.rotate, size: 14),
                label: const Text('REAL-TIME REFRESH', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                style: TextButton.styleFrom(foregroundColor: EdgeTheme.lavender),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModelControlCard(activeModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EdgeTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: EdgeTheme.lavender.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(10),
                child: const FaIcon(FontAwesomeIcons.powerOff, color: EdgeTheme.lavender, size: 16),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NEURAL CORE CONTROL',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      'ACTIVE PROCESS MANAGEMENT',
                      style: TextStyle(
                        fontSize: 10,
                        color: EdgeTheme.textTertiary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (activeModel != null) ...[
            Row(
              children: [
                const FaIcon(FontAwesomeIcons.circleCheck, color: EdgeTheme.lavender, size: 16),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    activeModel.name.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _stopModel,
              icon: const FaIcon(FontAwesomeIcons.stop, size: 14),
              label: const Text('TERMINATE CORE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1)),
              style: ElevatedButton.styleFrom(
                backgroundColor: EdgeTheme.errorRed.withValues(alpha: 0.1),
                foregroundColor: EdgeTheme.errorRed,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: EdgeTheme.errorRed, width: 1),
                ),
              ),
            ),
          ] else
            const Text(
              'No model loaded',
              style: TextStyle(color: EdgeTheme.textTertiary),
            ),
        ],
      ),
    );
  }

  Widget _buildDeviceInfoCard() {
    if (_deviceInfo == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EdgeTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: EdgeTheme.lavender.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(10),
                child: const FaIcon(FontAwesomeIcons.mobileScreen, color: EdgeTheme.lavender, size: 16),
              ),
              const SizedBox(width: 16),
              const Text(
                'HARDWARE SPECIFICATIONS',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Device', _deviceInfo!['device']),
          _buildInfoRow('Manufacturer', _deviceInfo!['manufacturer']),
          _buildInfoRow('Android', '${_deviceInfo!['androidVersion']} (API ${_deviceInfo!['sdkVersion']})'),
          _buildInfoRow('Total RAM', '${_deviceInfo!['totalRam'] ~/ 1024} GB'),
          _buildInfoRow('Available RAM', '${_deviceInfo!['availableRam'] ~/ 1024} GB'),
          _buildInfoRow('Used RAM', '${_deviceInfo!['usedRam'] ~/ 1024} GB'),
          _buildInfoRow('RAM Usage', '${_deviceInfo!['ramUsagePercent']}%'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: EdgeTheme.textTertiary,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          Text(
            value.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 11,
              color: EdgeTheme.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRamHistoryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EdgeTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: EdgeTheme.lavender.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: const FaIcon(FontAwesomeIcons.clockRotateLeft, color: EdgeTheme.lavender, size: 16),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'NEURAL LOAD HISTORY',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: _clearHistory,
                icon: const FaIcon(FontAwesomeIcons.trashCan, size: 12),
                label: const Text('PURGE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                style: TextButton.styleFrom(foregroundColor: EdgeTheme.errorRed),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._ramHistory!.take(10).map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${entry.usedRamMB ~/ 1024}GB / ${entry.totalRamMB ~/ 1024}GB',
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                          ),
                          if (entry.activeModel != null)
                            Text(
                              entry.activeModel!.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: EdgeTheme.lavender,
                                letterSpacing: 1,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${entry.usagePercent.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                            color: entry.usagePercent > 80
                                ? EdgeTheme.errorRed
                                : entry.usagePercent > 60
                                    ? Colors.orange
                                    : EdgeTheme.lavender,
                          ),
                        ),
                        Text(
                          _formatTime(entry.timestamp).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: EdgeTheme.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
