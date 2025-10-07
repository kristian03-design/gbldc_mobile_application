import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'help&support_page.dart';
import 'loan-page.dart';
import 'payment_methods.dart';
import 'landing_page.dart';
import 'loan-history.dart';
import 'bank-account.dart';
import 'onboarding_screen.dart';
import 'account&security.dart';
import 'privacy_policy_page.dart';
import 'about_us_page.dart';
import 'credit_score_page.dart';

void main() {
  runApp(MaterialApp(
    home: AccountPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class AccountPage extends StatefulWidget {
  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  bool _isEmailVisible = false;

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Change Profile Picture',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Iconsax.camera, color: Colors.green),
                title: const Text('Take Photo'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? photo = await _picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 80,
                  );
                  if (photo != null) {
                    setState(() {
                      _profileImage = File(photo.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Iconsax.gallery, color: Colors.green),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                  );
                  if (image != null) {
                    setState(() {
                      _profileImage = File(image.path);
                    });
                  }
                },
              ),
              if (_profileImage != null)
                ListTile(
                  leading: const Icon(Iconsax.trash, color: Colors.red),
                  title: const Text('Remove Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _profileImage = null;
                    });
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.5,
        centerTitle: true,
        title: const Text('Account', style: TextStyle(color: Colors.black)),
        actions: [],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Profile Section
          Row(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 34,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!) as ImageProvider
                      : const AssetImage('assets/images/2x2.jpg'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Kristian Lloyd Hernandez',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _isEmailVisible
                                ? 'hkris*********@gmail.com'
                                : '••••••••••@gmail.com',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isEmailVisible = !_isEmailVisible;
                            });
                          },
                          child: Icon(
                            _isEmailVisible ? Iconsax.eye : Iconsax.eye_slash,
                            size: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),
          _buildSectionTitle('Settings',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          _buildMenuItem(Iconsax.security_user, 'Account & Security', onTap: () {
            Navigator.push(
                context, _fadeRoute(const AccountSecurityPage()));
          }),

          const SizedBox(height: 30),
          _buildSectionTitle('Manage',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          _buildMenuItem(Iconsax.document_text, 'Loan History', onTap: () {
            Navigator.push(context, _fadeRoute(LoanHistoryPage()));
          }),
          _buildMenuItem(Iconsax.chart_1, 'Credit Score', onTap: () {
            Navigator.push(context, _fadeRoute(const CreditScorePage()));
          }),
          _buildMenuItem(Iconsax.bank, 'Bank Account', onTap: () {
            Navigator.push(context, _fadeRoute(const BankAccountPage()));
          }),
          _buildMenuItem(Iconsax.wallet_2, 'Payment Methods', onTap: () {
            Navigator.push(context, _fadeRoute(const PaymentMethods()));
          }),
          _buildMenuItem(Iconsax.message_question, 'Help & Support', onTap: () {
            Navigator.push(context, _fadeRoute(const HelpSupportPage()));
          }),
          _buildMenuItem(Iconsax.info_circle, 'About Us', onTap: () {
            Navigator.push(context, _fadeRoute(const AboutUsPage()));
          }),
          _buildMenuItem(Iconsax.shield_tick, 'Privacy Policy', onTap: () {
            Navigator.push(context, _fadeRoute(const PrivacyPolicyPage()));
          }),
          _buildMenuItem(Iconsax.logout, 'Logout',
              iconColor: Colors.red, textColor: Colors.red, onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(10.0)),
                  ),
                  builder: (BuildContext context) {
                    return Padding(
                      padding: const EdgeInsets.all(45.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Logout',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              fontFamily: 'Poppins',
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Are you sure you want to logout?',
                            style:
                            TextStyle(fontSize: 14, fontFamily: 'Poppins'),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    backgroundColor: Colors.green[50],
                                  ),
                                  child: Text('Cancel',
                                      style:
                                      TextStyle(color: Colors.green[600])),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                      _fadeRoute(OnboardingScreen()),
                                          (Route<dynamic> route) => false,
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                  child: const Text('Yes, Logout',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: 2,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(context, _fadeRoute(LandingPage()));
          } else if (index == 1) {
            Navigator.push(context, _fadeRoute(LoanPageHomepage()));
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Iconsax.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Iconsax.money), label: 'Loan'),
          BottomNavigationBarItem(
              icon: Icon(Iconsax.profile_circle), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title,
      {VoidCallback? onTap,
        Widget? trailing,
        Color? iconColor,
        Color? textColor}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Icon(icon, color: iconColor ?? Colors.black),
      title: Text(title,
          style: TextStyle(
              color: textColor ?? Colors.black, fontWeight: FontWeight.w500)),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildSectionTitle(String title, {TextStyle? style}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(title,
          style: style ??
              const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54)),
    );
  }

  PageRouteBuilder _fadeRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 800),
      pageBuilder: (context, animation, _) => page,
      transitionsBuilder: (context, animation, _, child) {
        final curved =
        CurvedAnimation(parent: animation, curve: Curves.easeInOut);
        return FadeTransition(opacity: curved, child: child);
      },
    );
  }
}