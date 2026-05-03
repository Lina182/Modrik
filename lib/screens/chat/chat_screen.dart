import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String title;

  const ChatScreen({super.key, required this.title});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController c = TextEditingController();

  List msgs = [];

  void send() {
    if (c.text.isEmpty) return;

    setState(() {
      msgs.add({"t": c.text, "u": true});
      msgs.add({"t": "Reply received from expert.", "u": false});
    });

    c.clear();
  }

  Widget circleBtn(IconData icon, VoidCallback tap) {
    return GestureDetector(
      onTap: tap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFF),
      body: Column(
        children: [
          const SizedBox(height: 50),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                circleBtn(Icons.arrow_back_ios_new, () {
                  Navigator.pop(context);
                }),
                const SizedBox(width: 10),
                const CircleAvatar(),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Dr. Ahmed Ali",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      "Online",
                      style: TextStyle(color: Colors.green, fontSize: 12),
                    ),
                  ],
                ),
                const Spacer(),
                circleBtn(Icons.more_vert, () {}),
              ],
            ),
          ),

          const Divider(height: 30, color: Colors.black12),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFFE0E2FF)),
            ),
            child: Row(
              children: [
                const Icon(Icons.description, color: Color(0xFF6C63FF)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.title,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const Text(
                        "File • Sent",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 14),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: msgs.length,
              itemBuilder: (_, i) {
                var m = msgs[i];
                bool u = m["u"];

                return Align(
                  alignment:
                      u ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: u ? const Color(0xFFDADCF5) : Colors.white,
                      borderRadius: BorderRadius.circular(16),),
                    child: Text(m["t"]),
                  ),
                );
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.attach_file, color: Color(0xFF6C63FF)),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: c,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: const Color(0xFF6C63FF),
                  child: IconButton(
                    onPressed: send,
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}