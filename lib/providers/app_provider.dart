import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/influencer_model.dart';
import '../models/campaign_model.dart';
import '../models/franchise_model.dart';
import '../models/product_model.dart';
import '../models/chat_message_model.dart';
import '../models/notification_model.dart';
import '../models/personal_brand_model.dart';
import '../models/user_model.dart';
import '../data/mock_data.dart';
import '../services/api_service.dart';
// ignore_for_file: avoid_types_as_parameter_names

class AppProvider extends ChangeNotifier {
  final _uuid = const Uuid();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadDataFromApi({double? lat, double? lng}) async {
    _isLoading = true;
    notifyListeners();
    try {
      _influencers = await ApiService.getInfluencers(lat: lat, lng: lng);
      _campaigns = await ApiService.getCampaigns(lat: lat, lng: lng);
      _franchises = await ApiService.getFranchises(lat: lat, lng: lng);
      _products = await ApiService.getProducts();
      _chatMessages = await ApiService.getChatMessages();
      _notifications = await ApiService.getNotifications();
      try {
        _personalBrand = await ApiService.getPersonalBrand();
      } catch (_) {
        _personalBrand = MockData.defaultPersonalBrand;
      }
    } catch (e) {
      debugPrint('Error loading data from API: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Current User / Role ───────────────────────────────────────────────────
  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;
  UserRole get role => _currentUser?.role ?? UserRole.businessOwner;
  bool get isBusinessOwner => role == UserRole.businessOwner;
  bool get isInfluencer => role == UserRole.influencer;
  bool get isLoggedIn => _currentUser != null;

  void login(AppUser user) {
    _currentUser = user;
    
    // Bind logged-in user data dynamically to PersonalBrand
    if (user.role == UserRole.influencer) {
      _personalBrand = _personalBrand.copyWith(
        displayName: user.name,
        contactEmail: user.email,
        avatarUrl: user.avatarUrl.isNotEmpty ? user.avatarUrl : _personalBrand.avatarUrl,
        tagline: user.niche ?? _personalBrand.tagline,
      );
    }
    
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    _onboardingComplete = false;
    notifyListeners();
  }

  void updateCurrentUser(AppUser user) {
    _currentUser = user;
    notifyListeners();
  }

  // ── Theme ─────────────────────────────────────────────────────────────────
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  // ── Onboarding ────────────────────────────────────────────────────────────
  bool _onboardingComplete = false;
  bool get onboardingComplete => _onboardingComplete;
  void completeOnboarding() {
    _onboardingComplete = true;
    notifyListeners();
  }

  // --- Influencers ---
  List<Influencer> _influencers = [];
  List<Influencer> get influencers => List.unmodifiable(_influencers);

  void addInfluencer(Influencer influencer) {
    _influencers.add(influencer);
    _addNotification(
      AppNotification(
        id: _uuid.v4(),
        title: 'New Influencer Added',
        body: '${influencer.name} has been added to the marketplace.',
        type: NotificationType.general,
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void updateInfluencer(Influencer influencer) {
    final idx = _influencers.indexWhere((i) => i.id == influencer.id);
    if (idx != -1) {
      _influencers[idx] = influencer;
      notifyListeners();
    }
  }

  void deleteInfluencer(String id) {
    _influencers.removeWhere((i) => i.id == id);
    notifyListeners();
  }

  Influencer? getInfluencerById(String id) {
    try {
      return _influencers.firstWhere((i) => i.id == id);
    } catch (_) {
      return null;
    }
  }

  // --- Campaigns ---
  List<Campaign> _campaigns = [];
  List<Campaign> get campaigns => List.unmodifiable(_campaigns);

  void addCampaign(Campaign campaign) {
    _campaigns.add(campaign);
    _addNotification(
      AppNotification(
        id: _uuid.v4(),
        title: 'New Campaign Added!',
        body: '${campaign.businessName} posted a new campaign: ${campaign.title}',
        type: NotificationType.newCampaign,
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void updateCampaign(Campaign campaign) {
    final idx = _campaigns.indexWhere((c) => c.id == campaign.id);
    if (idx != -1) {
      _campaigns[idx] = campaign;
      notifyListeners();
    }
  }

  void deleteCampaign(String id) {
    _campaigns.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  Campaign? getCampaignById(String id) {
    try {
      return _campaigns.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  // --- Franchises ---
  List<Franchise> _franchises = [];
  List<Franchise> get franchises => List.unmodifiable(_franchises);

  void addFranchise(Franchise franchise) {
    _franchises.add(franchise);
    notifyListeners();
  }

  void updateFranchise(Franchise franchise) {
    final idx = _franchises.indexWhere((f) => f.id == franchise.id);
    if (idx != -1) {
      _franchises[idx] = franchise;
      notifyListeners();
    }
  }

  void deleteFranchise(String id) {
    _franchises.removeWhere((f) => f.id == id);
    notifyListeners();
  }

  // --- Products ---
  List<Product> _products = [];
  List<Product> get products => List.unmodifiable(_products);

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void updateProduct(Product product) {
    final idx = _products.indexWhere((p) => p.id == product.id);
    if (idx != -1) {
      _products[idx] = product;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _products.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  // --- Chat Messages ---
  List<ChatMessage> _chatMessages = [];
  List<ChatMessage> get chatMessages => List.unmodifiable(_chatMessages);

  void sendChatMessage(String message) {
    final newMsg = ChatMessage(
      id: _uuid.v4(),
      senderId: 'me',
      senderName: 'You',
      senderAvatar: 'https://i.pravatar.cc/100?img=33',
      message: message,
      timestamp: DateTime.now(),
      isMe: true,
    );
    _chatMessages.add(newMsg);
    
    // Send to backend
    ApiService.sendChatMessage(newMsg);

    // Mock auto-reply after 1 second delay is handled in UI
    notifyListeners();
  }

  void addMockReply(String reply) {
    _chatMessages.add(ChatMessage(
      id: _uuid.v4(),
      senderId: 'user2',
      senderName: 'Priya Sharma',
      senderAvatar: 'https://i.pravatar.cc/100?img=1',
      message: reply,
      timestamp: DateTime.now(),
      isMe: false,
    ));
    notifyListeners();
  }

  // --- AI Chat Messages ---
  List<AiChatMessage> _aiMessages = [];
  List<AiChatMessage> get aiMessages => List.unmodifiable(_aiMessages);

  void addAiUserMessage(String message) {
    _aiMessages.add(AiChatMessage(
      id: _uuid.v4(),
      message: message,
      isUser: true,
      timestamp: DateTime.now(),
    ));
    notifyListeners();
  }

  void addAiReply(String reply) {
    _aiMessages.add(AiChatMessage(
      id: _uuid.v4(),
      message: reply,
      isUser: false,
      timestamp: DateTime.now(),
    ));
    notifyListeners();
  }

  void clearAiChat() {
    _aiMessages.clear();
    notifyListeners();
  }

  // --- Notifications ---
  List<AppNotification> _notifications = [];
  List<AppNotification> get notifications => List.unmodifiable(_notifications);
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void _addNotification(AppNotification notification) {
    _notifications.insert(0, notification);
  }

  void markNotificationRead(String id) {
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx != -1) {
      _notifications[idx].isRead = true;
      notifyListeners();
    }
  }

  void markAllRead() {
    for (final n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  // --- Personal Brand ---
  PersonalBrand _personalBrand = MockData.defaultPersonalBrand;
  PersonalBrand get personalBrand => _personalBrand;

  void updatePersonalBrand(PersonalBrand brand) {
    _personalBrand = brand;
    notifyListeners();
  }

  void addService(BrandService service) {
    _personalBrand = _personalBrand.copyWith(
      services: [..._personalBrand.services, service],
    );
    notifyListeners();
  }

  void deleteService(String id) {
    _personalBrand = _personalBrand.copyWith(
      services: _personalBrand.services.where((s) => s.id != id).toList(),
    );
    notifyListeners();
  }

  void addPortfolioItem(PortfolioItem item) {
    _personalBrand = _personalBrand.copyWith(
      portfolioItems: [..._personalBrand.portfolioItems, item],
    );
    notifyListeners();
  }

  void deletePortfolioItem(String id) {
    _personalBrand = _personalBrand.copyWith(
      portfolioItems: _personalBrand.portfolioItems.where((p) => p.id != id).toList(),
    );
    notifyListeners();
  }

  // --- Stats ---
  int get totalReach {
    return _influencers.fold(0, (sum, i) => sum + i.followers);
  }

  int get activeCampaigns =>
      _campaigns.where((c) => c.status == CampaignStatus.open || c.status == CampaignStatus.inProgress).length;

  double get mockEarnings => 284500.0;
  int get totalClicks => 18420;

  // --- Reset ---
  void resetToMockData() {
    _influencers = List.from(MockData.influencers);
    _campaigns = List.from(MockData.campaigns);
    _franchises = List.from(MockData.franchises);
    _products = List.from(MockData.products);
    _chatMessages = List.from(MockData.mockChatMessages);
    _aiMessages = [];
    _notifications = List.from(MockData.notifications);
    _personalBrand = MockData.defaultPersonalBrand;
    notifyListeners();
  }

  // --- Generate new ID ---
  String generateId() => _uuid.v4();
}
