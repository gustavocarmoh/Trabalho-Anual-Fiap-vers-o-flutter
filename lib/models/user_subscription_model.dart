class UserSubscription {
  final String id;
  final String userId;
  final String planId;
  final String planName;
  final DateTime startDate;
  final DateTime? endDate; // Nullable if the subscription can be indefinite or end date is not always set
  final bool isActive;
  final double planPrice;

  UserSubscription({
    required this.id,
    required this.userId,
    required this.planId,
    required this.planName,
    required this.startDate,
    this.endDate,
    required this.isActive,
    required this.planPrice,
  });

  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    return UserSubscription(
      id: json['id'] as String,
      userId: json['userId'] as String,
      planId: json['planId'] as String,
      planName: json['planName'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate'] as String) : null,
      isActive: json['isActive'] as bool,
      planPrice: (json['planPrice'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'planId': planId,
    'planName': planName,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate?.toIso8601String(),
    'isActive': isActive,
    'planPrice': planPrice,
  };
}
