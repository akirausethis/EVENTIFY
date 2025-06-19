import 'package:eventify_flutter/core/model/event_model.dart';
import 'package:eventify_flutter/core/theme/app_theme.dart';
import 'package:eventify_flutter/services/firestore_service.dart';
import 'package:eventify_flutter/shared/widgets/custom_notification_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateOprecPage extends StatefulWidget {
  const CreateOprecPage({super.key});

  @override
  State<CreateOprecPage> createState() => _CreateOprecPageState();
}

class _CreateOprecPageState extends State<CreateOprecPage> {
  final _formKey = GlobalKey<FormState>();
  final _firestoreService = FirestoreService();

  final List<String> _majors = [
    "IMT", "ISB", "FIKOM", "IBM", "CB", "ACC",
    "PSY", "MED", "FDB", "FTP", "LAW", "ARCH"
  ];
  String? _selectedMajor;

  final _titleController = TextEditingController();
  final _detailsController = TextEditingController();
  final _regDateController = TextEditingController();
  final _benefitsController = TextEditingController();
  final _conditionsController = TextEditingController();
  final _dDayController = TextEditingController();
  bool _isLoading = false;

  Future<void> _saveOprec() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final newEvent = EventModel(
        title: _titleController.text,
        subtitle: 'Jurusan: $_selectedMajor',
        imagePath: 'assets/images/Firefly.webp',
        category: EventCategory.oprec,
        detailsContent: _detailsController.text,
        registrationDate: _regDateController.text,
        benefits: _benefitsController.text,
        conditions: _conditionsController.text,
        dDayDate: _dDayController.text,
      );

      await _firestoreService.addEvent(newEvent);

      if (mounted) {
        await showCustomNotificationDialog(
          context: context,
          title: "Success!",
          message: "You have successfully created a new Oprec post.",
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
    bool isDropdown = false,
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
          isDropdown
              ? DropdownButtonFormField<String>(
                  value: _selectedMajor,
                  items: _majors.map((String major) {
                    return DropdownMenuItem<String>(
                      value: major,
                      child: Text(major),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedMajor = newValue;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppTheme.inputFieldColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) => value == null ? 'Please select a major' : null,
                )
              : TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppTheme.inputFieldColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'This field cannot be empty' : null,
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Oprec Post",
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
      ),
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
                  controller: TextEditingController(),
                  label: "Major",
                  icon: Icons.school_outlined,
                  isDropdown: true),
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
                  controller: _conditionsController,
                  label: "Conditions",
                  icon: Icons.check_circle_outline),
              _buildCustomInputField(
                  controller: _dDayController,
                  label: "D-Day Date",
                  icon: Icons.flag_outlined),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveOprec,
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