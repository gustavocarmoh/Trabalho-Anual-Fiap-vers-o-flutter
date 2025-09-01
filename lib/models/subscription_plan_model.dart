class SubscriptionPlan {
  final String id;
  final String name;
  final String description;
  final double price;
  final int nutritionPlanLimit;
  final bool isActive;
  final String createdAt;
  final List<String> features;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.nutritionPlanLimit,
    required this.isActive,
    required this.createdAt,
    required this.features,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    var featuresFromJson = json['features'];
    List<String> featuresList = [];
    if (featuresFromJson is List) {
      featuresList = List<String>.from(featuresFromJson.map((item) => item.toString()));
    }
    
    return SubscriptionPlan(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      nutritionPlanLimit: json['nutritionPlanLimit'] as int,
      isActive: json['isActive'] as bool,
      createdAt: json['createdAt'] as String, // Consider parsing to DateTime if needed
      features: featuresList,
    );
  }
}
