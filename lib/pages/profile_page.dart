import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../components/custom_bottom_nav_bar.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Color primaryColor = const Color(0xFF8D6CD1);
  String atividadeFisica = 'Sim';

  final TextEditingController numeroController =
  TextEditingController(text: '+55 (11) 95022-4749');
  final TextEditingController emailController =
  TextEditingController(text: 'jchagas200403@gmail.com');
  final TextEditingController pesoController =
  TextEditingController(text: '55');
  final TextEditingController infoExtraController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final maskFormatter = MaskTextInputFormatter(
    mask: '+## (##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  void dispose() {
    numeroController.dispose();
    emailController.dispose();
    pesoController.dispose();
    infoExtraController.dispose();
    super.dispose();
  }

  bool isEmailValid(String email) {
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: -1,
        primaryColor: primaryColor,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 32,
                      backgroundImage: NetworkImage('https://randomuser.me/api/portraits/women/20.jpg'),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Text(
                                'Usuário',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF8D6CD1),
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.open_in_new,
                                  size: 16, color: Color(0xFF8D6CD1)),
                            ],
                          ),
                          const Text(
                            'Plano Platina',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildInputLabel('Número Cadastrado:'),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade50,
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 12),
                            child: Image.asset(
                              'icons/flags/png/br.png',
                              package: 'country_icons',
                              width: 24,
                              height: 24,
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: numeroController,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [maskFormatter],
                              decoration: const InputDecoration(
                                hintText: '+55 (11) 90000-0000',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    buildInputLabel('Melhor Email:'),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade50,
                      ),
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'email@example.com',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 16),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe um e-mail';
                          }
                          if (!isEmailValid(value)) {
                            return 'E-mail inválido';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    buildInputLabel('Seu peso:'),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade50,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: pesoController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: const InputDecoration(
                                hintText: 'Ex: 70',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 16),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: Text(
                              'kg',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    buildInputLabel(
                        'Pratica atividades físicas regularmente?'),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade50,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: atividadeFisica,
                          items: ['Sim', 'Não']
                              .map((value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                atividadeFisica = value;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    buildInputLabel('Informações extras para a I.A:'),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade50,
                      ),
                      child: TextField(
                        controller: infoExtraController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText:
                          'Restrições alimentares, alergias, objetivos, informações extra de bioimpedância, etc...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Perfil salvo com sucesso!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'Salvar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
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
  }

  Widget buildInputLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );
  }
}
