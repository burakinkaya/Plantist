import 'package:flutter/material.dart';
import '../src/components/customText.dart';
import './signIn.dart';
import "./signUp.dart";

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: size.height * 0.20),
                  Image(
                    image: const AssetImage('assets/mainPage.png'),
                    height: size.height * 0.3,
                  ),
                  SizedBox(height: size.height * 0.05),
                  const CustomText(
                    text: 'Welcome back to',
                    fontSize: 40,
                    color: Colors.black,
                  ),
                  const CustomText(
                    text: 'Plantist',
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                  SizedBox(height: size.height * 0.05),
                  CustomText(
                    text: 'Start your productive life now!',
                    fontSize: 14,
                    color: Colors.grey[800],
                  ),
                  SizedBox(height: size.height * 0.05),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(
                        Icons.mail_rounded,
                        color: Colors.black,
                      ),
                      label: const CustomText(
                        text: 'Sign in with email',
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignIn()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const CustomText(
                        text: "Don't you have an account? ",
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w800,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUp()),
                          );
                        },
                        child: const CustomText(
                          text: "Sign up",
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
