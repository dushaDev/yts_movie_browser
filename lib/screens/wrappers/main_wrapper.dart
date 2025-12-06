import 'package:flutter/material.dart';
import '../home_screen.dart';
import '../search_screen.dart';
import '../saved_screen.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const SearchScreen(),
    const SavedScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // The body stays behind the bottom nav
      body: IndexedStack(index: _currentIndex, children: _pages),

      // STANDARD FIXED BOTTOM NAV BAR
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: colorScheme.surface, // Matches the theme background
        indicatorColor:
            colorScheme.primaryContainer, // The pill color behind icon
        elevation: 2,
        // Optional: Remove labels if you want icons only
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,

        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined, size: 28),
            selectedIcon: Icon(
              Icons.home_rounded,
              size: 28,
              color: colorScheme.primary,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: const Icon(Icons.search_outlined, size: 28),
            selectedIcon: Icon(
              Icons.search_rounded,
              size: 28,
              color: colorScheme.primary,
            ),
            label: 'Search',
          ),
          NavigationDestination(
            icon: const Icon(Icons.bookmark_outline, size: 28),
            selectedIcon: Icon(
              Icons.bookmark_rounded,
              size: 28,
              color: colorScheme.primary,
            ),
            label: 'Saved',
          ),
        ],
      ),
    );
  }
}
