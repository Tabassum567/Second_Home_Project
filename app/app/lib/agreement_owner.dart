import 'package:app/Dashboard.dart';
import 'package:app/owner_homescree.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

setAgreement(email_address) async {
  final response = await http
      .post(Uri.parse("http://localhost:5000/setAgreement/$email_address"));
}

class Agreement extends StatefulWidget {
  var email_address;

  var status;

  Agreement({super.key, required this.email_address, required this.status});

  @override
  State<Agreement> createState() => _AgreementState();
}

class _AgreementState extends State<Agreement> {
  bool _termsChecked = false;
  void _doSomething() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => barNav(
                email: widget.email_address,
                status: widget.status,
              )),
    );

    // Do something
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(children: [
              Icon(
                Icons.receipt_long,
                size: size.height * 0.08,
                color: Colors.teal,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Terms & Conditions",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.roboto(
                        // color: Colors.black.withOpacity(0.7),
                        fontWeight: FontWeight.w700,
                        fontSize: size.height * 0.0175),
                  ),
                  Text(
                    "Last Updated:Date",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.roboto(
                        color: Colors.black.withOpacity(0.7),
                        fontWeight: FontWeight.w700,
                        fontSize: size.height * 0.0175),
                  ),
                ],
              ),
            ]),
            SizedBox(
              height: size.height * 0.015,
            ),
            Container(
                width: size.width,
                alignment: Alignment.topLeft,
                child: RichText(
                  text: TextSpan(
                    // style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Agreement Policy for Owner:\n',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: size.height * 0.02,
                            color: Colors.black.withOpacity(0.7),
                          )),
                      const TextSpan(
                        text:
                            '1.Listing of Properties: Landlords shall list their properties on the App and provide accurate and up-to-date information about the properties, including the address, rent, and amenities. The App shall make the listed properties available for viewing by potential tenants.\n2.Rent Collection: The App shall collect rent from tenants on behalf of the Landlords. Rent shall be due on the due date specified in the lease agreement. If rent is not received by the due date, a late fee may be assessed by the Landlord.\n3.Commission: The App shall charge a commission on rent collected from tenants. The commission rate shall be [commission rate] percent of the rent collected.\n4.Maintenance and Repairs: Landlords shall be responsible for maintaining their properties in a habitable condition and for making any necessary repairs. Tenants shall be responsible for notifying the App of any needed repairs.\n5.Termination: Either party may terminate this Policy upon [notice period] days written notice to the other party.\n6.Entire Agreement: This Policy constitutes the entire agreement between the parties and supersedes all prior agreements and understandings, whether oral or written.\n7.Severability: If any provision of this Policy is held to be invalid or unenforceable, such provision shall be struck and the remaining provisions shall be enforced.\n8.Waiver: The failure of either party to enforce any rights under this Policy shall not be deemed a waiver of such rights.\n',
                      ),
                      const TextSpan(
                          text:
                              'By using the App, Landlords acknowledge that they have read, understood and agreed to be bound by the terms and conditions of this Policy.\n'),
                      // TextSpan(text: 'Line 4 of your terms and conditions\n'),
                    ],
                  ),
                )),
            Row(
              children: [
                Material(
                  child: Checkbox(
                    value: _termsChecked,
                    onChanged: (value) {
                      setState(() {
                        _termsChecked = value ?? false;
                      });
                    },
                    activeColor: Colors.teal, // Customize the checkbox color
                    checkColor: Colors.white,
                  ),
                ),
                const Text(
                  'I have read and accept terms and conditions',
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  setAgreement(widget.email_address);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => barNav(
                              email: widget.email_address,
                              status: widget.status,
                            )),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 24), // Customize the button padding
                  textStyle:
                      TextStyle(fontSize: 16), // Customize the text style
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8), // Customize the button border radius
                  ),
                  backgroundColor:
                      Colors.teal, // Customize the button background color
                  foregroundColor:
                      Colors.white, // Customize the button text color
                ),
                child: const Text(
                  'Agree',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      )),
    );
  }
}
