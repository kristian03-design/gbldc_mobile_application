import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'payment-confirmation.dart';
import 'package:iconsax/iconsax.dart';

class PaymentMethodOption {
  final String name;
  final String imagePath;
  final String description;
  final bool isEnabled;

  PaymentMethodOption({
    required this.name,
    required this.imagePath,
    required this.description,
    this.isEnabled = true,
  });
}

class SelectPaymentMethodPage extends StatefulWidget {
  final double amountPaid;

  const SelectPaymentMethodPage({Key? key, required this.amountPaid})
      : super(key: key);

  @override
  _SelectPaymentMethodPageState createState() =>
      _SelectPaymentMethodPageState();
}

class _SelectPaymentMethodPageState extends State<SelectPaymentMethodPage> {
  String _selectedMethod = 'GCash';
  double? _customAmount;
  bool _isProcessing = false;
  final _formKey = GlobalKey<FormState>();

  final List<PaymentMethodOption> paymentMethods = [
    PaymentMethodOption(
      name: 'GCash',
      imagePath: 'assets/images/g-cash.jpeg',
      description: 'Instant transfer via GCash wallet',
    ),
    PaymentMethodOption(
      name: 'Maya',
      imagePath: 'assets/images/maya.jpeg',
      description: 'Pay using Maya e-wallet',
    ),
    PaymentMethodOption(
      name: 'PayPal',
      imagePath: 'assets/images/gbldc_paypal.png',
      description: 'Secure international payments',
    ),
    PaymentMethodOption(
      name: 'Credit Card',
      imagePath: 'assets/images/visa-card.png',
      description: 'Visa, Mastercard, JCB accepted',
    ),
  ];

  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.amountPaid.toStringAsFixed(2);
    _customAmount = widget.amountPaid;
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _navigateToConfirmation() {
    if (_customAmount == null || _customAmount! <= 0) {
      _showErrorSnackBar('Please enter a valid payment amount');
      return;
    }

    if (_customAmount! > widget.amountPaid) {
      _showErrorSnackBar('Amount cannot exceed the total due amount');
      return;
    }

    setState(() => _isProcessing = true);

    // Simulate processing delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;

      setState(() => _isProcessing = false);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentConfirmationPage(
            amountPaid: _customAmount!,
            paymentMethod: _selectedMethod,
            transactionNumber: _generateTransactionNumber(),
          ),
        ),
      );
    });
  }

  String _generateTransactionNumber() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'TRX$timestamp';
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Iconsax.warning_2, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showConfirmationModal() {
    if (_customAmount == null || _customAmount! <= 0) {
      _showErrorSnackBar('Please enter a valid payment amount');
      return;
    }

    if (_customAmount! > widget.amountPaid) {
      _showErrorSnackBar('Amount cannot exceed the total due amount');
      return;
    }

    HapticFeedback.mediumImpact();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Iconsax.receipt_text,
                          color: Colors.green, size: 24),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Payment Summary",
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      _summaryRow(Iconsax.money_send, "Amount to Pay",
                          '₱${_customAmount!.toStringAsFixed(2)}', isHighlight: true),
                      const Divider(height: 20),
                      _summaryRow(Iconsax.percentage_circle, "Interest Rate", "6%"),
                      const Divider(height: 20),
                      _summaryRow(Iconsax.card_pos, "Payment Type",
                          _customAmount == widget.amountPaid ? "Full Payment" : "Partial Payment"),
                      const Divider(height: 20),
                      _summaryRow(
                          Iconsax.wallet_check, "Payment Method", _selectedMethod),
                      if (_customAmount! < widget.amountPaid) ...[
                        const Divider(height: 20),
                        _summaryRow(
                          Iconsax.wallet_3,
                          "Remaining Balance",
                          '₱${(widget.amountPaid - _customAmount!).toStringAsFixed(2)}',
                          valueColor: Colors.orange.shade700,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Iconsax.close_circle,
                            color: Colors.black87, size: 20),
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        label: const Text("Cancel",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        icon: _isProcessing
                            ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white),
                          ),
                        )
                            : const Icon(Iconsax.tick_circle,
                            color: Colors.white, size: 20),
                        onPressed: _isProcessing
                            ? null
                            : () {
                          Navigator.pop(context);
                          _navigateToConfirmation();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        label: Text(
                          _isProcessing ? "Processing..." : "Confirm Payment",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _summaryRow(IconData icon, String title, String value,
      {bool isHighlight = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Colors.green.shade600),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: isHighlight ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isHighlight ? 16 : 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _loanInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.green.shade600),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _paymentMethodTile(PaymentMethodOption method) {
    final isSelected = _selectedMethod == method.name;

    return GestureDetector(
      onTap: method.isEnabled
          ? () {
        setState(() {
          _selectedMethod = method.name;
        });
        HapticFeedback.selectionClick();
      }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.green.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage(method.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    method.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.green : Colors.grey.shade300,
                  width: 2,
                ),
                color: isSelected ? Colors.green : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAmountButtons() {
    final amounts = [
      widget.amountPaid * 0.25,
      widget.amountPaid * 0.5,
      widget.amountPaid * 0.75,
      widget.amountPaid,
    ];
    final labels = ['25%', '50%', '75%', 'Full'];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(amounts.length, (index) {
        return InkWell(
          onTap: () {
            setState(() {
              _customAmount = amounts[index];
              _amountController.text = amounts[index].toStringAsFixed(2);
            });
            HapticFeedback.lightImpact();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: _customAmount == amounts[index]
                  ? Colors.green
                  : Colors.green.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _customAmount == amounts[index]
                    ? Colors.green
                    : Colors.green.shade200,
              ),
            ),
            child: Text(
              '${labels[index]} (₱${amounts[index].toStringAsFixed(2)})',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _customAmount == amounts[index]
                    ? Colors.white
                    : Colors.green.shade700,
              ),
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final remainingAmount = widget.amountPaid - (_customAmount ?? 0);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Select Payment Method',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Loan Summary Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Iconsax.document_text,
                                color: Colors.green, size: 20),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "Loan Summary",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _loanInfoRow(Iconsax.money_send, "Total Amount Due",
                          '₱${widget.amountPaid.toStringAsFixed(2)}'),
                      _loanInfoRow(
                          Iconsax.percentage_circle, "Interest Rate", "6%"),
                      _loanInfoRow(Iconsax.card_pos, "Payment Type",
                          "Partial / Full"),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Amount Input Section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Iconsax.wallet_money,
                                color: Colors.green, size: 20),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "Enter Amount to Pay",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          onChanged: (value) {
                            setState(() {
                              _customAmount = double.tryParse(value) ?? 0;
                            });
                          },
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            prefixIcon:
                            const Icon(Iconsax.wallet_2, color: Colors.green),
                            prefixText: "₱ ",
                            prefixStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            hintText: "0.00",
                            filled: true,
                            fillColor: Colors.grey[50],
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
                              borderSide:
                              const BorderSide(color: Colors.green, width: 2),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildQuickAmountButtons(),
                      if (remainingAmount > 0 &&
                          _customAmount != null &&
                          _customAmount! < widget.amountPaid) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.orange.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(Iconsax.info_circle,
                                  color: Colors.orange.shade700, size: 18),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Remaining balance: ₱${remainingAmount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.orange.shade900,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Payment Methods Section
                const Text(
                  "Choose Payment Method",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...paymentMethods.map((method) => _paymentMethodTile(method)),

                const SizedBox(height: 20),

                // Info Note
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Iconsax.shield_tick,
                          color: Colors.blue.shade700, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "You can make a partial payment or pay the full amount. All transactions are secure and encrypted.",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue.shade900,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Button
          Container(
            padding: EdgeInsets.fromLTRB(
              20,
              16,
              20,
              MediaQuery.of(context).padding.bottom + 16,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _showConfirmationModal,
                  icon: const Icon(Iconsax.arrow_right_1,
                      color: Colors.white, size: 20),
                  label: const Text(
                    "Proceed to Pay",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}