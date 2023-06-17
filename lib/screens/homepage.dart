import 'package:flutter/material.dart';
import 'package:stepbit/screens/favorites.dart';
import 'package:stepbit/screens/map.dart';
import 'package:stepbit/screens/start_activity.dart';
import 'package:stepbit/utils/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int selectedIndex = 1;
  final pageController = PageController(initialPage: 1);

  double selectedDistance = 1;
  void setNewDistance(double newDistance) {
    setState(() => selectedDistance = newDistance);
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
        selectedItemColor: AppColors.primaryColor,
        onTap: (index) => pageController.animateToPage(index,
            duration: const Duration(milliseconds: 200),
            curve: Curves.bounceOut),
      ),
      body: PageView(
        controller: pageController,
        children: [
          Favorites(data: selectedDistance),
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
