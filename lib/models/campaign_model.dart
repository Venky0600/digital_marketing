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
}
