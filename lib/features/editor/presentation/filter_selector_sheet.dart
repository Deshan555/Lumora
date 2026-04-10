import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/theme/edge_theme.dart';
import '../../../core/services/image_service.dart';

class FilterSelectorSheet extends StatefulWidget {
  final String imagePath;
  final Function(String newPath) onFilterApplied;

  const FilterSelectorSheet({
    super.key,
    required this.imagePath,
    required this.onFilterApplied,
  });

  @override
  State<FilterSelectorSheet> createState() => _FilterSelectorSheetState();
}

class _FilterSelectorSheetState extends State<FilterSelectorSheet> {
  String? _currentPath;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _currentPath = widget.imagePath;
  }

  Future<void> _apply(AppImageFilter filter) async {
    setState(() => _isProcessing = true);
    try {
      final path = await ImageService.applyFilter(widget.imagePath, filter);
      if (mounted) {
        setState(() {
          _currentPath = path;
          _isProcessing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Filter error: $e')),
        );
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: EdgeTheme.surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Apply Filter',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          
          // Image Preview
          SizedBox(
            height: 250,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                   Image.file(File(_currentPath!), fit: BoxFit.cover),
                   if (_isProcessing)
                     const CircularProgressIndicator(color: EdgeTheme.lavender),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Filter presets
          SizedBox(
            height: 60,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: AppImageFilter.presets.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final filter = AppImageFilter.presets[index];
                return InkWell(
                  onTap: () => _apply(filter),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: EdgeTheme.lavender.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: EdgeTheme.lavender.withValues(alpha: 0.3)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      filter.name,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 32),
          
          // Confirm Button
          ElevatedButton(
            onPressed: () {
              widget.onFilterApplied(_currentPath!);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: EdgeTheme.lavender,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Save & Finish', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
