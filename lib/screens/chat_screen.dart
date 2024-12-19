import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'globals.dart' as globals;

class ChatScreen extends StatefulWidget {
  final String username;
  final String recordingType;

  ChatScreen({required this.username, required this.recordingType});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _questionController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final List<ChatMessage> _userMessages = [];
  bool isLoading = false;
  String _summary = globals.summary;

  Future<void> _sendMessage(String question) async {
    if (question.trim().isEmpty) return;

    setState(() {
      _userMessages.add(ChatMessage(
        text: question,
        isUser: true,
      ));
      _messages.add(ChatMessage(
        text: "${widget.username}: $question",
        isUser: true,
      ));
      isLoading = true;
    });

    try {
      final response = await Gemini.instance.prompt(
        parts: [
          Part.text(
            "תוכן ההקלטה (${widget.recordingType}):\n$_summary\n\nענה בעברית על השאלה הבאה:\n$question",
          ),
        ],
      );

      setState(() {
        _messages.add(ChatMessage(
          text: response?.output ?? 'לא התקבלה תשובה',
          isUser: false,
        ));
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: "שגיאה בחיבור לשרת",
          isUser: false,
        ));
        isLoading = false;
      });
    }

    _questionController.clear();
  }

  Future<void> _sendSummary() async {
    if (_summary.trim().isEmpty) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await Gemini.instance.prompt(
        parts: [
          Part.text(
            "שלח את הסיכום עבור ההקלטה (${widget.recordingType}):\n$_summary",
          ),
        ],
      );

      setState(() {
        _messages.add(ChatMessage(
          text: response?.output ?? 'לא התקבלה תשובה',
          isUser: false,
        ));
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: "שגיאה בשליחת הסיכום",
          isUser: false,
        ));
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('צ׳אט עם המורה הוירטואלי'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return ChatBubble(message: message);
              },
            ),
          ),
          if (isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _questionController,
                    decoration: InputDecoration(
                      hintText: 'שאל שאלה...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _sendMessage(_questionController.text),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _sendSummary,
                  child: Text('שלח סיכום'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
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

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.white : Colors.black,
          ),
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }
}
