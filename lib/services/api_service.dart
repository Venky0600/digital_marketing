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
      return jsonList.map((j) => Influencer(
        id: j['_id']?.toString() ?? '',
        name: j['name']?.toString() ?? 'Unknown',
        profileImageUrl: j['profileImageUrl']?.toString() ?? '',
        bio: j['bio']?.toString() ?? '',
        niche: j['niche']?.toString() ?? '',
        location: j['location']?.toString() ?? '',
        platform: _parseInfluencerPlatform(j['platform']?.toString() ?? ''),
        followers: (j['followers'] ?? 0) as int,
        engagementRate: (j['engagementRate'] ?? 0).toDouble(),
        pricePerPromotion: (j['pricePerPromotion'] ?? 0).toDouble(),
        rating: (j['rating'] ?? 0).toDouble(),
        previousWorks: j['previousWorks'] != null ? List<String>.from(j['previousWorks']) : [],
        isVerified: j['isVerified'] ?? false,
        createdAt: j['createdAt'] != null ? DateTime.parse(j['createdAt']) : DateTime.now(),
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
      return jsonList.map((j) => Campaign(
        id: j['_id']?.toString() ?? '',
        businessName: j['businessName']?.toString() ?? '',
        logoUrl: j['logoUrl']?.toString() ?? '',
        category: j['category']?.toString() ?? '',
        title: j['title']?.toString() ?? '',
        description: j['description']?.toString() ?? '',
        location: j['location']?.toString() ?? '',
        budget: (j['budget'] ?? 0).toDouble(),
        targetAudience: j['targetAudience']?.toString() ?? '',
        campaignType: _parseCampaignType(j['campaignType']?.toString() ?? ''),
        requiredNiche: j['requiredNiche']?.toString() ?? '',
        status: _parseCampaignStatus(j['status']?.toString() ?? ''),
        createdAt: j['createdAt'] != null ? DateTime.parse(j['createdAt']) : DateTime.now(),
        applicants: (j['applicants'] ?? 0) as int,
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
      return jsonList.map((j) => Franchise(
        id: j['_id']?.toString() ?? '',
        brandName: j['brandName']?.toString() ?? '',
        imageUrl: j['imageUrl']?.toString() ?? '',
        investmentRequired: (j['investmentRequired'] ?? 0).toDouble(),
        expectedProfit: (j['expectedProfit'] ?? 0).toDouble(),
        locationAvailability: j['locationAvailability']?.toString() ?? '',
        category: j['category']?.toString() ?? '',
        supportProvided: j['supportProvided'] != null ? List<String>.from(j['supportProvided']) : [],
        contactEmail: j['contactEmail']?.toString() ?? '',
        description: j['description']?.toString() ?? '',
        established: j['established'] ?? 0,
        totalOutlets: j['totalOutlets'] ?? 0,
        createdAt: j['createdAt'] != null ? DateTime.parse(j['createdAt']) : DateTime.now(),
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
      return jsonList.map((j) => Product(
        id: j['_id']?.toString() ?? '',
        name: j['name']?.toString() ?? '',
        imageUrl: j['imageUrl']?.toString() ?? '',
        description: j['description']?.toString() ?? '',
        price: (j['price'] ?? 0).toDouble(),
        discountedPrice: j['discountedPrice'] != null ? (j['discountedPrice']).toDouble() : null,
        offerBadge: j['offerBadge']?.toString(),
        benefits: j['benefits'] != null ? List<String>.from(j['benefits']) : [],
        testimonials: (j['testimonials'] as List? ?? []).map((t) => Testimonial(
          name: t['name']?.toString() ?? '',
          review: t['review']?.toString() ?? '',
          rating: (t['rating'] ?? 0).toDouble(),
          avatarUrl: t['avatarUrl']?.toString() ?? '',
        )).toList(),
        ctaLabel: j['ctaLabel']?.toString() ?? '',
        category: j['category']?.toString() ?? '',
        createdAt: j['createdAt'] != null ? DateTime.parse(j['createdAt']) : DateTime.now(),
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
      return jsonList.map((j) => ChatMessage(
        id: j['_id']?.toString() ?? '',
        senderId: j['senderId']?.toString() ?? '',
        senderName: j['senderName']?.toString() ?? '',
        senderAvatar: j['senderAvatar']?.toString() ?? '',
        message: j['message']?.toString() ?? '',
        timestamp: j['timestamp'] != null ? DateTime.parse(j['timestamp']) : DateTime.now(),
        isMe: j['isMe'] ?? false,
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
      return jsonList.map((j) => AppNotification(
        id: j['_id']?.toString() ?? '',
        title: j['title']?.toString() ?? '',
        body: j['body']?.toString() ?? '',
        type: _parseNotificationType(j['type']?.toString() ?? ''),
        timestamp: j['timestamp'] != null ? DateTime.parse(j['timestamp']) : DateTime.now(),
        isRead: j['isRead'] ?? false,
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
        displayName: jsonMap['displayName']?.toString() ?? '',
        avatarUrl: jsonMap['avatarUrl']?.toString() ?? '',
        tagline: jsonMap['tagline']?.toString() ?? '',
        bio: jsonMap['bio']?.toString() ?? '',
        contactEmail: jsonMap['contactEmail']?.toString() ?? '',
        socialLinks: (jsonMap['socialLinks'] as List? ?? []).map((l) => SocialLink(
          platform: l['platform']?.toString() ?? '', url: l['url']?.toString() ?? ''
        )).toList(),
        portfolioItems: (jsonMap['portfolioItems'] as List? ?? []).map((p) => PortfolioItem(
          id: p['_id']?.toString() ?? '', title: p['title']?.toString() ?? '',
          description: p['description']?.toString() ?? '', imageUrl: p['imageUrl']?.toString() ?? ''
        )).toList(),
        services: (jsonMap['services'] as List? ?? []).map((s) => BrandService(
          id: s['_id']?.toString() ?? '', title: s['title']?.toString() ?? '',
          description: s['description']?.toString() ?? '',
          price: (s['price'] ?? 0).toDouble()
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
