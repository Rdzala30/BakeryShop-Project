import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bakery_project/models/item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';

Future getItems() async {
  print('Get item data called!!!');
  List<dynamic> temp = [];
  try {
    await FirebaseFirestore.instance
        .collection('items')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        temp.add(doc.data());
      });
    });
    print(temp);
    print("From item service");
    return temp;
  } catch (Excepthion) {
    return null;
  }
}

final box = GetStorage();

void addToCard(List<Item> cart) {
  box.write('cart', cart);
  return;
}

List<Item> getCart() {
  return box.read('cart');
}

String? userEmail = FirebaseAuth.instance.currentUser?.email;
String? username = FirebaseAuth.instance.currentUser?.displayName;
