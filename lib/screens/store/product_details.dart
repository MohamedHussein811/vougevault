import 'package:flutter/material.dart';
import 'package:store/screens/home/home.dart';
import 'package:store/widgets/my_tap_bar.dart';
import 'package:store/screens/store/store.dart';
import 'package:store/screens/store/mycart.dart';
import 'package:store/screens/signin/loginPage.dart';

import 'myfav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDetails extends StatelessWidget {
  final String image;
  final String name;
  final double price;

  final String username;
  final String email;
  final String userimage;

  ProductDetails({required this.image, required this.name, required this.price,required this.username,required this.email,required this.userimage});

  @override
  Widget build(BuildContext context) {
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => StoreApp(username: username, email: email, image: image)));
          break;
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    price.toString(),
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Product Description',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Product Description is gonna be here.",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (email != "null") {
                        // Reference to the cart document in Firestore
                        DocumentReference cartRef = FirebaseFirestore.instance.collection('cart').doc(email);

                        // Create or update the cart document
                        cartRef.set({
                          'email': email,
                          'items': FieldValue.arrayUnion([
                            {
                              'name': name,
                              'price': price,
                              'image': image,
                              'quantity': 1,
                            }
                          ])
                        }, SetOptions(merge: true)); // Use merge option to update only specified fields
                      }
                      else
                      {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("You're Guest"),
                              content: Text('You must be signed in to add to cart'),
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

                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 24.0,
                      ),
                      child: Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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

