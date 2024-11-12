import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  final CollectionReference orderCollection =
      FirebaseFirestore.instance.collection("orders");

  Future updateUser(String fullname, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullname,
      "email": email,
      "groups": [],
      "profilePic": "",
      "uid": uid,
    });
  }

  Future getuserdata(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  Future createOrder({
    required String orderId,
    required String orderName,
    required double price,
    required String userId,
    required String userName,
    required String userEmail,
    required DateTime orderDate,
  }) async {
    return await orderCollection.doc(orderId).set({
      "orderId": orderId,
      "orderName": orderName,
      "price": price,
      "userId": userId,
      "userName": userName,
      "userEmail": userEmail,
      "orderDate": orderDate.toIso8601String(),
    });
  }

  Future<List<QueryDocumentSnapshot>> getAllOrders() async {
    QuerySnapshot snapshot = await orderCollection.get();
    return snapshot.docs;
  }
}
