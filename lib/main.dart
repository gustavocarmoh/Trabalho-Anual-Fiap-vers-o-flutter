import 'package:fiap_20025/pages/account_lost_page.dart';
import 'package:fiap_20025/pages/create_account_page.dart';
import 'package:fiap_20025/pages/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fiap_20025/services/api_service.dart'; // Added import

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
  final ApiService _apiService = ApiService(); // Instantiate ApiService

  String? errorMessage;
  bool _isLoading = false; // Added loading state

  Future<void> _login() async { // Changed to async
    setState(() {
      errorMessage = null;
      _isLoading = true; // Set loading true
    });

    if (_formKey.currentState!.validate()) {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      try {
        final success = await _apiService.login(email, password);
        if (success != null) {
          Navigator.pushReplacement( // Use pushReplacement to not allow back to login
            context,
            MaterialPageRoute(builder: (_) => DashboardPage()),
          );
        } else {
          setState(() => errorMessage = 'Credenciais inválidas ou erro na API.');
        }
      } catch (e) {
        setState(() => errorMessage = 'Erro ao tentar fazer login: ${e.toString()}');
      } finally {
        if (mounted) { // Check if the widget is still in the tree
          setState(() => _isLoading = false); // Set loading false
        }
      }
    } else {
      if (mounted) {
        setState(() => _isLoading = false); // Also set loading false if form is invalid
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
                          final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,5}$');
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
                          onPressed: _isLoading ? null : () { // Disable if loading
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
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            errorMessage!,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login, // Disable if loading
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: _isLoading 
                               ? SizedBox(
                                   height: 20, 
                                   width: 20, 
                                   child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                                 ) 
                               : Text('Entrar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: _isLoading ? null : () { // Disable if loading
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
