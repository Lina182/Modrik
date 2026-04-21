import 'package:flutter/material.dart';

class ExpertHomeScreen extends StatefulWidget {
  const ExpertHomeScreen({super.key});

  @override
  State<ExpertHomeScreen> createState() => _ExpertHomeScreenState();
}
class _ExpertHomeScreenState extends State<ExpertHomeScreen> {
  final TextEditingController c = TextEditingController();
  final List msgs = [];
  final Color mainPurple = const Color(0xFF9DA3D9);

  void send() {
    if (c.text.trim().isEmpty) return;

    setState(() {
      msgs.add({"u": true, "t": c.text});
      msgs.add({"u": false, "t": "This is a response from the expert."});
    });
    c.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Expert Chat")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: msgs.length,
              itemBuilder: (context, i) {
                final m = msgs[i];
                final isUser = m["u"];

                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser
                          ? Colors.grey.shade200
                          : mainPurple.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      m["t"],
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: c,
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: send,
                  icon: const Icon(Icons.send),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}