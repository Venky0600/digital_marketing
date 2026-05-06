class Franchise {
  final String id;
  final String brandName;
  final String imageUrl;
  final double investmentRequired;
  final double expectedProfit;
  final String locationAvailability;
  final String category;
  final List<String> supportProvided;
  final String contactEmail;
  final String description;
  final int established;
  final int totalOutlets;
  final DateTime createdAt;

  const Franchise({
    required this.id,
    required this.brandName,
    required this.imageUrl,
    required this.investmentRequired,
    required this.expectedProfit,
    required this.locationAvailability,
    required this.category,
    required this.supportProvided,
    required this.contactEmail,
    required this.description,
    required this.established,
    required this.totalOutlets,
    required this.createdAt,
  });

  String get investmentFormatted {
    if (investmentRequired >= 100000) return '₹${(investmentRequired / 100000).toStringAsFixed(1)}L';
    if (investmentRequired >= 1000) return '₹${(investmentRequired / 1000).toStringAsFixed(0)}K';
    return '₹${investmentRequired.toStringAsFixed(0)}';
  }

  String get profitFormatted {
    if (expectedProfit >= 100000) return '₹${(expectedProfit / 100000).toStringAsFixed(1)}L/mo';
    if (expectedProfit >= 1000) return '₹${(expectedProfit / 1000).toStringAsFixed(0)}K/mo';
    return '₹${expectedProfit.toStringAsFixed(0)}/mo';
  }

  Franchise copyWith({
    String? id, String? brandName, String? imageUrl, double? investmentRequired,
    double? expectedProfit, String? locationAvailability, String? category,
    List<String>? supportProvided, String? contactEmail, String? description,
    int? established, int? totalOutlets, DateTime? createdAt,
  }) => Franchise(
    id: id ?? this.id, brandName: brandName ?? this.brandName,
    imageUrl: imageUrl ?? this.imageUrl,
    investmentRequired: investmentRequired ?? this.investmentRequired,
    expectedProfit: expectedProfit ?? this.expectedProfit,
    locationAvailability: locationAvailability ?? this.locationAvailability,
    category: category ?? this.category,
    supportProvided: supportProvided ?? this.supportProvided,
    contactEmail: contactEmail ?? this.contactEmail,
    description: description ?? this.description,
    established: established ?? this.established,
    totalOutlets: totalOutlets ?? this.totalOutlets,
    createdAt: createdAt ?? this.createdAt,
  );
}
