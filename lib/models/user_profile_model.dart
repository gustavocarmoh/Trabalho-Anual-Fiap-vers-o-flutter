class UserProfile {
  final String email;
  final String userId;
  final bool hasActivePlan;
  final String? activePlanName;
  final String? activePlanId;
  final bool hasProfilePhoto;
  final String? profilePhotoUrl; // This is a relative URL as per API doc
  // Add other fields if needed, e.g., fullName if available from this or another endpoint
  final String? fullName; // Assuming fullName might come from /api/v1/auth/profile or be added

  UserProfile({
    required this.email,
    required this.userId,
    required this.hasActivePlan,
    this.activePlanName,
    this.activePlanId,
    required this.hasProfilePhoto,
    this.profilePhotoUrl,
    this.fullName,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      email: json['email'] as String,
      userId: json['userId'] as String,
      hasActivePlan: json['hasActivePlan'] as bool,
      activePlanName: json['activePlanName'] as String?,
      activePlanId: json['activePlanId'] as String?,
      hasProfilePhoto: json['hasProfilePhoto'] as bool,
      profilePhotoUrl: json['profilePhotoUrl'] as String?,
      fullName: json['fullName'] as String?, // Adjust if API provides it under a different key
    );
  }
}
