import 'package:flutter/material.dart';
import 'package:gloom/auth/login_page.dart';
import 'package:gloom/pages/home_page.dart';
import 'package:gloom/service/auth_service.dart';

class ProfilePage extends StatefulWidget {
  String username;
  String email;
  ProfilePage({super.key, required this.username, required this.email});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthServices authservices = AuthServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profilepage"),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              Icon(
                Icons.person,
                size: 150,
              ),
              SizedBox(
                height: 20,
              ),
              Text(widget.username),
              SizedBox(
                height: 20,
              ),
              Text(widget.email),
              SizedBox(
                height: 20,
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("profile"),
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("logout"),
                onTap: () async {
                  await authservices.signout();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
              )
            ],
          ),
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 80),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.person,
                  size: 300,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("Fullname"), Text(widget.username)],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("Email"), Text(widget.email)],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
