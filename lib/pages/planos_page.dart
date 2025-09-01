import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import '../components/custom_app_bar.dart';
import '../components/custom_bottom_nav_bar.dart';
import '../services/api_service.dart';
import '../models/subscription_plan_model.dart';
import '../models/user_subscription_model.dart';

class PlanosPage extends StatefulWidget {
  const PlanosPage({Key? key}) : super(key: key);

  @override
  _PlanosPageState createState() => _PlanosPageState();
}

class _PlanosPageState extends State<PlanosPage> {
  final Color primaryColor = const Color(0xFF8D6CD1);
  final Color secondaryColor = const Color(0xFF64B5F6); // For upgrades
  final Color accentColor = const Color(0xFFF06292);   // For downgrades
  final Color currentPlanColor = Colors.grey.shade700; 

  final ApiService _apiService = ApiService();
  
  List<SubscriptionPlan> _subscriptionPlans = [];
  UserSubscription? _currentUserSubscription;
  bool _isLoading = true;
  bool _isSubscribing = false;
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
    });
    try {
      // Fetch plans and current user subscription concurrently
      final results = await Future.wait([
        _apiService.getSubscriptionPlans(),
        _apiService.getActiveUserSubscription(),
      ]);

      final plans = results[0] as List<SubscriptionPlan>;
      final currentSubscription = results[1] as UserSubscription?;

      if (mounted) {
        setState(() {
          _subscriptionPlans = plans.take(3).toList(); // Show max 3 plans
          _currentUserSubscription = currentSubscription;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceFirst("Exception: ", "");
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleSubscription(String planId) async {
    if (_isSubscribing) return;
    setState(() {
      _isSubscribing = true;
      _errorMessage = null;
    });
    try {
      final newSubscription = await _apiService.subscribeToPlan(planId);
      if (mounted) {
        setState(() {
          _currentUserSubscription = newSubscription;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Inscrição no plano ${newSubscription.planName} realizada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        // Optionally, refresh custom app bar if it relies on user plan data from parent
        // However, CustomAppBar now fetches its own data, so this might not be needed for it.
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceFirst("Exception: ", "");
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Falha ao inscrever-se no plano: $_errorMessage'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubscribing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(), // CustomAppBar now fetches its own data
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 3, // PlanosPage is assumed to be index 3
        primaryColor: primaryColor,
      ),
      body: Stack(
        children: [
          // Decorative lines - kept as is for now
          // ... (decorative lines code omitted for brevity but remains the same)
          SafeArea(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: primaryColor))
                : _errorMessage != null && _subscriptionPlans.isEmpty // Show general error only if no plans loaded
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Erro ao carregar dados: $_errorMessage',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red, fontSize: 16),
                          ),
                        ),
                      )
                    : _subscriptionPlans.isEmpty
                        ? const Center(
                            child: Text(
                              'Nenhum plano de assinatura disponível no momento.',
                              style: TextStyle(fontSize: 16, color: Colors.grey /*.shade700*/),
                            ),
                          )
                        : SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            child: Column(
                              children: _subscriptionPlans.asMap().entries.map((entry) {
                                int index = entry.key;
                                SubscriptionPlan plan = entry.value;
                                Color cardBg = index % 2 == 0 ? Colors.grey.shade100 : const Color(0xFFEDE7F6);
                                
                                bool isCurrentPlan = _currentUserSubscription?.planId == plan.id;
                                String buttonText = "Selecionar Plano";
                                Color buttonColor = primaryColor;
                                VoidCallback? onPressedAction = () => _handleSubscription(plan.id);

                                if (_isSubscribing) {
                                  onPressedAction = null; // Disable button while subscribing
                                } else if (isCurrentPlan) {
                                  buttonText = "Plano Atual";
                                  buttonColor = currentPlanColor;
                                  onPressedAction = null; // Current plan, no action
                                } else if (_currentUserSubscription != null) {
                                  if (plan.price > _currentUserSubscription!.planPrice) {
                                    buttonText = "Fazer Upgrade";
                                    buttonColor = secondaryColor;
                                  } else if (plan.price < _currentUserSubscription!.planPrice) {
                                    buttonText = "Fazer Downgrade";
                                    buttonColor = accentColor;
                                  } 
                                  // If price is same but different plan, it keeps "Selecionar Plano"
                                }

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 40.0),
                                  child: planoCard(
                                    context: context,
                                    plan: plan,
                                    background: cardBg,
                                    buttonText: buttonText,
                                    buttonColor: buttonColor,
                                    numberFormat: numberFormat,
                                    onPressed: onPressedAction,
                                    isSubscribing: _isSubscribing,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget planoCard({
    required BuildContext context,
    required SubscriptionPlan plan,
    required Color background,
    required String buttonText,
    required Color buttonColor,
    required NumberFormat numberFormat,
    required VoidCallback? onPressed,
    required bool isSubscribing,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
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
              Flexible(
                child: Text(plan.name,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)), 
              ),
              Text('${numberFormat.format(plan.price)}/mês',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 4),
          Text(plan.description, style: const TextStyle(fontSize: 13, color: Colors.black54)),
          const SizedBox(height: 12),
          ...plan.features.map(
                (f) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  const Icon(Icons.circle, size: 6, color: Colors.black54),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(f,
                        style: const TextStyle(fontSize: 14, color: Colors.black87)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: isSubscribing ? null : onPressed, // Disable if isSubscribing globally
              child: isSubscribing && onPressed != null // Show loading only on the pressed button if needed, but for now global disable is fine
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3,)) 
                  : Text(buttonText),
            ),
          )
        ],
      ),
    );
  }
}
