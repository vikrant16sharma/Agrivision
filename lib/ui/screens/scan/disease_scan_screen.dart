import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/config/supabase_config.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../../presentation/auth_provider.dart';

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

  // NEW: prediction state
  String? _diseaseLabel;
  double? _confidence;
  String? _errorMessage;

  @override
  void dispose() {
    _fieldIdController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // Pick image from Camera or Gallery
  Future<void> _captureImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
          _diseaseLabel = null;
          _confidence = null;
          _errorMessage = null;
        });
      }
    } catch (e) {
      debugPrint("Image pick error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to pick image: $e")),
      );
    }
  }

  // Submit to Supabase Edge Function (multipart -> FastAPI)
  Future<void> _submitScan() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please capture an image first')));
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final url = Uri.parse("https://cropdetectionbackend.onrender.com/disease-scan");

      var request = http.MultipartRequest('POST', url);

      request.files.add(await http.MultipartFile.fromPath(
        'file',
        _imageFile!.path,
      ));

      var response = await request.send();
      var body = await response.stream.bytesToString();

      debugPrint("Response: $body");

      if (response.statusCode == 200) {
        var json = jsonDecode(body);

        if (json["success"] == true) {
          setState(() {
            _diseaseLabel = json["label"];
            _confidence = (json["confidence"] as num).toDouble();
          });

          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Scan Successful!")));
        } else {
          setState(() => _errorMessage = json["error"]);
        }
      } else {
        setState(() => _errorMessage = "Server Error: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    }

    if (mounted) setState(() => _isLoading = false);
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
            Text(
              'Capture plant photo for AI diagnosis',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            _buildImageCaptureArea(),
            const SizedBox(height: 24),
            _buildForm(),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Analyze Plant',
              icon: Icons.camera_alt,
              onPressed: _submitScan,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 16),
            _buildResultSection(), // NEW: show prediction
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
        border: Border.all(color: AppColors.border, width: 2),
      ),
      child: _imageFile == null
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.camera_alt_outlined,
              size: 64, color: AppColors.textTertiary),
          const SizedBox(height: 16),
          Text('Capture plant image',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary)),
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
          )
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
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => setState(() {
                _imageFile = null;
                _diseaseLabel = null;
                _confidence = null;
                _errorMessage = null;
              }),
            ),
          )
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
          child: Row(
            children: [
              Icon(icon,
                  size: 20,
                  color: isPrimary ? Colors.white : AppColors.primary),
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

  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          DropdownButtonFormField(
            value: _selectedCrop,
            decoration: const InputDecoration(labelText: "Crop Type"),
            items: const [
              DropdownMenuItem(value: "tomato", child: Text("Tomato")),
              DropdownMenuItem(value: "corn", child: Text("Corn")),
              DropdownMenuItem(value: "wheat", child: Text("Wheat")),
              DropdownMenuItem(value: "rice", child: Text("Rice")),
              DropdownMenuItem(value: "potato", child: Text("Potato")),
            ],
            onChanged: (v) => setState(() => _selectedCrop = v!),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _fieldIdController,
            decoration:
            const InputDecoration(labelText: "Field ID (Optional)"),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _locationController,
            decoration:
            const InputDecoration(labelText: "Location (Optional)"),
          ),
        ],
      ),
    );
  }

  Widget _buildResultSection() {
    if (_isLoading) return const SizedBox.shrink();

    if (_errorMessage != null) {
      return Text(
        "Error: $_errorMessage",
        style: AppTextStyles.bodyMedium.copyWith(color: Colors.red),
      );
    }

    if (_diseaseLabel == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Prediction",
            style: AppTextStyles.bodyMedium
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text("Disease: $_diseaseLabel"),
          if (_confidence != null)
            Text("Confidence: ${(_confidence! * 100).toStringAsFixed(2)}%"),
        ],
      ),
    );
  }
}
