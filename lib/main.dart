import 'package:fiap_20025/pages/account_lost_page.dart';
import 'package:fiap_20025/pages/create_account_page.dart';
import 'package:fiap_20025/pages/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Color primaryColor = Color(0xFF8D6CD1);

  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
      routes: {
        '/account_lost': (_) => AccountLostPage(),
        '/create_account': (_) => CreateAccountPage(),
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Color primaryColor = Color(0xFF8D6CD1);
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? errorMessage;

  void _login() {
    setState(() => errorMessage = null);

    if (_formKey.currentState!.validate()) {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (email == 'teste@gmail.com' && password == 'teste') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DashboardPage()),
        );
      } else {
        setState(() => errorMessage = 'Credenciais inválidas');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Image.asset('lib/assets/images/logo.png', height: 200),
              SizedBox(height: 24),
              Text(
                'O seu aplicativo expert em nutrição.',
                style: TextStyle(color: primaryColor.withOpacity(0.8)),
              ),
              SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Digite seu email:',
                          filled: true,
                          fillColor: Colors.grey.shade300,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email obrigatório';
                          }
                          final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegex.hasMatch(value.trim())) {
                            return 'Email inválido';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Digite sua senha:',
                          filled: true,
                          fillColor: Colors.grey.shade300,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Senha obrigatória';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/account_lost');
                          },
                          child: Text(
                            'Esqueci minha senha',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      if (errorMessage != null)
                        Text(
                          errorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            foregroundColor: Colors.white
                          ),
                          child: Text('Entrar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/create_account');
                },
                child: Text(
                  'Não possui uma conta? Crie uma aqui!',
                  style: TextStyle(color: primaryColor.withOpacity(0.8), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}