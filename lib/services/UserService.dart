import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import '../pages/users.dart';

Future getUsers() async {
  print('Get item data called!!!');
  List<dynamic> temp = [];
  try {
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        temp.add(doc.data());
      });
    });
    print(temp);
    print("From item service");
    return temp;
  } on Exception {
    return null;
  }
}

final box = GetStorage();

void addToCard(List<User> cart) {
  box.write('cart', cart);
  return;
}

List<Users> getCart() {
  return box.read('cart');
}
