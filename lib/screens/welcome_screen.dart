import 'package:flutter/material.dart';
import 'auth/login_screen.dart';
import 'auth/registration_screen.dart';
import 'package:flitter/components/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';
  WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  //   with SingleTickerProviderStateMixin {
  // AnimationController controller;
  // Animation animation;

  // @override
  // void initState() {
  //   super.initState();
  //
  //   controller = AnimationController(
  //     duration: Duration(seconds: 1),
  //     vsync: this,
  //   );
  //   animation = ColorTween(
  //     begin: Colors.blueGrey,
  //     end: Colors.white,
  //   ).animate(controller);
  //   controller.forward();
  //   controller.addListener(() {
  //     setState(() {});
  //   });
  // }
  //
  // @override
  // void dispose() {
  //   controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                // Hero(
                //   tag: 'logo',
                //   child: Container(
                //     child: Image.asset('images/logo.png'),
                //     height: 60.0,
                //   ),
                // ),
                // AnimatedTextKit(
                //   animatedTexts: [
                //     TypewriterAnimatedText(
                //       'Flash Chat',
                //       textStyle: TextStyle(
                //         fontSize: 45.0,
                //         fontWeight: FontWeight.w900,
                //       ),
                //       // Change this to make it faster or slower
                //       speed: Duration(milliseconds: 350),
                //     ),
                //   ],
                //   // You could replace repeatForever to a fixed number of repeats
                //   // with totalRepeatCount: X, where X is the repeats you want.
                //   repeatForever: true,
                // ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              color: Colors.lightBlueAccent,
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  LoginScreen.id,
                );
              },
              title: 'Log In',
            ),
            RoundedButton(
              color: Colors.blueAccent,
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  RegistrationScreen.id,
                );
              },
              title: 'Register',
            ),
          ],
        ),
      ),
    );
  }
}
