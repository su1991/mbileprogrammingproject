import 'package:flutter/material.dart';
import 'package:mbileprogrammingproject/GiftListPage .dart';



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Event List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EventListPage(),
    );
  }
}

class EventListPage extends StatefulWidget {
  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  List<Event> events = [
    Event(name: 'Birthday Party', category: 'Personal', status: 'Upcoming'),
    Event(name: 'Conference', category: 'Work', status: 'Current'),
    Event(name: 'Wedding', category: 'Personal', status: 'Past'),
  ];

  String dropdownValue = 'Category';
  var items = ['Category', 'Status', 'Name'];

  void _addEvent() {
    setState(() {
      events.add(Event(name: 'New Event', category: 'General', status: 'Upcoming'));
    });
  }

  void _deleteEvent(int index) {
    setState(() {
      events.removeAt(index);
    });
  }

  void _editEvent(int index) {
    showDialog(
      context: context,
      builder: (context) {
        final nameController = TextEditingController(text: events[index].name);
        final categoryController = TextEditingController(text: events[index].category);
        final statusController = TextEditingController(text: events[index].status);

        return AlertDialog(
          title: Text('Edit Event'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Event Name'),
              ),
              TextField(
                controller: categoryController,
                decoration: InputDecoration(labelText: 'Category'),
              ),
              TextField(
                controller: statusController,
                decoration: InputDecoration(labelText: 'Status'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final name = nameController.text;
                final category = categoryController.text;
                final status = statusController.text;

                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Name field should not be empty')),
                  );
                } else if (category != 'Work' && category != 'Personal') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Category must be "Work" or "Personal".')),
                  );
                } else if (status != 'Past' && status != 'Upcoming' && status != 'Current') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Status must be "Past", "Upcoming", or "Current".')),
                  );
                } else {
                  setState(() {
                    events[index] = Event(
                      name: name,
                      category: category,
                      status: status,
                    );
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
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

  void _sortEvents(String criterion) {
    switch (criterion) {
      case 'Category':
        events.sort((a, b) => a.category.compareTo(b.category));
        break;
      case 'Status':
        events.sort((a, b) => a.status.compareTo(b.status));
        break;
      case 'Name':
        events.sort((a, b) => a.name.compareTo(b.name));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event List'),
        actions: [
          DropdownButton(
            value: dropdownValue,
            icon: const Icon(Icons.keyboard_arrow_down),
            items: items.map((String item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
                _sortEvents(dropdownValue);
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: GestureDetector(
              child: Text(
                events[index].name,
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GiftListPage(event: events[index]),
                  ),
                );
              },
            ),
            subtitle: Text('${events[index].category} - ${events[index].status}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _editEvent(index),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteEvent(index),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEvent,
        tooltip: 'Add Event',
        child: Icon(Icons.add),
      ),
    );
  }
}

class Event {
  String name;
  String category;
  String status;

  Event({required this.name, required this.category, required this.status});
}
