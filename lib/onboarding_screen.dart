import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_form.dart';
import 'register.dart';
import 'package:iconsax/iconsax.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _introKey = GlobalKey<IntroductionScreenState>();
  int _currentPage = 0;

  Future<void> _onIntroEnd(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_onboarding', true);
  }

  void _navigateToLogin() async {
    await _onIntroEnd(context);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, _) => const LoginScreen(),
        transitionsBuilder: (context, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _navigateToRegister() async {
    await _onIntroEnd(context);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, _) => const RegisterScreen(),
        transitionsBuilder: (context, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: IntroductionScreen(
          key: _introKey,
          globalBackgroundColor: Colors.white,
          allowImplicitScrolling: false,
          isProgress: true,
          isProgressTap: false,
          freeze: false,
          onChange: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          pages: [
            PageViewModel(
              title: '',
              bodyWidget: _buildOnboardingPage(
                'assets/images/secure.png',
                'Secure & Fast Loans',
                'Access quick and reliable loans with competitive interest rates tailored to your financial needs.',
                Iconsax.security_safe,
                isLast: false,
              ),
              decoration: _getPageDecoration(),
            ),
            PageViewModel(
              title: '',
              bodyWidget: _buildOnboardingPage(
                'assets/images/loan.jpg',
                'Easy Loan Management',
                'Track your loans, payments, and financial progress all in one convenient place with our intuitive dashboard.',
                Iconsax.chart_success,
                isMiddle: true,
              ),
              decoration: _getPageDecoration(),
            ),
            PageViewModel(
              title: '',
              bodyWidget: _buildOnboardingPage(
                'assets/images/customer_support.jpg',
                '24/7 Customer Support',
                'Our dedicated support team is always ready to assist you with any questions or concerns you may have.',
                Iconsax.support,
              ),
              decoration: _getPageDecoration(),
            ),
            PageViewModel(
              title: '',
              bodyWidget: _buildOnboardingPage(
                'assets/images/joinus.jpg',
                'Welcome to GBLDC',
                'Join us today and take the first step towards a brighter financial future!',
                Iconsax.money_3,
                isLast: true,
              ),
              decoration: _getPageDecoration(),
            ),
          ],
          onDone: () => _onIntroEnd(context),
          showSkipButton: false,
          showNextButton: false,
          showDoneButton: false,
          next: const SizedBox.shrink(),
          done: const SizedBox.shrink(),
          dotsDecorator: DotsDecorator(
            size: const Size(8, 8),
            activeSize: const Size(24, 8),
            activeColor: const Color(0xFF16A34A),
            color: Colors.grey.shade300,
            spacing: const EdgeInsets.symmetric(horizontal: 4),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          controlsMargin: const EdgeInsets.all(25),
          controlsPadding: const EdgeInsets.all(0),
          dotsContainerDecorator: const BoxDecoration(
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(
      String imagePath,
      String title,
      String description,
      IconData fallbackIcon, {
        bool isLast = false,
        bool isMiddle = false,
      }) {
    final screenHeight = MediaQuery.of(context).size.height;
    final safeHeight = screenHeight - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom;

    return SizedBox(
      height: safeHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 20),

            // Image section with fixed height
            SizedBox(
              height: safeHeight * 0.30,
              child: Center(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: safeHeight * 0.35,
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Icon(
                          fallbackIcon,
                          size: 100,
                          color: const Color(0xFF16A34A),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Text section with fixed constraints
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Button section
            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (isLast) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _navigateToLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF16A34A),
                          minimumSize: const Size.fromHeight(54),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Login to your account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _navigateToRegister,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF16A34A),
                          side: const BorderSide(color: Color(0xFF16A34A), width: 2),
                          minimumSize: const Size.fromHeight(54),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Create a new account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 140),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _introKey.currentState?.next(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF16A34A),
                          minimumSize: const Size.fromHeight(54),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PageDecoration _getPageDecoration() {
    return const PageDecoration(
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
      contentMargin: EdgeInsets.zero,
      bodyPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      bodyAlignment: Alignment.center,
      imageAlignment: Alignment.center,
    );
  }
}