import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_bottom_nav_bar.dart';
import 'supermarkets_page.dart';

class MenuPage extends StatefulWidget {
  final String? day;
  MenuPage({this.day});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final Color primaryColor = Color(0xFF8D6CD1);
  bool showLine = true;

  final List<Map<String, String>> meals = [
    {
      'title': 'Café da manhã',
      'desc': 'Claras de ovo (150g); Aveia em flocos (40g); Banana (100g); Iogurte natural (100g); Morangos (50g)'
    },
    {
      'title': 'Lanche da manhã',
      'desc': 'Maçã (120g); Amêndoas (30g); Cenoura baby (50g)'
    },
    {
      'title': 'Almoço',
      'desc': 'Peito de frango grelhado (120g); Arroz integral cozido (100g); Feijão carioca cozido (80g); Brócolis no vapor (80g); Salada (alface e tomate) (100g); Azeite de oliva (10g)'
    },
    {
      'title': 'Lanche da Tarde',
      'desc': 'Pão integral (50g); Pasta de amendoim (20g); Queijo cottage (100g); Uvas (50g)'
    },
    {
      'title': 'Jantar',
      'desc': 'Filé de tilápia grelhado (120g); Quinoa cozida (80g); Abobrinha grelhada (80g); Cenoura assada (80g); Espinafre refogado (60g)'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final String titulo = widget.day != null
        ? 'Plano de alimentação, ${widget.day}'
        : 'Plano de alimentação';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        userName: 'User', userPlan: 'Plano Platina', userImageUrl: '',
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: -1,
        primaryColor: primaryColor,
      ),
      body: Stack(
        children: [
          if (showLine)
            Positioned(
              top: 60,
              left: 48,
              bottom: 0,
              child: Container(
                width: 6,
                color: primaryColor.withOpacity(0.4),
              ),
            ),
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: primaryColor),
                        onPressed: () {
                          setState(() => showLine = false);
                          Navigator.of(context).pop();
                        },
                      ),
                      SizedBox(width: 8),
                      Text(
                        titulo,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    itemCount: meals.length,
                    itemBuilder: (context, index) {
                      final meal = meals[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 20),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    meal['title']!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    meal['desc']!,
                                    style: TextStyle(fontSize: 13, color: Colors.black87),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => SupermarketListPage()),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Icon(Icons.shopping_cart_outlined, color: primaryColor, size: 24),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}