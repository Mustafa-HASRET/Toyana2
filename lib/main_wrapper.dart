import 'package:flutter/material.dart';
import 'common_widget/custom_bottom_nav_bar.dart';
import 'add_event_view.dart';
import 'home_view.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({Key? key}) : super(key: key);

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 0;

  static const List<String> _titles = [
    'Ana Sayfa',
    'Gallery',
    'Create',
    'Announcements',
    'Profile',
  ];

  static final List<Widget> _screens = [
    const HomeView(),
    const _ScreenContent(title: 'Gallery'),
    const AddEventView(),
    const _ScreenContent(title: 'Announcements'),
    const _ScreenContent(title: 'Profile'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0
          ? null
          : AppBar(
              title: Text(_titles[_selectedIndex]),
              backgroundColor: Colors.orange,
            ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class _ScreenContent extends StatelessWidget {
  final String title;

  const _ScreenContent({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}
