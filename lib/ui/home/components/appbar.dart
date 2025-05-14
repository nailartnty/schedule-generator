import 'package:flutter/material.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget{
  const Appbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(left: 5),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xFFF9F9F9),
                borderRadius: BorderRadius.circular(5)
              ),
              child: IconButton(
                icon: const Icon(Icons.notifications, color: Colors.black),
                onPressed: () {
                },
              ),
            ),
            GestureDetector(
              onTap: () {
              },
              child: const CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/images/IMG_20250327_203520.jpg'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}