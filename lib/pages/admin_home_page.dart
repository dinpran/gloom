import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gloom/service/auth_service.dart';
import 'package:gloom/service/database_service.dart';
// import 'package:gloom/service/database_services.dart';
import 'package:gloom/auth/login_page.dart';
import 'package:gloom/shared/constants.dart';
import 'package:gloom/helper/helper_functions.dart';
import 'package:gloom/widgets/widgets.dart';
import 'package:intl/intl.dart'; // Import the intl package for DateFormat

class Admin_HomePage extends StatefulWidget {
  const Admin_HomePage({super.key});

  @override
  State<Admin_HomePage> createState() => _Admin_HomePageState();
}

class _Admin_HomePageState extends State<Admin_HomePage> {
  AuthServices authServices = AuthServices();
  DatabaseService databaseService =
      DatabaseService(uid: ""); // Ensure you pass the correct uid here
  List<QueryDocumentSnapshot> orders =
      []; // Holds the orders fetched from Firestore

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  // Fetch orders from Firestore
  _fetchOrders() async {
    try {
      var snapshot = await databaseService.orderCollection.get();
      setState(() {
        orders = snapshot.docs;
      });
    } catch (e) {
      print("Error fetching orders: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Home Page"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Text(
                'Gloom App',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                // Handle Home tap
              },
            ),
            ListTile(
              leading: Icon(Icons.admin_panel_settings),
              title: Text('Admin Portal'),
              onTap: () {
                // Navigate to Admin Orders Page
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => AdminOrdersPage()),
                // );
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                authServices.signout();
                nextScreenReplacement(context, LoginPage());
              },
            ),
          ],
        ),
      ),
      body: orders.isEmpty
          ? Center(
              child:
                  CircularProgressIndicator()) // Show loading if orders are not loaded
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                var order = orders[index].data() as Map<String, dynamic>;

                // Handle orderDate type (either String or Timestamp)
                var orderDateString = order['orderDate'];
                DateTime orderDate;
                if (orderDateString is String) {
                  // If orderDate is a String, parse it to DateTime
                  orderDate = DateTime.parse(orderDateString);
                } else {
                  // If orderDate is a Timestamp, convert it to DateTime
                  Timestamp timestamp = orderDateString;
                  orderDate = timestamp.toDate();
                }

                // Format the DateTime into a human-readable string
                String formattedDate =
                    DateFormat('yyyy-MM-dd – kk:mm').format(orderDate);

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: ListTile(
                    title: Text(order['orderName']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Order ID: ${order['orderId']}'),
                        Text('Price: \$${order['price']}'),
                        Text('User Name: ${order['userName']}'),
                        Text('User Email: ${order['userEmail']}'),
                        Text('Order Date: $formattedDate'),
                      ],
                    ),
                    onTap: () {
                      // Handle order tap (optional)
                    },
                  ),
                );
              },
            ),
    );
  }
}
