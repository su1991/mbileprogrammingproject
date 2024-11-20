
import 'package:flutter/material.dart';





class FriendDetailsPage extends StatelessWidget
{
  final String name;
  final String profilePic;
  final String events;


   FriendDetailsPage({
    Key? key,
    required this.name,
    required this.profilePic,
    required this.events,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(profilePic),
              radius: 50,
            ),
            SizedBox(height: 16),
            Text(
              name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 8),
            Text(
              events,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
