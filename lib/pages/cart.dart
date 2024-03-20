import 'package:bakery_project/pages/LoseCart.dart';
import 'package:bakery_project/pages/Profile.dart';
import 'package:bakery_project/pages/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bakery_project/models/item.dart';
import 'package:get_storage/get_storage.dart';
import '../Services/controller.dart';
import '../models/order.dart';
import 'BottomNavigationBar.dart';

class CartPage extends StatefulWidget {
  final List<Item> userCart;

  CartPage({required this.userCart});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Map<Item, int> itemQuantities = {};
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    _updateItemQuantities();
  }

  void _updateItemQuantities() {
    for (var item in widget.userCart) {
      if (itemQuantities.containsKey(item)) {
        itemQuantities[item] = itemQuantities[item]! + 1;
      } else {
        itemQuantities[item] = 1;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalPriceOfAllItems = 0;
    Controller ctrl = new Controller();

    itemQuantities.forEach((item, quantity) {
      totalPriceOfAllItems += item.price * quantity;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: itemQuantities.isEmpty
          ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Center(
                child: Text(
                  'Cart is empty',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                ),
                onPressed: () async {
                  int totQuantity = 0, totPrice = 0;
                  String username = ctrl.box.read("email");
                  print(totPrice.toString() +
                      " " +
                      totQuantity.toString() +
                      " " +
                      username);

                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MainPage()));
                },
                child: Text('Add Items'),
              ),
            ])
          : ListView.builder(
              itemCount: itemQuantities.length + 2,
              itemBuilder: (context, index) {
                if (index == itemQuantities.length) {
                  return ListTile(
                    title: Text(
                      'Amount to be Paid : \₹ ${totalPriceOfAllItems.toStringAsFixed(2)}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                } else if (index == itemQuantities.length + 1) {
                  return ListTile(
                    title: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.orange, onPrimary: Colors.white),
                      onPressed: () {
                        List<Map<String, dynamic>> cartData = [];
                        itemQuantities.forEach((item, quantity) {
                          int totalPrice = item.price * quantity;
                          cartData.add({
                            'name': item.name,
                            'quantity': quantity,
                            'price': item.price,
                            'totalPrice': totalPrice,
                          });
                        });
                        box.write('cartData', cartData);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Profile()));
                      },
                      child: Text('Place Oder'),
                    ),
                  );
                } else {
                  Item item = itemQuantities.keys.elementAt(index);
                  int quantity = itemQuantities[item]!;
                  int totalPrice = item.price * quantity;
                  return ListTile(
                    leading: Image.network(
                      item.url,
                      width: 90,
                      height: 300,
                      fit: BoxFit.fill,
                    ),
                    title: Text(
                      item.name,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Flavour: ${item.flavour}',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          'Quantity: $quantity',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          'Price: \₹${item.price}',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          'Total Price: \₹${totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    trailing: InkWell(
                      child: Icon(Icons.delete_outline_rounded),
                      onTap: () {
                        setState(() {
                          itemQuantities.remove(item);
                        });
                      },
                    ),
                  );
                }
              },
            ),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: 1,
        onTap: (int index) {
          switch (index) {
            case 0:
              itemQuantities.isNotEmpty
                  ? showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return LoseCartDialogue();
                      })
                  : Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MainPage()));
              break;
            case 1:
              break;
            case 2:
              itemQuantities.isNotEmpty
                  ? showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return LoseCartDialogue();
                      })
                  : Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Profile()));
              break;
          }
        },
        isAdmin: false,
      ),
    );
  }

  void addOrderToFirebase(Order order, List<Item> userCart) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String? currentUserEmail = currentUser?.email;

    if (currentUserEmail != null) {
      FirebaseFirestore.instance.collection('orders').add({
        'userEmail': currentUserEmail,
        'username': order.username,
        'totPrice': order.totPrice,
        'totQuantity': order.totQuantity,
        'items': userCart.map((item) => item.toJson()).toList(),
      }).then((value) {
        print('Order added to Firebase: $value');
      }).catchError((error) {
        print('Error adding order to Firebase: $error');
      });
    }
  }
}
