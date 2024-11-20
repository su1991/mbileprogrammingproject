import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main()
{
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pledged Gifts',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PledgedGiftsPage(),
    );
  }
}

class Gift {
  final String name;
  final String friendName;
  final DateTime dueDate;
  bool isPending;

  Gift({
    required this.name,
    required this.friendName,
    required this.dueDate,
    this.isPending = true,
  });
}

class PledgedGiftsPage extends StatefulWidget {
  @override
  _PledgedGiftsPageState createState() => _PledgedGiftsPageState();
}

class _PledgedGiftsPageState extends State<PledgedGiftsPage> {
  List<Gift> gifts = [
    Gift(name: 'Book', friendName: 'Alice', dueDate: DateTime(2024, 12, 1)),
    Gift(name: 'Watch', friendName: 'Bob', dueDate: DateTime(2024, 11, 15)),
    Gift(name: 'Toy', friendName: 'Charlie', dueDate: DateTime(2024, 10, 30), isPending: false),
  ];

  void _modifyGift(Gift gift) {
    setState(() {
      gift.isPending = !gift.isPending; // Toggle pending status
    });
    final status = gift.isPending ? 'marked as pending' : 'marked as completed';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${gift.name} has been $status!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pledged Gifts'),
      ),
      body: gifts.isEmpty
          ? Center(
        child: Text(
          'No pledged gifts yet!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      )
          : ListView.builder(
        itemCount: gifts.length,
        itemBuilder: (context, index) {
          final gift = gifts[index];
          return ListTile(
            title: Text(gift.name),
            subtitle: Text(
              'Pledged by: ${gift.friendName}\nDue Date: ${DateFormat('yyyy-MM-dd').format(gift.dueDate)}',
            ),
            trailing: IconButton
              (
              icon: Icon(gift.isPending ? Icons.check : Icons.clear),
              onPressed: () => _modifyGift(gift),
            ),
            tileColor: gift.isPending ? Colors.green[100] : Colors.red[100],
          );
        },
      ));




  }
}
