import 'package:flutter/material.dart';
import 'enter-otp-code.dart';
import 'register.dart';
import 'forgot_password.dart';
import 'package:iconsax/iconsax.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = false;
  bool obscurePassword = true;

  Widget _buildCenteredSuccessDialog() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        bool isLoading = true;

        // Trigger success transition after delay
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              isLoading = false;
            });

            // Auto-close after showing success
            Future.delayed(const Duration(seconds: 1), () {
              if (Navigator.canPop(context)) Navigator.of(context).pop();
            });
          }
        });

        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(28),
            constraints: const BoxConstraints(minHeight: 180),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeInOut,
                  child: isLoading
                      ? const CircularProgressIndicator(
                    key: ValueKey("loading"),
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF16A34A)),
                    strokeWidth: 3,
                  )
                      : const Icon(
                    Iconsax.tick_circle,
                    key: ValueKey("success"),
                    size: 60,
                    color: Color(0xFF16A34A),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  isLoading ? "Logging you in..." : "Login Successful!",
                  key: ValueKey("title-${DateTime
                      .now()
                      .millisecondsSinceEpoch}"),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  isLoading
                      ? "Please wait while we redirect you..."
                      : "Redirecting to your OTP verification screen...",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Column(
            children: [
              // Logo
              Image.asset('assets/images/logocoop.png', height: 70),
              const SizedBox(height: 30),

              // Welcome Text
              const Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Login to access your account',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),

              // Email Field
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'Enter your email',
                  filled: true,
                  fillColor: const Color(0xFFF1F1F1),
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Password Field
              TextField(
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  filled: true,
                  fillColor: const Color(0xFFF1F1F1),
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword ? Iconsax.eye_slash : Iconsax.eye,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Remember Me + Forgot Password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: rememberMe,
                        onChanged: (val) {
                          setState(() => rememberMe = val!);
                        },
                        activeColor: const Color(0xFF16A34A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const Text("Remember me"),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 800),
                          pageBuilder: (context, animation, _) =>
                          const ForgotPasswordPage(),
                          transitionsBuilder: (context, animation, _, child) {
                            final curved = CurvedAnimation(
                                parent: animation, curve: Curves.easeInOut);
                            return FadeTransition(
                                opacity: curved, child: child);
                          },
                        ),
                      );
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Color(0xFF16A34A)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => _buildCenteredSuccessDialog(),
                    );
                    // Simulate delay before navigating
                    await Future.delayed(const Duration(milliseconds: 500));

                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 800),
                        pageBuilder: (context, animation,
                            _) => const OtpScreen(),
                        transitionsBuilder: (context, animation, _, child) {
                          final curved = CurvedAnimation(
                              parent: animation, curve: Curves.easeInOut);
                          return FadeTransition(opacity: curved, child: child);
                        },
                      ),
                    );
                  },


                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF16A34A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 1,
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Divider with "or continue with"
              Row(
                children: [
                  const Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Or continue with',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  const Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Social Login Buttons
              Column(
                children: [
                  _buildSocialButton(
                    iconPath: 'assets/images/google-logo.png',
                    text: 'Sign in with Google',
                    backgroundColor: const Color.fromARGB(255, 233, 233, 233),
                    foregroundColor: Colors.black87,
                    onTap: _handleGoogleSignIn,
                  ),
                  const SizedBox(height: 12),
                  _buildSocialButton(
                    iconPath: 'assets/images/facebook.png',
                    text: 'Sign in with Facebook',
                    backgroundColor: Color(0xFF1877F2),
                    foregroundColor: Colors.white,
                    onTap: _handleFacebookSignIn,
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 800),
                          pageBuilder: (context, animation, _) =>
                          const RegisterScreen(),
                          transitionsBuilder: (context, animation, _, child) {
                            final curved = CurvedAnimation(
                                parent: animation, curve: Curves.easeInOut);
                            return FadeTransition(
                                opacity: curved, child: child);
                          },
                        ),
                      );
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF16A34A),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required String iconPath,
    required String text,
    required Color backgroundColor,
    required Color foregroundColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconPath, height: 22),
            const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                  color: foregroundColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w500
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      final GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account != null) {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (context, animation, _) => const OtpScreen(),
            transitionsBuilder: (context, animation, _, child) {
              final curved =
              CurvedAnimation(parent: animation, curve: Curves.easeInOut);
              return FadeTransition(opacity: curved, child: child);
            },
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google sign-in cancelled')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In Error: $error')),
      );
    }
  }


  Future<void> _handleFacebookSignIn() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData();
        print('Facebook User Data: $userData');

        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (context, animation, _) => const OtpScreen(),
            transitionsBuilder: (context, animation, _, child) {
              final curved = CurvedAnimation(
                  parent: animation, curve: Curves.easeInOut);
              return FadeTransition(opacity: curved, child: child);
            },
          ),
        );
      } else if (result.status == LoginStatus.cancelled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Facebook login cancelled')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Facebook login failed: ${result.message}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Facebook login error: $error')),
      );
    }
  }
}