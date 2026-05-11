import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../providers/app_provider.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';

// ─── Data model for a single chat message ────────────────────────────────────
class _AiMessage {
  final String text;
  final bool isUser;
  final DateTime time;
  _AiMessage({required this.text, required this.isUser, DateTime? time})
      : time = time ?? DateTime.now();
}

// ─── AI Chat Screen (connected to real Gemini backend) ───────────────────────
class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen>
    with TickerProviderStateMixin {
  final _controller    = TextEditingController();
  final _scrollCtrl    = ScrollController();
  final List<_AiMessage> _messages = [];
  // Conversation history to send to backend for context
  final List<Map<String, String>> _history = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Welcome message
    _messages.add(_AiMessage(
      text: '👋 Hi! I\'m your Digital Marketing AI assistant. I can help you with:\n\n• 📣 Campaign strategy & improvement\n• 👥 Influencer recommendations\n• 🏪 Franchise investment advice\n• 📈 Brand growth tips\n• ✍️ Content & caption ideas\n\nWhat would you like to explore today?',
      isUser: false,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty || _isLoading) return;
    _controller.clear();

    setState(() {
      _messages.add(_AiMessage(text: text, isUser: true));
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      final token = await AuthService.getToken();
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/ai/chat'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'message': text,
          'history': _history,
        }),
      ).timeout(const Duration(seconds: 30));

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data   = json.decode(response.body);
        final reply  = data['reply'] as String;

        // Build history for context in next message
        _history.add({ 'role': 'user',  'text': text  });
        _history.add({ 'role': 'model', 'text': reply });

        // Keep history to last 10 exchanges to avoid large payloads
        if (_history.length > 20) _history.removeRange(0, 2);

        setState(() {
          _messages.add(_AiMessage(text: reply, isUser: false));
        });
      } else {
        final err = json.decode(response.body)['message'] ?? 'AI service unavailable.';
        setState(() {
          _messages.add(_AiMessage(text: '⚠️ $err', isUser: false));
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.add(_AiMessage(
          text: '⚠️ Could not reach AI service. Please check your connection and ensure GEMINI_API_KEY is set in the backend .env file.',
          isUser: false,
        ));
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
      _scrollToBottom();
    }
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
    final isDark = context.watch<AppProvider>().isDark;
    final bgColor = isDark ? const Color(0xFF0F1426) : const Color(0xFFF4F5FA);
    final cardColor = isDark ? const Color(0xFF1E2746) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFF5C6BC0), Color(0xFF7986CB)]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Marketing Assistant',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700, fontSize: 15,
                        color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
                Text('Powered by Gemini',
                    style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.white38 : Colors.black38)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded,
                color: isDark ? Colors.white54 : Colors.black45),
            onPressed: () {
              setState(() {
                _messages.clear();
                _history.clear();
                _messages.add(_AiMessage(
                  text: '🔄 Conversation reset. How can I help you?',
                  isUser: false,
                ));
              });
            },
            tooltip: 'Reset conversation',
          )
        ],
      ),
      body: Column(
        children: [
          // Quick suggestion chips
          _buildSuggestionChips(isDark),

          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return _buildTypingIndicator(isDark);
                }
                final msg = _messages[index];
                return _buildMessageBubble(msg, isDark);
              },
            ),
          ),

          // Input bar
          _buildInputBar(isDark, cardColor),
        ],
      ),
    );
  }

  Widget _buildSuggestionChips(bool isDark) {
    final suggestions = [
      '📣 Improve my campaign',
      '👥 Find influencers',
      '📈 Grow my brand',
      '✍️ Write captions',
    ];
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: suggestions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) => GestureDetector(
          onTap: () => _sendMessage(suggestions[i]),
          child: Chip(
            label: Text(suggestions[i],
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
            backgroundColor: isDark
                ? const Color(0xFF1E2746)
                : const Color(0xFFE8EEFF),
            labelStyle: TextStyle(
                color: isDark ? Colors.white70 : const Color(0xFF3949AB)),
            padding: const EdgeInsets.symmetric(horizontal: 4),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(_AiMessage msg, bool isDark) {
    final isUser = msg.isUser;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 30, height: 30,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFF5C6BC0), Color(0xFF7986CB)]),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.auto_awesome,
                  color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                gradient: isUser
                    ? const LinearGradient(
                        colors: [Color(0xFF5C6BC0), Color(0xFF3949AB)])
                    : null,
                color: isUser
                    ? null
                    : (isDark ? const Color(0xFF1E2746) : Colors.white),
                borderRadius: BorderRadius.only(
                  topLeft:     const Radius.circular(16),
                  topRight:    const Radius.circular(16),
                  bottomLeft:  Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Text(
                msg.text,
                style: TextStyle(
                  color: isUser
                      ? Colors.white
                      : (isDark ? Colors.white : const Color(0xFF1A1A2E)),
                  fontSize: 13.5,
                  height: 1.5,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 14,
              backgroundColor: const Color(0xFF5C6BC0).withOpacity(0.2),
              child: const Icon(Icons.person_rounded,
                  size: 16, color: Color(0xFF5C6BC0)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 30, height: 30,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFF5C6BC0), Color(0xFF7986CB)]),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.auto_awesome,
                color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E2746) : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16),
                bottomLeft: Radius.circular(4), bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) => _Dot(delay: i * 200)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(bool isDark, Color cardColor) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 16),
      decoration: BoxDecoration(
        color: cardColor,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08),
              blurRadius: 10, offset: const Offset(0, -2))
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: _sendMessage,
              decoration: InputDecoration(
                hintText: 'Ask about campaigns, influencers...',
                hintStyle: TextStyle(
                    color: isDark ? Colors.white38 : Colors.black38,
                    fontSize: 13),
                filled: true,
                fillColor: isDark
                    ? const Color(0xFF0F1426)
                    : const Color(0xFFF4F5FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              ),
              style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87, fontSize: 13),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _sendMessage(_controller.text),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 46, height: 46,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFF5C6BC0), Color(0xFF3949AB)]),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF5C6BC0).withOpacity(0.4),
                    blurRadius: 10, offset: const Offset(0, 4),
                  )
                ],
              ),
              child: _isLoading
                  ? const Center(
                      child: SizedBox(
                          width: 20, height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2)))
                  : const Icon(Icons.send_rounded,
                      color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Animated typing dot ─────────────────────────────────────────────────────
class _Dot extends StatefulWidget {
  final int delay;
  const _Dot({required this.delay});
  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _anim;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600))
      ..repeat(reverse: true);
    _anim = Tween(begin: 0.0, end: -6.0).animate(
        CurvedAnimation(parent: _c, curve: Curves.easeInOut));
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _c.forward();
    });
  }
  @override
  void dispose() { _c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, _anim.value),
        child: Container(
          width: 8, height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: const Color(0xFF5C6BC0).withOpacity(0.6),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
