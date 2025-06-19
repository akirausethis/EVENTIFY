import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify_flutter/core/theme/app_theme.dart';
import 'package:eventify_flutter/features/shell/main_scaffold.dart';
import 'package:eventify_flutter/shared/widgets/custom_notification_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

Future<void> _register() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isLoading = true);

  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (userCredential.user != null) {
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'username': _usernameController.text.trim(),
        'email': _emailController.text.trim(),
      });
    }

    if (mounted) {
      // --- NOTIFIKASI BARU ---
      await showCustomNotificationDialog(
        context: context,
        title: "Congratulations!",
        message: "Your account is all set and ready to go.",
        type: DialogType.success,
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainScaffold()),
        (Route<dynamic> route) => false,
      );
    }

  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.message ?? 'Registration failed')),
    );
  } finally {
     if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: screenHeight * 0.75,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(32.0, 40.0, 32.0, 16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Register", style: GoogleFonts.montserrat(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.darkTextColor)),
                          const Spacer(flex: 2),
                          _CustomInputField(label: "Username", icon: Icons.person_outline, controller: _usernameController),
                          const SizedBox(height: 16),
                          _CustomInputField(label: "Email", icon: Icons.email_outlined, controller: _emailController, isEmail: true),
                          const SizedBox(height: 16),
                          _CustomInputField(label: "Password", icon: Icons.lock_outline, isPassword: true, controller: _passwordController),
                          const Spacer(flex: 3),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _register,
                              child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("REGISTER NOW"),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Already have an account?", style: GoogleFonts.montserrat(color: AppTheme.secondaryTextColor)),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text("Login", style: GoogleFonts.montserrat(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomInputField extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPassword;
  final bool isEmail;
  final TextEditingController controller;

  const _CustomInputField({
    required this.label,
    required this.icon,
    required this.controller,
    this.isPassword = false,
    this.isEmail = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Icon(icon, color: AppTheme.primaryColor, size: 20),
          const SizedBox(width: 8),
          Text(label, style: GoogleFonts.montserrat(color: AppTheme.darkTextColor, fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppTheme.inputFieldColor,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your $label';
            }
            if (isEmail && !value.contains('@')) {
              return 'Please enter a valid email';
            }
            if (isPassword && value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
          style: GoogleFonts.montserrat(),
        ),
      ],
    );
  }
}