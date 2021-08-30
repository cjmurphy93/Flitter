import 'package:flutter/material.dart';
import 'auth/login_screen.dart';
import 'auth/registration_screen.dart';
import 'package:flitter/components/rounded_button.dart';
import 'package:flitter/services/auth_services.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

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
  //
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
  final AuthService _auth = AuthService();
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
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                // Text(
                //   'Flitter',
                //   style: TextStyle(
                //     fontSize: 45.0,
                //     fontWeight: FontWeight.w900,
                //   ),
                // ),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Flitter',
                      textStyle: TextStyle(
                        fontSize: 45.0,
                        fontWeight: FontWeight.w900,
                      ),
                      // Change this to make it faster or slower
                      speed: Duration(milliseconds: 150),
                    ),
                    TypewriterAnimatedText(
                      'made by',
                      textStyle: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w900,
                      ),
                      // Change this to make it faster or slower
                      speed: Duration(milliseconds: 100),
                    ),
                    ColorizeAnimatedText(
                      'Connor Murphy',
                      textStyle: TextStyle(
                        fontSize: 35.0,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Horizon',
                      ),
                      colors: [
                        Colors.blue,
                        Colors.blueGrey,
                        Colors.black,
                      ],
                      // Change this to make it faster or slower
                      speed: Duration(milliseconds: 200),
                    ),
                  ],
                  // You could replace repeatForever to a fixed number of repeats
                  // with totalRepeatCount: X, where X is the repeats you want.
                  repeatForever: true,
                ),
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
            RoundedButton(
              title: 'Demo User',
              onPressed: () async {
                // setState(() {
                //   showSpinner = true;
                // },);
                try {
                  _auth.signIn(
                    'demo@user.com',
                    'password123',
                  );
                  Navigator.pushNamed(
                    context,
                    '/',
                  );
                } catch (e) {
                  print(e);
                } finally {
                  // setState(() {
                  //   showSpinner = false;
                  // },);
                }
              },
              color: Colors.lightBlueAccent,
            ),
          ],
        ),
      ),
    );
  }
}
