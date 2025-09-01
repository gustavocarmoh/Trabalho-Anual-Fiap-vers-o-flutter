class FoodItem {
  final String name;
  final num quantity; // API shows number, could be int or double
  final String unit;
  final num calories; // API shows number

  FoodItem({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.calories,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      name: json['name'] as String,
      quantity: json['quantity'] as num,
      unit: json['unit'] as String,
      calories: json['calories'] as num,
    );
  }
}

class Meal {
  final String name;
  final num targetCalories;
  final List<FoodItem> foods;

  Meal({
    required this.name,
    required this.targetCalories,
    required this.foods,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    var foodsList = json['foods'] as List?;
    List<FoodItem> foods = foodsList != null
        ? foodsList.map((i) => FoodItem.fromJson(i as Map<String, dynamic>)).toList()
        : [];
    return Meal(
      name: json['name'] as String,
      targetCalories: json['targetCalories'] as num,
      foods: foods,
    );
  }
}

class NutritionPlan {
  final String? id; // Assuming an ID might come from other endpoints like /api/nutrition-plans/{planId}
  final String date; // API shows string like "2024-01-15"
  final num targetCalories;
  final List<Meal> meals;
  // Add other fields if present in the API response for 'today' or 'week'
  // For example: "completed": true/false might be relevant from other plan endpoints

  NutritionPlan({
    this.id,
    required this.date,
    required this.targetCalories,
    required this.meals,
  });

  factory NutritionPlan.fromJson(Map<String, dynamic> json) {
    var mealsList = json['meals'] as List?;
    List<Meal> meals = mealsList != null
        ? mealsList.map((i) => Meal.fromJson(i as Map<String, dynamic>)).toList()
        : [];
    return NutritionPlan(
      id: json['id'] as String?, // if your specific endpoint for today returns an id
      date: json['date'] as String,
      targetCalories: json['targetCalories'] as num,
      meals: meals,
    );
  }
}
