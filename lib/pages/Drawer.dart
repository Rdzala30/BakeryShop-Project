import 'package:bakery_project/pages/login.dart';
import 'package:flutter/material.dart';

class DrawerNavigation extends StatefulWidget {
  const DrawerNavigation({Key? key}) : super(key: key);

  @override
  State<DrawerNavigation> createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://cdn.dribbble.com/users/315465/screenshots/15640761/dribbble_tick_appicon_4x.png'),
                ),
                accountName: Text('Utsav Sheth'),
                accountEmail: Text('utsav202c@gmail.com'),
                decoration: BoxDecoration(color: Colors.blueAccent)),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Login'),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Login())),
            ),
            ListTile(
              leading: Icon(Icons.view_list),
              title: Text('Category'),
            ),
          ],
        ),
      ),
    );
  }
}
