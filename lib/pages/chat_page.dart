import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_bottom_nav_bar.dart';
import 'dashboard_page.dart';
import 'planos_page.dart';

class ChatPage extends StatelessWidget {
  final Color primaryColor = Color(0xFF8D6CD1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        userName: 'User', userPlan: 'Plano Platina', userImageUrl: '',
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        primaryColor: primaryColor,
      ),
      body: Stack(
        children: [
          Positioned(
            left: 28,
            top: 20,
            bottom: 100,
            child: Container(
              width: 3,
              color: primaryColor.withOpacity(0.5),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Header
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListView(
                      children: [
                        // Mensagem do usuário
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                SizedBox(height: 6),
                                CircleAvatar(
                                  backgroundImage:NetworkImage('https://randomuser.me/api/portraits/women/20.jpg'),
                                  radius: 20,
                                ),
                              ],
                            ),
                            SizedBox(width: 10),
                            Container(
                              padding: EdgeInsets.all(12),
                              constraints: BoxConstraints(maxWidth: 250),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                'Eu preciso que meus próximos cardápios excluam o máximo de carboidratos possíveis.',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),

                        // Mensagem IA 1
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              constraints: BoxConstraints(maxWidth: 280),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                'Alterações feitas! A partir de agora, seus próximos cardápios estão otimizados para minimizar ao máximo a ingestão de carboidratos. Incluí mais proteínas magras como frango, peixe e ovos, além de vegetais folhosos e legumes com baixo índice glicêmico. Para compensar a redução dos carboidratos, adicionei gorduras saudáveis provenientes de fontes como abacate, azeite de oliva e oleaginosas.',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            SizedBox(width: 8),
                            Column(
                              children: [
                                SizedBox(height: 6),
                                CircleAvatar(
                                  backgroundColor: primaryColor,
                                  radius: 18,
                                  child: Icon(Icons.smart_toy,
                                      color: Colors.white, size: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 12),

                        // Mensagem IA 2
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              constraints: BoxConstraints(maxWidth: 280),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                'Essa mudança pode trazer benefícios como maior saciedade, redução dos picos de glicemia e auxílio na perda de gordura corporal. No início, você pode notar uma leve queda na energia devido à adaptação do corpo, mas isso tende a melhorar em poucos dias conforme seu organismo passa a usar gordura como fonte primária de energia.\n\nFique à vontade para me informar como se sente ao longo do processo! 📈✨',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            SizedBox(width: 8),
                            Column(
                              children: [
                                SizedBox(height: 6),
                                CircleAvatar(
                                  backgroundColor: primaryColor,
                                  radius: 18,
                                  child: Icon(Icons.smart_toy,
                                      color: Colors.white, size: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Campo de digitação
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Digite aqui...',
                        border: InputBorder.none,
                      ),
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
}
