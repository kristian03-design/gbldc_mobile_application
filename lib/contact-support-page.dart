import 'package:flutter/material.dart';
import 'dart:async';
import 'package:iconsax/iconsax.dart';

class LiveChatPage extends StatefulWidget {
  const LiveChatPage({super.key});

  @override
  State<LiveChatPage> createState() => _LiveChatPageState();
}

class _LiveChatPageState extends State<LiveChatPage> with TickerProviderStateMixin {
  final List<Map<String, dynamic>> messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool isTyping = false;
  bool showQuickQuestions = true;
  late AnimationController _typingAnimController;

  final List<Map<String, String>> quickQuestions = [
    {'icon': '📝', 'text': 'How to apply for a loan?'},
    {'icon': '💰', 'text': 'What are the interest rates?'},
    {'icon': '💳', 'text': 'Can I make a partial payment?'},
    {'icon': '📊', 'text': 'How to check my loan status?'},
    {'icon': '📞', 'text': 'Where can I contact support?'},
  ];

  @override
  void initState() {
    super.initState();
    _typingAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    // Welcome message
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          messages.add({
            "sender": "support",
            "text": "Hi! Welcome to GBLDC Support 👋\n\nHow can I help you today?",
            "time": DateTime.now(),
          });
        });
        _scrollToBottom();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    _typingAnimController.dispose();
    super.dispose();
  }

  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;

    setState(() {
      messages.add({
        "sender": "user",
        "text": message,
        "time": DateTime.now(),
      });
      isTyping = true;
      showQuickQuestions = false;
    });

    _controller.clear();
    _scrollToBottom();

    // Simulate typing delay (1-2 seconds)
    final typingDelay = Duration(milliseconds: 800 + (message.length * 20));
    Future.delayed(typingDelay, () {
      if (mounted) {
        final reply = _getAutoReply(message);
        setState(() {
          messages.add({
            "sender": "support",
            "text": reply,
            "time": DateTime.now(),
          });
          isTyping = false;
        });
        _scrollToBottom();
      }
    });
  }

  String _getAutoReply(String message) {
    final lower = message.toLowerCase();

    if (lower.contains("loan") && (lower.contains("apply") || lower.contains("application"))) {
      return "To apply for a loan:\n\n1. Go to the Loan page 💰\n2. Fill out the application form\n3. Submit required documents\n4. Wait for approval (usually 24-48 hours)\n\nNeed help with the application?";
    } else if (lower.contains("interest") || lower.contains("rate")) {
      return "Our interest rates are competitive:\n\n• Personal Loans: 3-5% per annum\n• Business Loans: 4-6% per annum\n• Emergency Loans: 3.5% per annum\n\nRates may vary based on loan amount and credit score. Would you like more details?";
    } else if (lower.contains("partial") || lower.contains("payment")) {
      return "Yes! We support flexible payment options:\n\n✅ Partial payments allowed\n✅ Early payment without penalty\n✅ Payment extensions (with approval)\n\nYou can make payments anytime through the Payment Methods page.";
    } else if (lower.contains("status") || lower.contains("track")) {
      return "To check your loan status:\n\n1. Go to Loan History page 📊\n2. View your active loans\n3. Check payment schedule and balance\n\nYou'll receive notifications for important updates!";
    } else if (lower.contains("contact") || lower.contains("support") || lower.contains("help")) {
      return "You can reach us through:\n\n📧 Email: support@gblcdc.coop\n📱 Phone: (123) 456-7890\n💬 Live Chat: Right here!\n🏢 Office Hours: Mon-Fri, 8AM-5PM\n\nHow else can I assist you?";
    } else if (lower.contains("document") || lower.contains("requirement")) {
      return "Required documents for loan application:\n\n📄 Valid ID (2 copies)\n💼 Proof of income\n🏠 Proof of address\n📋 Employment certificate\n\nAll documents can be uploaded digitally!";
    } else if (lower.contains("credit") || lower.contains("score")) {
      return "Your credit score affects:\n\n• Loan approval chances\n• Interest rates offered\n• Loan amount limit\n\nCheck your credit score in the Profile section. Maintaining good payment history improves your score!";
    } else if (lower.contains("thank")) {
      return "You're welcome! 😊\n\nIs there anything else I can help you with today?";
    } else if (lower.contains("hi") || lower.contains("hello") || lower.contains("hey")) {
      return "Hello! 👋 How can I assist you today?";
    } else {
      return "Thank you for reaching out! 🙏\n\nYour question has been noted. Our support team will provide a detailed response shortly.\n\nMeanwhile, feel free to ask more questions or choose from the quick questions below.";
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildMessageBubble(Map<String, dynamic> message, bool isUser) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Row(
        mainAxisAlignment:
        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage('assets/images/logocoop.png'),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: isUser
                    ? LinearGradient(
                  colors: [Colors.green.shade400, Colors.green.shade500],
                )
                    : null,
                color: isUser ? null : Colors.grey.shade50,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment:
                isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    message["text"],
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black87,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Iconsax.clock,
                        size: 10,
                        color: isUser ? Colors.white70 : Colors.grey.shade400,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatTime(message["time"]),
                        style: TextStyle(
                          color: isUser ? Colors.white70 : Colors.grey.shade500,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.green, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage('assets/images/2x2.jpg'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime? time) {
    if (time == null) return '';
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final min = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return "$hour:$min $period";
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('assets/images/logocoop.png'),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                const SizedBox(width: 4),
                _buildDot(1),
                const SizedBox(width: 4),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedBuilder(
      animation: _typingAnimController,
      builder: (context, child) {
        final delay = index * 0.2;
        final value = (_typingAnimController.value - delay) % 1.0;
        final opacity = (value < 0.5 ? value * 2 : (1 - value) * 2).clamp(0.3, 1.0);

        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(opacity),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  Widget _buildQuickQuestions() {
    if (!showQuickQuestions && messages.isNotEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Iconsax.message_question, size: 18, color: Colors.green.shade700),
              const SizedBox(width: 8),
              Text(
                "Quick Questions",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: quickQuestions.map((question) {
              return InkWell(
                onTap: () => _sendMessage(question['text']!),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        question['icon']!,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        question['text']!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage('assets/images/logocoop.png'),
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "GBLDC Support",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Online • Reply within minutes",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.more),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Iconsax.refresh, color: Colors.green),
                        title: const Text('Clear Chat'),
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            messages.clear();
                            showQuickQuestions = true;
                          });
                        },
                      ),
                      ListTile(
                        leading: const Icon(Iconsax.call, color: Colors.green),
                        title: const Text('Call Support'),
                        subtitle: const Text('(123) 456-7890'),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Iconsax.sms, color: Colors.green),
                        title: const Text('Email Support'),
                        subtitle: const Text('support@gblcdc.coop'),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              controller: _scrollController,
              itemCount: messages.length + (isTyping ? 1 : 0) + 1,
              itemBuilder: (context, index) {
                if (index < messages.length) {
                  final message = messages[index];
                  final isUser = message["sender"] == "user";
                  return _buildMessageBubble(message, isUser);
                } else if (index == messages.length && isTyping) {
                  return _buildTypingIndicator();
                } else {
                  return _buildQuickQuestions();
                }
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        textInputAction: TextInputAction.send,
                        onSubmitted: _sendMessage,
                        decoration: InputDecoration(
                          hintText: "Type your message...",
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          prefixIcon: Icon(Iconsax.message,
                              color: Colors.grey.shade400, size: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green.shade400, Colors.green.shade500],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Iconsax.send_2, color: Colors.white, size: 22),
                      onPressed: () {
                        if (_controller.text.isNotEmpty) {
                          _sendMessage(_controller.text);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}