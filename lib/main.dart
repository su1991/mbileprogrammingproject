import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mbileprogrammingproject/Gift%20details%20page.dart';
import 'eventlistpage.dart';
import 'GiftListPage .dart';
import 'My Pledged Gifts Page.dart';
import 'profilepage.dart';
import 'Login.dart';


void main() {

  runApp(MyApp());
}

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hediaty App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int selectedIndex = 0;



  UserProfile userProfile = UserProfile()
    ..name = "John Doe"
    ..email = "john.doe@example.com"
    ..notificationsEnabled = true;// Default to the first tab (friends list)

  // Pages to navigate
  late final List<Widget> _pages =
  [
    FriendListPage(), // Friends list is now the default home page
    EventListPage(),
    GiftDetailsPage(),
    GiftListPage(),
    PledgedGiftsPage(),
    UserProfilePage(userProfile:UserProfile()),
  ];

  void onItemTapped(int index)
  {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(widget.title),
        backgroundColor: Colors.blue,
        actions:
        [ ElevatedButton(onPressed: null, child: Text("Create your own Event/List")),

          IconButton
            (
            onPressed: ()
            {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              );
            },
            icon: const Icon(Icons.search),
          ),
          Image.asset('images/gift.PNG', height: 100),
        ],
      ),

      body: IndexedStack(

        index: selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Event List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Gift Details',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Gift List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Pledged Gifts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
    );
  }


}

class CustomSearchDelegate extends SearchDelegate {
  List<String> searchTerms = [
    "Apple",
    "Banana",
    "Mango",
    "Pear",
    "Watermelons",
    "Blueberries",
    "Pineapples",
    "Strawberries"
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(); // Placeholder for suggestions
  }
}

class FriendListPage extends StatelessWidget {
  final List<Map<String, String>> friends = [
    {'name': 'Abdo', 'profilePic': 'https://via.placeholder.com/50', 'events': '1'},
    {'name': 'hussein', 'profilePic': 'https://via.placeholder.com/50', 'events': 'No Upcoming Events'},
    {'name': 'ali', 'profilePic': 'https://via.placeholder.com/50', 'events': '2'},
  ];

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final friend = friends[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(friend['profilePic']!),
          ),
          title: Text(friend['name']!),
          subtitle: Text(friend['events']!),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FriendDetailsPage(
                  name: friend['name']!,
                  profilePic: friend['profilePic']!,
                  events: friend['events']!,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class FriendDetailsPage extends StatelessWidget {
  final String name;
  final String profilePic;
  final String events;

  const FriendDetailsPage({
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