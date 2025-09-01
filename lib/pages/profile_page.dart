import 'package:fiap_20025/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../components/custom_bottom_nav_bar.dart';
import '../services/api_service.dart';
import '../models/user_profile_model.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Color primaryColor = const Color(0xFF8D6CD1);
  
  final ApiService _apiService = ApiService();
  UserProfile? _userProfile;
  bool _isLoading = true;
  String? _errorMessage;

  // Controllers will be initialized after fetching data
  late TextEditingController numeroController;
  late TextEditingController emailController;
  late TextEditingController pesoController;
  late TextEditingController infoExtraController;
  String atividadeFisica = 'Sim'; // Default or load from profile if available

  final _formKey = GlobalKey<FormState>();

  final maskFormatter = MaskTextInputFormatter(
    mask: '+## (##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  void initState() {
    super.initState();
    numeroController = TextEditingController();
    emailController = TextEditingController();
    pesoController = TextEditingController();
    infoExtraController = TextEditingController();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final profile = await _apiService.getFullUserProfile();
      setState(() {
        _userProfile = profile;
        if (profile != null) {
          emailController.text = profile.email;
          // Assuming fullName comes from the profile, if not, adjust.
          // numeroController.text = profile.phoneNumber ?? ''; 
          // pesoController.text = profile.weight?.toString() ?? '';
          // infoExtraController.text = profile.extraInfo ?? '';
          // atividadeFisica = profile.praticaAtividadeFisica ?? 'Sim';
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst("Exception: ", "");
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  // TODO: Implement _saveProfile logic calling appropriate API endpoint
  Future<void> _saveProfile() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    
    setState(() => _isLoading = true);
    try {
      // Example: await _apiService.updateUserProfile(fullName: _userProfile?.fullName ?? 'Nome Default', newEmail: emailController.text ...);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil salvo com sucesso! (API call pending)'), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: ${e.toString()}'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    await _apiService.logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => MyApp()), // Assuming LoginPage is the home of MyApp or directly accessible
      (Route<dynamic> route) => false,
    );
  }

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
        currentIndex: 3, // Assuming Profile is the fourth item (index 3)
        primaryColor: primaryColor,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : _errorMessage != null 
              ? Center(child: Padding(padding: const EdgeInsets.all(16.0), child: Text('Erro: $_errorMessage', style: TextStyle(color: Colors.red))))
              : _userProfile == null 
                  ? Center(child: Text('Não foi possível carregar o perfil.'))
                  : SafeArea(
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
                                  CircleAvatar(
                                    radius: 32,
                                    backgroundImage: _userProfile!.hasProfilePhoto && _userProfile!.profilePhotoUrl != null
                                        ? NetworkImage(_apiService.getFullPhotoUrl(_userProfile!.profilePhotoUrl!))
                                        : AssetImage('lib/assets/images/default_profile.png') as ImageProvider, // Ensure default_profile.png exists
                                    onBackgroundImageError: (_, __) { /* Handle error, show placeholder */ }, 
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              _userProfile?.fullName ?? _userProfile?.email ?? 'Usuário',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: primaryColor,
                                              ),
                                            ),
                                            // SizedBox(width: 4),
                                            // Icon(Icons.open_in_new, size: 16, color: primaryColor), // Edit icon if needed
                                          ],
                                        ),
                                        Text(
                                          _userProfile?.activePlanName ?? 'Nenhum plano ativo',
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
                                  // Phone number is not in UserProfile from /api/v1/user/me
                                  // Keep current implementation or decide how to integrate if API exists
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade400),
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.grey.shade50,
                                    ),
                                    child: Row(children: [ /* ... existing phone input ... */ 
                                        Padding(padding:const EdgeInsets.symmetric(horizontal: 12), child: Image.asset('icons/flags/png/br.png',package: 'country_icons',width: 24,height: 24,),),
                                        Expanded(child: TextFormField(controller: numeroController,keyboardType: TextInputType.phone,inputFormatters: [maskFormatter],decoration: const InputDecoration(hintText: '+55 (11) 90000-0000',border: InputBorder.none,contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),),),),
                                    ]),
                                  ),
                                  const SizedBox(height: 16),
                                  buildInputLabel('Melhor Email:'),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade400),
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.grey.shade100, // Read-only indication
                                    ),
                                    child: TextFormField(
                                      controller: emailController,
                                      readOnly: true, // Email usually not changed here, or needs specific API flow
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  buildInputLabel('Seu peso:'),
                                  // Weight is not in UserProfile from /api/v1/user/me
                                  Container(
                                     decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400),borderRadius: BorderRadius.circular(8),color: Colors.grey.shade50,),
                                     child: Row(children: [ Expanded(child: TextFormField(controller: pesoController,keyboardType: TextInputType.number,inputFormatters: [FilteringTextInputFormatter.digitsOnly],decoration: const InputDecoration(hintText: 'Ex: 70',border: InputBorder.none,contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),),),),const Padding(padding: EdgeInsets.only(right: 16),child: Text('kg',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 16,),),),])
                                  ),
                                  const SizedBox(height: 16),
                                  buildInputLabel('Pratica atividades físicas regularmente?'),
                                   Container(padding: const EdgeInsets.symmetric(horizontal: 12),decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400),borderRadius: BorderRadius.circular(8),color: Colors.grey.shade50,),child: DropdownButtonHideUnderline(child: DropdownButton<String>(isExpanded: true,value: atividadeFisica,items: ['Sim', 'Não'].map((value) => DropdownMenuItem<String>(value: value,child: Text(value),)).toList(),onChanged: (value) {if (value != null) { setState(() {atividadeFisica = value;});}},),),),
                                  const SizedBox(height: 16),
                                  buildInputLabel('Informações extras para a I.A:'),
                                  Container(padding: const EdgeInsets.symmetric(horizontal: 12),decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400),borderRadius: BorderRadius.circular(8),color: Colors.grey.shade50,),child: TextField(controller: infoExtraController,maxLines: 3,decoration: const InputDecoration(hintText:'Restrições alimentares, alergias, objetivos, informações extra de bioimpedância, etc...',border: InputBorder.none,),),),
                                  const SizedBox(height: 24),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.black,padding: const EdgeInsets.symmetric(vertical: 16),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),),
                                      onPressed: _isLoading ? null : _saveProfile,
                                      child: _isLoading ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white))) : const Text('Salvar',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white,),),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: TextButton.icon(
                                      icon: Icon(Icons.logout, color: Colors.red.shade700),
                                      label: Text('Sair da Conta', style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold)),
                                      onPressed: _logout,
                                      style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12),side: BorderSide(color: Colors.red.shade200),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
