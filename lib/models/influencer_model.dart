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

  factory Influencer.fromJson(Map<String, dynamic> json) {
    return Influencer(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown',
      profileImageUrl: json['profileImageUrl']?.toString() ?? 'https://i.pravatar.cc/300',
      bio: json['bio']?.toString() ?? '',
      niche: json['niche']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      platform: _parsePlatform(json['platform']?.toString()),
      followers: (json['followers'] ?? 0) as int,
      engagementRate: (json['engagementRate'] ?? 0).toDouble(),
      pricePerPromotion: (json['pricePerPromotion'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      previousWorks: json['previousWorks'] != null ? List<String>.from(json['previousWorks']) : [],
      isVerified: json['isVerified'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }

  static InfluencerPlatform _parsePlatform(String? p) {
    switch (p?.toLowerCase()) {
      case 'instagram': return InfluencerPlatform.instagram;
      case 'youtube':   return InfluencerPlatform.youtube;
      case 'facebook':  return InfluencerPlatform.facebook;
      case 'linkedin':  return InfluencerPlatform.linkedin;
      case 'tiktok':    return InfluencerPlatform.tiktok;
      default:          return InfluencerPlatform.instagram;
    }
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'profileImageUrl': profileImageUrl,
    'bio': bio,
    'niche': niche,
    'location': location,
    'platform': platform.name,
    'followers': followers,
    'engagementRate': engagementRate,
    'pricePerPromotion': pricePerPromotion,
    'rating': rating,
    'previousWorks': previousWorks,
    'isVerified': isVerified,
  };
}
