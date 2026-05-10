enum UserRole { businessOwner, influencer }

extension UserRoleExt on UserRole {
  String get displayName => this == UserRole.businessOwner ? 'Business Owner' : 'Influencer';
  String get emoji => this == UserRole.businessOwner ? '🏢' : '📸';
  String get tagline => this == UserRole.businessOwner
      ? 'Find the perfect influencers for your brand'
      : 'Discover campaigns & grow your audience';
}

class AppUser {
  final String name;
  final String email;
  final String avatarUrl;
  final UserRole role;
  final String? company;  // for business owners
  final String? niche;    // for influencers

  const AppUser({
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.role,
    this.company,
    this.niche,
  });

  AppUser copyWith({
    String? name, String? email, String? avatarUrl, UserRole? role, String? company, String? niche,
  }) => AppUser(
    name: name ?? this.name,
    email: email ?? this.email,
    avatarUrl: avatarUrl ?? this.avatarUrl,
    role: role ?? this.role,
    company: company ?? this.company,
    niche: niche ?? this.niche,
  );
}
