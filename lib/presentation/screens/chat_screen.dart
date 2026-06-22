import 'dart:async';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Cleared out dummy messages. Added one welcome message from Support to start the conversation.
  final List<Map<String, dynamic>> messages = [
    {
      "message": "Hello! How can I help you with your shopping today?",
      "isMe": false,
      "time": "Just now",
    },
  ];

  // Function to automatically scroll to the bottom when a new message arrives
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void sendMessage() {
    if (messageController.text.trim().isEmpty) return;

    String userMessage = messageController.text;

    setState(() {
      messages.add({
        "message": userMessage,
        "isMe": true,
        "time": TimeOfDay.now().format(context),
      });
    });

    messageController.clear();
    _scrollToBottom();

    // Simulate Customer Support replying after 1.5 seconds
    Timer(const Duration(milliseconds: 1500), () {
      simulateSupportReply(userMessage);
    });
  }

  // Simple automated reply logic based on what the customer types
  void simulateSupportReply(String customerMessage) {
    String reply =
        "Thank you for reaching out. A live agent will connect with you shortly.";

    final lowerMsg = customerMessage.toLowerCase();
    if (lowerMsg.contains("order") || lowerMsg.contains("track")) {
      reply =
          "Please share your Order ID, and I'll gladly check the delivery status for you!";
    } else if (lowerMsg.contains("hello") || lowerMsg.contains("hi")) {
      reply = "Hi there! What can I assist you with today?";
    } else if (lowerMsg.contains("refund") || lowerMsg.contains("return")) {
      reply =
          "You can initiate a return directly from your 'My Orders' section, or I can help you here.";
    }

    setState(() {
      messages.add({
        "message": reply,
        "isMe": false,
        "time": TimeOfDay.now().format(context),
      });
    });

    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        titleSpacing: 0,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 22,
              backgroundColor: Colors.black12,
              child: Icon(Icons.person, color: Colors.black),
            ),
            const SizedBox(width: 12),
            const Text(
              "Customer Support",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: const [
          Icon(Icons.videocam_outlined),
          SizedBox(width: 15),
          Icon(Icons.call_outlined),
          SizedBox(width: 15),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController, // Attached scroll controller here
              padding: const EdgeInsets.all(15),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isMe = msg["isMe"];

                return Align(
                  alignment: isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.black : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          msg["message"],
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          msg["time"],
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: sendMessage,
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
