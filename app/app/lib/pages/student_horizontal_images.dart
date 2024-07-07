import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    // routes: {'/shape': (context) => const Shape()},
    home: Try()));

class Try extends StatefulWidget {
  var length;

  Try({Key? key}) : super(key: key);

  // Function()? onTap;

  @override
  State<Try> createState() => _Try();
}

class _Try extends State<Try> {
  List<String> photos = [];
  @override
  void initState() {
    super.initState();
    // Initialize your imageList here
    photos = [
      'hotel1.png',
      'hotel2.png',
      'hotel3.png',
      'hotel4.png',
      'hotel5.png',
      'hotel6.png'
      // Add more images to the list as needed
    ];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.blueAccent),
      ),
      body: SingleChildScrollView(
          child: Container(
              height: size.height,
              width: double.infinity,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 300.0,
                      margin: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.grey.shade200)),
                      child: InkWell(
                        onTap: () {},
                        child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 350,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: Colors.grey.shade200,
                                    ),
                                    child: Image.asset(
                                      photos[index],
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                ])),
                      ),
                    );
                  }))),
    );
  }
}
