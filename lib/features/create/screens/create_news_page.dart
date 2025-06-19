import 'package:eventify_flutter/core/model/event_model.dart';
import 'package:eventify_flutter/core/theme/app_theme.dart';
import 'package:eventify_flutter/services/firestore_service.dart';
import 'package:eventify_flutter/shared/widgets/custom_notification_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateNewsPage extends StatefulWidget {
  const CreateNewsPage({super.key});

  @override
  State<CreateNewsPage> createState() => _CreateNewsPageState();
}

class _CreateNewsPageState extends State<CreateNewsPage> {
  final _formKey = GlobalKey<FormState>();
  final _firestoreService = FirestoreService();
  final _titleController = TextEditingController();
  final _detailsController = TextEditingController();
  bool _isLoading = false;

  Future<void> _saveNews() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final newEvent = EventModel(
        title: _titleController.text,
        subtitle: 'University News',
        imagePath: 'assets/images/Firefly.webp',
        category: EventCategory.news,
        detailsContent: _detailsController.text,
      );

      await _firestoreService.addEvent(newEvent);

      if (mounted) {
        await showCustomNotificationDialog(
          context: context,
          title: "Success!",
          message: "You have successfully created a new News post.",
          type: DialogType.success,
        );
        Navigator.of(context).pop();
      }
      setState(() => _isLoading = false);
    }
  }

  Widget _buildCustomInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.primaryColor, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.montserrat(
                  color: AppTheme.darkTextColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppTheme.inputFieldColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) =>
                value == null || value.isEmpty ? 'This field cannot be empty' : null,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create News Post",
            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 48.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildCustomInputField(
                controller: _titleController,
                label: "News Title",
                icon: Icons.title,
              ),
              _buildCustomInputField(
                controller: _detailsController,
                label: "News Details",
                icon: Icons.description_outlined,
                maxLines: 8,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveNews,
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("CREATE POST"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
