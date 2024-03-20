import 'package:bakery_project/pages/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Services/controller.dart';
import 'BottomNavigationBar.dart';
import 'home.dart';

class Orders extends StatefulWidget {
  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  double h = 0, w = 0;
  Controller ctrl = new Controller();
  final CollectionReference _orders =
      FirebaseFirestore.instance.collection('order');

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('All Orders'),
      ),
      body: StreamBuilder(
        stream: _orders.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            List<DocumentSnapshot> documents = streamSnapshot.data!.docs;
            double totalOrderPrice = 0;

            documents.forEach((doc) {
              List<dynamic> cartData = doc['cartData'];
              cartData.forEach((order) {
                totalOrderPrice += order['totalPrice'];
              });
            });

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          documents[index];
                      int cardIndex = index + 1;
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.all(5),
                        color: Color.fromRGBO(255, 248, 220, 1),
                        child: ListTile(
                          title: Text(
                            documentSnapshot['User'],
                            style: TextStyle(
                                fontSize: 25.0, fontWeight: FontWeight.w700),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (var order in documentSnapshot['cartData'])
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      order['name'].toString(),
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      ": ₹${order['totalPrice'].toString()} /-",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          // Display card index
                          leading: CircleAvatar(
                            backgroundColor: Colors.amber[50],
                            child: Text(
                              cardIndex.toString(),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.grey[600],
                  child: Text(
                    'Total Orders: ₹$totalOrderPrice /-',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: Text("Error"),
            );
          }
        },
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: 2,
        onTap: (int index) {
          // Handle navigation based on index
          switch (index) {
            case 0:
              // Handle home navigation
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Home()));
              break;
            case 1:
              // Handle profile navigation
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Users()));
              break;
            case 2:
              // Handle users navigation
              break;
          }
        },
        isAdmin: true,
      ),
    );
  }
}
