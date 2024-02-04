import 'package:flutter/material.dart';
class AppBarWidgetWithoutTabs extends StatelessWidget implements PreferredSizeWidget{
  const AppBarWidgetWithoutTabs({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

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
    );
  }
}
