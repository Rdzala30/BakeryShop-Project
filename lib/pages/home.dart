import 'package:bakery_project/pages/LogoutScreen.dart';
import 'package:bakery_project/pages/SnackBar.dart';
import 'package:bakery_project/pages/orders.dart';
import 'package:bakery_project/pages/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bakery_project/services/controller.dart';
import 'package:bakery_project/models/item.dart';
import 'BottomNavigationBar.dart';
import 'admin_additem.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Controller ctrl = new Controller();
  double h = 0, w = 0;
  List<Item> userCart = [];

  Stream<List<Item>> readItems() => FirebaseFirestore.instance
      .collection('items')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Item.fromJson(doc.data())).toList());

  Future<void> deleteItem(String name) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('items')
          .where('name', isEqualTo: name)
          .get();
      querySnapshot.docs.forEach((document) async {
        await document.reference.delete();
      });
      MySnackBar.show(context, 'Item deleted successfully');
    } catch (e) {
      MySnackBar.show(context, 'Error deleting item: $e');
    }
  }

  Widget buildItem(Item item) => Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Color.fromRGBO(255, 248, 220, 1),
        child: Container(
          padding: EdgeInsets.all(6.0),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Are You Sure ?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    await deleteItem(item.name);
                                  },
                                  child: Text('Yes'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('No'),
                                ),
                              ],
                            );
                          });
                    },
                    icon: Icon(
                      Icons.delete_outline,
                      color: Colors.black,
                      size: 35,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(1),
                  child: Image.network(
                    item.url,
                    height: h * 0.15,
                    width: w * 0.45,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                      Text(
                        'Flavour : ${item.flavour}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        "₹ ${item.price.toString()} /- ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                      (!ctrl.isAdmin())
                          ? TextButton(
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
                          : SizedBox(),
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
              if (choice == 'Add') {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddItem()));
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'Add',
                  child: Text(
                    'Add Item',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Text(
                    'Logout',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Item>>(
        stream: readItems(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error occured!!!");
          } else if (snapshot.hasData) {
            final Items = snapshot.data;
            return ListView(
              children: Items!.map(buildItem).toList(),
            );
          } else {
            return Text("Loading...");
          }
        },
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: 0,
        onTap: (int index) {
          switch (index) {
            case 0:
              // Handle home navigation
              break;
            case 1:
              // Handle profile navigation
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Users()));
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
