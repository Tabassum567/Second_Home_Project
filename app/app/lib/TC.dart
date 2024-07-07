import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
        backgroundColor: Colors.teal, // Customize the app bar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: const <Widget>[
            TermsConditionsItem(
              title: 'Acceptance of Terms',
              content:
                  'By using this student housing accommodation application, you agree to be bound by these Terms and Conditions. If you do not agree to these terms, please do not use the application.',
            ),
            TermsConditionsItem(
              title: 'Eligibility',
              content:
                  'To use this application, you must be a student seeking housing accommodation and have the legal capacity to enter into a contract.',
            ),
            TermsConditionsItem(
              title: 'User Responsibilities',
              content:
                  'As a user of this application, you are responsible for providing accurate and up-to-date information during the housing application process. You must also adhere to any rules and regulations set forth by the housing providers and educational institutions.',
            ),
            TermsConditionsItem(
              title: 'Intellectual Property',
              content:
                  'All intellectual property rights related to this application, including but not limited to the logo, design, and content, belong to the application owner. Users are prohibited from using, reproducing, or distributing any of the intellectual property without prior consent.',
            ),
            TermsConditionsItem(
              title: 'Data Privacy',
              content:
                  'By using this application, you agree to the collection and use of your personal information as outlined in the Privacy Policy. Please review the Privacy Policy for more information on data collection, usage, and security.',
            ),
            TermsConditionsItem(
              title: 'Disclaimer of Liability',
              content:
                  'The application owner and its affiliates shall not be liable for any direct, indirect, incidental, consequential, or exemplary damages resulting from the use of this application or any housing services provided through the application.',
            ),
            TermsConditionsItem(
              title: 'Modifications to the Terms',
              content:
                  'The application owner reserves the right to modify or update these Terms and Conditions at any time. Users will be notified of any changes, and continued use of the application after the modifications constitutes acceptance of the updated Terms.',
            ),
          ],
        ),
      ),
    );
  }
}

class TermsConditionsItem extends StatelessWidget {
  final String title;
  final String content;

  const TermsConditionsItem(
      {Key? key, required this.title, required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              content,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TermsConditionsScreen(),
    theme: ThemeData(
      primaryColor: Colors.teal, // Customize the overall theme color
    ),
  ));
}
