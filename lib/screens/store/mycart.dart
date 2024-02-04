import 'package:flutter/material.dart';
import 'package:store/screens/profile/profilePage.dart';
import 'package:store/screens/store/store.dart';
import 'package:store/widgets/my_tap_bar.dart';
import 'package:store/screens/home/home.dart';
import 'package:store/screens/signin/loginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'myfav.dart';

class MyCart extends StatefulWidget {
  final String username;
  final String email;
  final String image;
  MyCart({required this.username,required this.email,required this.image});

  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  double total = 0.0;
  late int quantity = 1;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    calculateTotal();
    fetchCartData();
  }


  void calculateTotal() {
    total = 0.0;
    for (var cartItem in retrievedCart) {
      double itemPrice = cartItem['price'];
      total += itemPrice;
    }
  }
  List<dynamic> retrievedCart = [];
  Future<void> fetchCartData() async {
    try {
      DocumentSnapshot cartSnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .doc(widget.email)
          .get();

      if (cartSnapshot.exists) {
        dynamic cartData = cartSnapshot.data();
        if (cartData != null && cartData['items'] is List) {
          List<dynamic> cartItems = List.from(cartData['items']);
          // Update the cart and recalculate the total
          setState(() {
            retrievedCart = cartItems;
            calculateTotal();
          });
        }
      }
    } catch (error) {
      print('Error fetching cart data: $error');
    }
  }
  Future<void> moveCartToOrders() async {
    try {
      if (widget.email != "null") {
        // Create a new document in the "orders" collection with user's email as document ID
        await _firestore.collection('orders').doc().set({
          'email': widget.email,
          'items': retrievedCart,
          'timestamp': FieldValue.serverTimestamp(),
          'total':total,
        });

        // Clear the user's cart after copying to orders
        await clearUserCart();
      }
    } catch (error) {
      print('Error moving cart to orders: $error');
    }
  }
  Future<void> clearUserCart() async {
    try {
      await FirebaseFirestore.instance
          .collection('cart')
          .doc(widget.email)
          .update({'items': []}); // Clear the 'items' field by setting it to an empty array
    } catch (error) {
      print('Error clearing cart: $error');
    }
  }
  Future<void> deleteCartItemFromFirestore(int itemIndex) async {
    try {
      // Fetch the current cart data from Firestore
      DocumentSnapshot cartSnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .doc(widget.email)
          .get();

      if (cartSnapshot.exists) {
        Map<String, dynamic>? cartData = cartSnapshot.data() as Map<String, dynamic>?;

        if (cartData != null && cartData['items'] is List) {
          List<dynamic> updatedCart = List.from(cartData['items']);
          updatedCart.removeAt(itemIndex);

          // Update the cart data in Firestore
          await FirebaseFirestore.instance
              .collection('cart')
              .doc(widget.email)
              .update({'items': updatedCart});
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
        break;
      case 3:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyFav(
                     username: widget.username, email: widget.email, image: widget.image)));
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
        title: Text('My Cart'),
      ),
      body: ListView.builder(
        itemCount: retrievedCart.length,
        itemBuilder: (context, index) {
          final cartItem = retrievedCart[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: Image.asset(
                cartItem['image'],
                width: 60,
                height: 60,
                fit: BoxFit.cover,

              ),
              title: Text(
                cartItem['name'],
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
                    '\$${cartItem['price']}',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            if(cartItem['quantity'] > 1)
                              {
                                total-=cartItem['price'];
                                cartItem['quantity']--;
                              }
                          });

                        },
                        child: const Icon(Icons.remove),
                      ),
                      Text(cartItem['quantity'].toString(), style: TextStyle(fontSize: 20),),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            if(cartItem['quantity'] < 10)
                              {
                                total+= cartItem['price'];
                                cartItem['quantity']++;
                              }
                          });
                        },
                        child: const Icon(Icons.add),
                      ),
                    ],
                  )
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  // Remove the item from the local widget.cart
                  setState(() {
                    calculateTotal();
                  });

                  // Remove the item from the Firestore collection
                  await deleteCartItemFromFirestore(index);

                  // Navigate back to the cart screen to trigger a refresh
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyCart(
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
                primary: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                if(total == 0)
                  {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Cart is empty'),
                          content: Text(
                              'Your order didnt placed successfully'),
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
                        title: Text('Order Placed'),
                        content: Text(
                            'Your order has been placed successfully. Total: \$${total.toStringAsFixed(2)}'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              if (widget.email != "null") {
                                Navigator.pop(context);
                                moveCartToOrders(); // Call the function to move cart to "orders" and clear the cart
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
                            'You must be signed in to add or delete from your cart.'),
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
                'Place Order',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          MyTapBar(
            currentIndex: 2,
            onTap: (index) {
              _handleTap(index);
            },
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            color: Colors.black,
            child: Text(
              'Total: \$${total.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
