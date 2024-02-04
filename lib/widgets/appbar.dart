import 'package:flutter/material.dart';
class AppBarWidget extends StatelessWidget implements PreferredSizeWidget{
  const AppBarWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
        child: Center(child: Text("VOUGE VAULT")), // Center the text
      ),
      bottom: TabBar(
        tabs: [
          Tab(
            text: 'MEN',
          ),
          Tab(
            text: 'WOMEN',
          ),
          Tab(
            text: 'KIDS',
          ),
        ],
      ),
    );
  }
}
