import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store/screens/store/product_details.dart';
import 'package:store/screens/store/searchscreen.dart';
import 'package:store/screens/signin/loginPage.dart';

class ProductsDisp extends StatelessWidget {
  final String username;
  final String email;
  final String image;
  final List<Map> items;

  ProductsDisp({
    required this.username,
    required this.email,
    required this.image,
    required this.items,
  });

  final List<Map<String, dynamic>> cartItems = [];
  late TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> getList() {
    return cartItems;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: (items.length / 2).ceil(),
      itemBuilder: (context, rowIndex) {
        int startIndex = rowIndex * 2;
        int endIndex = startIndex + 1;
        if (endIndex >= items.length) {
          endIndex = items.length - 1;
        }

        return Column(
          children: [
            SizedBox(height: 10),
            TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search...',
                suffixIcon: InkWell(
                  child: const Icon(Icons.search),
                  onTap: () async {
                    String searchText = searchController.text;
                    QuerySnapshot snapshot = await FirebaseFirestore.instance
                        .collection('products')
                        .where('name', isGreaterThanOrEqualTo: searchText)
                        .where('name', isLessThanOrEqualTo: searchText + '\uf8ff')
                        .get();
                    if (snapshot.docs.isEmpty) {
                      print("No matching products found.");
                      return;
                    }

                    List<Map<String, dynamic>> searchItems = snapshot.docs
                        .map((doc) => {
                      'name': doc['name'],
                      'price': doc['price'],
                      'image': doc['image'],
                    })
                        .toList();

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (c) {
                          return SearchScreen(
                            username: username,
                            email: email,
                            image: image,
                            search: searchText,
                            items: searchItems,
                          );
                        },
                      ),
                    );
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
            Row(
              children: [
                for (int index = startIndex; index <= endIndex; index++)
                  Expanded(
                    child: Container(
                      margin:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                                      image: items[index]['image'],
                                      name: items[index]['name'],
                                      price: items[index]['price'],
                                      username: username,
                                      email: email,
                                      userimage: image,
                                    );
                                  },
                                ));
                              },
                              child: Container(
                                height: 150, // Adjust the height of the image
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(items[index]['image']),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    items[index]['name'],
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    items[index]['price'].toString(),
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
                                      if (email != "null") {
                                        // Reference to the cart document in Firestore
                                        DocumentReference favRef = FirebaseFirestore.instance.collection('fav').doc(email);

                                        // Create or update the cart document
                                        favRef.set({
                                          'email': email,
                                          'items': FieldValue.arrayUnion([
                                            {
                                              'name': items[index]['name'],
                                              'price': items[index]['price'],
                                              'image': items[index]['image'],
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
                                      if (email != "null") {
                                        // Reference to the cart document in Firestore
                                        DocumentReference cartRef = FirebaseFirestore.instance.collection('cart').doc(email);

                                        // Create or update the cart document
                                        cartRef.set({
                                          'email': email,
                                          'items': FieldValue.arrayUnion([
                                            {
                                              'name': items[index]['name'],
                                              'price': items[index]['price'],
                                              'image': items[index]['image'],
                                              'quantity': 1,
                                            }
                                          ])
                                        }, SetOptions(merge: true)); // Use merge option to update only specified fields
                                      }
                                      else {
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
    );
  }
}
