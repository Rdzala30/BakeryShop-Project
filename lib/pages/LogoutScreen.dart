import 'package:bakery_project/pages/login.dart';
import 'package:flutter/material.dart';
import '../services/itemService.dart';

class LogoutPopupMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
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
            child: Text('Logout'),
          ),
        ];
      },
    );
  }
}

class LogoutAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Are you sure?'),
      content: Text('Do you want to logout?'),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('No'),
        ),
        ElevatedButton(
          onPressed: () {
            box.erase();
            Navigator.of(context).pop(); // Close dialog
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Login()));
          },
          child: Text('Yes'),
        ),
      ],
    );
  }
}
