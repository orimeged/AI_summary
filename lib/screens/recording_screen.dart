import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'globals.dart' as globals;

class RecordingScreen extends StatefulWidget {
  @override
  _RecordingScreenState createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "לחץ על הכפתור והתחל לדבר...";
  bool isLoading = false;
  String recordingType = "";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      print("הרשאה למיקרופון ניתנה.");
    } else {
      print("הרשאה למיקרופון נדחתה.");
    }
  }

  void _showRecordingTypeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("בחר סוג הקלטה"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("הרצאה/שיעור"),
                onTap: () => _selectRecordingType("הרצאה/שיעור"),
              ),
              ListTile(
                title: Text("פגישה"),
                onTap: () => _selectRecordingType("פגישה"),
              ),
              ListTile(
                title: Text("נאום"),
                onTap: () => _selectRecordingType("נאום"),
              ),
              ListTile(
                title: Text("שיחת טלפון"),
                onTap: () => _selectRecordingType("שיחת טלפון"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _selectRecordingType(String type) {
    setState(() {
      recordingType = type;
    });
    Navigator.of(context).pop();
    _startListening();
  }

  void _listen() {
    if (!_isListening) {
      _showRecordingTypeDialog();
    } else {
      _stopListening();
    }
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print('סטטוס: $status'),
      onError: (error) => print('שגיאה: ${error.errorMsg}'),
    );
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() {
            _text = result.recognizedWords;
          });
        },
      );
    }
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
    _summarizeText();
  }

  Future<void> _summarizeText() async {
    if (_text.isEmpty || _text == "לחץ על הכפתור והתחל לדבר...") return;

    setState(() => isLoading = true);

    try {
      final response = await Gemini.instance.prompt(
        parts: [
          Part.text("תוכל בבקשה לסכם לי את זה בתור $recordingType $_text"),
        ],
      );

      setState(() {
        globals.summary = response?.output ?? 'לא התקבל סיכום';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        globals.summary = "שגיאה בחיבור לשרת";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('הקלטת שיעור'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isListening ? Colors.green.shade100 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    color: _isListening ? Colors.green : Colors.grey,
                  ),
                  SizedBox(width: 8),
                  Text(
                    _isListening ? "מקליט..." : "מוכן להקלטה",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        _text,
                        style: TextStyle(fontSize: 16),
                        textDirection: TextDirection.rtl,
                      ),
                      if (globals.summary.isNotEmpty) ...[
                        Divider(height: 32),
                        Text(
                          "סיכום:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          globals.summary,
                          style: TextStyle(fontSize: 16),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: _listen,
              icon: Icon(_isListening ? Icons.stop : Icons.mic),
              label: Text(_isListening ? "סיים הקלטה" : "התחל הקלטה"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                backgroundColor: _isListening ? Colors.red : Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            if (isLoading)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
