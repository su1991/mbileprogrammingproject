import 'package:flutter/material.dart';
import 'My Pledged Gifts Page.dart';
import 'main.dart';



class UserProfilePage extends StatefulWidget {
  final UserProfile userProfile;

  UserProfilePage({required this.userProfile});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class UserProfile {
  String? name;
  String? email;
  String? password;
  bool notificationsEnabled = false; // Add this property

  String? get getEmail => email;
  set setEmail(String value) => email = value;

  String? get getName => name;
  set setName(String value) => name = value;

  bool get getNotifications => notificationsEnabled;
  set setNotifications(bool value) => notificationsEnabled = value;
}

class _UserProfilePageState extends State<UserProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userProfile.name);
    _emailController = TextEditingController(text: widget.userProfile.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    setState(() {
      widget.userProfile.name = _nameController.text;
      widget.userProfile.email = _emailController.text;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Notifications'),
                Switch(
                  value: widget.userProfile.notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      widget.userProfile.notificationsEnabled = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              child: Text('Save'),
            ),
            ElevatedButton(
              onPressed: ()
              {
                final homePageState = context.findAncestorStateOfType<HomePageState>();

                  homePageState?.onItemTapped(4); // Switch to the "Pledged Gifts" tab
              },
              child: Text('My Pledged Gifts'),
            ),
          ],
        ),
      ),
    );
  }
}
