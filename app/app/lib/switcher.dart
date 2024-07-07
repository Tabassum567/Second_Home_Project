import 'package:app/login_page_1.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GetStarted(),
    ));

class GetStarted extends StatelessWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IntroductionScreen(
        showNextButton: true,
        pages: [
          PageViewModel(
            title: 'Your Security Partner',
            bodyWidget: const Text(
              'Welcome to our app, your trusted security partner!',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            image: buildImage('house.png'),
            decoration: decoration(),
          ),
          PageViewModel(
            title: 'Off-Campus Housing Services',
            bodyWidget: const Text(
              'Discover the best off-campus housing options!',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            image: buildImage('Reading.png'),
            decoration: decoration(),
          ),
          PageViewModel(
            title: 'Help A Mate Out',
            bodyWidget: const Text(
              'Help your friends find great accommodation!',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            image: buildImage('help_mate.jpg'),
            decoration: decoration(),
          ),
          PageViewModel(
            title: 'Online Consulting',
            bodyWidget: const Text(
              'Get expert advice and consulting online!',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            image: buildImage('online-consulting.webp'),
            decoration: decoration(),
          ),
        ],
        done: const Text(
          'Done',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Times New Roman',
            fontSize: 16,
          ),
        ),
        onDone: () {
          home(context);
        },
        showSkipButton: true,
        skip: const Text(
          'Skip',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
        onSkip: () {
          home(context);
        },
        next: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.white,
        ),
        dotsDecorator: dots(),
        nextFlex: 0,
        skipStyle: TextButton.styleFrom(
          primary: Colors.teal,
        ),
        doneStyle: TextButton.styleFrom(
          primary: Colors.teal,
        ),
        nextStyle: TextButton.styleFrom(
          primary: Colors.white,
          backgroundColor: Colors.teal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget buildImage(String path) {
    return Center(
      child: Image.asset(
        path,
        width: 350,
      ),
    );
  }

  PageDecoration decoration() => const PageDecoration(
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontFamily: 'Times New Roman',
        ),
        titlePadding: EdgeInsets.only(top: 50),
        imagePadding: EdgeInsets.all(24),
        pageColor: Colors.white,
      );

  DotsDecorator dots() => const DotsDecorator(
        color: Color.fromARGB(255, 178, 223, 219),
        size: Size(10, 10),
        activeColor: Colors.teal,
        activeSize: Size(15, 15),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
      );
}

void home(BuildContext context) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (_) => Login()),
  );
}
