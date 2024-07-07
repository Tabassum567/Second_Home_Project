import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Frequently Asked Questions'),
        backgroundColor: Colors.teal, // Customize the app bar color
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        children: const <Widget>[
          FAQItem(
            question: 'How do I apply for student housing?',
            answer:
                'To apply for student housing, download our application and signup for the application form. Make sure to provide all the required information accurately.',
          ),
          FAQItem(
            question: 'What amenities are provided in the housing facilities?',
            answer:
                'Our housing facilities include fully furnished rooms, high-speed internet, laundry facilities, study areas, common spaces, and 24/7 security.',
          ),
          FAQItem(
            question: 'How can I pay the housing fees?',
            answer:
                'You can pay the housing fees through our online payment portal using various payment methods, including credit/debit cards, bank transfers, or electronic wallets.',
          ),
          // Add more FAQItems as needed
        ],
      ),
    );
  }
}

class FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const FAQItem({Key? key, required this.question, required this.answer})
      : super(key: key);

  @override
  _FAQItemState createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        title: Text(
          widget.question,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        collapsedBackgroundColor: Colors.teal.withOpacity(0.1),
        backgroundColor: Colors.teal.withOpacity(0.1),
        textColor: Colors.black,
        iconColor: Colors.teal,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              widget.answer,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
        onExpansionChanged: (bool expanded) {
          setState(() {
            isExpanded = expanded;
          });
        },
        initiallyExpanded: isExpanded,
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FAQScreen(),
    theme: ThemeData(
      primaryColor: Colors.teal, // Customize the overall theme color
    ),
  ));
}
