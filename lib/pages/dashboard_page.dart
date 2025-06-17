import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_bottom_nav_bar.dart';
import 'cardapios_page.dart';
import 'planos_page.dart' hide ChatPage;
import 'chat_page.dart';

class DashboardPage extends StatelessWidget {
  final Color primaryColor = const Color(0xFF8D6CD1);

  final List<Map<String, String>> days = [
    {'day': 'Segunda-Feira', 'letter': 'S'},
    {'day': 'Terça-Feira', 'letter': 'T'},
    {'day': 'Quarta-Feira', 'letter': 'Q'},
    {'day': 'Quinta-Feira', 'letter': 'Q'},
    {'day': 'Sexta-Feira', 'letter': 'S'},
  ];

  @override
  Widget build(BuildContext context) {
    final double verticalLineLeft = 52;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        userName: 'User', userPlan: 'Plano Platina', userImageUrl: '',
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        primaryColor: primaryColor,
      ),
      body: Stack(
        children: [
          Positioned(
            left: verticalLineLeft,
            top: 10,
            bottom: 0,
            child: Container(
              width: 3,
              color: primaryColor.withOpacity(0.5),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Olá, Usário!",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text.rich(
                      TextSpan(
                        text: "Aqui estão os ",
                        children: [
                          TextSpan(
                            text: "cardápios da semana.",
                            style: TextStyle(color: Colors.blueAccent),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: ListView.separated(
                    padding: EdgeInsets.only(bottom: 16),
                    itemCount: days.length,
                    separatorBuilder: (_, __) => SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      final item = days[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          left: 8,
                          top: index == 0 ? 20 : 0,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MenuPage(day: item['day']),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 42,
                                  height: 42,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(right: 16),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: primaryColor.withOpacity(0.15),
                                  ),
                                  child: Text(
                                    item['letter']!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['day']!,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Gerado em 08/05',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Row(
                        children: [
                          SizedBox(width: verticalLineLeft + 32),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => PlanosPage()),
                                );
                              },
                              child: Text(
                                'Melhore seu plano para liberar mais dias!',
                                style: TextStyle(
                                  color: primaryColor.withOpacity(0.85),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: verticalLineLeft - 20,
                      top: 10,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.add,
                            size: 28,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}