import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Translator.dart';
import 'dictionary.dart';

class MyNavDrawer extends StatelessWidget {
  const MyNavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        centerTitle: true,
        title: const Text('Navigation Drawer'),
      ),
      endDrawer: const MyDrawer(),
      body: const Center(
        child: Text("Main Contents"),
      ),
    );
  }
}

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    const TranslatorApp(),
    const Dictionary(),
  ];

  void onTappedBar(int index) {
    Navigator.pop(context);
    setState(() {
      _currentIndex = index;
    });

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => _children[_currentIndex],
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.black45,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black87,
              ),
              child: Text('Translator & Dictionary App', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 35, color: Colors.blueGrey)),
            ),
            ListTile(
              onTap: () {
                onTappedBar(0);
              },
              title: const Text(
                "Home",
                style: TextStyle(color: Colors.black,fontSize: 17, fontWeight: FontWeight.bold),
              ),
              leading: const Icon(
                Icons.home,
              ),
            ),
            ListTile(
              onTap: () {
                onTappedBar(1);
              },
              title: const Text(
                "Dictionary",
                style: TextStyle(color: Colors.black,fontSize: 17, fontWeight: FontWeight.bold),
              ),
              leading: const Icon(
                Icons.book,
              ),
            ),
            ListTile(
              onTap: () {
                SystemNavigator.pop();
              },
              title: const Text(
                "Exit",
                style: TextStyle(color: Colors.black,fontSize: 17, fontWeight: FontWeight.bold),
              ),
              leading: const Icon(
                Icons.exit_to_app,
              ),
            ),
          ],
        ),
      ),
    );
  }
  }