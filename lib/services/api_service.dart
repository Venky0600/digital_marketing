import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import '../models/influencer_model.dart';
import '../models/campaign_model.dart';
import '../models/franchise_model.dart';
import '../models/product_model.dart';
import '../models/chat_message_model.dart';
import '../models/notification_model.dart';
import '../models/personal_brand_model.dart';
import '../models/marketing_service_model.dart';

import '../config/env_config.dart';

class ApiService {
  static const String baseUrl = EnvConfig.apiBaseUrl;

  static Future<Map<String, String>> _getHeaders() async {
    final token = await AuthService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Production-grade request wrapper with timeout and retry logic
  static Future<http.Response> _retryRequest(
    Future<http.Response> Function() requestFn, {
    int maxRetries = 2,
  }) async {
    int attempts = 0;
    while (attempts <= maxRetries) {
      try {
        return await requestFn().timeout(const Duration(seconds: 15));
      } catch (e) {
        attempts++;
        if (attempts > maxRetries) rethrow;
        await Future.delayed(Duration(seconds: attempts)); // Exponential backoff
      }
    }
    throw Exception('Request failed after $maxRetries retries');
  }

  // --- Authentication ---
  static Future<Map<String, dynamic>> signup({
    required String fullName,
    required String email,
    required String password,
    required String role,
    String? company,
    String? niche,
  }) async {
    final response = await _retryRequest(() => http.post(
      Uri.parse('$baseUrl/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'fullName': fullName,
        'email': email,
        'password': password,
        'role': role,
        'company': company,
        'niche': niche,
      }),
    ));

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      if (response.body.trim().startsWith('<!DOCTYPE') || response.body.trim().startsWith('<html')) {
        throw Exception('Network Error: Could not reach the server. Make sure the Node backend is running and CORS is allowed.');
      }
      String? errorMessage;
      try {
        errorMessage = json.decode(response.body)['error'];
      } catch (e) {
        throw Exception('Server returned invalid data (Status: ${response.statusCode}). Please ensure Node backend is restarted.');
      }
      throw Exception(errorMessage ?? 'Signup failed');
    }
  }

  static Future<Map<String, dynamic>> login(String email, String password, String role) async {
    final response = await _retryRequest(() => http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
        'role': role,
      }),
    ));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      if (response.body.trim().startsWith('<!DOCTYPE') || response.body.trim().startsWith('<html')) {
        throw Exception('Network Error: Could not reach the server. Make sure the Node backend is running and CORS is allowed.');
      }
      String? errorMessage;
      try {
        errorMessage = json.decode(response.body)['error'];
      } catch (e) {
        throw Exception('Server returned invalid data (Status: ${response.statusCode}). Please ensure Node backend is restarted.');
      }
      throw Exception(errorMessage ?? 'Login failed');
    }
  }

  // --- Influencers ---
  static Future<List<Influencer>> getInfluencers({double? lat, double? lng}) async {
    final headers = await _getHeaders();
    final uri = Uri.parse('$baseUrl/influencers').replace(queryParameters: {
      if (lat != null) 'lat': lat.toString(),
      if (lng != null) 'lng': lng.toString(),
    });
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List<dynamic> jsonList = (decoded is Map<String, dynamic> && decoded.containsKey('data')) 
          ? decoded['data'] 
          : (decoded as List<dynamic>);
      return jsonList.map((j) => Influencer.fromJson(j)).toList();
    } else {
      throw Exception('Failed to load influencers');
    }
  }

  static InfluencerPlatform _parseInfluencerPlatform(String platform) {
    switch (platform.toLowerCase()) {
      case 'instagram': return InfluencerPlatform.instagram;
      case 'youtube': return InfluencerPlatform.youtube;
      case 'linkedin': return InfluencerPlatform.linkedin;
      case 'tiktok': return InfluencerPlatform.tiktok;
      default: return InfluencerPlatform.instagram;
    }
  }

  // --- Campaigns ---
  static Future<List<Campaign>> getCampaigns({double? lat, double? lng}) async {
    final headers = await _getHeaders();
    final uri = Uri.parse('$baseUrl/campaigns').replace(queryParameters: {
      if (lat != null) 'lat': lat.toString(),
      if (lng != null) 'lng': lng.toString(),
    });
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List<dynamic> jsonList = (decoded is Map<String, dynamic> && decoded.containsKey('data')) 
          ? decoded['data'] 
          : (decoded as List<dynamic>);
      return jsonList.map((j) => Campaign.fromJson(j)).toList();
    } else {
      throw Exception('Failed to load campaigns');
    }
  }

  static CampaignType _parseCampaignType(String type) {
    switch (type) {
      case 'brandAwareness': return CampaignType.brandAwareness;
      case 'productPromotion': return CampaignType.productPromotion;
      case 'eventMarketing': return CampaignType.eventMarketing;
      case 'contentCreation': return CampaignType.contentCreation;
      case 'influencerCollaboration': return CampaignType.influencerCollaboration;
      default: return CampaignType.brandAwareness;
    }
  }

  static CampaignStatus _parseCampaignStatus(String status) {
    switch (status) {
      case 'open': return CampaignStatus.open;
      case 'inProgress': return CampaignStatus.inProgress;
      case 'completed': return CampaignStatus.completed;
      default: return CampaignStatus.open;
    }
  }

  // --- Franchises ---
  static Future<List<Franchise>> getFranchises({double? lat, double? lng}) async {
    final headers = await _getHeaders();
    final uri = Uri.parse('$baseUrl/franchises').replace(queryParameters: {
      if (lat != null) 'lat': lat.toString(),
      if (lng != null) 'lng': lng.toString(),
    });
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List<dynamic> jsonList = (decoded is Map<String, dynamic> && decoded.containsKey('data')) 
          ? decoded['data'] 
          : (decoded as List<dynamic>);
      return jsonList.map((j) => Franchise.fromJson(j)).toList();
    } else {
      throw Exception('Failed to load franchises');
    }
  }

  // --- Products ---
  static Future<List<Product>> getProducts() async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/products'), headers: headers);
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List<dynamic> jsonList = (decoded is Map<String, dynamic> && decoded.containsKey('data')) 
          ? decoded['data'] 
          : (decoded as List<dynamic>);
      return jsonList.map((j) => Product.fromJson(j)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  // --- Chat Messages ---
  static Future<List<ChatMessage>> getChatMessages() async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/chat'), headers: headers);
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List<dynamic> jsonList = (decoded is Map<String, dynamic> && decoded.containsKey('data')) 
          ? decoded['data'] 
          : (decoded as List<dynamic>);
      return jsonList.map((j) => ChatMessage.fromJson(j)).toList();
    } else {
      throw Exception('Failed to load chat messages');
    }
  }
  
  static Future<void> sendChatMessage(ChatMessage msg) async {
    final headers = await _getHeaders();
    await http.post(
      Uri.parse('$baseUrl/chat'),
      headers: headers,
      body: json.encode({
        'senderId': msg.senderId,
        'senderName': msg.senderName,
        'senderAvatar': msg.senderAvatar,
        'message': msg.message,
        'isMe': msg.isMe,
      }),
    );
  }

  // --- Notifications ---
  static Future<List<AppNotification>> getNotifications() async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/notifications'), headers: headers);
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List<dynamic> jsonList = (decoded is Map<String, dynamic> && decoded.containsKey('data')) 
          ? decoded['data'] 
          : (decoded as List<dynamic>);
      return jsonList.map((j) => AppNotification.fromJson(j)).toList();
    } else {
      throw Exception('Failed to load notifications');
    }
  }
  
  // --- Personal Brand ---
  static Future<PersonalBrand> getPersonalBrand() async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/personal-brand'), headers: headers);
    if (response.statusCode == 200 && response.body.isNotEmpty && response.body != 'null') {
      final jsonMap = json.decode(response.body);
      return PersonalBrand.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load personal brand');
    }
  }

  // --- Marketing Services ---
  static Future<List<MarketingService>> getMarketingServices() async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/marketing-services'), headers: headers);
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List<dynamic> jsonList = (decoded is Map<String, dynamic> && decoded.containsKey('data')) 
          ? decoded['data'] 
          : (decoded as List<dynamic>);
      return jsonList.map((json) => MarketingService.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load marketing services');
    }
  }
}
