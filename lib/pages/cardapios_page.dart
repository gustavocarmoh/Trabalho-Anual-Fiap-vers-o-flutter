import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../components/custom_app_bar.dart';
import '../components/custom_bottom_nav_bar.dart';
import '../services/api_service.dart';
import '../models/nutrition_models.dart';
import '../models/user_profile_model.dart';
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

  final ApiService _apiService = ApiService();
  NutritionPlan? _nutritionPlan;
  UserProfile? _userProfile;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPageData();
  }

  Future<void> _fetchPageData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _nutritionPlan = null; // Reset previous plan
    });
    try {
      // Fetch user profile first for the app bar
      final profile = await _apiService.getFullUserProfile();
      if (mounted) {
        setState(() {
          _userProfile = profile;
        });
      }

      if (widget.day == null || widget.day!.isEmpty) {
        // If no specific day is provided, try to get today's plan as a fallback
        final plan = await _apiService.getTodaysNutritionPlan();
         if (mounted) {
          setState(() {
            _nutritionPlan = plan;
          });
        }
      } else {
        final weeklyPlans = await _apiService.getWeeklyNutritionPlans();
        NutritionPlan? foundPlan;
        for (var plan in weeklyPlans) {
          try {
            final DateTime planDate = DateTime.parse(plan.date);
            final String planDayName = DateFormat.EEEE('pt_BR').format(planDate).toLowerCase();
            final String targetDayName = widget.day!.toLowerCase().replaceAll('-', ' ');
            
            // Normalize targetDayName further if needed, e.g. removing "feira"
            final String normalizedTargetDayName = targetDayName.replaceAll('feira', '').trim();
            final String normalizedPlanDayName = planDayName.replaceAll('feira', '').trim();

            if (normalizedPlanDayName == normalizedTargetDayName) {
              foundPlan = plan;
              break;
            }
          } catch (e) {
            print("Error parsing date or comparing day names: $e");
            // Continue to the next plan if one fails to parse
          }
        }
        if (mounted) {
            setState(() {
            if (foundPlan != null) {
                _nutritionPlan = foundPlan;
            } else {
                _errorMessage = "Nenhum plano alimentar encontrado para ${widget.day}.";
            }
            });
        }
      }

    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceFirst("Exception: ", "");
        });
      }
      print("Error fetching menu page data: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _formatFoodItems(List<FoodItem> items) {
    if (items.isEmpty) return 'Nenhum item cadastrado.';
    return items
        .map((item) => '${item.name} (${item.quantity}${item.unit})')
        .join('; ');
  }

  String _getFormattedDate(String? dateString) {
    if (dateString == null) return 'Data não disponível';
    try {
      final DateTime date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy', 'pt_BR').format(date);
    } catch (e) {
      return dateString; 
    }
  }

  @override
  Widget build(BuildContext context) {
    String titulo = 'Plano de alimentação';
    if (_nutritionPlan != null) {
      titulo = 'Plano para ${widget.day ?? _getFormattedDate(_nutritionPlan!.date)}';
    } else if (widget.day != null) {
      titulo = 'Procurando plano para ${widget.day}...';
    }
    if (_isLoading) {
        titulo = 'Carregando plano...';
    } else if (_errorMessage != null && _nutritionPlan == null){
        titulo = widget.day != null ? 'Plano para ${widget.day}' : 'Plano de alimentação';
    }


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        userName: _userProfile?.fullName ?? _userProfile?.email ?? 'Usuário',
        userPlan: _userProfile?.activePlanName ?? 'Plano',
        userImageUrl: _userProfile?.hasProfilePhoto == true && _userProfile?.profilePhotoUrl != null
            ? _apiService.getFullPhotoUrl(_userProfile!.profilePhotoUrl!)
            : "https://www.gravatar.com/avatar/placeholder?d=mp&s=200",
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1, 
        primaryColor: primaryColor,
      ),
      body: Stack(
        children: [
          if (showLine && (_nutritionPlan?.meals.isNotEmpty ?? false))
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
                          Navigator.of(context).pop();
                        },
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          titulo,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Expanded(
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator(color: primaryColor))
                      : _errorMessage != null
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  _errorMessage!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.red, fontSize: 16),
                                ),
                              ),
                            )
                          : _nutritionPlan == null || _nutritionPlan!.meals.isEmpty
                              ? Center(
                                  child: Text(
                                    widget.day != null 
                                      ? 'Nenhum plano alimentar encontrado para ${widget.day}.': 'Nenhum plano alimentar disponível.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                                  ),
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                  itemCount: _nutritionPlan!.meals.length,
                                  itemBuilder: (context, index) {
                                    final meal = _nutritionPlan!.meals[index];
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
                                                  meal.name, 
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  _formatFoodItems(meal.foods),
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
