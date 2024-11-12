import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gloom/auth/register_page.dart';
import 'package:gloom/pages/home_page.dart';
import 'package:gloom/service/auth_service.dart';
import 'package:gloom/widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formkey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isloading = false;
  AuthServices authServices = AuthServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: _isloading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Form(
                  key: formkey,
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min, // To reduce unnecessary space
                    children: <Widget>[
                      SizedBox(height: 30), // Space between top and content
                      Text(
                        "GROUPIE!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Login and see what's new",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 20),
                      // Use a smaller image size to prevent it from taking up too much space
                      Image.asset(
                        "assets/login.png",
                        height: 400, // Adjust height
                        width: 400, // Adjust width
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        decoration: textinputdecoration.copyWith(
                          labelText: "Email",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          prefixIcon: Icon(Icons.email),
                        ),
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                        validator: (value) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value!)
                              ? null
                              : "Please enter a valid email";
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        obscureText: true,
                        decoration: textinputdecoration.copyWith(
                          labelText: "Password",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          prefixIcon: Icon(Icons.password),
                        ),
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                        validator: (value) {
                          if (value!.length < 8) {
                            return "Enter a password which is greater than 8 characters";
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            login();
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            backgroundColor: Colors.orange,
                          ),
                          child: Text(
                            "SIGN IN",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text.rich(
                        TextSpan(
                          text: "Don't have an account?",
                          children: [
                            TextSpan(
                              text: "REGISTER NOW",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  nextScreen(context, RegisterPage());
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  login() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        _isloading = true;
      });
      await authServices.login(email, password).then((value) {
        if (value == true) {
          nextScreenReplacement(context, HomePage());
        } else {
          showsnackbar(context, value, Colors.orange);
          setState(() {
            _isloading = false;
          });
        }
      });
    }
  }
}
