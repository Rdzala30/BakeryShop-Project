import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bakery_project/services/controller.dart';
import 'BottomNavigationBar.dart';
import 'home.dart';
import 'orders.dart';

class Users extends StatefulWidget {
  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  Controller ctrl = new Controller();
  double w = 0, h = 0;
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    final double cardPadding = 5.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          'All Users',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: _users.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                int cardIndex = index + 1;
                return Padding(
                  padding: EdgeInsets.all(cardPadding),
                  child: Card(
                    elevation: 4.0,
                    color: Color.fromRGBO(255, 248, 220, 1),
                    child: ListTile(
                      title: Text(
                        documentSnapshot['username'],
                        style: TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.w700),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            documentSnapshot['email'].toString(),
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Contact: ${documentSnapshot['number'].toString()}",
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w700),
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
                  ),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: 1,
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
              break;
            case 2:
              // Handle users navigation
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Orders()));
              break;
          }
        },
        isAdmin: true,
      ),
    );
  }
}
