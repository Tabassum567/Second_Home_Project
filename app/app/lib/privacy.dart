import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
        backgroundColor: Colors.teal, // Customize the app bar color
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: const <Widget>[
            PrivacyPolicyItem(
              title: 'Data Collection',
              content:
                  'We collect personal information such as name, email, phone number, and address during the student housing application process. This information is used for the purpose of providing housing services and maintaining communication with the applicants.',
            ),
            PrivacyPolicyItem(
              title: 'Data Usage',
              content:
                  'The collected data is used to facilitate the application and housing allocation process, including verifying eligibility, assigning rooms, and managing lease agreements. We may also use the data to improve our services and provide personalized recommendations to students.',
            ),
            PrivacyPolicyItem(
              title: 'Data Sharing',
              content:
                  'We may share the collected personal information with relevant housing providers, educational institutions, and third-party service providers involved in the housing application and allocation process. However, we do not sell or rent personal data to third parties for marketing purposes.',
            ),
            PrivacyPolicyItem(
              title: 'Data Security',
              content:
                  'We take appropriate measures to ensure the security and confidentiality of the collected personal data. This includes employing industry-standard encryption, access controls, and regular security audits. However, it is important to note that no method of data transmission over the internet or electronic storage is 100% secure.',
            ),
            PrivacyPolicyItem(
              title: 'Data Retention',
              content:
                  'We retain personal data for as long as necessary to fulfill the purposes outlined in this privacy policy, unless a longer retention period is required or permitted by law. After the retention period, we will securely dispose of the data.',
            ),
            PrivacyPolicyItem(
              title: 'User Rights',
              content:
                  'Users have the right to access, rectify, or delete their personal information held by us. If you wish to exercise any of these rights or have any privacy-related concerns, please contact us through the provided channels.',
            ),
            PrivacyPolicyItem(
              title: 'Policy Changes',
              content:
                  'We reserve the right to modify or update this privacy policy at any time. Any changes will be communicated to users through appropriate means. It is advisable to review this policy periodically for any updates.',
            ),
          ],
        ),
      ),
    );
  }
}

class PrivacyPolicyItem extends StatelessWidget {
  final String title;
  final String content;

  const PrivacyPolicyItem({Key? key, required this.title, required this.content})
      : super(key: key);

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
          title,
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
              content,
              style: TextStyle(fontSize: 16),
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
    home: PrivacyPolicyScreen(),
    theme: ThemeData(
      primaryColor: Colors.teal, // Customize the overall theme color
    ),
  ));
}
