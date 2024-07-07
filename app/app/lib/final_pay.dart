import 'package:app/pages/student_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quickalert/quickalert.dart';

import 'package:intl/intl.dart';

final _expiryDateController = TextEditingController();
TextFormField buildTextField(
  String labelText,
  Function(String) onChanged, {
  TextInputType keyboardType = TextInputType.text,
}) {
  return TextFormField(
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    style: const TextStyle(fontSize: 16),
    keyboardType: keyboardType,
    onChanged: onChanged,
  );
}

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String formattedValue = '';
    int selectionIndex = newValue.selection.end;

    // Remove all non-digit characters from the new value
    String unformattedValue = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Apply the MM/YY format
    if (unformattedValue.length >= 2) {
      formattedValue += '${unformattedValue.substring(0, 2)}/';
      if (selectionIndex > 2) selectionIndex += 1;
    }
    if (unformattedValue.length >= 4) {
      formattedValue += '${unformattedValue.substring(2, 4)}';
      if (selectionIndex > 4) selectionIndex += 1;
    }

    // Prevent the user from entering more than 4 digits
    if (unformattedValue.length > 4) {
      unformattedValue = unformattedValue.substring(0, 4);
    }

    // Return the formatted value and update the selection index
    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

class PaymentScreen extends StatefulWidget {
  var monthlyRent;

  var advancePayment;

  var propertyId;

  var userEmail;

  var startDate;

  var endDate;

  var selectedRoomType;

  var sharedRoomId;

  var privateRoomId;

  var status;

  PaymentScreen({
    Key? key,
    required this.monthlyRent,
    required this.advancePayment,
    required this.propertyId,
    required this.userEmail,
    required this.startDate,
    required this.endDate,
    required this.selectedRoomType,
    required this.sharedRoomId,
    required this.privateRoomId,
    required this.status,
  }) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

String? cardNumber;
int? bookingAmount;
int? advancePayment;
int? totalAmount;

class _PaymentScreenState extends State<PaymentScreen> {
  String cardholderName = '';
  String cardNumber = '';
  String expirationDate = '';
  String cvv = '';
  // String? cardholderName;
  // String? cardNumber;

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.teal,
      actions: [
        // IconButton(onPressed: (){}, icon: Image.asset("plus.png", color: Colors.black,width: 30,)),
        IconButton(
          onPressed: () {},
          icon: Image.asset(
            "bin.png",
            color: Colors.black,
            width: 25,
          ),
        )
      ],
    );
  }

  void showAlert() {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      bookingAmount = int.parse(widget.monthlyRent);
      advancePayment = int.parse(widget.advancePayment);
      totalAmount = bookingAmount! + advancePayment!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Payment",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "One step away from final booking",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
              const Divider(),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                height: 180,
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const SweepGradient(
                    center: AlignmentDirectional(1, -1),
                    startAngle: 1.7,
                    endAngle: 3,
                    colors: <Color>[
                      Color(0xff148535),
                      Color(0xff148535),
                      Color(0xff0D6630),
                      Color(0xff0D6630),
                      Color(0xff148535),
                      Color(0xff148535),
                    ],
                    stops: <double>[
                      0.0,
                      0.3,
                      0.3,
                      0.7,
                      0.7,
                      1.0,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Visa",
                          style: TextStyle(
                            fontSize: 24.30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "visa Electron",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      "****  ****  **** ****  2193",
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Card Holder",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white24,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Komal Devi Aruwani",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white24,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                )
                              ],
                            )),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Expiry",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white24,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "07 / 23",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                )
                              ],
                            )),
                            const Expanded(
                                child: Align(
                              alignment: Alignment.centerRight,
                              child: CircleAvatar(
                                backgroundColor: Colors.lightGreen,
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                ),
                              ),
                            ))
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              // const SizedBox(height: 20.0),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Card Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: buildTextField(
                  'Cardholder Name',
                  (value) {
                    setState(() {
                      cardholderName = value;
                      // print(cardholderName);
                    });
                  },
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: buildTextField(
                  'Card Number',
                  (value) {
                    setState(() {
                      cardNumber = value;
                    });
                  },
                  keyboardType: TextInputType.number,
                ),
              ),

              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: buildTextField(
                        'Expiration Date',
                        (value) {
                          setState(() {
                            expirationDate = value;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: buildTextField(
                        'CVV',
                        (value) {
                          setState(() {
                            cvv = value;
                          });
                        },
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Total',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Booking Amount',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      bookingAmount.toString(),
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
              ),
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Advance Payment',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      advancePayment.toString(),
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      totalAmount.toString(),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 23),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.teal),
                  ),
                  onPressed: () {
                    if (cardNumber == null || cardNumber!.length != 16) {
                      final snackBar = SnackBar(
                        content:
                            Text('Please enter a valid 16-digit card number'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      // continue with payment processing
                      print("Proceeding to Payment");

                      QuickAlert.show(
                        context: context,
                        text: "Are you sure to proceed with the payment",
                        type: QuickAlertType.confirm,
                        onConfirmBtnTap: () async {
                          var response = await bookRoom(
                              widget.selectedRoomType == 'Shared Room'
                                  ? widget.sharedRoomId
                                  : widget.privateRoomId,
                              widget.userEmail,
                              widget.propertyId,
                              DateFormat('dd-MM-yyyy').format(widget.startDate),
                              DateFormat('dd-MM-yyyy').format(widget.endDate),
                              cardholderName,
                              cardNumber,
                              expirationDate,
                              cvv,
                              totalAmount);

                          if (response.statusCode == 200) {
                            print("${json.decode(response.body)['message']}");
                            QuickAlert.show(
                              context: context,
                              text: "Payment Succesful",
                              type: QuickAlertType.success,
                              onConfirmBtnTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NavBar(
                                              email: widget.userEmail,
                                              role: "Student",
                                              status: widget.status,
                                            )));
                              },
                            );
                          } else {
                            print("${json.decode(response.body)['message']}");
                          }
                        },
                        onCancelBtnTap: () {
                          Navigator.pop(context);
                        },
                      );
                    }
                  },
                  child: const Text('Pay Now'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// API Call
Future bookRoom(roomId, userEmail, propertyId, start_date, end_date,
    card_holder_name, card_number, expiration_date, cvv, total_amount) async {
  var response =
      await http.post(Uri.parse("http://localhost:5000/bookRoom"), body: {
    "roomId": roomId,
    "userEmail": userEmail,
    "propertyId": propertyId,
    "start_date": start_date,
    "end_date": end_date,
    "card_holder_name": card_holder_name,
    "card_number": card_number,
    "expiration_date": expiration_date,
    "cvv": cvv,
    "total_amount": total_amount.toString()
  });
  return response;
}
