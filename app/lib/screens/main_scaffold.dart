import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'history_screen.dart';
import 'dashboard_screen.dart';
import 'account_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const HistoryScreen(),
    const DashboardScreen(),
    const AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.search, color: Colors.white70),
          onPressed: () {},
        ),
        title: const Text('TRACK BUG'),
        actions: [
          Row(
            children: [
              const Text(
                'Nikitin',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
              const SizedBox(width: 8),
              const CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
              ),
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Colors.white70),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        height: 70,
        decoration: BoxDecoration(
          color: const Color(0xFFC6FF00),
          borderRadius: BorderRadius.circular(35),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_outlined, Icons.home, 0),
            _buildNavItem(Icons.history, Icons.history, 1),
            _buildNavItem(Icons.dashboard_outlined, Icons.dashboard, 2),
            _buildNavItem(Icons.person_outline, Icons.person, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, IconData activeIcon, int index) {
    bool isActive = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: isActive ? const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ) : null,
        child: Icon(
          isActive ? activeIcon : icon,
          color: isActive ? const Color(0xFFC6FF00) : Colors.black,
          size: 28,
        ),
      ),
    );
  }
}
