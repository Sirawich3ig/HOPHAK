import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ChatRoomScreen extends StatefulWidget {
  final String dormName;
  const ChatRoomScreen({super.key, required this.dormName});

  static final ValueNotifier<int> chatUpdated = ValueNotifier<int>(0);
  // เริ่มต้นเป็นค่าว่าง จะแสดงเฉพาะหอพักที่เรากดเข้าไปแชทจริงๆ
  static final Map chatHistories = {};

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final _msgController = TextEditingController();
  late List _messages;

  @override
  void initState() {
    super.initState();
    if (!ChatRoomScreen.chatHistories.containsKey(widget.dormName)) {
      ChatRoomScreen.chatHistories[widget.dormName] = [
        {'isMe': true, 'text': 'สวัสดีครับ สนใจห้องพักรายเดือนครับ'},
        {'isMe': false, 'text': 'สวัสดีค่ะ ตอนนี้มีห้องว่างชั้น 3 ค่ะ สนใจนัดดูห้องไหมคะ?'},
      ];
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ChatRoomScreen.chatUpdated.value++;
      });
    }
    _messages = ChatRoomScreen.chatHistories[widget.dormName];
  }

  void _sendMessage() {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add({'isMe': true, 'text': text});
      _msgController.clear();
    });
    ChatRoomScreen.chatUpdated.value++;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.dormName),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final isMe = _messages[index]['isMe'] == true;
                final text = _messages[index]['text'].toString();

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isMe ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      text,
                      style: TextStyle(color: isMe ? Colors.white : AppColors.textPrimary),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: const InputDecoration(
                      hintText: 'พิมพ์ข้อความ...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: AppColors.primary),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}