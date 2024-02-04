import 'package:flutter/material.dart';
import 'package:store/screens/profile/profilePage.dart';
import 'package:store/screens/store/store.dart';
import 'package:store/widgets/appbarnottaps.dart';
import 'package:store/widgets/drawer.dart';
import 'package:store/widgets/my_tap_bar.dart';
import 'package:store/screens/signin/loginPage.dart';
import 'package:store/screens/store/mycart.dart';
import 'package:store/screens/store/myfav.dart';

class HomePage extends StatelessWidget {
  final String username;
  final String email;
  final String image;
  HomePage({required this.username,required this.email,required this.image});

  @override
  Widget build(BuildContext context) {
    void _handleTap(int index) {
      switch (index) {
        case 0:
          break;
        case 1:
          Navigator.push(context, MaterialPageRoute(builder: (context) => StoreApp(username: username, email: email, image: image)));
          break;
        case 2:
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyCart(username: username, email: email, image: image)));
          break;
        case 3:
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyFav(username: username, email: email, image: image)));
          break;
        case 4:
          if(email != "null")
          {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(username: username, email: email, image: image)));
          }
          else
          {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("You're Guest"),
                  content: Text('You must be signed in.'),
                  actions: <Widget>[
                    Row(
                      children: [
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Sign in'),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          }          break;
      }
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: DrawerWidget(email: email,username: username,image: image),
        appBar: AppBarWidgetWithoutTabs(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Welcome to Our Online Fashion Store",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                height: 200,
                width: double.infinity,
                child: Image.asset(
                  "assets/images/logo/banner_image.jpg", // Replace with actual image path
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Explore our wide range of clothing options for men, women, and kids. Discover the latest trends and styles.",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              // Other sections and widgets can be added here
            ],
          ),
        ),
        bottomNavigationBar: MyTapBar(
          currentIndex: 0,
          onTap: (index) {
            _handleTap(index);
          },
        ),
      ),
    );
  }
}
