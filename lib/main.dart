import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'Gift details page.dart';
import 'eventlistpage.dart';
import 'GiftListPage .dart';
import 'My Pledged Gifts Page.dart';
import 'profilepage.dart';
import 'Login.dart';
import 'package:flutter/services.dart';

void main() async { WidgetsFlutterBinding.ensureInitialized();

// Lock orientation to portrait
await SystemChrome.setPreferredOrientations([
  DeviceOrientation.portraitUp,
  DeviceOrientation.portraitDown,
]);



runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Design size (width x height)
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Hediaty App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: isLoggedIn ? HomePage(title: 'Home') : LoginPage(),
        );
      },
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
    ..notificationsEnabled = true;

  final Event dummyevent=Event(name: "Birthday", category: "personal", status: "upcoming");

  late final List<Widget> _pages =
  [
    FriendListPage(),
    EventListPage(),
    GiftDetailsPage(),
    PledgedGiftsPage(),
    UserProfilePage(userProfile: userProfile),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 20.sp), // Scaled font size
        ),
        backgroundColor: Colors.blue,
        actions: [
          ElevatedButton(
            onPressed: null,
            child: Text(
              "Create your own Event/List",
              style: TextStyle(fontSize: 14.sp), // Scaled font size
            ),
          ),
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              );
            },
            icon: const Icon(Icons.search),
          ),
          Image.asset('images/gift.PNG', height: 50.h), // Scaled height
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
          title: Text(
            result,
            style: TextStyle(fontSize: 16.sp), // Scaled font size
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(); // Placeholder for suggestions
  }
}

class FriendListPage extends StatefulWidget {
  @override
  _FriendListPageState createState() => _FriendListPageState();
}

class _FriendListPageState extends State<FriendListPage> with AutomaticKeepAliveClientMixin {
  final List<Map<String, String>> friends = [
    {'name': 'Abdo', 'profilePic': 'https://via.placeholder.com/50', 'events': '1'},
    {'name': 'hussein', 'profilePic': 'https://via.placeholder.com/50', 'events': 'No Upcoming Events'},
    {'name': 'ali', 'profilePic': 'https://via.placeholder.com/50', 'events': '2'},
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final friend = friends[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(friend['profilePic']!),
            radius: 20.r, // Scaled radius
          ),
          title: Text(
            friend['name']!,
            style: TextStyle(fontSize: 16.sp), // Scaled font size
          ),
          subtitle: Text(
            friend['events']!,
            style: TextStyle(fontSize: 14.sp), // Scaled font size
          ),
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

  @override
  bool get wantKeepAlive => true; // Keep the page alive
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
