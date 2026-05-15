import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'ai_service.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController controller = TextEditingController();
  final List<Map<String, dynamic>> messages = [];
  File? image;

  Future<void> sendMessage() async {
    if (controller.text.isEmpty && image == null) return;

    String userText = controller.text;
    File? userImage = image;

    controller.clear();
    image = null;

    setState(() {
      messages.add({
        "text": userText,
        "isUser": true,
        "image": userImage
      });
    });

    String reply = await AIService.sendMessage(userText);

    setState(() {
      messages.add({
        "text": reply,
        "isUser": false,
        "image": null
      });
    });
  }

  Future<void> pickImage() async {
    final picked =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        image = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Support Chat")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];

                return Align(
                  alignment: msg["isUser"]
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(10),
                    color: msg["isUser"]
                        ? Colors.blue
                        : Colors.grey[300],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (msg["text"] != "")
                          Text(
                            msg["text"],
                            style: TextStyle(
                              color: msg["isUser"]
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        if (msg["image"] != null)
                          Image.file(msg["image"], height: 100),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          Row(
            children: [
              IconButton(
                onPressed: pickImage,
                icon: const Icon(Icons.image),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration:
                  const InputDecoration(hintText: "اكتب مشكلتك"),
                ),
              ),
              IconButton(
                onPressed: sendMessage,
                icon: const Icon(Icons.send),
              ),
            ],
          )
        ],
      ),
    );
  }
}