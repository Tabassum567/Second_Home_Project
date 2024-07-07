import 'package:app/pages/student_navbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future sendMessage(message, email) async {
  var response =
      await http.post(Uri.parse("http://localhost:5000/sendMessage"), body: {
    "messageData": message,
    "studentEmail": email,
  });
  return response;
}

bool messageSend = false;

class LiveChatScreen extends StatefulWidget {
  var email_address;

  var role;

  var status;

  @override
  _LiveChatScreenState createState() => _LiveChatScreenState();

  LiveChatScreen(
      {super.key,
      required this.email_address,
      required this.status,
      required this.role});
}

class _LiveChatScreenState extends State<LiveChatScreen> {
  List<ChatMessage> messages = [];
  TextEditingController _textEditingController = TextEditingController();

  void _sendMessage(String message) {
    setState(() {
      messages.add(
        ChatMessage(
          content: message,
          sender: 'User', // Replace with appropriate sender name
          isUser: true,
        ),
      );
      if (message.isNotEmpty) {
        messages.add(
          ChatMessage(
            content:
                'Please select the type of service needed:\n1. After sale service\n2. Booking service\n3. Other',
            sender: 'Consultant',
            isUser: false,
            options: ['1', '2', '3'],
          ),
        );
      }
    });
    _textEditingController.clear();
  }

  void _handleOptionSelected(String option) {
    setState(() {
      messages.add(
        ChatMessage(
          content: option,
          sender: 'User',
          isUser: true,
        ),
      );
    });

    // Delay before displaying the automated message
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        if (!messageSend) {
          if (option == '3') {
            messages.add(
              ChatMessage(
                content:
                    'Please describe your problem, we will surely help you.',
                sender: 'Consultant',
                isUser: false,
              ),
            );
          } else {
            messages.add(
              ChatMessage(
                content:
                    'You selected option $option. We will assist you accordingly.',
                sender: 'Consultant',
                isUser: false,
              ),
            );
            messageSend = true;
          }
        }
      });
    });
  }

  void _navigateToPreferredScreen() {
    // Navigate to your preferred screen here
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => NavBar(
                email: widget.email_address,
                role: widget.role,
                status: widget.status,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Chat'),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _navigateToPreferredScreen();
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                final chatMessage = messages[index];
                return ListTile(
                  title: Text(
                    chatMessage.content,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: chatMessage.isUser ? Colors.teal : Colors.black,
                    ),
                  ),
                  subtitle: Text(chatMessage.sender),
                  tileColor: chatMessage.isUser
                      ? Colors.transparent
                      : Colors.grey.shade200,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  trailing: chatMessage.isUser ? null : Icon(Icons.person),
                  leading: chatMessage.isUser ? Icon(Icons.person) : null,
                );
              },
            ),
          ),
          Divider(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    String message = _textEditingController.text;
                    if (messageSend && message.isNotEmpty) {
                      _sendMessage(message);
                      await sendMessage(message, widget.email_address);
                      messageSend = false;
                      _sendMessage("Our Consultant will contact you soon");
                    } else if (message.isNotEmpty) {
                      if (messages.isNotEmpty &&
                          messages.last.sender == 'Consultant' &&
                          messages.last.options != null) {
                        if (messages.last.options!.contains(message)) {
                          _handleOptionSelected(message);
                        } else {
                          _sendMessage(message);
                        }
                      } else {
                        _sendMessage(message);
                      }
                    }
                  },
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
  final String content;
  final String sender;
  final bool isUser;
  final List<String>? options;

  ChatMessage(
      {required this.content,
      required this.sender,
      required this.isUser,
      this.options});
}
