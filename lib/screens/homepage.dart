import 'package:flutter/material.dart';
import 'package:stepbit/screens/deals.dart';
import 'package:stepbit/screens/favorites.dart';
import 'package:stepbit/screens/map.dart';
import 'package:stepbit/screens/settings.dart';
import 'package:stepbit/screens/start_activity.dart';
import 'package:stepbit/utils/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int selectedIndex = 2;
  final pageController = PageController(initialPage: 2);

  double selectedDistance = 1;
  void setNewDistance(double newDistance) {
    setState(() => selectedDistance = newDistance);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StepBit', style: TextStyle(fontSize: 30)),
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Settings()));
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.discount),
            label: 'Deals',
          ),
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
        selectedItemColor: AppColors.primaryColor,
        onTap: (index) => pageController.animateToPage(index,
            duration: const Duration(milliseconds: 200),
            curve: Curves.bounceOut),
      ),
      body: PageView(
        controller: pageController,
        children: [
          const Deals(),
          const Favorites(),
          StartActivity(
            pageController: pageController,
            setDistanceCallback: setNewDistance,
            data: selectedDistance,
          ),
          MapWidget(data: selectedDistance)
        ],
        onPageChanged: (index) => setState(() => selectedIndex = index),
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
