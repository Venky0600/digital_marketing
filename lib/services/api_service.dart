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

class ApiService {
  // Use 10.0.2.2 for Android emulator, 127.0.0.1 for iOS simulator or Windows
  // Assuming local run for now. Using localhost instead of 127.0.0.1 for better Chrome Web compatibility.
  static const String baseUrl = 'http://localhost:5000/api';

  static Future<Map<String, String>> _getHeaders() async {
    final token = await AuthService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
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
    final response = await http.post(
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
    );

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
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
        'role': role,
      }),
    );

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
  static Future<List<Influencer>> getInfluencers() async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/influencers'), headers: headers);
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List<dynamic> jsonList = (decoded is Map<String, dynamic> && decoded.containsKey('data')) 
          ? decoded['data'] 
          : (decoded as List<dynamic>);
      return jsonList.map((json) => Influencer(
        id: json['_id'],
        name: json['name'],
        profileImageUrl: json['profileImageUrl'],
        bio: json['bio'],
        niche: json['niche'],
        location: json['location'],
        platform: _parseInfluencerPlatform(json['platform']),
        followers: json['followers'],
        engagementRate: json['engagementRate'].toDouble(),
        pricePerPromotion: json['pricePerPromotion'].toDouble(),
        rating: json['rating'].toDouble(),
        previousWorks: List<String>.from(json['previousWorks']),
        isVerified: json['isVerified'],
        createdAt: DateTime.parse(json['createdAt']),
      )).toList();
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
  static Future<List<Campaign>> getCampaigns() async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/campaigns'), headers: headers);
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List<dynamic> jsonList = (decoded is Map<String, dynamic> && decoded.containsKey('data')) 
          ? decoded['data'] 
          : (decoded as List<dynamic>);
      return jsonList.map((json) => Campaign(
        id: json['_id'],
        businessName: json['businessName'],
        logoUrl: json['logoUrl'],
        category: json['category'],
        title: json['title'],
        description: json['description'],
        location: json['location'],
        budget: json['budget'].toDouble(),
        targetAudience: json['targetAudience'],
        campaignType: _parseCampaignType(json['campaignType']),
        requiredNiche: json['requiredNiche'],
        status: _parseCampaignStatus(json['status']),
        createdAt: DateTime.parse(json['createdAt']),
        applicants: json['applicants'],
      )).toList();
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
  static Future<List<Franchise>> getFranchises() async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/franchises'), headers: headers);
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List<dynamic> jsonList = (decoded is Map<String, dynamic> && decoded.containsKey('data')) 
          ? decoded['data'] 
          : (decoded as List<dynamic>);
      return jsonList.map((json) => Franchise(
        id: json['_id'],
        brandName: json['brandName'],
        imageUrl: json['imageUrl'],
        investmentRequired: json['investmentRequired'].toDouble(),
        expectedProfit: json['expectedProfit'].toDouble(),
        locationAvailability: json['locationAvailability'],
        category: json['category'],
        supportProvided: List<String>.from(json['supportProvided']),
        contactEmail: json['contactEmail'],
        description: json['description'],
        established: json['established'],
        totalOutlets: json['totalOutlets'],
        createdAt: DateTime.parse(json['createdAt']),
      )).toList();
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
      return jsonList.map((json) => Product(
        id: json['_id'],
        name: json['name'],
        imageUrl: json['imageUrl'],
        description: json['description'],
        price: json['price'].toDouble(),
        discountedPrice: json['discountedPrice']?.toDouble(),
        offerBadge: json['offerBadge'],
        benefits: List<String>.from(json['benefits']),
        testimonials: (json['testimonials'] as List).map((t) => Testimonial(
          name: t['name'], review: t['review'], rating: t['rating'], avatarUrl: t['avatarUrl']
        )).toList(),
        ctaLabel: json['ctaLabel'],
        category: json['category'],
        createdAt: DateTime.parse(json['createdAt']),
      )).toList();
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
      return jsonList.map((json) => ChatMessage(
        id: json['_id'],
        senderId: json['senderId'],
        senderName: json['senderName'],
        senderAvatar: json['senderAvatar'],
        message: json['message'],
        timestamp: DateTime.parse(json['timestamp']),
        isMe: json['isMe'],
      )).toList();
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
      return jsonList.map((json) => AppNotification(
        id: json['_id'],
        title: json['title'],
        body: json['body'],
        type: _parseNotificationType(json['type']),
        timestamp: DateTime.parse(json['timestamp']),
        isRead: json['isRead'],
      )).toList();
    } else {
      throw Exception('Failed to load notifications');
    }
  }
  
  static NotificationType _parseNotificationType(String type) {
    switch (type) {
      case 'match': return NotificationType.match;
      case 'newCampaign': return NotificationType.newCampaign;
      case 'message': return NotificationType.message;
      case 'general': return NotificationType.general;
      default: return NotificationType.general;
    }
  }

  // --- Personal Brand ---
  static Future<PersonalBrand> getPersonalBrand() async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/personal-brand'), headers: headers);
    if (response.statusCode == 200 && response.body.isNotEmpty && response.body != 'null') {
      final jsonMap = json.decode(response.body);
      return PersonalBrand(
        displayName: jsonMap['displayName'],
        avatarUrl: jsonMap['avatarUrl'],
        tagline: jsonMap['tagline'],
        bio: jsonMap['bio'],
        contactEmail: jsonMap['contactEmail'],
        socialLinks: (jsonMap['socialLinks'] as List).map((l) => SocialLink(
          platform: l['platform'], url: l['url']
        )).toList(),
        portfolioItems: (jsonMap['portfolioItems'] as List).map((p) => PortfolioItem(
          id: p['_id'] ?? '', title: p['title'], description: p['description'], imageUrl: p['imageUrl']
        )).toList(),
        services: (jsonMap['services'] as List).map((s) => BrandService(
          id: s['_id'] ?? '', title: s['title'], description: s['description'], price: s['price'].toDouble()
        )).toList(),
      );
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
