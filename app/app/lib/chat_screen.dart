import 'dart:convert';
import 'dart:ui';
import 'package:app/owner_homescree.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future getMessages() async {
  var response =
      await http.get(Uri.parse("http://localhost:5000/chatMessages"));
  return json.decode(response.body)["messages"];
}

class ChatScreen extends StatefulWidget {
  var email;

  ChatScreen({super.key, required this.email});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var data = [];
  @override
  void initState() {
    super.initState();

    getMessages().then((response) {
      setState(() {
        data = response;
        print(data);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: SafeArea(
        child: Column(
          children: [
            _top(),
            _body(data),
          ],
        ),
      ),
    );
  }

  Widget _top() {
    return Container(
      padding: EdgeInsets.only(top: 30, left: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '24/7 Live Chat:\nAlways Here for You!',
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Row(
            children: [
              // Container(
              //   padding: EdgeInsets.all(14),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(50),
              //     color: Colors.black12,
              //   ),
              //   child: Icon(
              //     Icons.search,
              //     size: 30,
              //     color: Colors.white,
              //   ),
              // ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Container(
                  height: 100,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      return Avatar(
                        margin: EdgeInsets.only(right: 15),
                        image: 'avatar/${index + 1}.png',
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _body(data) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(45), topRight: Radius.circular(45)),
          color: Colors.white,
        ),
        child: ListView(
          padding: EdgeInsets.only(top: 35),
          physics: BouncingScrollPhysics(),
          children: [
            for (var item in data)
              _itemChats(
                avatar: 'avatar.png',
                name: item["data"]["username"],
                chat: item["content"],
                time: item["date"],
              ),
            // _itemChats(
            //   avatar: 'avatar.png',
            //   name: 'Komal',
            //   chat:
            //       'Hi! I need advice on handling maintenance issues in my property. How can I ensure timely repairs and upkeep',
            //   time: '03.19',
            // ),
            // _itemChats(
            //   avatar: 'avatar.png',
            //   name: 'Aadesh',
            //   chat:
            //       'Greetings! I have a vacant property near a university campus. How can I effectively market it to attract student tenants? Any tips or suggestions?',
            //   time: '02.53',
            // ),
            // _itemChats(
            //   avatar: 'avatar.png',
            //   name: 'Tabassum',
            //   chat:
            //       'Hi! I have questions about the lease agreement and my rights as a tenant. Can you provide guidance on understanding my responsibilities and how the property owner handles after-service matters?',
            //   time: '11.39',
            // ),
            // _itemChats(
            //   avatar: 'avatar.png',
            //   name: 'Yumna',
            //   chat:
            //       'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur',
            //   time: '00.09',
            // ),
            // _itemChats(
            //   avatar: 'avatar.png',
            //   name: 'Pawan',
            //   chat:
            //       'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur',
            //   time: '00.09',
            // ),
          ],
        ),
      ),
    );
  }

  Widget _itemChats(
      {String avatar = '', name = '', chat = '', time = '00.00'}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChatPage(
                email: widget.email,
                chat: chat,
                message: chat,
                time: time,
                name: name),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 20),
        elevation: 0,
        child: Row(
          children: [
            Avatar(
              margin: EdgeInsets.only(right: 20),
              size: 60,
              image: avatar,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$name',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '$time',
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '$chat',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  var chat;

  var email;

  var message;

  var time;

  var name;

  @override
  _ChatPageState createState() => _ChatPageState();

  ChatPage(
      {super.key,
      required this.email,
      required this.chat,
      required this.message,
      required this.time,
      required this.name});
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _topChat(),
                _bodyChat(),
                SizedBox(
                  height: 120,
                )
              ],
            ),
            _formChat(),
          ],
        ),
      ),
    );
  }

  _topChat() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 25,
                  color: Colors.white,
                ),
              ),
              Text(
                widget.name,
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
          // Row(
          //   children: [
          //     Container(
          //       padding: EdgeInsets.all(12),
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(50),
          //         color: Colors.black12,
          //       ),
          //       child: Icon(
          //         Icons.call,
          //         size: 25,
          //         color: Colors.white,
          //       ),
          //     ),
          //     SizedBox(
          //       width: 20,
          //     ),
          //     Container(
          //       padding: EdgeInsets.all(12),
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(50),
          //         color: Colors.black12,
          //       ),
          //       child: Icon(
          //         Icons.videocam,
          //         size: 25,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }

  Widget _bodyChat() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 25, right: 25, top: 25),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(45), topRight: Radius.circular(45)),
          color: Colors.white,
        ),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            _itemChat(
              avatar: widget.chat,
              chat: 1,
              message: widget.message,
              time: widget.time,
            ),
            // _itemChat(
            //   chat: 0,
            //   message: 'Okey 🐣',
            //   time: '18.00',
            // ),
            // _itemChat(
            //   avatar: 'avatar.png',
            //   chat: 1,
            //   message: 'It has survived not only five centuries, 😀',
            //   time: '18.00',
            // ),
            // _itemChat(
            //   chat: 0,
            //   message:
            //       'Contrary to popular belief, Lorem Ipsum is not simply random text. 😎',
            //   time: '18.00',
            // ),
            // _itemChat(
            //   avatar: 'avatar.png',
            //   chat: 1,
            //   message:
            //       'The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.',
            //   time: '18.00',
            // ),
            // _itemChat(
            //   avatar: 'avatar.png',
            //   chat: 1,
            //   message: '😅 😂 🤣',
            //   time: '18.00',
            // ),
          ],
        ),
      ),
    );
  }

  // 0 = Send
  // 1 = Recieved
  _itemChat({chat, avatar, message, time}) {
    return Row(
      mainAxisAlignment:
          chat == 0 ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        avatar != null
            ? Avatar(
                image: avatar,
                size: 50,
              )
            : Text(
                '$time',
                style: TextStyle(color: Colors.grey.shade400),
              ),
        Flexible(
          child: Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: chat == 0 ? Colors.indigo.shade100 : Colors.indigo.shade50,
              borderRadius: chat == 0
                  ? BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    )
                  : BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
            ),
            child: Text('$message'),
          ),
        ),
        chat == 1
            ? Text(
                '$time',
                style: TextStyle(color: Colors.grey.shade400),
              )
            : SizedBox(),
      ],
    );
  }

  Widget _formChat() {
    return Positioned(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 120,
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          color: Colors.white,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Type your message...',
              suffixIcon: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.teal),
                padding: EdgeInsets.all(14),
                child: Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              filled: true,
              fillColor: Colors.blueGrey[50],
              labelStyle: TextStyle(fontSize: 12),
              contentPadding: EdgeInsets.all(20),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey),
                borderRadius: BorderRadius.circular(25),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  final double size;
  final image;
  final EdgeInsets margin;
  Avatar({this.image, this.size = 50, this.margin = const EdgeInsets.all(0)});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Container(
        width: size,
        height: size,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          image: new DecorationImage(
            image: AssetImage(image),
          ),
        ),
      ),
    );
  }
}
