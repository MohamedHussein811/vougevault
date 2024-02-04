import 'package:flutter/material.dart';
import '../screens/signin/loginPage.dart';
import '../screens/store/mycart.dart';
import '../screens/profile/profilePage.dart';
import '../screens/signup/registerPage.dart';
class DrawerWidget extends StatelessWidget {
  final String email;
  final String username;
  final String image;
  const DrawerWidget({super.key,required this.email,required this.username,required this.image});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.teal],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(image),
                ),
                const SizedBox(height: 10),
                Text(
                  username,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          if (email != "null")
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(username: username, email: email, image: image),
                  ),
                );
              },
            ),
          if (email != "null")
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => SettingsScreen(),
                //   ),
                // );
              },
            ),
          if (email != "null")
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Cart'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyCart(username: username, email: email, image: image)));
              },
            ),
          if (email == "null")
            ListTile(
              leading: Icon(Icons.login),
              title: Text('Login'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
          if (email == "null")
            ListTile(
              leading: Icon(Icons.app_registration),
              title: Text('Register'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
              },
            ),
          if (email != "null")
            ListTile(
              leading: Icon(Icons.app_registration),
              title: Text('Log Out'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),


        ],
      ),
    );
  }
}
