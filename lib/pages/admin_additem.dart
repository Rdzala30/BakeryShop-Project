import 'package:bakery_project/models/item.dart';
import 'package:bakery_project/pages/SnackBar.dart';
import 'package:bakery_project/pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/controller.dart';

class AddItem extends StatelessWidget {
  Controller ctrl = new Controller();

  TextEditingController nameController = new TextEditingController();
  TextEditingController flavourController = new TextEditingController();
  TextEditingController urlController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 248, 220, 1),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          'Add item',
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: h * 0.81,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    labelStyle: TextStyle(fontSize: 18, color: Colors.orange),
                    errorText: nameController.text.isEmpty
                        ? 'Field cannot be empty'
                        : null,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: flavourController,
                  decoration: InputDecoration(
                    labelText: "Flavour",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    labelStyle: TextStyle(fontSize: 18, color: Colors.orange),
                    errorText: flavourController.text.isEmpty
                        ? 'Field cannot be empty'
                        : null,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: urlController,
                  decoration: InputDecoration(
                    labelText: "Image URL",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    labelStyle: TextStyle(fontSize: 18, color: Colors.orange),
                    errorText: urlController.text.isEmpty
                        ? 'Field cannot be empty'
                        : null,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                    labelText: "Price",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    labelStyle: TextStyle(fontSize: 18, color: Colors.orange),
                    errorText: priceController.text.isEmpty
                        ? 'Field cannot be empty'
                        : null,
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isEmpty ||
                        flavourController.text.isEmpty ||
                        urlController.text.isEmpty ||
                        priceController.text.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text('Please fill in all fields.'),
                            actions: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      String name = nameController.text;
                      String flavour = flavourController.text;
                      String url = urlController.text;
                      int price = int.parse(priceController.text);

                      createItem(name, flavour, url, price);
                      MySnackBar.show(context, 'Item Added Successfully ');

                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orange, // Background color
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Add Item',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future createItem(String name, String flavour, String url, int price) async {
  final fbcol = FirebaseFirestore.instance.collection("items").doc();
  final item = Item(name, flavour, price, url);
  final json = item.toJson();
  await fbcol.set(json);
}
