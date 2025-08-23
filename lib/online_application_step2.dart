import 'package:flutter/material.dart';
import 'online_application_step3.dart';

class BusinessInformationForm extends StatefulWidget {
  const BusinessInformationForm({super.key});

  @override
  State<BusinessInformationForm> createState() => _BusinessInformationFormState();
}

class _BusinessInformationFormState extends State<BusinessInformationForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController numEmployeesController = TextEditingController();
  final TextEditingController businessAddressController = TextEditingController();

  String? selectedBusinessType;
  String? selectedBusinessStructure;
  String? selectedYearsInBusiness;
  String? selectedGrossIncome;
  String? selectedNetIncome;

  List<String> businessTypes = [
    'Retail',
    'Food & Beverage',
    'Services',
    'Manufacturing',
    'Agriculture',
    'Construction',
    'Transport & Logistics',
    'IT/Online Business',
    'Other'
  ];

  List<String> businessStructures = [
    'Sole Proprietorship',
    'Partnership',
    'Corporation',
    'Freelancer / Self-Employed'
  ];

  List<String> yearsInBusiness = [
    'Less than 1 year',
    '1-2 years',
    '3-5 years',
    'More than 5 years'
  ];

  List<String> incomeRanges = [
    'Below ₱10,000',
    '₱10,000 - ₱20,000',
    '₱20,001 - ₱50,000',
    '₱50,001 - ₱100,000',
    'Above ₱100,000'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Text(
              "Step 2 of 6",
              style: TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const LinearProgressIndicator(
                  value: 0.4,
                  color: Colors.green,
                  backgroundColor: Color(0xFFE0E0E0),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Business Information",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Provide your business details for loan evaluation. More information helps us assess your eligibility faster.",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 25),

                _buildLabel("Business Name"),
                _buildInput(controller: businessNameController, hint: "Enter your registered business name"),
                const SizedBox(height: 20),

                _buildLabel("Business Type"),
                _buildDropdown(
                  value: selectedBusinessType,
                  items: businessTypes,
                  onChanged: (value) => setState(() => selectedBusinessType = value),
                  hint: 'Select business type',
                ),
                const SizedBox(height: 20),

                _buildLabel("Business Structure"),
                _buildDropdown(
                  value: selectedBusinessStructure,
                  items: businessStructures,
                  onChanged: (value) => setState(() => selectedBusinessStructure = value),
                  hint: 'Select business structure',
                ),
                const SizedBox(height: 20),

                _buildLabel("Years in Business"),
                _buildDropdown(
                  value: selectedYearsInBusiness,
                  items: yearsInBusiness,
                  onChanged: (value) => setState(() => selectedYearsInBusiness = value),
                  hint: 'Select duration',
                ),
                const SizedBox(height: 20),

                _buildLabel("Monthly Gross Income"),
                _buildDropdown(
                  value: selectedGrossIncome,
                  items: incomeRanges,
                  onChanged: (value) => setState(() => selectedGrossIncome = value),
                  hint: 'Select gross income range',
                ),
                const SizedBox(height: 20),

                _buildLabel("Monthly Net Income"),
                _buildDropdown(
                  value: selectedNetIncome,
                  items: incomeRanges,
                  onChanged: (value) => setState(() => selectedNetIncome = value),
                  hint: 'Select net income range',
                ),
                const SizedBox(height: 20),

                _buildLabel("Number of Employees"),
                _buildInput(controller: numEmployeesController, hint: "Enter total employees (if any)", keyboardType: TextInputType.number),
                const SizedBox(height: 20),

                _buildLabel("Business Address"),
                _buildInput(controller: businessAddressController, hint: "Enter your business address"),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: const Duration(milliseconds: 800),
                            pageBuilder: (context, animation, _) => const EmergencyContactsPage(),
                            transitionsBuilder: (context, animation, _, child) {
                              final curved = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
                              return FadeTransition(opacity: curved, child: child);
                            },
                          ),
                        );
                      }
                    },
                    label: const Text(
                      "Continue",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.green, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required String hint,
  }) {
    return DropdownButtonFormField<String>(
      dropdownColor: Colors.white,
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
      value: value,
      onChanged: onChanged,
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.green, width: 1.5),
        ),
      ),
    );
  }
}
