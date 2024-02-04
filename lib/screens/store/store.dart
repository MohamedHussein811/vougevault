import 'package:flutter/material.dart';
import 'package:store/screens/profile/profilePage.dart';
import 'package:store/widgets/drawer.dart';
import 'package:store/widgets/my_tap_bar.dart';
import 'package:store/screens/store/mencategory.dart';
import 'package:store/screens/store/womencategory.dart';
import 'package:store/screens/store/kidscategory.dart';
import 'package:store/screens/store/mycart.dart';
import 'package:store/widgets/appbar.dart';
import 'package:store/screens/home/home.dart';
import 'package:store/screens/signin/loginPage.dart';
import 'myfav.dart';

class StoreApp extends StatelessWidget {
  final String username;
  final String email;
  final String image;

  StoreApp({required this.username,required this.email,required this.image});

  @override
  Widget build(BuildContext context) {
    final List<Widget> _tabs = [
      MenCategory(username: username, email: email, image: image), // Replace this with your desired content for the "MEN" tab
      WomenCategory(username: username, email: email, image: image), // Replace this with your desired content for the "WOMEN" tab
      KidsCategory(username: username, email: email, image: image), // Replace this with your desired content for the "MEN" tab
    ];
    void _handleTap(int index) {
      switch (index) {
        case 0:
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(username: username, email: email, image: image)));
          break;
        case 1:
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
          }
          break;
      }
    }
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: DrawerWidget(email: email,username: username,image: image),
        appBar: AppBarWidget(),

        body: TabBarView(
          children: _tabs,
        ),
        bottomNavigationBar: MyTapBar(
          currentIndex: 1, // Use the widget's currentIndex
          onTap: (index) {
            _handleTap(index);
          },
        ),
      ),
    );
  }
}
