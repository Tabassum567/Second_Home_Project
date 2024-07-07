// import 'dart:html';
// import 'dart:html';
// import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:app/Dashboard.dart';
import 'package:app/owner_homescree.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

XFile? pickedFile;

updateProfile(name, number, image, email_address) async {
  print(
      " Email Address = $email_address and name = $name and number = $number");
  if (image != null) {
    print("Image Gotten");
    Uint8List base64Data = await image!.readAsBytes();
    String image64 = base64.encode(base64Data);
    var response = await http.post(
        Uri.parse("http://localhost:5000/updateCustomer/$email_address"),
        body: {
          "email_address": email_address,
          "name": name,
          "contact_number": number,
          "image": image64,
        });
  } else {
    print("Image not Gotten");
    var response = await http.post(
        Uri.parse("http://localhost:5000/updateCustomer/$email_address"),
        body: {
          "email_address": email_address.toString(),
          "name": name.toString(),
          "contact_number": number,
          "image": "",
        });
  }
  print("=================>          Sent Data");
}

class CreateProfile extends StatefulWidget {
  var email_address;

  var name;

  var contact_number;

  var nic;

  var picture_url;

  var status;

  CreateProfile(
      {super.key,
      required this.email_address,
      required this.name,
      required this.contact_number,
      required this.nic,
      required this.picture_url,
      required this.status});

  @override
  State<CreateProfile> createState() {
    return _CreateProfileState();
  }
}

class _CreateProfileState extends State<CreateProfile> {
  bool enabled = false;
  final _formKey = GlobalKey<FormState>();
  String? _imageFile = "";
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: widget.name);
    final emailController = TextEditingController(text: widget.email_address);
    final numberController = TextEditingController(text: widget.contact_number);
    final nicController = TextEditingController(text: widget.nic);
    print("Image = ${widget.picture_url}");
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        toolbarHeight: 40,
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.green),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Form(
          // autovalidateMode: AutovalidateMode.always,
          key: _formKey,
          child: ListView(
            children: [
              personImage(),
              const SizedBox(
                height: 10,
              ),
              nameField(nameController),
              const SizedBox(
                height: 20,
              ),
              emailField(emailController),
              const SizedBox(
                height: 20,
              ),
              phoneField(numberController),
              const SizedBox(
                height: 20,
              ),
              NICField(nicController),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    enabled == true ? enabled = false : enabled = true;
                  });
                },
                style: TextButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.teal,
                ),
                // highlightColor: Colors.transparent,
                // splashColor: Colors.black,
                //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
                  child: Text(
                    'Edit',
                    style: TextStyle(
                        // backgroundColor: Colors.green,
                        color: Colors.white,
                        fontSize: 16.0,
                        fontFamily: 'WorkSansBold'),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () async {
                  validate();

                  final response = await updateProfile(nameController.text,
                      numberController.text, pickedFile, widget.email_address);
                  if (response.statusCode == 200) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => barNav(
                                email: widget.email_address,
                                status: widget.status,
                              )),
                    );
                  } else {
                    Alert(
                            context: this.context,
                            title: "Error",
                            desc: jsonDecode(response.body)['message'])
                        .show();
                  }
                  print("Clicked");
                },
                style: TextButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.teal,
                ),
                // highlightColor: Colors.transparent,
                // splashColor: Colors.black,
                //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
                  child: Text(
                    'Save and Submit',
                    style: TextStyle(
                        // backgroundColor: Colors.green,
                        color: Colors.white,
                        fontSize: 16.0,
                        fontFamily: 'WorkSansBold'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void validate() {
    if (_formKey.currentState!.validate()) {
      print("Saved");
    } else {
      print("Error");
    }
  }

  Widget bottomPage() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          const Text(
            "Choose Profile Photo",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              icon: const Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: const Text("Camera"),
            ),
            TextButton.icon(
              icon: const Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
                // final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
              },
              label: const Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    pickedFile = await _picker.pickImage(
      source: source,
    );
    setState(() {
      _imageFile = pickedFile!.path;
    });
  }

  Widget personImage() {
    return Center(
      child: Stack(
        children: [
          SizedBox(
              width: 130,
              height: 130,
              child: widget.picture_url != null
                  ? CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.transparent,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(70),
                          child: Image(
                            image:
                                NetworkImage(widget.picture_url ?? "Sir.jpg"),
                            width: 200,
                            height: 200,
                          )),
                    )
                  : CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.transparent,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.network(_imageFile!,
                              width: 120, height: 120, fit: BoxFit.cover)),
                    )),
          Positioned(
            bottom: 12,
            right: 15,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => bottomPage()),
                );
              },
              child: const Icon(
                Icons.camera_alt,
                color: Colors.green,
                size: 24,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget nameField(nameController) {
    return TextFormField(
      controller: nameController,
      enabled: enabled,
      validator: RequiredValidator(errorText: "Required"),
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.orange,
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.person,
          size: 16,
          color: Colors.blue,
        ),
        labelText: "Name",
        hintText: "Write Name",
      ),
    );
  }

  Widget emailField(emailController) {
    return TextFormField(
      controller: emailController,
      enabled: false,
      validator: MultiValidator([
        RequiredValidator(errorText: "Required"),
        EmailValidator(errorText: "Not valid")
      ]),
      decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.orange,
              width: 2,
            ),
          ),
          prefixIcon: Icon(
            Icons.email,
            size: 16,
            color: Colors.blue,
          ),
          labelText: "Email",
          hintText: "ali@gmail.com"),
    );
  }

  Widget phoneField(numberController) {
    return TextFormField(
      controller: numberController,
      enabled: enabled,
      validator: MultiValidator([
        RequiredValidator(errorText: "Required"),
        MaxLengthValidator(11, errorText: "11 required"),
        PatternValidator(r'^(?:[+0][1-9])?[0-9]{10,12}$', errorText: 'error'),
      ]),
      decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.orange,
              width: 2,
            ),
          ),
          prefixIcon: Icon(
            Icons.numbers,
            size: 16,
            color: Colors.blue,
          ),
          labelText: "ContactNumber",
          hintText: "Number"),
    );
  }

  Widget NICField(nicController) {
    return TextFormField(
      controller: nicController,
      enabled: false,
      validator: MultiValidator([
        RequiredValidator(errorText: "Required"),
        MaxLengthValidator(13, errorText: "13 required"),
        PatternValidator(r'^[1-4]{1}[0-9]{4}(-)?[0-9]{7}(-)?[0-9]{1}$',
            errorText: 'error'),
      ]),

      // maxLines: 4,
      decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.orange,
              width: 2,
            ),
          ),
          prefixIcon: Icon(
            Icons.supervised_user_circle,
            size: 16,
            color: Colors.blue,
          ),
          labelText: "CNIC",
          hintText: "ID"),
    );
  }
}
