import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/models/ai_personality.dart';
import '../../../core/theme/edge_theme.dart';
import '../../../core/di/state_providers.dart';
import '../../../data/repositories/settings_repository.dart';

/// AI Personality settings screen
class PersonalityScreen extends ConsumerStatefulWidget {
  const PersonalityScreen({super.key});

  @override
  ConsumerState<PersonalityScreen> createState() => _PersonalityScreenState();
}

class _PersonalityScreenState extends ConsumerState<PersonalityScreen> {
  AIPersonality? _selectedPersonality;
  List<AIPersonality> _customPersonalities = [];
  bool _isCustomizing = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(settingsRepositoryProvider);
      final customs = await repo.getCustomPersonalities();
      
      if (mounted) {
        setState(() {
          _customPersonalities = customs;
          // Fallback to provider default if somehow null
          _selectedPersonality = ref.read(settingsProvider).personality;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading personality data: $e');
      if (mounted) {
        setState(() {
          _selectedPersonality = ref.read(settingsProvider).personality;
          _isLoading = false;
        });
      }
    }
  }

  void _createNewPersonality() {
    final newP = AIPersonality(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      name: 'New Custom Probe',
      avatarIcon: FontAwesomeIcons.robot,
    );
    setState(() {
      _selectedPersonality = newP;
      _isCustomizing = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _selectedPersonality == null) {
      return const Scaffold(
        backgroundColor: EdgeTheme.primaryBackground,
        body: Center(child: CircularProgressIndicator(color: EdgeTheme.lavender)),
      );
    }

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
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          // Active Personality Card - Premium Glow
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: EdgeTheme.brainyGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: EdgeTheme.purpleGlow(EdgeTheme.lavender),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(16),
                      child: FaIcon(
                        _selectedPersonality!.avatarIcon,
                        size: 32,
                        color: EdgeTheme.primaryPurple,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedPersonality!.displayName,
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  color: EdgeTheme.primaryBackground,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          Text(
                            'Active Intelligence Core',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: EdgeTheme.primaryBackground.withValues(alpha: 0.6),
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => setState(() => _isCustomizing = !_isCustomizing),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: EdgeTheme.primaryBackground,
                    foregroundColor: EdgeTheme.lavender,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: Text(_isCustomizing ? 'Lock Settings' : 'Modify Core'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          Text(
            'SYSTEM CORES',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: EdgeTheme.textTertiary,
                ),
          ),
          const SizedBox(height: 16),
          ...PredefinedPersonalities.all.map((p) => _buildPersonalityCard(p)),

          if (_customPersonalities.isNotEmpty) ...[
            const SizedBox(height: 32),
            Text(
              'CUSTOM PROBES',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: EdgeTheme.textTertiary,
                  ),
            ),
            const SizedBox(height: 16),
            ..._customPersonalities.map((p) => _buildPersonalityCard(p)),
          ],

          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: _createNewPersonality,
            icon: const FaIcon(FontAwesomeIcons.circlePlus, size: 16),
            label: const Text('ENGAGE NEW PROBE'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20),
              side: const BorderSide(color: EdgeTheme.lavender, width: 1),
            ),
          ),

          const SizedBox(height: 32),

          // Customization Section
          if (_isCustomizing) ...[
            Text(
              'INTEL CALIBRATION',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: EdgeTheme.textTertiary,
                  ),
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('IDENTIFIER'),
            _buildTextField(
              value: _selectedPersonality!.customName,
              onChanged: (val) => setState(
                () => _selectedPersonality = _selectedPersonality!.copyWith(customName: val),
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('GENDER BIAS'),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: AIGender.values.map((g) {
                final isSelected = _selectedPersonality!.gender == g;
                return ChoiceChip(
                  label: Text(g.displayName),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedPersonality = _selectedPersonality!.copyWith(gender: g));
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('CORE INTENSITY'),
            ..._buildTraitSliders(),
            const SizedBox(height: 24),

            _buildSectionTitle('VOICE FREQUENCY'),
            _buildSlider(
              label: 'Pitch',
              value: _selectedPersonality!.voicePitch,
              min: 0.5,
              max: 2.0,
              onChanged: (val) => setState(
                () => _selectedPersonality = _selectedPersonality!.copyWith(voicePitch: val),
              ),
            ),
            _buildSlider(
              label: 'Velocity',
              value: _selectedPersonality!.voiceSpeed,
              min: 0.5,
              max: 2.0,
              onChanged: (val) => setState(
                () => _selectedPersonality = _selectedPersonality!.copyWith(voiceSpeed: val),
              ),
            ),
            const SizedBox(height: 32),

            // Save button
            Container(
              decoration: BoxDecoration(
                boxShadow: EdgeTheme.purpleGlow(EdgeTheme.lavender),
              ),
              child: ElevatedButton(
                onPressed: () async {
                  final notifier = ref.read(settingsProvider.notifier);
                  final repo = ref.read(settingsRepositoryProvider);
                  
                  // Save to state
                  notifier.updatePersonality(_selectedPersonality!);
                  
                  // If it's a custom personality, save to database
                  if (_selectedPersonality!.id.startsWith('custom_')) {
                    await repo.saveCustomPersonality(_selectedPersonality!);
                    await _loadData(); // Refresh list
                  }
                  
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Intelligence calibrated successfully.')),
                    );
                    setState(() => _isCustomizing = false);
                  }
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(FontAwesomeIcons.circleCheck, size: 18),
                    SizedBox(width: 12),
                    Text('SYNC CORE'),
                  ],
                ),
              ),
            ),
            if (_selectedPersonality!.id.startsWith('custom_')) ...[
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () async {
                  final repo = ref.read(settingsRepositoryProvider);
                  await repo.deleteCustomPersonality(_selectedPersonality!.id);
                  await _loadData();
                  if (mounted) {
                    setState(() => _isCustomizing = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Probe deleted.')),
                    );
                  }
                },
                icon: const FaIcon(FontAwesomeIcons.trashCan, size: 14, color: EdgeTheme.errorRed),
                label: const Text('DELETE PROBE', style: TextStyle(color: EdgeTheme.errorRed)),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildPersonalityCard(AIPersonality p) {
    final isSelected = _selectedPersonality?.id == p.id;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _selectedPersonality = p);
        ref.read(settingsProvider.notifier).updatePersonality(p);
        // Also persist the choice
        ref.read(settingsRepositoryProvider).updatePersonality(p);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: isSelected ? EdgeTheme.lavender.withValues(alpha: 0.05) : EdgeTheme.surfaceColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? EdgeTheme.lavender : Colors.white.withValues(alpha: 0.05),
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected ? EdgeTheme.purpleGlow(EdgeTheme.lavender) : [],
          ),
        child: Row(
          children: [
            FaIcon(p.avatarIcon, size: 28, color: isSelected ? EdgeTheme.lavender : EdgeTheme.textPrimary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isSelected ? EdgeTheme.lavender : EdgeTheme.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  Text(
                    p.occupationName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: EdgeTheme.textTertiary,
                        ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const FaIcon(FontAwesomeIcons.circleDot, color: EdgeTheme.lavender, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: EdgeTheme.textSecondary,
              letterSpacing: 1.5,
            ),
      ),
    );
  }

  Widget _buildTextField({
    required String value,
    required Function(String) onChanged,
  }) {
    return TextField(
      onChanged: onChanged,
      controller: TextEditingController(text: value),
      style: const TextStyle(color: EdgeTheme.textPrimary),
      decoration: const InputDecoration(
        hintText: 'Enter Probe Identifier',
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    int? divisions,
    required Function(double) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            Text(
              value.toStringAsFixed(1),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: EdgeTheme.lavender),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          activeColor: EdgeTheme.lavender,
          onChanged: onChanged,
        ),
      ],
    );
  }

  List<Widget> _buildTraitSliders() {
    final traits = {
      'humor': TraitIntensity.medium,
      'formal': TraitIntensity.low,
      'casual': TraitIntensity.medium,
      'empathetic': TraitIntensity.medium,
      'concise': TraitIntensity.low,
      'detailed': TraitIntensity.medium,
    };

    return traits.entries.map((entry) {
      final value = _selectedPersonality!.traits[entry.key] ?? entry.value;
      return _buildSlider(
        label: entry.key.toUpperCase(),
        value: value.index.toDouble(),
        min: 0,
        max: 2,
        divisions: 2,
        onChanged: (val) {
          final newTraits = Map<String, TraitIntensity>.from(_selectedPersonality!.traits);
          newTraits[entry.key] = TraitIntensity.values[val.toInt()];
          setState(() => _selectedPersonality = _selectedPersonality!.copyWith(traits: newTraits));
        },
      );
    }).toList();
  }
}
