import 'package:flutter/material.dart';
import 'package:store/screens/store/store.dart';
import 'package:store/widgets/my_tap_bar.dart';
import 'editProfile.dart';
import 'package:store/screens/home/home.dart';
import 'package:store/screens/signin/loginpage.dart';
import 'package:store/screens/store/mycart.dart';
import 'package:store/screens/store/myfav.dart';

class ProfileScreen extends StatelessWidget {
  final String username;
  final String email;
  final String image;

  ProfileScreen({required this.username,required this.email,required this.image});

  @override
  Widget build(BuildContext context) {
    void _handleTap(int index) {
      switch (index) {
        case 0:
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(username: username, email: email, image: image)));
          break;
        case 1:
          Navigator.push(context, MaterialPageRoute(builder: (context) => StoreApp(username: username, email: email, image: image)));
          break;
        case 2:
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyCart(username: username, email: email, image: image)));
          break;
        case 3:
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyFav(username: username, email: email, image: image,)));
          break;
        case 4:
          break;
      }
    }
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurpleAccent, Colors.lightBlueAccent],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        title: Container(
          margin: EdgeInsets.only(right: 56.0), // Adjust the margin as needed
          child: Text(
            'Profile',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image(
                        image: AssetImage(image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.deepPurpleAccent.withOpacity(0.4),
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.deepPurpleAccent,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              Text(
                username,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                email,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              Container(
                width: 200,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.deepPurpleAccent, Colors.lightBlueAccent],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateProfileScreen(
                          username: username, email: email, image: image,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    primary: Colors.transparent,
                    elevation: 0,
                    // Add additional styles as needed
                  ),
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              ProfileMenuWidget(
                title: 'Settings',
                icon: Icons.settings,
                onPress: () {},
                endIcon: true,
              ),
              ProfileMenuWidget(
                title: 'User Management',
                icon: Icons.person,
                onPress: () {},
                endIcon: true,
              ),
              const Divider(),
              ProfileMenuWidget(
                title: 'Information',
                icon: Icons.info_outline,
                onPress: () {},
                endIcon: false,
              ),
              ProfileMenuWidget(
                title: 'Logout',
                icon: Icons.logout,
                onPress: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                },
                endIcon: false,
                textColor: Colors.red,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MyTapBar(
        currentIndex: 4, // Use the widget's currentIndex
        onTap: (index) {
          _handleTap(index);
        },
      ),
    );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
    required this.endIcon,
    this.textColor,
  });

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: onPress,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.deepPurpleAccent.withOpacity(0.1),
          ),
          child: Icon(
            icon,
            color: Colors.deepPurpleAccent,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 23),
        ),
        trailing: endIcon
            ? Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.deepPurpleAccent.withOpacity(0.1),
          ),
          child: Icon(
            Icons.arrow_forward_ios_sharp,
            color: Colors.deepPurpleAccent,
          ),
        )
            : null);
  }
}
