class SocialLink {
  final String platform;
  final String url;
  const SocialLink({required this.platform, required this.url});
}

class PortfolioItem {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  const PortfolioItem({required this.id, required this.title, required this.description, required this.imageUrl});
}

class BrandService {
  final String id;
  final String title;
  final String description;
  final double price;
  const BrandService({required this.id, required this.title, required this.description, required this.price});
}

class PersonalBrand {
  final String displayName;
  final String avatarUrl;
  final String tagline;
  final String bio;
  final String contactEmail;
  final List<SocialLink> socialLinks;
  final List<PortfolioItem> portfolioItems;
  final List<BrandService> services;

  const PersonalBrand({
    required this.displayName,
    required this.avatarUrl,
    required this.tagline,
    required this.bio,
    required this.contactEmail,
    required this.socialLinks,
    required this.portfolioItems,
    required this.services,
  });

  PersonalBrand copyWith({
    String? displayName, String? avatarUrl, String? tagline, String? bio,
    String? contactEmail, List<SocialLink>? socialLinks,
    List<PortfolioItem>? portfolioItems, List<BrandService>? services,
  }) => PersonalBrand(
    displayName: displayName ?? this.displayName,
    avatarUrl: avatarUrl ?? this.avatarUrl,
    tagline: tagline ?? this.tagline,
    bio: bio ?? this.bio,
    contactEmail: contactEmail ?? this.contactEmail,
    socialLinks: socialLinks ?? this.socialLinks,
    portfolioItems: portfolioItems ?? this.portfolioItems,
    services: services ?? this.services,
  );
}
