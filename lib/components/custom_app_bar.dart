import 'package:flutter/material.dart';

import '../pages/profile_page.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final String userPlan;
  final String userImageUrl;

  const CustomAppBar({
    super.key,
    required this.userName,
    required this.userPlan,
    required this.userImageUrl,
  });

  final Color primaryColor = const Color(0xFF8D6CD1);

  @override
  Size get preferredSize => const Size.fromHeight(90);

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.fromLTRB(16, topPadding + 8, 16, 12),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.2),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfilePage()),
              );
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://randomuser.me/api/portraits/women/20.jpg'),
              radius: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  userPlan,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward_ios, color: primaryColor, size: 18),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfilePage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
