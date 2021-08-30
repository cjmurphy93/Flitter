import 'package:flutter/material.dart';
import 'package:flitter/services/auth_services.dart';
import 'package:flitter/components/rounded_button.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flitter/constants.dart';
import 'package:flitter/screens/home.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  LoginScreen({Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  bool showSpinner = false;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LoadingOverlay(
        isLoading: showSpinner,
        opacity: 0.2,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your email',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password',
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                title: 'Log In',
                onPressed: () async {
                  setState(
                    () {
                      showSpinner = true;
                    },
                  );
                  try {
                    _auth.signIn(
                      email,
                      password,
                    );
                  } catch (e) {
                    print(e);
                  } finally {
                    setState(
                      () {
                        showSpinner = false;
                      },
                    );
                    Navigator.pushNamed(
                      context,
                      '/',
                    );
                  }
                },
                color: Colors.lightBlueAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
