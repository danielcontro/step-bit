import 'package:flutter/material.dart';
import 'package:stepbit/screens/start_activity.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int selectedIndex = 1;
  final pageViewController = PageController(initialPage: 1);

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> screens = <Widget>[
    Text(
      'Favorites',
      style: optionStyle,
    ),
    StartActivity(),
    Text(
      'Maps',
      style: optionStyle,
    ),
  ];

  @override
  void dispose() {
    pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StepBit', style: TextStyle(fontSize: 30)),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Maps',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: (index) => pageViewController.animateToPage(index,
            duration: const Duration(milliseconds: 200),
            curve: Curves.bounceOut),
      ),
      body: PageView(
        controller: pageViewController,
        children: screens,
        onPageChanged: (index) => setState(() => selectedIndex = index),
      ),
    );
  }
}
