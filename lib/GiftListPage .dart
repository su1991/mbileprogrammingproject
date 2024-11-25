import 'package:flutter/material.dart';
import 'package:mbileprogrammingproject/eventlistpage.dart';


import 'package:flutter/widgets.dart';



class Gift {
  String name;
  String category;
  String status;


  Gift({required this.name, required this.category, required this.status});
}

class GiftListPage extends StatefulWidget {
  late final Event event;
  GiftListPage({required this.event});
  @override
  _GiftListPageState createState() => _GiftListPageState();
}

class _GiftListPageState extends State<GiftListPage> {
  List<Gift> gifts = [];
  String sortCriteria = 'name'; // Default sort criteria

  void _addGift() {
    // Logic to add a new gift
    // This can be a dialog or a new page to fill details
    showDialog(
      context: context,
      builder: (context) {
        String name = '';
        String category = '';
        String Event='';
        String status = 'Available';
        return AlertDialog(
          title: Text('Add Gift'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Gift Name'),
                onChanged: (value) => name = value,
              ),

              TextField(
                decoration: InputDecoration(labelText: 'Category'),
                onChanged: (value) => category = value,
              ),
              DropdownButton<String>(
                value: status,
                items: <String>['Available', 'Pledged']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    status = newValue!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (name.isNotEmpty && category.isNotEmpty) {
                  setState(() {
                    gifts.add(Gift(name: name, category: category, status: status));
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _editGift(int index) {
    Gift gift = gifts[index];
    showDialog(
      context: context,
      builder: (context) {
        String name = gift.name;
        String category = gift.category;
        String status = gift.status;


        return AlertDialog(
          title: Text('Edit Gift'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Gift Name'),
                onChanged: (value) => name = value,
                controller: TextEditingController(text: name),
              ),

              TextField(
                decoration: InputDecoration(labelText: 'Category'),
                onChanged: (value) => category = value,
                controller: TextEditingController(text: category),
              ),
              DropdownButton<String>(
                value: status,
                items: <String>['Available', 'Pledged']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    status = newValue!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (name.isNotEmpty && category.isNotEmpty) {
                  setState(() {
                    gifts[index] = Gift(name: name, category: category, status: status);
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _deleteGift(int index) {
    setState(() {
      gifts.removeAt(index);
    });
  }

  void _sortGifts(String criteria) {
    setState(() {
      sortCriteria = criteria;
      if (criteria == 'name') {
        gifts.sort((a, b) => a.name.compareTo(b.name));
      } else if (criteria == 'category') {
        gifts.sort((a, b) => a.category.compareTo(b.category));
      } else if (criteria == 'status') {
        gifts.sort((a, b) => a.status.compareTo(b.status));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gift List'),
        actions: [
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {
              // Show sorting options
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Sort By'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile
                          (
                          title: Text('Name'),
                          onTap: ()
                          {
                            _sortGifts('name');
                            Navigator.of(context).pop();
                          },
                        ),

                        ListTile(
                          title: Text('Category'),
                          onTap: () {
                            _sortGifts('category');
                            Navigator.of(context).pop();
                          },

                        ),
                        ListTile(
                          title: Text('Status'),
                          onTap: () {
                            _sortGifts('status');
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: gifts.length,
        itemBuilder: (context, index) {
          Gift gift = gifts[index];
          Color statusColor = gift.status == 'Pledged' ? Colors.green : Colors.red;

          return ListTile(
            title: Text(gift.name),
            subtitle: Text('${gift.category}  ${gift.status}'),
            tileColor: statusColor.withOpacity(0.1),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _editGift(index),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteGift(index),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addGift,
        child: Icon(Icons.add),
      ),
    );
  }
}
