enum CampaignStatus { open, inProgress, completed }
enum CampaignType { brandAwareness, productPromotion, eventMarketing, influencerCollaboration, contentCreation }

extension CampaignStatusExt on CampaignStatus {
  String get displayName {
    switch (this) {
      case CampaignStatus.open: return 'Open';
      case CampaignStatus.inProgress: return 'In Progress';
      case CampaignStatus.completed: return 'Completed';
    }
  }
}

extension CampaignTypeExt on CampaignType {
  String get displayName {
    switch (this) {
      case CampaignType.brandAwareness: return 'Brand Awareness';
      case CampaignType.productPromotion: return 'Product Promotion';
      case CampaignType.eventMarketing: return 'Event Marketing';
      case CampaignType.influencerCollaboration: return 'Influencer Collab';
      case CampaignType.contentCreation: return 'Content Creation';
    }
  }
}

class Campaign {
  final String id;
  final String businessName;
  final String logoUrl;
  final String category;
  final String title;
  final String description;
  final String location;
  final double budget;
  final String targetAudience;
  final CampaignType campaignType;
  final String requiredNiche;
  final CampaignStatus status;
  final DateTime createdAt;
  final int applicants;

  const Campaign({
    required this.id,
    required this.businessName,
    required this.logoUrl,
    required this.category,
    required this.title,
    required this.description,
    required this.location,
    required this.budget,
    required this.targetAudience,
    required this.campaignType,
    required this.requiredNiche,
    required this.status,
    required this.createdAt,
    required this.applicants,
  });

  String get budgetFormatted {
    if (budget >= 100000) return '₹${(budget / 100000).toStringAsFixed(1)}L';
    if (budget >= 1000) return '₹${(budget / 1000).toStringAsFixed(0)}K';
    return '₹${budget.toStringAsFixed(0)}';
  }

  Campaign copyWith({
    String? id, String? businessName, String? logoUrl, String? category,
    String? title, String? description, String? location, double? budget,
    String? targetAudience, CampaignType? campaignType, String? requiredNiche,
    CampaignStatus? status, DateTime? createdAt, int? applicants,
  }) => Campaign(
    id: id ?? this.id, businessName: businessName ?? this.businessName,
    logoUrl: logoUrl ?? this.logoUrl, category: category ?? this.category,
    title: title ?? this.title, description: description ?? this.description,
    location: location ?? this.location, budget: budget ?? this.budget,
    targetAudience: targetAudience ?? this.targetAudience,
    campaignType: campaignType ?? this.campaignType,
    requiredNiche: requiredNiche ?? this.requiredNiche,
    status: status ?? this.status, createdAt: createdAt ?? this.createdAt,
    applicants: applicants ?? this.applicants,
  );

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      businessName: json['businessName']?.toString() ?? 'Unknown Business',
      logoUrl: json['logoUrl']?.toString() ?? 'https://picsum.photos/200',
      category: json['category']?.toString() ?? '',
      title: json['title']?.toString() ?? 'No Title',
      description: json['description']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      budget: (json['budget'] ?? 0).toDouble(),
      targetAudience: json['targetAudience']?.toString() ?? '',
      campaignType: _parseType(json['campaignType']?.toString()),
      requiredNiche: json['requiredNiche']?.toString() ?? '',
      status: _parseStatus(json['status']?.toString()),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      applicants: (json['applicants'] ?? 0) as int,
    );
  }

  static CampaignStatus _parseStatus(String? s) {
    switch (s?.toLowerCase()) {
      case 'open':       return CampaignStatus.open;
      case 'inprogress': return CampaignStatus.inProgress;
      case 'completed':  return CampaignStatus.completed;
      default:           return CampaignStatus.open;
    }
  }

  static CampaignType _parseType(String? t) {
    switch (t?.toLowerCase()) {
      case 'brandawareness':          return CampaignType.brandAwareness;
      case 'productpromotion':        return CampaignType.productPromotion;
      case 'eventmarketing':          return CampaignType.eventMarketing;
      case 'influencercollaboration': return CampaignType.influencerCollaboration;
      case 'contentcreation':         return CampaignType.contentCreation;
      default:                        return CampaignType.brandAwareness;
    }
  }

  Map<String, dynamic> toJson() => {
    'businessName': businessName,
    'logoUrl': logoUrl,
    'category': category,
    'title': title,
    'description': description,
    'location': location,
    'budget': budget,
    'targetAudience': targetAudience,
    'campaignType': campaignType.name,
    'requiredNiche': requiredNiche,
    'status': status.name,
    'applicants': applicants,
  };
}
