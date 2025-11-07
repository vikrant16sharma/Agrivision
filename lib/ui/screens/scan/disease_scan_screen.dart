import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../widgets/buttons/primary_button.dart';

class DiseaseScanScreen extends StatefulWidget {
  const DiseaseScanScreen({super.key});

  @override
  State<DiseaseScanScreen> createState() => _DiseaseScanScreenState();
}

class _DiseaseScanScreenState extends State<DiseaseScanScreen> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String _selectedCrop = 'tomato';
  final TextEditingController _fieldIdController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _fieldIdController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _captureImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      maxWidth: 1024,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  Future<void> _submitScan() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please capture an image first')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // TODO: Implement actual scan submission
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isLoading = false);
      // Navigate to results screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disease Scan'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            Text(
              'Capture plant photo for AI diagnosis',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 24),

            // Image Capture Area
            _buildImageCaptureArea(),

            const SizedBox(height: 24),

            // Form Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.backgroundWhite,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowLight,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Scan Details', style: AppTextStyles.h4),
                  const SizedBox(height: 20),

                  // Crop Type Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedCrop,
                    decoration: InputDecoration(
                      labelText: 'Crop Type',
                      filled: true,
                      fillColor: AppColors.backgroundGray,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'tomato', child: Text('Tomato')),
                      DropdownMenuItem(value: 'corn', child: Text('Corn')),
                      DropdownMenuItem(value: 'wheat', child: Text('Wheat')),
                      DropdownMenuItem(value: 'rice', child: Text('Rice')),
                      DropdownMenuItem(value: 'potato', child: Text('Potato')),
                      DropdownMenuItem(value: 'cotton', child: Text('Cotton')),
                    ],
                    onChanged: (value) {
                      setState(() => _selectedCrop = value!);
                    },
                  ),

                  const SizedBox(height: 16),

                  // Field ID
                  TextFormField(
                    controller: _fieldIdController,
                    decoration: InputDecoration(
                      labelText: 'Field ID (optional)',
                      hintText: 'e.g., Field-A1',
                      filled: true,
                      fillColor: AppColors.backgroundGray,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Location
                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: 'Location (optional)',
                      hintText: 'e.g., North section',
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      filled: true,
                      fillColor: AppColors.backgroundGray,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Tips Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF), // blue-50
                border: Border.all(
                  color: const Color(0xFFBFDBFE), // blue-200
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: AppColors.info,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Tips for best results:',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: const Color(0xFF1E3A8A), // blue-900
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTip('Capture close-up of affected leaves'),
                  _buildTip('Ensure good lighting (natural light preferred)'),
                  _buildTip('Keep camera steady and focused'),
                  _buildTip('Include both healthy and diseased areas'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Submit Button
            PrimaryButton(
              text: 'Analyze Plant',
              icon: Icons.camera_alt,
              onPressed: _submitScan,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCaptureArea() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: AppColors.backgroundGray,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: _imageFile == null
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.camera_alt_outlined,
            size: 64,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            'Capture plant image',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCaptureButton(
                icon: Icons.camera_alt,
                label: 'Camera',
                onTap: () => _captureImage(ImageSource.camera),
                isPrimary: true,
              ),
              const SizedBox(width: 16),
              _buildCaptureButton(
                icon: Icons.photo_library,
                label: 'Gallery',
                onTap: () => _captureImage(ImageSource.gallery),
                isPrimary: false,
              ),
            ],
          ),
        ],
      )
          : Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.file(
              _imageFile!,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  setState(() => _imageFile = null);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaptureButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    return Material(
      color: isPrimary ? AppColors.primary : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            border: isPrimary
                ? null
                : Border.all(color: AppColors.border, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: isPrimary ? Colors.white : AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTextStyles.button.copyWith(
                  color: isPrimary ? Colors.white : AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: AppTextStyles.bodySmall.copyWith(
              color: const Color(0xFF1E40AF), // blue-800
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(
                color: const Color(0xFF1E40AF), // blue-800
              ),
            ),
          ),
        ],
      ),
    );
  }
}
