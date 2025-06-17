import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_bottom_nav_bar.dart';

class PlanosPage extends StatelessWidget {
  final String? diaSemana;
  final Color primaryColor = const Color(0xFF8D6CD1);

  PlanosPage({Key? key, this.diaSemana}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        userName: 'User', userPlan: 'Plano Platina', userImageUrl: '',
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 2,
        primaryColor: primaryColor,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double screenWidth = constraints.maxWidth;
                return Stack(
                  children: [
                    Positioned(
                      top: 120,
                      left: 0,
                      right: screenWidth * 0.35,
                      child: Container(
                        height: 6,
                        color: primaryColor.withOpacity(0.3),
                      ),
                    ),
                    Positioned(
                      top: 350,
                      left: screenWidth * 0.35,
                      right: 0,
                      child: Container(
                        height: 6,
                        color: primaryColor.withOpacity(0.3),
                      ),
                    ),
                    Positioned(
                      top: 580,
                      left: 0,
                      right: screenWidth * 0.35,
                      child: Container(
                        height: 6,
                        color: primaryColor.withOpacity(0.3),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      children: [
                        planoCard(
                          context: context,
                          title: 'Basico',
                          price: 'R\$12',
                          background: Colors.grey.shade200,
                          features: [
                            'Planos p/ 3 dias na semana',
                            'Sem Acesso ao Chat',
                          ],
                          buttonText: 'Rebaixar Plano',
                          buttonColor: Colors.black87,
                          isUpgrade: false,
                        ),
                        SizedBox(height: 40),
                        planoCard(
                          context: context,
                          title: 'Platina',
                          price: 'R\$28',
                          background: Color(0xFFEDE7F6),
                          features: [
                            'Planejamento p/ dias úteis',
                            'Acesso ao chat + 5 tokens',
                          ],
                          titleColor: primaryColor,
                          buttonText: 'Plano Atual!',
                          buttonColor: primaryColor,
                          isUpgrade: null,
                        ),
                        SizedBox(height: 40),
                        planoCard(
                          context: context,
                          title: 'Diamante',
                          price: 'R\$80',
                          background: Color(0xFFD1C4E9),
                          features: [
                            'Planejamento p/ dias úteis',
                            'Acesso ao chat sem limites!',
                          ],
                          titleColor: primaryColor,
                          buttonText: 'Melhorar Plano',
                          buttonColor: Color(0xFF5E35B1),
                          isUpgrade: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget planoCard({
    required BuildContext context,
    required String title,
    required String price,
    required List<String> features,
    required String buttonText,
    required Color buttonColor,
    required Color background,
    Color? titleColor,
    bool? isUpgrade,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: titleColor ?? Colors.black)),
              Text('$price/mês',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          SizedBox(height: 12),
          ...features.map(
                (f) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Icon(Icons.circle, size: 6, color: Colors.black54),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(f,
                        style: TextStyle(fontSize: 14, color: Colors.black87)),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                if (isUpgrade == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Plano melhorado com sucesso!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else if (isUpgrade == false) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Plano rebaixado."),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text(buttonText),
            ),
          )
        ],
      ),
    );
  }
}
