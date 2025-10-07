import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'loan_payment_method.dart';
import 'package:iconsax/iconsax.dart';

class PaymentTransaction {
  final String date;
  final double amount;
  final String method;
  final String status;
  final String transactionNo;

  PaymentTransaction({
    required this.date,
    required this.amount,
    required this.method,
    required this.status,
    required this.transactionNo,
  });
}

class LoanPaymentPage extends StatefulWidget {
  const LoanPaymentPage({Key? key}) : super(key: key);

  @override
  State<LoanPaymentPage> createState() => _LoanPaymentPageState();
}

class _LoanPaymentPageState extends State<LoanPaymentPage> {
  final double totalLoan = 20000;
  final double interest = 1200;
  final double paidAmount = 5000;
  final DateTime dueDate = DateTime.now().add(const Duration(days: 10));

  final List<PaymentTransaction> paymentHistory = [
    PaymentTransaction(
      date: "June 10, 2025",
      amount: 1000.00,
      method: "GCash",
      status: "Paid",
      transactionNo: "TRX123456789",
    ),
    PaymentTransaction(
      date: "May 25, 2025",
      amount: 2000.00,
      method: "Bank Transfer",
      status: "Paid",
      transactionNo: "TRX987654321",
    ),
    PaymentTransaction(
      date: "May 10, 2025",
      amount: 2000.00,
      method: "Credit Card",
      status: "Paid",
      transactionNo: "TRX543216789",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final remaining = totalLoan + interest - paidAmount;
    final progress = (paidAmount / (totalLoan + interest)).clamp(0.0, 1.0);
    final daysRemaining = dueDate.difference(DateTime.now()).inDays;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Loan Payment",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Add refresh logic here
          await Future.delayed(const Duration(seconds: 1));
        },
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildSummaryCard(context, remaining, progress, daysRemaining),
            const SizedBox(height: 24),
            _buildLoanDetailsCard(),
            const SizedBox(height: 24),
            _buildPayNowButton(context, remaining),
            const SizedBox(height: 28),
            _buildPaymentHistorySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
      BuildContext context, double remaining, double progress, int daysRemaining) {
    final bool isOverdue = daysRemaining < 0;
    final bool isDueSoon = daysRemaining <= 3 && daysRemaining >= 0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade400, Colors.green.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Amount Due",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (isOverdue)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "OVERDUE",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '₱${remaining.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                isOverdue
                    ? Iconsax.warning_2
                    : isDueSoon
                    ? Iconsax.clock
                    : Iconsax.calendar_1,
                color: Colors.white70,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                isOverdue
                    ? "Overdue by ${daysRemaining.abs()} day${daysRemaining.abs() != 1 ? 's' : ''}"
                    : "Due: ${DateFormat.yMMMMd().format(dueDate)} (${daysRemaining} day${daysRemaining != 1 ? 's' : ''})",
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              color: Colors.white,
              backgroundColor: Colors.white24,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "${(progress * 100).toStringAsFixed(1)}% Paid",
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoanDetailsCard() {
    return Container(
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
          const Text(
            "Loan Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _infoRow("Principal Amount", '₱${totalLoan.toStringAsFixed(2)}', Iconsax.money_4),
          const Divider(height: 20),
          _infoRow("Interest", '₱${interest.toStringAsFixed(2)}', Iconsax.percentage_square),
          const Divider(height: 20),
          _infoRow("Total Loan", '₱${(totalLoan + interest).toStringAsFixed(2)}',
              Iconsax.wallet_money, isHighlight: true),
          const Divider(height: 20),
          _infoRow("Amount Paid", '₱${paidAmount.toStringAsFixed(2)}', Iconsax.tick_circle,
              valueColor: Colors.green),
          const Divider(height: 20),
          _infoRow(
            "Remaining Balance",
            '₱${(totalLoan + interest - paidAmount).toStringAsFixed(2)}',
            Iconsax.wallet_3,
            isHighlight: true,
            valueColor: Colors.orange.shade700,
          ),
        ],
      ),
    );
  }

  Widget _buildPayNowButton(BuildContext context, double remaining) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SelectPaymentMethodPage(
                amountPaid: remaining,
              ),
            ),
          );
        },
        icon: const Icon(Iconsax.card, color: Colors.white, size: 22),
        label: const Text(
          "Pay Loan Now",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(vertical: 18),
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildPaymentHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Payment History",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Text(
              "${paymentHistory.length} transaction${paymentHistory.length != 1 ? 's' : ''}",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (paymentHistory.isEmpty)
          _buildEmptyState()
        else
          ...paymentHistory.map((entry) => _historyTile(context, entry)).toList(),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Iconsax.document_text, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "No payment history yet",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, IconData icon,
      {bool isHighlight = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.green.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: isHighlight ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: isHighlight ? 16 : 15,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _historyTile(BuildContext context, PaymentTransaction entry) {
    return GestureDetector(
      onTap: () => _showPaymentDetails(context, entry),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Iconsax.tick_circle,
                color: Colors.green.shade600,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '₱${entry.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry.date,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    entry.method,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Iconsax.arrow_right_3,
              color: Colors.grey.shade400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentDetails(BuildContext context, PaymentTransaction entry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                entry.status == "Paid" ? Iconsax.tick_circle : Iconsax.close_circle,
                color: entry.status == "Paid" ? Colors.green : Colors.red,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Payment Details",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            _buildDetailItem(Iconsax.calendar_1, "Payment Date", entry.date),
            _buildDetailItem(
                Iconsax.money_send, "Amount Paid", '₱${entry.amount.toStringAsFixed(2)}'),
            _buildDetailItem(Iconsax.card_pos, "Payment Method", entry.method),
            _buildDetailItem(
              entry.status == "Paid" ? Iconsax.task_square : Iconsax.warning_2,
              "Status",
              entry.status,
            ),
            _buildDetailItem(
                Iconsax.document_text_1, "Transaction No.", entry.transactionNo),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Close",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.green.shade600, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}