enum InfluencerPlatform { instagram, youtube, facebook, linkedin, tiktok }

extension InfluencerPlatformExt on InfluencerPlatform {
  String get displayName {
    switch (this) {
      case InfluencerPlatform.instagram: return 'Instagram';
      case InfluencerPlatform.youtube: return 'YouTube';
      case InfluencerPlatform.facebook: return 'Facebook';
      case InfluencerPlatform.linkedin: return 'LinkedIn';
      case InfluencerPlatform.tiktok: return 'TikTok';
    }
  }

  String get icon {
    switch (this) {
      case InfluencerPlatform.instagram: return '📸';
      case InfluencerPlatform.youtube: return '▶️';
      case InfluencerPlatform.facebook: return '👤';
      case InfluencerPlatform.linkedin: return '💼';
      case InfluencerPlatform.tiktok: return '🎵';
    }
  }
}

class Influencer {
  final String id;
  final String name;
  final String profileImageUrl;
  final String bio;
  final String niche;
  final String location;
  final InfluencerPlatform platform;
  final int followers;
  final double engagementRate;
  final double pricePerPromotion;
  final double rating;
  final List<String> previousWorks;
  final bool isVerified;
  final DateTime createdAt;

  const Influencer({
    required this.id,
    required this.name,
    required this.profileImageUrl,
    required this.bio,
    required this.niche,
    required this.location,
    required this.platform,
    required this.followers,
    required this.engagementRate,
    required this.pricePerPromotion,
    required this.rating,
    required this.previousWorks,
    required this.isVerified,
    required this.createdAt,
  });

  String get followersFormatted {
    if (followers >= 1000000) return '${(followers / 1000000).toStringAsFixed(1)}M';
    if (followers >= 1000) return '${(followers / 1000).toStringAsFixed(0)}K';
    return followers.toString();
  }

  Influencer copyWith({
    String? id, String? name, String? profileImageUrl, String? bio,
    String? niche, String? location, InfluencerPlatform? platform,
    int? followers, double? engagementRate, double? pricePerPromotion,
    double? rating, List<String>? previousWorks, bool? isVerified, DateTime? createdAt,
  }) => Influencer(
    id: id ?? this.id, name: name ?? this.name,
    profileImageUrl: profileImageUrl ?? this.profileImageUrl, bio: bio ?? this.bio,
    niche: niche ?? this.niche, location: location ?? this.location,
    platform: platform ?? this.platform, followers: followers ?? this.followers,
    engagementRate: engagementRate ?? this.engagementRate,
    pricePerPromotion: pricePerPromotion ?? this.pricePerPromotion,
    rating: rating ?? this.rating, previousWorks: previousWorks ?? this.previousWorks,
    isVerified: isVerified ?? this.isVerified, createdAt: createdAt ?? this.createdAt,
  );
}
