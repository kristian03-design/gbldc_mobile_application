import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'loan-page.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:math' as math;

class PaymentConfirmationPage extends StatefulWidget {
  final double amountPaid;
  final String paymentMethod;
  final String transactionNumber;

  const PaymentConfirmationPage({
    super.key,
    required this.amountPaid,
    this.paymentMethod = "GCash",
    required this.transactionNumber,
  });

  @override
  State<PaymentConfirmationPage> createState() =>
      _PaymentConfirmationPageState();
}

class _PaymentConfirmationPageState extends State<PaymentConfirmationPage>
    with TickerProviderStateMixin {
  late final AnimationController _checkController;
  late final AnimationController _fadeController;
  late final AnimationController _scaleController;
  late final AnimationController _confettiController;

  late final Animation<double> _checkAnimation;
  late final Animation<double> _fadeIn;
  late final Animation<double> _scaleAnimation;

  bool _showConfetti = true;

  @override
  void initState() {
    super.initState();

    // Check mark animation
    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _checkAnimation = CurvedAnimation(
      parent: _checkController,
      curve: Curves.elasticOut,
    );

    // Fade in animation
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeIn = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    // Scale animation
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    );

    // Confetti animation
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Trigger animations
    Future.delayed(const Duration(milliseconds: 200), () {
      _checkController.forward();
      _confettiController.forward();
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      _fadeController.forward();
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      _scaleController.forward();
    });

    // Hide confetti after animation
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _showConfetti = false);
      }
    });

    // Haptic feedback
    HapticFeedback.heavyImpact();
  }

  @override
  void dispose() {
    _checkController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    HapticFeedback.mediumImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Iconsax.tick_circle, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Text('Copied: $text'),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareReceipt() {
    // TODO: Implement share functionality
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Iconsax.share, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            const Text('Share receipt functionality'),
          ],
        ),
        backgroundColor: Colors.blue.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _downloadReceipt() {
    // TODO: Implement download functionality
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Iconsax.document_download, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            const Text('Receipt downloaded successfully'),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate =
    DateFormat('MMMM d, y – hh:mm a').format(DateTime.now());
    final String formattedTime = DateFormat('hh:mm a').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          // Confetti effect
          if (_showConfetti)
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: ConfettiPainter(
                    animation: _confettiController,
                  ),
                ),
              ),
            ),

          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(24.0),
                    children: [
                      const SizedBox(height: 20),

                      // Success Icon with Animation
                      Center(
                        child: ScaleTransition(
                          scale: _checkAnimation,
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.green.shade400,
                                  Colors.green.shade600,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.4),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Iconsax.tick_circle5,
                              color: Colors.white,
                              size: 80,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Success Message
                      FadeTransition(
                        opacity: _fadeIn,
                        child: Column(
                          children: [
                            const Text(
                              "Payment Successful!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Your payment has been processed",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Amount Card
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.green.shade50,
                                Colors.green.shade100,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.green.shade200,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Amount Paid",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "₱${widget.amountPaid.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade700,
                                  letterSpacing: -1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Transaction Details Card
                      FadeTransition(
                        opacity: _fadeIn,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Iconsax.receipt_text,
                                      color: Colors.blue.shade600,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    "Transaction Details",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF111827),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              _buildDetailRow(
                                icon: Iconsax.calendar_1,
                                label: "Payment Date",
                                value: DateFormat('MMM d, y').format(DateTime.now()),
                                iconColor: Colors.purple,
                              ),
                              const Divider(height: 24),
                              _buildDetailRow(
                                icon: Iconsax.clock,
                                label: "Payment Time",
                                value: formattedTime,
                                iconColor: Colors.orange,
                              ),
                              const Divider(height: 24),
                              _buildDetailRow(
                                icon: Iconsax.document_text_1,
                                label: "Transaction Number",
                                value: widget.transactionNumber,
                                iconColor: Colors.blue,
                                isCopyable: true,
                                onCopy: () => _copyToClipboard(widget.transactionNumber),
                              ),
                              const Divider(height: 24),
                              _buildDetailRow(
                                icon: Iconsax.wallet_check,
                                label: "Payment Method",
                                value: widget.paymentMethod,
                                iconColor: Colors.green,
                              ),
                              const Divider(height: 24),
                              _buildDetailRow(
                                icon: Iconsax.money_send,
                                label: "Amount Paid",
                                value: "₱${widget.amountPaid.toStringAsFixed(2)}",
                                iconColor: Colors.teal,
                                isHighlight: true,
                              ),
                              const Divider(height: 24),
                              _buildDetailRow(
                                icon: Iconsax.shield_tick,
                                label: "Status",
                                value: "Completed",
                                iconColor: Colors.green,
                                showBadge: true,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Action Buttons
                      FadeTransition(
                        opacity: _fadeIn,
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _downloadReceipt,
                                icon: const Icon(Iconsax.document_download, size: 20),
                                label: const Text("Download"),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.green,
                                  side: BorderSide(color: Colors.green.shade300),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _shareReceipt,
                                icon: const Icon(Iconsax.share, size: 20),
                                label: const Text("Share"),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.blue,
                                  side: BorderSide(color: Colors.blue.shade300),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Info Note
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.shade100),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Iconsax.info_circle,
                              color: Colors.blue.shade700,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "Keep this receipt for your records. An email confirmation has been sent.",
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
                    24,
                    16,
                    24,
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
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => LoanPageHomepage()),
                                (route) => false,
                          );
                        },
                        icon: const Icon(Iconsax.home_2, color: Colors.white, size: 20),
                        label: const Text(
                          "Back to Loan Page",
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
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
    bool isCopyable = false,
    bool isHighlight = false,
    bool showBadge = false,
    VoidCallback? onCopy,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: isHighlight ? 16 : 15,
                        fontWeight: FontWeight.w600,
                        color: isHighlight ? Colors.green.shade700 : const Color(0xFF111827),
                      ),
                    ),
                  ),
                  if (showBadge)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        value,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        if (isCopyable)
          IconButton(
            onPressed: onCopy,
            icon: Icon(
              Iconsax.copy,
              size: 18,
              color: Colors.grey[600],
            ),
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
            visualDensity: VisualDensity.compact,
          ),
      ],
    );
  }
}

// Confetti Painter for celebration effect
class ConfettiPainter extends CustomPainter {
  final Animation<double> animation;
  final List<ConfettiParticle> particles;

  ConfettiPainter({required this.animation})
      : particles = List.generate(50, (index) => ConfettiParticle()),
        super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final progress = animation.value;
      final x = particle.startX * size.width;
      final y = particle.startY * size.height + (progress * size.height * 1.2);
      final opacity = (1 - progress).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = particle.color.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(progress * particle.rotation);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset.zero,
            width: particle.size,
            height: particle.size * 2,
          ),
          const Radius.circular(2),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) => true;
}

class ConfettiParticle {
  final double startX;
  final double startY;
  final double size;
  final double rotation;
  final Color color;

  ConfettiParticle()
      : startX = math.Random().nextDouble(),
        startY = -0.1 + math.Random().nextDouble() * 0.1,
        size = 4 + math.Random().nextDouble() * 4,
        rotation = math.Random().nextDouble() * math.pi * 4,
        color = [
          Colors.red,
          Colors.blue,
          Colors.green,
          Colors.yellow,
          Colors.orange,
          Colors.purple,
          Colors.pink,
        ][math.Random().nextInt(7)];
}