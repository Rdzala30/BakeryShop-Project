import 'package:bakery_project/pages/SnackBar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController numController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final RegExp emailRegex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 248, 220, 1),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Signup'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(height: h * 0.03),
            Padding(
              padding:
                  EdgeInsets.fromLTRB(w * 0.06, h * 0.01, w * 0.06, h * 0.01),
              child: Container(
                child: Column(
                  children: [
                    Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding:
                  EdgeInsets.fromLTRB(w * 0.06, h * 0.01, w * 0.06, h * 0.01),
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.orange,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelText: "Username",
                  labelStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.orange,
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.fromLTRB(w * 0.06, h * 0.01, w * 0.06, h * 0.01),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.orange,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelText: "Email",
                  labelStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.orange,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.fromLTRB(w * 0.06, h * 0.01, w * 0.06, h * 0.01),
              child: TextField(
                controller: numController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.orange,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelText: "Number",
                  labelStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.orange,
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.fromLTRB(w * 0.06, h * 0.01, w * 0.06, h * 0.01),
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.orange,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelText: "Password",
                  labelStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.orange,
                  ),
                ),
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
              ),
            ),
            SizedBox(height: h * 0.04),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final username = usernameController.text;
                  final password = passwordController.text;
                  final number = numController.text;
                  final email = emailController.text;

                  createUser(username, password, number, email);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 70),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                        children: [
                          TextSpan(
                            text: "Sign in",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> createUser(
      String username, String password, String number, String email) async {
    email = email.trim();
    password = password.trim();

    if (email.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Please enter an email."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }

    if (!emailRegex.hasMatch(email)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Please enter a valid email."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }

    if (number.length != 10) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Phone number must contain 10 digits."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }

    // Validate password length
    if (password.length < 6) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Password must contain at least 6 characters."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }

    final fbcol = FirebaseFirestore.instance.collection("users").doc();
    final user = UserDetail(int.parse(number), username, password, email);
    final json = user.toJson();
    await fbcol.set(json);

    MySnackBar.show(context, 'User registered successfully!');

    Navigator.pushReplacementNamed(context, '/login');
  }
}
