import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Construction Service',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.orange,
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Logo and Slogan Section
                Column(
                  children: [
                    const SizedBox(height: 80.0),
                    Image.asset(
                      'assets/p1.jpg', // Replace with your logo path
                      height: 200,
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      'Built on trust, focused on quality',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),

                // Username input field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username cannot be empty';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20.0),

                // Login button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50.0,
                      vertical: 15.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final username = _usernameController.text.trim();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(username: username),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Log In',
                    style: TextStyle(
                      color: Color(0xff1b1919),
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({required this.username, super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  late Timer _timer;
  int _currentPage = 0;

  // List of images for the slider
  final List<String> _sliderItems = [
    'assets/1.jpg',
    'assets/2.jpg',
    'assets/3.jpg',
    'assets/4.jpg',
  ];

  @override
  void initState() {
    super.initState();
    // Set up the auto-play functionality
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < _sliderItems.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // Show dialog for Feedback
  void _showFeedbackDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController feedbackController = TextEditingController();
        return AlertDialog(
          title: const Text('Feedback'),
          content: TextField(
            controller: feedbackController,
            decoration: const InputDecoration(
              hintText: 'Enter your feedback here',
            ),
            maxLines: 4,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle feedback submission logic here
                String feedback = feedbackController.text;
                Navigator.of(context).pop();
                // You can show a Snackbar or save the feedback here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Feedback submitted: $feedback')),
                );
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome ${widget.username}',
          style: const TextStyle(color: Color(0xff141313)),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            // Drawer Header with an icon and two names
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xffffffff),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.orange,
                    child: const Text(
                      'D_M',
                      style: TextStyle(
                        color: Color(0xff0a0a0a),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Welcome to Our Services Dear ${widget.username}',
                    style: const TextStyle(
                      color: Color(0xff070707),
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            // Drawer Body with Profile, Contact Us, and Feedback options
            ListTile(
              title: const Text('Profile'),
              leading: const Icon(Icons.account_circle),
              onTap: () {
                // Show profile welcome message
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                      Text('Our Creator is Mahmud Hersh and Darin Hussen')),
                );
              },
            ),
            ListTile(
              title: const Text('Contact Us'),
              leading: const Icon(Icons.phone),
              onTap: () {
                // Show contact details
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Contact Us'),
                      content: const Text(
                        'Creator: Darin Hussen - Mahmud Hersh\nPhone: +964 (750) 222-1322\nAddress: Erbil 60m',
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              title: const Text('Feedback'),
              leading: const Icon(Icons.feedback),
              onTap: () {
                // Show feedback dialog
                Navigator.pop(context);
                _showFeedbackDialog();
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Horizontal Image Slider Below AppBar (No Description)
          Container(
            height: 250.0, // Adjust height to suit your design
            child: PageView(
              controller: _pageController,
              children: _sliderItems
                  .map((item) => Image.asset(
                item,
                fit: BoxFit.cover,
              ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 20.0),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                children: [
                  GridItem(
                    title: "Building",
                    imagePath: "assets/22.jpg",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            GridDetailsPage(title: "Building"),
                      ),
                    ),
                  ),
                  GridItem(
                    title: "House",
                    imagePath: "assets/33.jpg",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GridDetailsPage(title: "House"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GridItem extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const GridItem(
      {required this.title,
        required this.imagePath,
        required this.onTap,
        super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.orangeAccent,
        elevation: 5.0,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GridDetailsPage extends StatelessWidget {
  final String title;
  GridDetailsPage({required this.title, super.key});

  // Define a map to store sub-grid image assets for each grid category
  final Map<String, List<Map<String, String>>> subGridImages = {
    "Building": [
      {'image': 'assets/b1.jpg', 'title': 'Wood'},
      {'image': 'assets/b2.jpg', 'title': 'Windows'},
    ],
    "House": [
      {'image': 'assets/h1.png', 'title': 'Water System'},
      {'image': 'assets/h2.jpg', 'title': 'Block builder'},
    ],
  };

  // Define a map to store employees for each sub-grid
  final Map<String, Map<String, List<Map<String, String>>>> subGridEmployees = {
    "Building": {
      "Wood": [
        {'name': 'Ahmed Kamaran', 'phone': '07500000000', 'address': 'Erbil'},
        {'name': 'kamaran jalil', 'phone': '07500000000', 'address': 'Dohuk'},
      ],
      "Windows": [
        {'name': 'Ali suhaib', 'phone': '07500000000', 'address': 'Erbil'},
        {'name': 'Sardar khayat', 'phone': '07500000000', 'address': 'Erbil'},
      ],
    },
    "House": {
      "Water System": [
        {'name': 'Anwer basher', 'phone': '07500000000', 'address': 'Erbil'},
        {'name': 'hasan bakr', 'phone': '07500000000', 'address': 'Dohuk'},
      ],
      "Block builder": [
        {
          'name': 'aziz wais',
          'phone': '07500000000',
          'address': 'Sulaymaniyah'
        },
        {'name': 'farman kamaran', 'phone': '07500000000', 'address': 'Dohuk'},
      ],
    }, // Repeat similarly for "Farm" and "Trucks"
  };

  @override
  Widget build(BuildContext context) {
    final subGridItems = subGridImages[title] ?? [];
    final subGridEmployeesMap = subGridEmployees[title] ?? {};

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Color(0xff000000))),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              shrinkWrap: true,
              children: List.generate(subGridItems.length, (index) {
                return GestureDetector(
                  onTap: () {
                    final subGridTitle = subGridItems[index]['title']!;
                    final employees = subGridEmployeesMap[subGridTitle] ?? [];
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubGridDetailPage(
                          subGridTitle: subGridTitle,
                          imagePath: subGridItems[index]['image']!,
                          employees: employees,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.orangeAccent,
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.asset(
                              subGridItems[index]['image']!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            subGridItems[index]['title']!,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class SubGridDetailPage extends StatelessWidget {
  final String subGridTitle;
  final String imagePath;
  final List<Map<String, String>> employees;

  const SubGridDetailPage(
      {required this.subGridTitle,
        required this.imagePath,
        required this.employees,
        super.key});

  @override
  Widget build(BuildContext context) {
    var headline6;
    return Scaffold(
      appBar: AppBar(
        title: Text(subGridTitle, style: const TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Image.asset(imagePath, fit: BoxFit.cover),
            const SizedBox(height: 20),
            Text(
              'Employees:',
              style: Theme.of(context).textTheme.headlineSmall, // updated
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: employees.length,
                itemBuilder: (context, index) {
                  final employee = employees[index];
                  return Card(
                    child: ListTile(
                      title: Text(employee['name']!),
                      subtitle: Text(
                          'Phone: ${employee['phone']}\nAddress: ${employee['address']}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
