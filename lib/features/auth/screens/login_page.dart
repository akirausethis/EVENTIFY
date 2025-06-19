import 'package:eventify_flutter/core/theme/app_theme.dart';
import 'package:eventify_flutter/features/auth/screens/register_page.dart';
import 'package:eventify_flutter/features/shell/main_scaffold.dart';
import 'package:eventify_flutter/shared/widgets/custom_notification_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

Future<void> _login() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isLoading = true);

  try {
    await _auth.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (mounted) {
      // --- NOTIFIKASI BARU ---
      await showCustomNotificationDialog(
        context: context,
        title: "Welcome Back!",
        message: "It's great to see you again. Let's find some events!",
        type: DialogType.success,
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainScaffold()),
        (Route<dynamic> route) => false,
      );
    }

  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.message ?? 'Login failed')),
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
                  height: screenHeight * 0.65,
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
                          Text("Login", style: GoogleFonts.montserrat(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.darkTextColor)),
                          const Spacer(flex: 2),
                          _CustomInputField(label: "Email", icon: Icons.email_outlined, controller: _emailController, isEmail: true),
                          const SizedBox(height: 16),
                          _CustomInputField(label: "Password", icon: Icons.lock_outline, isPassword: true, controller: _passwordController),
                          const Spacer(flex: 3),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _login,
                              child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("LOGIN"),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("New to this App?", style: GoogleFonts.montserrat(color: AppTheme.secondaryTextColor)),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => const RegisterPage()),
                                  );
                                },
                                child: Text("Register", style: GoogleFonts.montserrat(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
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
            return null;
          },
          style: GoogleFonts.montserrat(),
        ),
      ],
    );
  }
}