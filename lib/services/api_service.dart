import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/chat_message_model.dart';
import '../models/nutrition_models.dart';
import '../models/service_provider_model.dart';
import '../models/subscription_plan_model.dart';
import '../models/user_profile_model.dart';
import '../models/user_subscription_model.dart'; // Added UserSubscription model

class ApiService {
  final String _baseAuthUrl = "http://10.0.2.2:8000/api/v1";
  final String _baseApiUrl  = "http://10.0.2.2:8000/api/v1";

  final _storage = const FlutterSecureStorage();
  final String _tokenKey = 'auth_token';

  Uri _resolve(String base, String endpoint) {
    final baseUri = Uri.parse(base.endsWith('/') ? base : '$base/');
    return endpoint.startsWith('http')
        ? Uri.parse(endpoint)
        : baseUri.resolve(endpoint);
  }

  String getFullPhotoUrl(String? relativePath) {
    if (relativePath == null || relativePath.isEmpty) {
      return 'lib/assets/images/default_profile.png';
    }
    if (relativePath.startsWith('http')) return relativePath;
    final apiBase = Uri.parse(_baseApiUrl);
    final root = Uri(
      scheme: apiBase.scheme,
      host: apiBase.host,
      port: apiBase.port,
    );
    final normalized = relativePath.startsWith('/')
        ? relativePath.substring(1)
        : relativePath;
    return root.resolve(normalized).toString();
  }

  Future<String?> _getToken() async => _storage.read(key: _tokenKey);
  Future<void> _saveToken(String token) async => _storage.write(key: _tokenKey, value: token);
  Future<void> _deleteToken() async => _storage.delete(key: _tokenKey);

