import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'login_form.dart';

class CreateNewPasswordPage extends StatefulWidget {
  const CreateNewPasswordPage({super.key});

  @override
  State<CreateNewPasswordPage> createState() => _CreateNewPasswordPageState();
}

class _CreateNewPasswordPageState extends State<CreateNewPasswordPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  late AnimationController _dialogController;
  late Animation<double> _dialogScale;

  @override
  void initState() {
    super.initState();
    _dialogController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _dialogScale = CurvedAnimation(
      parent: _dialogController,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    _dialogController.dispose();
    super.dispose();
  }

  void _showSuccessDialog() {
    _dialogController.forward();
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 400),
      barrierLabel: "Success",
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (_, anim1, __, ___) {
        return ScaleTransition(
          scale: _dialogScale,
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Iconsax.tick_circle, size: 48, color: Colors.green),
                  const SizedBox(height: 12),
                  const Text(
                    "Password Updated",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins'),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Your new password has been successfully set. You can now log in.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontWeight: FontWeight.w400, fontFamily: 'Poppins'),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.green,
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Continue",
                        style: TextStyle(
                            color: Colors.white, // Changed to white for better contrast
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins'),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _submitNewPassword() {
    if (_formKey.currentState!.validate()) {
      Future.delayed(const Duration(milliseconds: 400), () {
        _showSuccessDialog();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "Create New Password",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Icon(Iconsax.key, size: 100, color: Colors.green),
              ),
              const SizedBox(height: 30),
              const Text(
                "Set a New Password",
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 10),
              const Text(
                "Your new password must be different from your previous password.",
                style: TextStyle(
                    fontSize: 14, color: Colors.black54, fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 30),
              // New Password Field
              TextFormField(
                controller: newPasswordController,
                obscureText: _obscureNew,
                decoration: InputDecoration(
                  labelText: "New Password",
                  prefixIcon: const Icon(Iconsax.lock),
                  labelStyle: const TextStyle(fontFamily: 'Poppins'),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureNew ? Iconsax.eye : Iconsax.eye_slash),
                    onPressed: () => setState(() => _obscureNew = !_obscureNew),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.green)),
                ),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Confirm Password Field
              TextFormField(
                controller: confirmPasswordController,
                obscureText: _obscureConfirm,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  prefixIcon: const Icon(Iconsax.lock_1),
                  labelStyle: const TextStyle(fontFamily: 'Poppins'),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirm ? Iconsax.eye : Iconsax.eye_slash),
                    onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.green)),
                ),
                validator: (value) {
                  if (value != newPasswordController.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submitNewPassword,
                  icon: const Icon(Iconsax.password_check, size: 20, color: Colors.white),
                  label: const Text("Set New Password",
                      style: TextStyle(
                          fontSize: 16, color: Colors.white, fontFamily: 'Poppins', fontWeight: FontWeight.w500)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
