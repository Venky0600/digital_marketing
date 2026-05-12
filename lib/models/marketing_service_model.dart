class MarketingService {
  final String id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double rating;
  final String? providerName;
  final DateTime createdAt;

  MarketingService({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.rating,
    this.providerName,
    required this.createdAt,
  });

  factory MarketingService.fromJson(Map<String, dynamic> json) {
    String? pName;
    if (json['provider'] is Map<String, dynamic>) {
      pName = json['provider']['fullName'];
    }
    return MarketingService(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? 'Other',
      price: (json['price'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      providerName: pName,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }
}
