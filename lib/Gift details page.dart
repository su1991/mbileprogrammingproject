import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gift Details',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GiftDetailsPage(),
    );
  }
}

class GiftDetailsPage extends StatefulWidget {
  @override
  _GiftDetailsPageState createState() => _GiftDetailsPageState();
}

class _GiftDetailsPageState extends State<GiftDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  String giftName = '';
  String description = '';
  String category = '';
  double price = 0.0;
  bool isPledged = false;
  XFile? imageFile;

  final ImagePicker _picker = ImagePicker();
  final List<String> categories = ['Electronics', 'Books', 'Clothing', 'Toys','Accessories','Furniture'];

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = pickedFile;
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate() && !isPledged) {
      // Handle the form submission
      // You can save the gift details here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gift details submitted!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gift Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Gift Name'),
                  validator: (value) => value!.isEmpty ? 'Please enter a gift name' : null,
                  onChanged: (value) => giftName = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
                  onChanged: (value) => description = value,

                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Category'),
                  items: categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: isPledged
                      ? null // Disable if pledged
                      : (value) {
                    setState(() {
                      category = value!;
                    });
                  },
                  validator: (value) => value == null ? 'Please select a category' : null,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) return 'Please enter a price';
                    if (double.tryParse(value) == null) return 'Please enter a valid number';
                    return null;
                  },
                  onChanged: (value) => price = double.parse(value),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text('Status: '),
                    Switch(
                      value: isPledged,
                      onChanged: (value) {
                        setState(() {
                          isPledged = value;
                        });
                      },
                    ),
                    Text(isPledged ? 'Pledged' : 'Available'),
                  ],
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: imageFile == null
                        ? Center(child: Text('Tap to upload an image'))
                        : Image.file(File(imageFile!.path), fit: BoxFit.cover),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: isPledged ? null : _submit,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
