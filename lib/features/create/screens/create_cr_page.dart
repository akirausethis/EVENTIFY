import 'package:eventify_flutter/core/model/event_model.dart';
import 'package:eventify_flutter/core/theme/app_theme.dart';
import 'package:eventify_flutter/services/firestore_service.dart';
import 'package:eventify_flutter/shared/widgets/custom_notification_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateCrPage extends StatefulWidget {
  const CreateCrPage({super.key});

  @override
  State<CreateCrPage> createState() => _CreateCrPageState();
}

class _CreateCrPageState extends State<CreateCrPage> {
  final _formKey = GlobalKey<FormState>();
  final _firestoreService = FirestoreService();

  final _titleController = TextEditingController();
  final _detailsController = TextEditingController();
  final _regDateController = TextEditingController();
  final _benefitsController = TextEditingController();
  final _dDayController = TextEditingController();
  bool _isLoading = false;

  Future<void> _saveCrEvent() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final newEvent = EventModel(
        title: _titleController.text,
        subtitle: 'Career Center',
        imagePath: 'assets/images/Firefly.webp',
        category: EventCategory.cr,
        detailsContent: _detailsController.text,
        registrationDate: _regDateController.text,
        benefits: _benefitsController.text,
        dDayDate: _dDayController.text,
      );

      await _firestoreService.addEvent(newEvent);

      if (mounted) {
        await showCustomNotificationDialog(
          context: context,
          title: "Success!",
          message: "You have successfully created a new Career post.",
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
          title: Text("Create Career Post",
              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 48.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildCustomInputField(
                  controller: _titleController,
                  label: "Event Title",
                  icon: Icons.title),
              _buildCustomInputField(
                  controller: _detailsController,
                  label: "Event Details",
                  icon: Icons.description_outlined),
              _buildCustomInputField(
                  controller: _regDateController,
                  label: "Registration Date",
                  icon: Icons.calendar_today_outlined),
              _buildCustomInputField(
                  controller: _benefitsController,
                  label: "Benefits",
                  icon: Icons.star_border_outlined),
              _buildCustomInputField(
                  controller: _dDayController,
                  label: "D-Day Date",
                  icon: Icons.flag_outlined),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveCrEvent,
                    child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("CREATE POST")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}