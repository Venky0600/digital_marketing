class Testimonial {
  final String name;
  final String review;
  final double rating;
  final String avatarUrl;

  const Testimonial({
    required this.name,
    required this.review,
    required this.rating,
    required this.avatarUrl,
  });

  factory Testimonial.fromJson(Map<String, dynamic> json) {
    return Testimonial(
      name: json['name']?.toString() ?? 'Anonymous',
      review: json['review']?.toString() ?? '',
      rating: (json['rating'] ?? 5).toDouble(),
      avatarUrl: json['avatarUrl']?.toString() ?? 'https://i.pravatar.cc/100',
    );
  }
}

class Product {
  final String id;
  final String name;
  final String imageUrl;
  final String description;
  final double price;
  final double? discountedPrice;
  final String? offerBadge;
  final List<String> benefits;
  final List<Testimonial> testimonials;
  final String ctaLabel;
  final String category;
  final DateTime createdAt;

  const Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.price,
    this.discountedPrice,
    this.offerBadge,
    required this.benefits,
    required this.testimonials,
    required this.ctaLabel,
    required this.category,
    required this.createdAt,
  });

  String get priceFormatted => '₹${price.toStringAsFixed(0)}';
  String? get discountedPriceFormatted =>
      discountedPrice != null ? '₹${discountedPrice!.toStringAsFixed(0)}' : null;
  int? get discountPercentage => discountedPrice != null
      ? (((price - discountedPrice!) / price) * 100).round()
      : null;

  Product copyWith({
    String? id, String? name, String? imageUrl, String? description,
    double? price, double? discountedPrice, String? offerBadge,
    List<String>? benefits, List<Testimonial>? testimonials,
    String? ctaLabel, String? category, DateTime? createdAt,
  }) => Product(
    id: id ?? this.id, name: name ?? this.name,
    imageUrl: imageUrl ?? this.imageUrl, description: description ?? this.description,
    price: price ?? this.price, discountedPrice: discountedPrice ?? this.discountedPrice,
    offerBadge: offerBadge ?? this.offerBadge, benefits: benefits ?? this.benefits,
    testimonials: testimonials ?? this.testimonials, ctaLabel: ctaLabel ?? this.ctaLabel,
    category: category ?? this.category, createdAt: createdAt ?? this.createdAt,
  );

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Product',
      imageUrl: json['imageUrl']?.toString() ?? 'https://picsum.photos/400/300',
      description: json['description']?.toString() ?? '',
      price: (json['price'] ?? 0).toDouble(),
      discountedPrice: json['discountedPrice'] != null ? (json['discountedPrice']).toDouble() : null,
      offerBadge: json['offerBadge']?.toString(),
      benefits: json['benefits'] != null ? List<String>.from(json['benefits']) : [],
      testimonials: (json['testimonials'] as List? ?? []).map((t) => Testimonial.fromJson(t)).toList(),
      ctaLabel: json['ctaLabel']?.toString() ?? 'Learn More',
      category: json['category']?.toString() ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }
}
