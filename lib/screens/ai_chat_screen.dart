import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../data/mock_data.dart';
import '../models/chat_message_model.dart';
import '../widgets/gradient_button.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final model = GenerativeModel(
    model: 'gemini-3.1-flash-lite-preview',
    apiKey: 'AIzaSyDUgEZSwDZcfgJbSMjr1DQc_9XW_ZSlmQc',
     generationConfig: GenerationConfig(
    maxOutputTokens: 120,
  ),
  );
  final _textCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  bool _isTyping = false;

  final _suggestions = [
    'Best marketing strategy for my business 📈',
    'How to grow Instagram followers 📱',
    'Best influencer for food promotion 🍔',
    'Campaign ideas for clothing brand 👗',
    'How to improve customer engagement 💬',
    'Best hashtags for product promotion 🔥',
    'Branding tips for startup business 🚀',
    'Social media marketing ideas 📣',
    'How to increase business reach 🌍',
    'Ad copy for my business product ✍️',
    'How to collaborate with influencers 🤝',
    'Tips to promote franchise business 🏢',
  ];

  @override
  void dispose() {
    _textCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    debugPrint(text);
    final provider = context.read<AppProvider>();
    _textCtrl.clear();
    provider.addAiUserMessage(text.trim());
    setState(() => _isTyping = true);
    _scrollToBottom();

    // await Future.delayed(const Duration(milliseconds: 1200));
    // if (!mounted) return;

    String lowerText = text.toLowerCase();

    List<String> allowedKeywords = [
      "business",
      "brand",
      "marketing",
      "influencer",
      "campaign",
      "promotion",
      "followers",
      "instagram",
      "youtube",
      "social media",
      "advertisement",
      "franchise",
      "content",
      "ads",
      "engagement",
      "reach",
      "branding",
      "collab",
    ];

    bool isAllowed = allowedKeywords.any(
      (keyword) => lowerText.contains(keyword),
    );

    String reply;

   if (isAllowed) {

  try {

    final content = [

      Content.text(
        "Business AI assistant. Answer shortly.\nQuestion: $text",
      ),
    ];

    final response =
        await model
            .generateContent(content)
            .timeout(
              const Duration(seconds: 8),
            );

    reply =
        response.text ??
        "⚠️ No response from Gemini.";

  } catch (e) {

    debugPrint("Gemini Error: $e");

    reply =
        "⚠️ Gemini server busy. Try again.";
  }

} else {

  reply =
      "❌ I only answer business, influencer, marketing and branding related questions.";
}

    provider.addAiReply(reply);
    setState(() => _isTyping = false);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final isDark = provider.isDark;
    final messages = provider.aiMessages;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F1426) : const Color(0xFFF4F5FA),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E2746) : Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
                gradient: AppColors.gradientPrimary, shape: BoxShape.circle),
            child:
                const Center(child: Text('🤖', style: TextStyle(fontSize: 18))),
          ),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('BrandBridge AI',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
            Text('Marketing Assistant',
                style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.white54 : Colors.black45)),
          ]),
        ]),
        actions: [
          if (messages.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete_outline,
                  color: isDark ? Colors.white60 : Colors.black45),
              onPressed: () => provider.clearAiChat(),
            ),
        ],
      ),
      body: Column(children: [
        Expanded(
          child: messages.isEmpty
              ? _buildWelcome(isDark)
              : ListView.builder(
                  controller: _scrollCtrl,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length + (_isTyping ? 1 : 0),
                  itemBuilder: (_, i) {
                    if (i == messages.length && _isTyping)
                      return _TypingBubble(isDark: isDark);
                    final m = messages[i];
                    return _ChatBubble(message: m, isDark: isDark);
                  },
                ),
        ),
        _buildInput(isDark),
      ]),
    );
  }

  Widget _buildWelcome(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        const SizedBox(height: 20),
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
              gradient: AppColors.gradientPrimary, shape: BoxShape.circle),
          child:
              const Center(child: Text('🤖', style: TextStyle(fontSize: 40))),
        ),
        const SizedBox(height: 16),
        Text('BrandBridge AI',
            style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
        const SizedBox(height: 6),
        Text('Your marketing co-pilot',
            style: TextStyle(
                color: isDark ? Colors.white54 : Colors.black45, fontSize: 14)),
        const SizedBox(height: 24),
        Text('Try asking:',
            style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _suggestions
              .map((s) => GestureDetector(
                    onTap: () => _sendMessage(s),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E2746) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: AppColors.primary.withOpacity(0.3)),
                      ),
                      child: Text(s,
                          style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500)),
                    ),
                  ))
              .toList(),
        ),
      ]),
    );
  }

  Widget _buildInput(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2746) : Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -3))
        ],
      ),
      child: Row(children: [
        Expanded(
          child: TextField(
            controller: _textCtrl,
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            decoration: InputDecoration(
              hintText: 'Ask about marketing...',
              hintStyle: TextStyle(
                  color: isDark ? Colors.white38 : Colors.black38,
                  fontSize: 14),
              filled: true,
              fillColor:
                  isDark ? const Color(0xFF0F1426) : const Color(0xFFF4F5FA),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            ),
            onSubmitted: _sendMessage,
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => _sendMessage(_textCtrl.text),
          child: Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
                gradient: AppColors.gradientPrimary, shape: BoxShape.circle),
            child:
                const Icon(Icons.send_rounded, color: Colors.white, size: 20),
          ),
        ),
      ]),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final AiChatMessage message;
  final bool isDark;
  const _ChatBubble({required this.message, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                    gradient: AppColors.gradientPrimary,
                    shape: BoxShape.circle),
                child: const Center(
                    child: Text('🤖', style: TextStyle(fontSize: 14)))),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: isUser ? AppColors.gradientPrimary : null,
                color: isUser
                    ? null
                    : (isDark ? const Color(0xFF1E2746) : Colors.white),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 18),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2))
                ],
              ),
              child: Text(
                message.message,
                style: TextStyle(
                  color: isUser
                      ? Colors.white
                      : (isDark ? Colors.white : const Color(0xFF1A1A2E)),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _TypingBubble extends StatefulWidget {
  final bool isDark;
  const _TypingBubble({required this.isDark});

  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
                gradient: AppColors.gradientPrimary, shape: BoxShape.circle),
            child: const Center(
                child: Text('🤖', style: TextStyle(fontSize: 14)))),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
              color: widget.isDark ? const Color(0xFF1E2746) : Colors.white,
              borderRadius: BorderRadius.circular(18)),
          child: AnimatedBuilder(
            animation: _c,
            builder: (_, __) => Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (i) {
                  final delay = i * 0.33;
                  final val = ((_c.value - delay) % 1.0).clamp(0.0, 1.0);
                  final bounce = val < 0.5 ? val * 2 : 1 - (val - 0.5) * 2;
                  return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: 8,
                      height: 8 + bounce * 4,
                      decoration: BoxDecoration(
                          color:
                              AppColors.primary.withOpacity(0.6 + bounce * 0.4),
                          borderRadius: BorderRadius.circular(4)));
                })),
          ),
        ),
      ]),
    );
  }
}
