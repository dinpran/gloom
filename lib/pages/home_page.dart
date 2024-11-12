import 'package:flutter/material.dart';
import 'package:gloom/auth/login_page.dart';
import 'package:gloom/helper/helper_functions.dart';
import 'package:gloom/pages/profile_page.dart';
import 'package:gloom/service/auth_service.dart';
import 'package:gloom/service/database_service.dart';
import 'package:gloom/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthServices authServices = AuthServices();
  DatabaseService databaseService = DatabaseService();
  String username = "";
  String email = "";
  String userId = "";

  // Sample product list
  final List<Map<String, dynamic>> products = [
    {"name": "Phone", "price": 599.99, "image": "assets/phone_2.jpg"},
    {"name": "Earbuds", "price": 29.99, "image": "assets/earbuds_2.jpg"},
    {"name": "Mouse", "price": 19.99, "image": "assets/mouse_2.jpg"},
    {"name": "Keyboard", "price": 49.99, "image": "assets/keyboard_2.jpg"},
    {"name": "Laptop", "price": 799.99, "image": "assets/macbook_2.jpg"},
    {"name": "Smartwatch", "price": 199.99, "image": "assets/smart_watch.jpeg"},
  ];

  @override
  void initState() {
    super.initState();
    getuserdata();
  }

  getuserdata() async {
    await HelperFunctions.getuseremail().then((value) {
      setState(() {
        email = value!;
      });
    });

    await HelperFunctions.getusername().then((value) {
      setState(() {
        username = value!;
      });
    });

    userId = authServices.getCurrentUserId();
  }

  Future<void> placeOrder(String productName, double price) async {
    String orderId = DateTime.now().millisecondsSinceEpoch.toString();
    DateTime orderDate = DateTime.now();

    await databaseService.createOrder(
      orderId: orderId,
      orderName: productName,
      price: price,
      userId: userId,
      userName: username,
      userEmail: email,
      orderDate: orderDate,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Order for $productName placed successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "HomePage",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Image.asset('assets/logo.jpeg', height: 40),
            onPressed: () {
              // You can add an action to handle clicks on the logo
              Scaffold.of(context).openDrawer();
            },
          ),
        ],
        iconTheme: IconThemeData(
          color: Colors.white, // Change the color of the drawer icon
        ),
        backgroundColor: Colors.blue, // AppBar background color matches logo
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer header with logo and user info
            Container(
              color: Colors.blue, // Match with your logo's blue color
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Image.asset('assets/logo.jpeg', height: 80), // Your logo
                  SizedBox(height: 10),
                  Text(
                    username,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    email,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.blue),
              onTap: () {
                nextScreen(
                    context,
                    ProfilePage(
                      username: username,
                      email: email,
                    ));
              },
              title: Text("Profile", style: TextStyle(color: Colors.black)),
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.blue),
              onTap: () {
                authServices.signout();
                nextScreenReplacement(context, LoginPage());
              },
              title: Text("Logout", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5, // 5 products in one row
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio:
                0.75, // Adjust the ratio to make images look attractive
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Card(
              elevation: 6,
              shadowColor: Colors.blueAccent.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(12), // Rounded corners for more style
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.asset(
                        product["image"],
                        fit: BoxFit
                            .cover, // Ensures the image covers the space nicely
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      product["name"],
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Text(
                      "\$${product["price"].toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            Colors.blue, // Match product price with blue color
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        placeOrder(product["name"], product["price"]);
                      },
                      child: Text(
                        "Order",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[700], // Button in orange
                        minimumSize: Size(80, 30),
                        padding: EdgeInsets.zero,
                        textStyle: TextStyle(fontSize: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
