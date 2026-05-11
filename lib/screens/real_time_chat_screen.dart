import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../providers/app_provider.dart';
import '../services/api_service.dart';

class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String text;
  final DateTime time;
  final bool isMe;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.time,
    required this.isMe,
  });
}

class RealTimeChatScreen extends StatefulWidget {
  final String roomId;
  final String recipientName;
  const RealTimeChatScreen({
    super.key,
    required this.roomId,
    required this.recipientName,
  });

  @override
  State<RealTimeChatScreen> createState() => _RealTimeChatScreenState();
}

class _RealTimeChatScreenState extends State<RealTimeChatScreen> {
  final _messageCtrl = TextEditingController();
  final _scrollCtrl  = ScrollController();
  final List<ChatMessage> _messages = [];

  late io.Socket _socket;
  bool _isConnected   = false;
  bool _isTyping      = false;
  String? _typingUser;

  @override
  void initState() {
    super.initState();
    _connectSocket();
  }

  void _connectSocket() {
    _socket = io.io(
      'http://localhost:5000',
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    _socket.connect();

    _socket.onConnect((_) {
      setState(() => _isConnected = true);
      final provider = context.read<AppProvider>();
      // Register as online
      _socket.emit('user:online', {
        'userId': provider.currentUser?.email ?? 'guest',
        'name':   provider.currentUser?.name  ?? 'User',
      });
      // Join the chat room
      _socket.emit('room:join', {'roomId': widget.roomId});
    });

    _socket.on('message:receive', (data) {
      if (!mounted) return;
      final provider = context.read<AppProvider>();
      final myName = provider.currentUser?.name ?? '';
      setState(() {
        _messages.add(ChatMessage(
          id:         DateTime.now().toString(),
          senderId:   data['senderId'] ?? '',
          senderName: data['senderName'] ?? 'Unknown',
          text:       data['text'] ?? '',
          time:       DateTime.now(),
          isMe:       data['senderName'] == myName,
        ));
        _isTyping  = false;
        _typingUser = null;
      });
      _scrollToBottom();
    });

    _socket.on('typing:start', (data) {
      if (!mounted) return;
      setState(() {
        _isTyping   = true;
        _typingUser = data['userName'];
      });
    });

    _socket.on('typing:stop', (_) {
      if (!mounted) return;
      setState(() { _isTyping = false; _typingUser = null; });
    });

    _socket.onDisconnect((_) {
      if (!mounted) return;
      setState(() => _isConnected = false);
    });
  }

  @override
  void dispose() {
    _socket.dispose();
    _messageCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageCtrl.text.trim();
    if (text.isEmpty || !_isConnected) return;

    final provider = context.read<AppProvider>();
    final name     = provider.currentUser?.name ?? 'User';
    final email    = provider.currentUser?.email ?? 'user@app.com';

    final message = {
      'senderId':   email,
      'senderName': name,
      'text':       text,
      'roomId':     widget.roomId,
    };

    _socket.emit('message:send', {'roomId': widget.roomId, 'message': message});
    _socket.emit('typing:stop',  {'roomId': widget.roomId});

    setState(() {
      _messages.add(ChatMessage(
        id: DateTime.now().toString(),
        senderId: email, senderName: name,
        text: text, time: DateTime.now(), isMe: true,
      ));
    });

    _messageCtrl.clear();
    _scrollToBottom();
  }

  void _onTyping(String value) {
    final provider = context.read<AppProvider>();
    final name     = provider.currentUser?.name ?? 'User';
    if (value.isNotEmpty) {
      _socket.emit('typing:start', {'roomId': widget.roomId, 'userName': name});
    } else {
      _socket.emit('typing:stop', {'roomId': widget.roomId});
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
    final isDark    = context.watch<AppProvider>().isDark;
    final bgColor   = isDark ? const Color(0xFF0F1426) : const Color(0xFFF4F5FA);
    final cardColor = isDark ? const Color(0xFF1E2746) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF5C6BC0).withOpacity(0.15),
              child: Text(widget.recipientName.isNotEmpty
                  ? widget.recipientName[0].toUpperCase() : '?',
                  style: const TextStyle(color: Color(0xFF5C6BC0),
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.recipientName,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700, fontSize: 15,
                        color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
                Row(children: [
                  Container(
                    width: 7, height: 7,
                    decoration: BoxDecoration(
                      color: _isConnected ? Colors.green : Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(_isConnected ? 'Connected' : 'Connecting...',
                      style: TextStyle(fontSize: 11,
                          color: _isConnected ? Colors.green : Colors.red)),
                ]),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? Center(child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.chat_bubble_outline_rounded,
                          size: 64,
                          color: isDark ? Colors.white24 : Colors.black12),
                      const SizedBox(height: 12),
                      Text('No messages yet.\nSay hello! 👋',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: isDark ? Colors.white38 : Colors.black38)),
                    ]))
                : ListView.builder(
                    controller: _scrollCtrl,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    itemCount: _messages.length,
                    itemBuilder: (_, i) =>
                        _buildBubble(_messages[i], isDark),
                  ),
          ),
          if (_isTyping && _typingUser != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 0, 4),
              child: Row(children: [
                Text('$_typingUser is typing...',
                    style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white38 : Colors.black45,
                        fontStyle: FontStyle.italic)),
              ]),
            ),
          _buildInputBar(isDark, cardColor),
        ],
      ),
    );
  }

  Widget _buildBubble(ChatMessage msg, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment:
            msg.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!msg.isMe) ...[
            CircleAvatar(
              radius: 14,
              backgroundColor: const Color(0xFF5C6BC0).withOpacity(0.15),
              child: Text(msg.senderName.isNotEmpty
                  ? msg.senderName[0].toUpperCase() : '?',
                  style: const TextStyle(fontSize: 11,
                      color: Color(0xFF5C6BC0), fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: msg.isMe
                  ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!msg.isMe)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2, left: 2),
                    child: Text(msg.senderName,
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white54 : Colors.black45)),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: msg.isMe
                        ? const LinearGradient(colors: [
                            Color(0xFF5C6BC0), Color(0xFF3949AB)])
                        : null,
                    color: msg.isMe
                        ? null
                        : (isDark ? const Color(0xFF1E2746) : Colors.white),
                    borderRadius: BorderRadius.only(
                      topLeft:     const Radius.circular(16),
                      topRight:    const Radius.circular(16),
                      bottomLeft:  Radius.circular(msg.isMe ? 16 : 4),
                      bottomRight: Radius.circular(msg.isMe ? 4 : 16),
                    ),
                    boxShadow: [BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 6, offset: const Offset(0, 2))],
                  ),
                  child: Text(msg.text,
                      style: TextStyle(
                          color: msg.isMe ? Colors.white
                              : (isDark ? Colors.white : const Color(0xFF1A1A2E)),
                          fontSize: 13.5, height: 1.4)),
                ),
                const SizedBox(height: 2),
                Text(
                  '${msg.time.hour.toString().padLeft(2,'0')}:${msg.time.minute.toString().padLeft(2,'0')}',
                  style: TextStyle(fontSize: 10,
                      color: isDark ? Colors.white24 : Colors.black26),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(bool isDark, Color cardColor) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 16),
      decoration: BoxDecoration(
        color: cardColor,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07),
            blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageCtrl,
              onChanged: _onTyping,
              onSubmitted: (_) => _sendMessage(),
              decoration: InputDecoration(
                hintText: 'Type a message...',
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
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 46, height: 46,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFF5C6BC0), Color(0xFF3949AB)]),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(
                    color: const Color(0xFF5C6BC0).withOpacity(0.4),
                    blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: const Icon(Icons.send_rounded,
                  color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
