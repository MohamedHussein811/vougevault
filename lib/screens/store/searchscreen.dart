import 'package:flutter/material.dart';
import 'package:store/screens/store/product_details.dart';
import 'package:store/screens/profile/profilePage.dart';
import 'package:store/widgets/appbarnottaps.dart';
import 'package:store/widgets/my_tap_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store/screens/home/home.dart';
import 'package:store/screens/signin/loginPage.dart';
import 'mycart.dart';
import 'myfav.dart';

class SearchScreen extends StatefulWidget {
  final String username;
  final String email;
  final String image;
  final String search;
  late List<Map> items = [];
  SearchScreen({Key? key, required this.username, required this.email, required this.image, required this.search, required this.items});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  void _handleTap(int index) {
    switch (index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(username: widget.username, email: widget.email, image: widget.image)));
        break;
      case 1:
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyCart(username: widget.username, email: widget.email, image: widget.image)));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyFav(username: widget.username, email: widget.email, image: widget.image)));
        break;
      case 4:
        if(widget.email != "null")
        {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(username: widget.username, email: widget.email, image: widget.image)));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidgetWithoutTabs(),
      body: ListView.builder(
        itemCount: (widget.items.length / 2).ceil(),
        itemBuilder: (context, rowIndex) {
          int startIndex = rowIndex * 2;
          int endIndex = startIndex + 1;
          if (endIndex >= widget.items.length) {
            endIndex = widget.items.length - 1;
          }

          return Column(
            children: [
              SizedBox(height: 10),
              Row(
                children: [
                  for (int index = startIndex; index <= endIndex; index++)
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (c) {
                                      return ProductDetails(
                                        image: widget.items[index]['image'],
                                        name: widget.items[index]['name'],
                                        price: widget.items[index]['price'],
                                        username: widget.username,
                                        email: widget.email,
                                        userimage: widget.image,
                                      );
                                    },
                                  ));
                                },
                                child: Container(
                                  height: 150, // Adjust the height of the image
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(widget.items[index]['image']),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.items[index]['name'],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      widget.items[index]['price'].toString(),
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        if (widget.email != "null") {
                                          // Reference to the cart document in Firestore
                                          DocumentReference favRef = FirebaseFirestore.instance.collection('fav').doc(widget.email);

                                          // Create or update the cart document
                                          favRef.set({
                                            'email': widget.email,
                                            'items': FieldValue.arrayUnion([
                                              {
                                                'name': widget.items[index]['name'],
                                                'price': widget.items[index]['price'],
                                                'image': widget.items[index]['image'],
                                              }
                                            ])
                                          }, SetOptions(merge: true)); // Use merge option to update only specified fields
                                        }  else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text("You're Guest"),
                                                content: Text(
                                                    'You must be signed in to add to favorite'),
                                                actions: <Widget>[
                                                  Row(
                                                    children: [
                                                      TextButton(
                                                        child: Text('OK'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: Text('Sign in'),
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  LoginPage(),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                      icon: Icon(Icons.favorite),
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        if (widget.email != "null") {
                                          // Reference to the cart document in Firestore
                                          DocumentReference cartRef = FirebaseFirestore.instance.collection('cart').doc(widget.email);

                                          // Create or update the cart document
                                          cartRef.set({
                                            'email': widget.email,
                                            'items': FieldValue.arrayUnion([
                                              {
                                                'name': widget.items[index]['name'],
                                                'price': widget.items[index]['price'],
                                                'image': widget.items[index]['image'],
                                                'quantity': 1,
                                              }
                                            ])
                                          }, SetOptions(merge: true)); // Use merge option to update only specified fields
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text("You're Guest"),
                                                content: Text(
                                                    'You must be signed in to add to cart'),
                                                actions: <Widget>[
                                                  Row(
                                                    children: [
                                                      TextButton(
                                                        child: Text('OK'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: Text('Sign in'),
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  LoginPage(),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                      icon: Icon(Icons.add_shopping_cart),
                                      color: Colors.white,
                                    ),
                                  ],
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
          );
        },

      ),
      bottomNavigationBar: MyTapBar(
        currentIndex: 1, // Use the widget's currentIndex
        onTap: (index) {
          _handleTap(index);
        },
      ),
    );

  }

}
