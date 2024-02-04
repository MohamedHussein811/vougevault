import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package
import 'Products.dart';

class KidsCategory extends StatelessWidget {
  final String username;
  final String email;
  final String image;
  KidsCategory({required this.username, required this.email, required this.image});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // Stream that listens to changes in the Firestore collection
      stream: FirebaseFirestore.instance.collection('products').where('category', isEqualTo: 'Kids').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData) {
          return CircularProgressIndicator(); // Loading indicator
        }

        final List<Map> items = snapshot.data!.docs.map((doc) {
          return {
            'name': doc['name'],
            'price': doc['price'],
            'image': doc['image'],
          };
        }).toList();

        return ProductsDisp(username: username, email: email, image: image, items: items);
      },
    );
  }
}
