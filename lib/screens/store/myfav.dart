import 'package:flutter/material.dart';
import 'package:store/screens/profile/profilePage.dart';
import 'package:store/screens/store/store.dart';
import 'package:store/widgets/my_tap_bar.dart';
import 'package:store/screens/home/home.dart';
import 'package:store/screens/signin/loginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'mycart.dart';

class MyFav extends StatefulWidget {
  final String username;
  final String email;
  final String image;
  MyFav({required this.username,required this.email,required this.image});

  @override
  _MyFavState createState() => _MyFavState();
}

class _MyFavState extends State<MyFav> {

  @override
  void initState() {
    super.initState();
    fetchFavData();
  }

  List<dynamic> retrievedFav = [];
  Future<void> fetchFavData() async {
    try {
      DocumentSnapshot favSnapshot = await FirebaseFirestore.instance
          .collection('fav')
          .doc(widget.email)
          .get();

      if (favSnapshot.exists) {
        dynamic favData = favSnapshot.data();
        if (favData != null && favData['items'] is List) {
          List<dynamic> favItems = List.from(favData['items']);
          setState(() {
            retrievedFav = favItems;
          });
        }
      }
    } catch (error) {
      print('Error fetching cart data: $error');
    }
  }

  Future<void> clearUserFav() async {
    try {
      await FirebaseFirestore.instance
          .collection('fav')
          .doc(widget.email)
          .update({'items': []}); // Clear the 'items' field by setting it to an empty array
    } catch (error) {
      print('Error clearing cart: $error');
    }
  }
  Future<void> deleteFavItemFromFirestore(int itemIndex) async {
    try {
      // Fetch the current fav data from Firestore
      DocumentSnapshot favSnapshot = await FirebaseFirestore.instance
          .collection('fav')
          .doc(widget.email)
          .get();

      if (favSnapshot.exists) {
        Map<String, dynamic>? favData = favSnapshot.data() as Map<String, dynamic>?;

        if (favData != null && favData['items'] is List) {
          List<dynamic> updatedFav = List.from(favData['items']);
          updatedFav.removeAt(itemIndex);

          // Update the fav data in Firestore
          await FirebaseFirestore.instance
              .collection('fav')
              .doc(widget.email)
              .update({'items': updatedFav});
        }
      }
    } catch (error) {
      print('Error deleting cart item: $error');
    }
  }
  void _handleTap(int index) {
    switch (index) {
      case 0:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(username: widget.username, email: widget.email, image: widget.image)));
        break;
      case 1:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StoreApp(username: widget.username, email: widget.email, image: widget.image)));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyCart(username: widget.username, email: widget.email, image: widget.image)));
        break;
      case 3:
        break;
      case 4:
        if (widget.email != "null") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ProfileScreen(username: widget.username, email: widget.email, image: widget.image)));
        } else {
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
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => LoginPage()));
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
      appBar: AppBar(
        title: Text('My Favourites'),
      ),
      body: ListView.builder(
        itemCount: retrievedFav.length,
        itemBuilder: (context, index) {
          final favItem = retrievedFav[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: Image.asset(
                favItem['image'],
                width: 60,
                height: 60,
                fit: BoxFit.cover,

              ),
              title: Text(
                favItem['name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Text(
                    '\$${favItem['price']}',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 14,
                    ),
                  ),

                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {

                  // Remove the item from the Firestore collection
                  await deleteFavItemFromFirestore(index);

                  // Navigate back to the cart screen to trigger a refresh
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyFav(
                        username: widget.username,
                        email: widget.email,
                        image: widget.image,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),

      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {

                if(retrievedFav.length == 0)
                {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Fav is empty'),
                        content: Text(
                            'You fav is already empty'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),

                        ],
                      );
                    },
                  );
                }
                else if (widget.email != "null") {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Success'),
                        content: Text(
                            'Your fav has been cleared.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              if (widget.email != "null") {
                                Navigator.pop(context);
                                clearUserFav(); // Call the function to move cart to "orders" and clear the cart
                              }
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("You're Guest"),
                        content: Text(
                            'You must be signed in to add or delete from your fav.'),
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
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()));
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
              child: Text(
                'Clear My Fav',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          MyTapBar(
            currentIndex: 3,
            onTap: (index) {
              _handleTap(index);
            },
          ),
        ],
      ),
    );
  }
}
