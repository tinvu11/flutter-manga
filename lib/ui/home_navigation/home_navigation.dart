import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeNavigation extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const HomeNavigation({super.key, required this.navigationShell});

  // static const routes = [
  //   RoutePath.home,
  //   RoutePaths.search,
  //   RoutePaths.personal,
  //   RoutePaths.library,
  // ];

  static const label = ['Home', 'Search', 'Library', 'Profile'];
  static const icon = [
    Icons.home,
    Icons.search,
    Icons.library_books,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Stack(children: [navigationShell]),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: BorderDirectional(
            top: BorderSide(color: colorScheme.secondary, width: 2.0),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: navigationShell.currentIndex,
          selectedItemColor: colorScheme.primary,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books),
              label: 'Library',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          onTap: (index) {
            navigateTo(index);
          },
        ),
      ),
    );
  }

  void navigateTo(int value) {
    navigationShell.goBranch(value);
  }
}
