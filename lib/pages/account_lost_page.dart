import 'package:flutter/material.dart';
import '../services/api_service.dart'; // Ensure ApiService is correctly imported

class AccountLostPage extends StatefulWidget {
  const AccountLostPage({Key? key}) : super(key: key);

  @override
  _AccountLostPageState createState() => _AccountLostPageState();
}

class _AccountLostPageState extends State<AccountLostPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _apiService = ApiService();

  bool _isLoading = false;
  String? _message;
  bool _isError = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submitPasswordResetRequest() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _message = null;
        _isError = false;
      });

      try {
        await _apiService.requestPasswordReset(_emailController.text.trim());
        setState(() {
          _message =
              "Se uma conta existir para este e-mail, um link para redefinição de senha foi enviado.";
          _isError = false;
          // Optionally clear the controller after success
          // _emailController.clear();
        });
      } catch (e) {
        setState(() {
          _message = e.toString().replaceFirst("Exception: ", "Erro: ");
          _isError = true;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Or your app's theme background
      appBar: AppBar(
        title: const Text(
          'Recuperar Senha',
          style: TextStyle(color: Colors.black87), // Adjust style as needed
        ),
        backgroundColor: Colors.transparent, // Or your app's theme app bar color
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87), // For back button
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 40),
              Text(
                'Perdeu sua senha?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple.shade700, // Theme color
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Não se preocupe! Insira seu e-mail abaixo para receber um link de redefinição de senha.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  hintText: 'seuemail@exemplo.com',
                  prefixIcon: Icon(Icons.email_outlined, color: Colors.purple.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.purple.shade700, width: 2),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, insira seu e-mail.';
                  }
                  if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                    return 'Por favor, insira um e-mail válido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade600, // Theme color
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _isLoading ? null : _submitPasswordResetRequest,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Text(
                        'Enviar Link de Redefinição',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
              const SizedBox(height: 20),
              if (_message != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    _message!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _isError ? Colors.red.shade700 : Colors.green.shade700,
                      fontSize: 14,
                    ),
                  ),
                ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Go back to login or previous screen
                },
                child: Text(
                  'Voltar para o Login',
                  style: TextStyle(color: Colors.purple.shade700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
