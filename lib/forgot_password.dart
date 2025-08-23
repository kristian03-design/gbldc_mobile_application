import 'package:flutter/material.dart';
import 'package:gbldc_app/CreateNewPasswordPage.dart';
import 'package:iconsax/iconsax.dart';

void main() {
  runApp(MaterialApp(
    home: ForgotPasswordPage(),
    theme: ThemeData(
      fontFamily: 'Poppins',
      primarySwatch: Colors.green,
    ),
    debugShowCheckedModeBanner: false,
  ));
}
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final TextEditingController emailController = TextEditingController();

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
    _dialogController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void _showResetConfirmationDialog() {
    _dialogController.forward();
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Reset Success",
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (context, anim1, anim2, _) {
        return ScaleTransition(
          scale: _dialogScale,
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                      Iconsax.tick_circle, size: 48, color: Colors.green),
                  const SizedBox(height: 12),
                  const Text(
                    "Reset Link Sent",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "We’ve sent a password reset link to your email. Please check your inbox.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14,
                        color: Colors.black54,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400),
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
                              builder: (
                                  context) => const CreateNewPasswordPage()),
                        );
                      },
                      child: const Text(
                        "OK",
                        style: TextStyle(
                            color: Colors.white,
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

  void _submitResetRequest() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      // Simulate network request
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });
        _showResetConfirmationDialog();      });
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
          "Forgot Password",
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(
                Iconsax.lock_1,
                size: 100,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Reset Your Password",
              style: TextStyle(fontSize: 22,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 10),
            const Text(
              "Enter your email address and we’ll send you a link to reset your password.",
              style: TextStyle(fontSize: 14,
                  color: Colors
                      .black54), // Removed fontFamily to inherit from theme
            ),
            const SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(fontSize: 15, fontFamily: 'Poppins'),
                    decoration: InputDecoration(
                      labelText: "Email Address",
                      prefixIcon: const Icon(Iconsax.sms, color: Colors.green),
                      hintText: "example@email.com",
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Colors.green, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email is required";
                      }
                      if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(
                          value)) {
                        return "Enter a valid email address";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitResetRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white),
                        ),
                      )
                          : const Text(
                          "Send Reset Link",
                          style: TextStyle(fontSize: 16, color: Colors.white)
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Additional help text
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade600),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Make sure to check your spam folder if you don't see the reset email in your inbox.",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}