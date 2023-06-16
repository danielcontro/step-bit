import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepbit/database/entities/person.dart';
import 'package:stepbit/screens/favorites.dart';
import 'package:stepbit/screens/map.dart';
import 'package:stepbit/screens/start_activity.dart';
import 'package:stepbit/utils/app_colors.dart';

import '../repositories/database_repository.dart';

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
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            //No need to use a Consumer, we are just using a method of the DatabaseRepository
            await Provider.of<DatabaseRepository>(context, listen: false)
                .insertPerson(Person(null, 'Luca'));
          },
          child: const Icon(Icons.add)),
      body: PageView(
        controller: pageController,
        children: [
          Favorites(data: selectedDistance),
          Consumer<DatabaseRepository>(
            builder: (context, dbr, child) {
              //The logic is to query the DB for the entire list of Todo using dbr.findAllTodos()
              //and then populate the ListView accordingly.
              //We need to use a FutureBuilder since the result of dbr.findAllTodos() is a Future.
              return FutureBuilder(
                initialData: null,
                future: dbr.findAllPeople(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data as List<Person>;
                    return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, personIndex) {
                          final person = data[personIndex];
                          return Card(
                            elevation: 5,
                            //Here we use a Dismissible widget to create a nicer UI.
                            child: Dismissible(
                              //Just create a dummy unique key
                              key: UniqueKey(),
                              //This is the background to show when the ListTile is swiped
                              background: Container(color: Colors.red),
                              //The ListTile is used to show the Todo entry
                              child: ListTile(
                                title: Text(person.name),
                                subtitle: Text('ID: ${person.id}'),
                                //If the ListTile is tapped, it is deleted
                              ),
                              //This method is called when the ListTile is dismissed
                              onDismissed: (direction) async {
                                //No need to use a Consumer, we are just using a method of the DatabaseRepository
                                await Provider.of<DatabaseRepository>(context,
                                        listen: false)
                                    .removePerson(person);
                              },
                            ),
                          );
                        });
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              );
            },
          ),
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
