import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gloom/auth/login_page.dart';
import 'package:gloom/helper/helper_functions.dart';
import 'package:gloom/pages/home_page.dart';
import 'package:gloom/service/auth_service.dart';
import 'package:gloom/widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formkey = GlobalKey<FormState>();
  String fullname = "";
  String email = "";
  String password = "";
  bool _isloading = false;
  AuthServices authServices = AuthServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RegisterPage"),
      ),
      body: _isloading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Form(
                    key: formkey,
                    child: Column(
                      children: [
                        Text("GROUPIE?"),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Rgister and see what's new"),
                        Image.asset(
                          "assets/register.png",
                          height: 400,
                          width: 400,
                        ),
                        TextFormField(
                          decoration: textinputdecoration.copyWith(
                              labelText: "fullname",
                              labelStyle:
                                  TextStyle(fontWeight: FontWeight.bold),
                              prefixIcon: Icon(Icons.person)),
                          onChanged: (value) {
                            setState(() {
                              fullname = value;
                            });
                          },
                          validator: (value) {
                            if (value!.isNotEmpty) {
                              return null;
                            } else {
                              return "Name cannot be null";
                            }
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: textinputdecoration.copyWith(
                              labelText: "email",
                              labelStyle:
                                  TextStyle(fontWeight: FontWeight.bold),
                              prefixIcon: Icon(Icons.email)),
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
                                : "Enter a valid email";
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: textinputdecoration.copyWith(
                              labelText: "password",
                              labelStyle:
                                  TextStyle(fontWeight: FontWeight.bold),
                              prefixIcon: Icon(Icons.password)),
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                          validator: (value) {
                            if (value!.length < 6) {
                              return "Password should be atleast of 6 characters";
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () {
                                  register();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange),
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(color: Colors.white),
                                ))),
                        Text.rich(TextSpan(
                            text: "Alreday have an account? ",
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                  text: "Login",
                                  style: TextStyle(),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      nextScreen(context, LoginPage());
                                    })
                            ]))
                      ],
                    )),
              ),
            ),
    );
  }

  register() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        _isloading = true;
      });
      await authServices.register(email, password, fullname).then((value) {
        if (value == true) {
          HelperFunctions.setuserloggedinstatus(true);
          HelperFunctions.setemailkeysf(email);
          HelperFunctions.setusernamesf(fullname);
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
