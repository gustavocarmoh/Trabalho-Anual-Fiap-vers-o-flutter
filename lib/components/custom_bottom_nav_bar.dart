import 'package:fiap_20025/pages/dashboard_page.dart';
import 'package:flutter/material.dart';
import '../pages/dashboard_page.dart';
import '../pages/chat_page.dart';
import '../pages/planos_page.dart';

class CustomBottomNavBar extends StatelessWidget {
  /// Use `null` ou `-1` para não selecionar nenhum ícone.
  final int? currentIndex;
  final Color primaryColor;

  const CustomBottomNavBar({
    Key? key,
    this.currentIndex,
    required this.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Se currentIndex for null ou -1, não seleciona nenhum item.
    int selectedIndex = (currentIndex == null || currentIndex == -1) ? 999 : currentIndex!;

    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex < 3 ? selectedIndex : 0,
        selectedItemColor: selectedIndex < 3 ? primaryColor : Colors.grey,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DashboardPage()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ChatPage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PlanosPage()),
            );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,
                color: (selectedIndex == 0) ? primaryColor : Colors.grey),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy,
                color: (selectedIndex == 1) ? primaryColor : Colors.grey),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money,
                color: (selectedIndex == 2) ? primaryColor : Colors.grey),
            label: '',
          ),
        ],
      ),
    );
  }
}
