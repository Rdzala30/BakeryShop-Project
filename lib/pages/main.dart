import 'package:bakery_project/pages/LogoutScreen.dart';
import 'package:bakery_project/pages/cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bakery_project/services/controller.dart';
import 'package:bakery_project/models/item.dart';
import 'BottomNavigationBar.dart';
import 'Profile.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Controller ctrl = new Controller();
  double h = 0, w = 0;
  List<Item> userCart = [];

  Stream<List<Item>> readItems() => FirebaseFirestore.instance
      .collection('items')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Item.fromJson(doc.data())).toList());

  Widget buildItem(Item item) => Card(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Color.fromRGBO(255, 248, 220, 1),
        child: Padding(
          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Image.network(item.url,
                      height: h * 0.15, width: w * 0.30),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(fontSize: 25),
                      ),
                      Text(
                        item.flavour,
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        item.price.toString(),
                        style: TextStyle(fontSize: 20),
                      ),
                      TextButton(
                        onPressed: () {
                          userCart.add(item);
                          userCart.forEach((item) {
                            print(item.name +
                                " " +
                                item.flavour +
                                " " +
                                item.price.toString());
                          });
                        },
                        child: Text(
                          'Add to Cart',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.orange,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          'Items',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String choice) {
              if (choice == 'logout') {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return LogoutAlertDialog();
                  },
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                 PopupMenuItem<String>(
                  value: 'logout',
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Expanded(
        child: StreamBuilder<List<Item>>(
          stream: readItems(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error occurred!!!");
            } else if (snapshot.hasData) {
              final items = snapshot.data;
              return ListView(
                children: items!.map(buildItem).toList(),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: 0,
        onTap: (int index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CartPage(userCart: userCart)));
              break;
            case 2:
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Profile()));
              break;
          }
        },
        isAdmin: false,
      ),
    );
  }
}