  Future<Map<String, String>> _getHeaders({
    bool includeAuth = true,
    bool isJsonContent = true,
    Map<String, String>? extra,
  }) async {
    final headers = <String, String>{};
    if (isJsonContent) {
      headers['Content-Type'] = 'application/json; charset=UTF-8';
    }
    if (includeAuth) {
      final token = await _getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    if (extra != null) headers.addAll(extra);
    return headers;
  }

  T _decodeJson<T>(http.Response resp) {
    final body = utf8.decode(resp.bodyBytes);
    final decoded = jsonDecode(body);
    return decoded as T;
  }

  Never _throwHttp(http.Response r, String context) {
    final body = utf8.decode(r.bodyBytes);
    throw Exception('$context: ${r.statusCode} $body');
  }

  // Auth Endpoints
  Future<Map<String, dynamic>> login(String email, String password) async {
    final uri = _resolve(_baseAuthUrl, 'auth/login');
    final resp = await http
        .post(
      uri,
      headers: await _getHeaders(includeAuth: false),
      body: jsonEncode({'email': email, 'password': password}),
    )
        .timeout(const Duration(seconds: 20));

    if (resp.statusCode == 200) {
      final data = _decodeJson<Map<String, dynamic>>(resp);
      final token = (data['token'] ?? data['access_token'])?.toString();
      if (token != null) await _saveToken(token);
      return data;
    }
    _throwHttp(resp, 'Failed to login');
  }

  Future<Map<String, dynamic>> register(
      String email, String password, String fullName) async {
    final uri = _resolve(_baseAuthUrl, 'auth/register');
    final resp = await http
        .post(
      uri,
      headers: await _getHeaders(includeAuth: false),
      body: jsonEncode({'email': email, 'password': password, 'fullName': fullName}),
    )
        .timeout(const Duration(seconds: 20));

    if (resp.statusCode == 201) {
      return _decodeJson<Map<String, dynamic>>(resp);
    }
    _throwHttp(resp, 'Failed to register');
  }
  
  Future<void> requestPasswordReset(String email) async {
    final uri = _resolve(_baseAuthUrl, 'auth/request-password-reset');
    final resp = await http.post(
        uri,
        headers: await _getHeaders(includeAuth: false),
        body: jsonEncode({'email': email}),
    ).timeout(const Duration(seconds: 20));

    if (resp.statusCode == 200 || resp.statusCode == 204) {
        return; // Success
    }
    _throwHttp(resp, 'Failed to request password reset');
  }

  // User Profile
  Future<UserProfile?> getFullUserProfile() async {
    final uri = _resolve(_baseApiUrl, 'user/me'); // Corrected base URL if necessary
    final resp = await http
        .get(uri, headers: await _getHeaders())
        .timeout(const Duration(seconds: 20));

    if (resp.statusCode == 200) {
      final data = _decodeJson<Map<String, dynamic>>(resp);
      return UserProfile.fromJson(data);
    } else {
      if (resp.statusCode == 401) await _deleteToken();
      _throwHttp(resp, 'Failed to get full user profile');
    }
  }

  Future<Map<String, dynamic>?> getAuthProfile() async {
    final uri = _resolve(_baseAuthUrl, 'auth/profile');
    final resp = await http
        .get(uri, headers: await _getHeaders())
        .timeout(const Duration(seconds: 20));

    if (resp.statusCode == 200) {
      return _decodeJson<Map<String, dynamic>>(resp);
    } else {
      if (resp.statusCode == 401) await _deleteToken();
      return null;
    }
  }

  Future<void> logout() async {
    await _deleteToken();
  }

  // Nutrition Plans
  Future<NutritionPlan?> getTodaysNutritionPlan() async {
    final uri = _resolve(_baseApiUrl, 'nutrition-plans/today');
    final resp = await http
        .get(uri, headers: await _getHeaders())
        .timeout(const Duration(seconds: 20));

    if (resp.statusCode == 200) {
      final data = _decodeJson<dynamic>(resp);
      if (data is Map<String, dynamic>) {
        return NutritionPlan.fromJson(data);
      }
      return null;
    } else if (resp.statusCode == 404) {
      return null;
    } else {
      _throwHttp(resp, "Failed to get today's nutrition plan");
    }
  }

  Future<List<NutritionPlan>> getWeeklyNutritionPlans() async {
    final uri = _resolve(_baseApiUrl, 'nutrition-plans/week');
    final resp = await http
        .get(uri, headers: await _getHeaders())
        .timeout(const Duration(seconds: 20));

    if (resp.statusCode == 200) {
      final data = _decodeJson<dynamic>(resp);
      if (data is List) {
        return data
            .cast<Map<String, dynamic>>()
            .map((e) => NutritionPlan.fromJson(e))
            .toList();
      } else if (data is Map<String, dynamic> && data['items'] is List) {
        final items = (data['items'] as List).cast<Map<String, dynamic>>();
        return items.map(NutritionPlan.fromJson).toList();
      } else {
        return <NutritionPlan>[];
      }
    }
    _throwHttp(resp, "Failed to get weekly nutrition plans");
  }

  // Subscription Plans
  Future<List<SubscriptionPlan>> getSubscriptionPlans() async {
    final uri = _resolve(_baseApiUrl, 'subscription-plans'); // Corrected base URL
    final resp = await http
        .get(uri, headers: await _getHeaders(includeAuth: false))
        .timeout(const Duration(seconds: 20));

    if (resp.statusCode == 200) {
      final data = _decodeJson<dynamic>(resp);
      final list = data is List ? data : (data is Map && data['items'] is List ? data['items'] : []);
      return (list as List)
          .cast<Map<String, dynamic>>()
          .map((e) => SubscriptionPlan.fromJson(e))
          .toList();
    }
    _throwHttp(resp, "Failed to get subscription plans");
  }
  
  Future<UserSubscription?> getActiveUserSubscription() async {
    final uri = _resolve(_baseApiUrl, 'user/me/subscription');
    final resp = await http.get(uri, headers: await _getHeaders());

    if (resp.statusCode == 200) {
      final data = _decodeJson<Map<String, dynamic>>(resp);
      return UserSubscription.fromJson(data);
    } else if (resp.statusCode == 404) {
      return null; // No active subscription found
    }
    _throwHttp(resp, 'Failed to get active user subscription');
  }

  Future<UserSubscription> subscribeToPlan(String planId) async {
    final uri = _resolve(_baseApiUrl, 'subscriptions/$planId');
    // API docs say POST /api/subscriptions/{planId} - body not specified, assuming empty or handled by ID
    final resp = await http.post(uri, headers: await _getHeaders()); 

    if (resp.statusCode == 200 || resp.statusCode == 201) { // 201 for created, 200 for updated/ok
      final data = _decodeJson<Map<String, dynamic>>(resp);
      return UserSubscription.fromJson(data);
    }
    _throwHttp(resp, 'Failed to subscribe to plan $planId');
  }

  // Chat Messages
  Future<List<ChatMessage>> getChatMessages() async {
    final uri = _resolve(_baseApiUrl, 'chat/messages');
    final resp = await http.get(uri, headers: await _getHeaders());
    if (resp.statusCode == 200) {
      final data = _decodeJson<List<dynamic>>(resp);
      return data.map((item) => ChatMessage.fromJson(item as Map<String, dynamic>)).toList();
    }
    _throwHttp(resp, 'Failed to get chat messages');
  }

  Future<ChatMessage> sendChatMessage(String messageContent) async {
    final uri = _resolve(_baseApiUrl, 'chat/messages');
    final resp = await http.post(
      uri,
      headers: await _getHeaders(),
      body: jsonEncode({'message': messageContent}),
    );
    if (resp.statusCode == 201 || resp.statusCode == 200) {
      final data = _decodeJson<Map<String, dynamic>>(resp);
      return ChatMessage.fromJson(data);
    }
    _throwHttp(resp, 'Failed to send chat message');
  }

  // Service Providers
  Future<List<ServiceProvider>> getActiveServiceProviders() async {
    final uri = _resolve(_baseApiUrl, 'service-providers/active');
    final resp = await http.get(uri, headers: await _getHeaders(includeAuth: false)); // Assuming no auth needed
    if (resp.statusCode == 200) {
      final data = _decodeJson<List<dynamic>>(resp);
      return data.map((item) => ServiceProvider.fromJson(item as Map<String, dynamic>)).toList();
    }
    _throwHttp(resp, 'Failed to get active service providers');
  }

  // Generic requests (already present, not duplicated)
  Future<http.Response> get(
      String endpoint, {
        bool useAuthUrl = true,
        bool includeAuth = true,
        Map<String, String>? extraHeaders,
      }) async {
    final base = useAuthUrl ? _baseAuthUrl : _baseApiUrl;
    final uri = _resolve(base, endpoint);
    return http.get(
      uri,
      headers: await _getHeaders(includeAuth: includeAuth, extra: extraHeaders),
    ).timeout(const Duration(seconds: 20));
  }

  Future<http.Response> post(
      String endpoint,
      Map<String, dynamic> body, {
        bool useAuthUrl = true,
        bool includeAuth = true,
        Map<String, String>? extraHeaders,
      }) async {
    final base = useAuthUrl ? _baseAuthUrl : _baseApiUrl;
    final uri = _resolve(base, endpoint);
    return http.post(
      uri,
      headers: await _getHeaders(includeAuth: includeAuth, extra: extraHeaders),
      body: jsonEncode(body),
    ).timeout(const Duration(seconds: 20));
  }
}
