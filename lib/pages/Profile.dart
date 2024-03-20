import 'package:bakery_project/Services/controller.dart';
import 'package:bakery_project/pages/SplashScreen.dart';
import 'package:bakery_project/pages/cart.dart';
import 'package:bakery_project/pages/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'BottomNavigationBar.dart';

final box = GetStorage();

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  double h = 0, w = 0;
  Controller ctrl = new Controller();
  final CollectionReference _orders =
      FirebaseFirestore.instance.collection('orders');

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 4), () {
      Navigator.pop(context);
    });
  }

  Future<void> saveCartToFirestore() async {
    final cartData = box.read('cartData');
    final currentUser = box.read('email');

    if (cartData != null && currentUser != null) {
      try {
        await FirebaseFirestore.instance
            .collection('order')
            .doc()
            .set({'cartData': cartData, 'User': currentUser});
        print('Cart data saved to Firestore');
      } catch (e) {
        print('Error saving cart data to Frestore: $e');
      }
    } else {
      print('Cart data or current user is null');
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;

    // Read data from box
    final email = box.read('email');
    final cartData = box.read('cartData');
    double getTotalPrice(List<dynamic> cartData) {
      double totalPrice = 0;
      for (var item in cartData) {
        totalPrice += item['totalPrice'];
      }
      return totalPrice;
    }

    double totalAmount = getTotalPrice(cartData);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('User Orders'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello, ${email ?? 'Guest'}',
            style: TextStyle(
              fontSize: 29,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            "Here's your order details",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          if (cartData == null || cartData.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  'No orders yet!',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: cartData.length,
                itemBuilder: (context, index) {
                  final item = cartData[index];
                  return ListTile(
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'],
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        Spacer(),
                        Column(
                          children: [
                            Text(
                              'Quantity: ${item['quantity']}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '\₹${item['price']}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Total Amount: \₹${item['totalPrice']}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    subtitle: Divider(),
                  );
                },
              ),
            ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: onPressedPayButton,
              style: ElevatedButton.styleFrom(
                primary: Colors.brown,
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Pay: ₹$totalAmount',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: 2,
        onTap: (int index) {
          switch (index) {
            case 0:
              // Handle home navigation
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => MainPage()));
              break;
            case 1:
              // Handle cart navigation
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CartPage(userCart: [])));
              break;
            case 2:
              // Handle orders navigation (already on orders page)
              break;
          }
        },
        isAdmin: false,
      ),
    );
  }

  void showOrderPlacedDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 100,
          child: SplashScreen(),
        );
      },
    );
  }

  void clearCartData() {
    box.remove('cartData');
  }

  void onPressedPayButton() {
    saveCartToFirestore();
    showOrderPlacedDialog(context);
  }
}
