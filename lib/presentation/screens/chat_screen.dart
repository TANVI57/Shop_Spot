import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();

  final List<Map<String, dynamic>> messages = [
    {"message": "I need help with my order.", "isMe": false, "time": "10:15"},
    {
      "message": "Sure, which order are you referring to?",
      "isMe": true,
      "time": "10:16",
    },
    {
      "message": "The shoes order I placed last week.",
      "isMe": false,
      "time": "10:17",
    },
    {
      "message": "I will check the status for you.",
      "isMe": true,
      "time": "10:18",
    },
    {"message": "Thank you.", "isMe": false, "time": "10:19"},
  ];

  void sendMessage() {
    if (messageController.text.trim().isEmpty) return;

    setState(() {
      messages.add({
        "message": messageController.text,
        "isMe": true,
        "time": TimeOfDay.now().format(context),
      });
    });

    messageController.clear();
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
