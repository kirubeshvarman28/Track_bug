import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
          ),
          const SizedBox(height: 20),
          const Text(
            'Nikitin Sergey',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Security Analyst',
            style: TextStyle(color: Colors.white38),
          ),
          const SizedBox(height: 40),
          _buildProfileItem(Icons.person_outline, 'Personal Info'),
          _buildProfileItem(Icons.security_outlined, 'Security Settings'),
          _buildProfileItem(Icons.notifications_outlined, 'Notifications'),
          _buildProfileItem(Icons.help_outline, 'Help & Support'),
          const SizedBox(height: 20),
          _buildProfileItem(Icons.logout, 'Logout', color: Colors.redAccent),
        ],
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, {Color color = Colors.white}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 20),
          Text(
            title,
            style: TextStyle(fontSize: 16, color: color),
          ),
          const Spacer(),
          const Icon(Icons.chevron_right, color: Colors.white24),
        ],
      ),
    );
  }
}
