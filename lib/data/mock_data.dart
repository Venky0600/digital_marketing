import '../models/influencer_model.dart';
import '../models/campaign_model.dart';
import '../models/franchise_model.dart';
import '../models/product_model.dart';
import '../models/chat_message_model.dart';
import '../models/notification_model.dart';
import '../models/personal_brand_model.dart';

class MockData {
  // ── Influencers ────────────────────────────────────────────────────────────
  static final List<Influencer> influencers = [
    Influencer(id: 'i1', name: 'Priya Sharma', profileImageUrl: 'https://i.pravatar.cc/300?img=1', bio: 'Fashion & lifestyle content creator with a passion for sustainable brands.', niche: 'Fashion', location: 'Mumbai, India', platform: InfluencerPlatform.instagram, followers: 285000, engagementRate: 4.8, pricePerPromotion: 25000, rating: 4.9, previousWorks: ['Nykaa', 'Myntra', 'H&M'], isVerified: true, createdAt: DateTime(2024, 1, 10)),
    Influencer(id: 'i2', name: 'Rahul Verma', profileImageUrl: 'https://i.pravatar.cc/300?img=3', bio: 'Tech reviewer and gadget enthusiast. Helping people make smarter buying decisions.', niche: 'Technology', location: 'Bangalore, India', platform: InfluencerPlatform.youtube, followers: 540000, engagementRate: 6.2, pricePerPromotion: 45000, rating: 4.7, previousWorks: ['Samsung', 'OnePlus', 'boAt'], isVerified: true, createdAt: DateTime(2024, 2, 5)),
    Influencer(id: 'i3', name: 'Ananya Iyer', profileImageUrl: 'https://i.pravatar.cc/300?img=5', bio: 'Food blogger exploring the best of Indian street food and fine dining.', niche: 'Food', location: 'Delhi, India', platform: InfluencerPlatform.instagram, followers: 182000, engagementRate: 5.5, pricePerPromotion: 18000, rating: 4.8, previousWorks: ['Zomato', 'Swiggy', 'Maggi'], isVerified: false, createdAt: DateTime(2024, 3, 15)),
    Influencer(id: 'i4', name: 'Vikram Singh', profileImageUrl: 'https://i.pravatar.cc/300?img=7', bio: 'Fitness coach and wellness advocate sharing daily workouts and nutrition tips.', niche: 'Fitness', location: 'Pune, India', platform: InfluencerPlatform.youtube, followers: 312000, engagementRate: 7.1, pricePerPromotion: 32000, rating: 4.6, previousWorks: ['MuscleBlaze', 'Boldfit', 'Decathlon'], isVerified: true, createdAt: DateTime(2024, 4, 20)),
    Influencer(id: 'i5', name: 'Meera Nair', profileImageUrl: 'https://i.pravatar.cc/300?img=9', bio: 'Travel storyteller visiting hidden gems across India and Southeast Asia.', niche: 'Travel', location: 'Kerala, India', platform: InfluencerPlatform.instagram, followers: 95000, engagementRate: 8.3, pricePerPromotion: 12000, rating: 4.9, previousWorks: ['MakeMyTrip', 'OYO', 'Air India'], isVerified: false, createdAt: DateTime(2024, 5, 1)),
    Influencer(id: 'i6', name: 'Arjun Patel', profileImageUrl: 'https://i.pravatar.cc/300?img=11', bio: 'Business and entrepreneurship content creator helping startups grow.', niche: 'Business', location: 'Ahmedabad, India', platform: InfluencerPlatform.linkedin, followers: 78000, engagementRate: 9.1, pricePerPromotion: 20000, rating: 4.5, previousWorks: ['Razorpay', 'Zoho', 'Freshworks'], isVerified: true, createdAt: DateTime(2024, 6, 12)),
    Influencer(id: 'i7', name: 'Sneha Kapoor', profileImageUrl: 'https://i.pravatar.cc/300?img=13', bio: 'Beauty and skincare expert helping women discover their best skin.', niche: 'Beauty', location: 'Hyderabad, India', platform: InfluencerPlatform.instagram, followers: 420000, engagementRate: 5.9, pricePerPromotion: 38000, rating: 4.8, previousWorks: ['Lakme', 'Mamaearth', 'Plum'], isVerified: true, createdAt: DateTime(2024, 7, 8)),
    Influencer(id: 'i8', name: 'Dev Malhotra', profileImageUrl: 'https://i.pravatar.cc/300?img=15', bio: 'Comedy creator making relatable content for Gen Z audiences.', niche: 'Entertainment', location: 'Chandigarh, India', platform: InfluencerPlatform.tiktok, followers: 1200000, engagementRate: 11.2, pricePerPromotion: 80000, rating: 4.4, previousWorks: ['Pepsi', 'Lays', 'Dream11'], isVerified: true, createdAt: DateTime(2024, 8, 20)),
  ];

  // ── Campaigns ──────────────────────────────────────────────────────────────
  static final List<Campaign> campaigns = [
    Campaign(id: 'c1', businessName: 'Zomato', logoUrl: 'https://picsum.photos/seed/zomato/200', category: 'Food Tech', title: 'Zomato Gold Launch Campaign', description: 'Looking for food influencers to promote our new Gold membership program with exclusive restaurant deals.', location: 'Pan India', budget: 500000, targetAudience: 'Adults 22-45', campaignType: CampaignType.productPromotion, requiredNiche: 'Food', status: CampaignStatus.open, createdAt: DateTime(2024, 8, 1), applicants: 23),
    Campaign(id: 'c2', businessName: 'boAt Lifestyle', logoUrl: 'https://picsum.photos/seed/boat/200', category: 'Electronics', title: 'boAt Wave Series Unboxing', description: 'Seeking tech and lifestyle influencers to create unboxing and review content for our new smartwatch series.', location: 'Mumbai, Delhi, Bangalore', budget: 350000, targetAudience: 'Youth 18-30', campaignType: CampaignType.brandAwareness, requiredNiche: 'Technology', status: CampaignStatus.open, createdAt: DateTime(2024, 8, 5), applicants: 41),
    Campaign(id: 'c3', businessName: 'Nykaa', logoUrl: 'https://picsum.photos/seed/nykaa/200', category: 'Beauty', title: 'Nykaa Festive Glow Collection', description: 'Collaborate with beauty influencers for our festive makeup collection launch across digital platforms.', location: 'Pan India', budget: 750000, targetAudience: 'Women 18-40', campaignType: CampaignType.influencerCollaboration, requiredNiche: 'Beauty', status: CampaignStatus.inProgress, createdAt: DateTime(2024, 7, 20), applicants: 67),
    Campaign(id: 'c4', businessName: 'MakeMyTrip', logoUrl: 'https://picsum.photos/seed/mmt/200', category: 'Travel', title: 'Kerala Backwaters Experience', description: 'Travel content creators needed for an immersive 5-day Kerala backwaters trip content series.', location: 'Kerala, India', budget: 420000, targetAudience: 'Travel enthusiasts 25-50', campaignType: CampaignType.contentCreation, requiredNiche: 'Travel', status: CampaignStatus.open, createdAt: DateTime(2024, 8, 10), applicants: 18),
    Campaign(id: 'c5', businessName: 'Decathlon India', logoUrl: 'https://picsum.photos/seed/decathlon/200', category: 'Sports', title: 'Marathon Season Kick-off', description: 'Fitness and sports influencers needed to promote our running gear for the upcoming marathon season.', location: 'Delhi, Mumbai, Bangalore', budget: 280000, targetAudience: 'Fitness enthusiasts 20-45', campaignType: CampaignType.eventMarketing, requiredNiche: 'Fitness', status: CampaignStatus.completed, createdAt: DateTime(2024, 6, 15), applicants: 55),
    Campaign(id: 'c6', businessName: 'Mamaearth', logoUrl: 'https://picsum.photos/seed/mamaearth/200', category: 'Skincare', title: 'Natural Skincare Awareness', description: 'Seeking authentic skincare influencers to promote our toxin-free product range with real skin transformation stories.', location: 'Pan India', budget: 600000, targetAudience: 'Health-conscious women 22-40', campaignType: CampaignType.brandAwareness, requiredNiche: 'Beauty', status: CampaignStatus.open, createdAt: DateTime(2024, 8, 12), applicants: 29),
  ];

  // ── Franchises ─────────────────────────────────────────────────────────────
  static final List<Franchise> franchises = [
    Franchise(id: 'f1', brandName: 'Chai Point', imageUrl: 'https://picsum.photos/seed/chai/400/250', investmentRequired: 1500000, expectedProfit: 120000, locationAvailability: 'Mumbai, Pune, Bangalore, Delhi', category: 'Beverages', supportProvided: ['Training', 'Supply Chain', 'Marketing'], contactEmail: 'franchise@chaipoint.com', description: 'India\'s largest organised tea retail chain with 200+ outlets. Low investment, high ROI model.', established: 2010, totalOutlets: 215, createdAt: DateTime(2024, 1, 1)),
    Franchise(id: 'f2', brandName: 'FreshMenu Kitchen', imageUrl: 'https://picsum.photos/seed/freshmenu/400/250', investmentRequired: 2500000, expectedProfit: 220000, locationAvailability: 'Bangalore, Mumbai, Hyderabad', category: 'Cloud Kitchen', supportProvided: ['Technology', 'Menu R&D', 'Delivery Partners', 'Branding'], contactEmail: 'franchise@freshmenu.com', description: 'Tech-enabled cloud kitchen franchise with 15+ cuisine options and guaranteed delivery partnership.', established: 2014, totalOutlets: 87, createdAt: DateTime(2024, 2, 15)),
    Franchise(id: 'f3', brandName: 'Jockey Exclusive Store', imageUrl: 'https://picsum.photos/seed/jockey/400/250', investmentRequired: 3000000, expectedProfit: 180000, locationAvailability: 'Tier 1 & Tier 2 Cities', category: 'Apparel', supportProvided: ['Visual Merchandising', 'CRM', 'Supply Chain', 'Marketing Fund'], contactEmail: 'retail@jockey.in', description: 'Premium innerwear & activewear franchise with strong brand equity and consistent consumer demand.', established: 1994, totalOutlets: 1200, createdAt: DateTime(2024, 3, 10)),
    Franchise(id: 'f4', brandName: 'Dr. Batra\'s Clinic', imageUrl: 'https://picsum.photos/seed/drbatras/400/250', investmentRequired: 5000000, expectedProfit: 350000, locationAvailability: 'Pan India', category: 'Healthcare', supportProvided: ['Medical Training', 'IT System', 'Branding', 'Patient CRM'], contactEmail: 'franchise@drbatras.com', description: 'India\'s leading chain of homeopathy clinics with 300+ clinics. Proven model with medical backend support.', established: 1982, totalOutlets: 320, createdAt: DateTime(2024, 4, 5)),
  ];

  // ── Products ───────────────────────────────────────────────────────────────
  static final List<Product> products = [
    Product(id: 'p1', name: 'GlowBoost Vitamin C Serum', imageUrl: 'https://picsum.photos/seed/serum/600/400', description: 'Advanced brightening serum with 20% Vitamin C, Niacinamide and Hyaluronic Acid. Dermatologist tested.', price: 1499, discountedPrice: 999, offerBadge: '🔥 33% OFF', benefits: ['Brightens skin tone', 'Reduces dark spots', 'Deep hydration', 'Boosts collagen'], testimonials: [Testimonial(name: 'Kavya R.', review: 'My skin looks 10x better in just 2 weeks!', rating: 5, avatarUrl: 'https://i.pravatar.cc/100?img=20')], ctaLabel: 'Buy Now', category: 'Skincare', createdAt: DateTime(2024, 5, 1)),
    Product(id: 'p2', name: 'PowerPro Whey Protein', imageUrl: 'https://picsum.photos/seed/protein/600/400', description: 'Premium whey protein isolate with 26g protein per serving. Available in 5 delicious flavours.', price: 3499, discountedPrice: 2799, offerBadge: '⚡ Flash Sale', benefits: ['26g protein/serving', 'Zero added sugar', 'Fast absorption', 'FSSAI certified'], testimonials: [Testimonial(name: 'Rohit M.', review: 'Best tasting protein powder I\'ve had!', rating: 5, avatarUrl: 'https://i.pravatar.cc/100?img=22')], ctaLabel: 'Add to Cart', category: 'Fitness', createdAt: DateTime(2024, 6, 10)),
    Product(id: 'p3', name: 'BrandBridge Marketing Course', imageUrl: 'https://picsum.photos/seed/course/600/400', description: 'Complete digital marketing masterclass covering SEO, influencer marketing, paid ads and personal branding.', price: 9999, discountedPrice: 4999, offerBadge: '🎓 50% OFF', benefits: ['12 modules', 'Certificate', 'Lifetime access', '1-on-1 mentorship'], testimonials: [Testimonial(name: 'Sanjana P.', review: 'Landed my first brand deal after this course!', rating: 5, avatarUrl: 'https://i.pravatar.cc/100?img=25')], ctaLabel: 'Enroll Now', category: 'Education', createdAt: DateTime(2024, 7, 15)),
  ];

  // ── Chat Messages ──────────────────────────────────────────────────────────
  static final List<ChatMessage> mockChatMessages = [
    ChatMessage(id: 'cm1', senderId: 'user2', senderName: 'Priya Sharma', senderAvatar: 'https://i.pravatar.cc/100?img=1', message: 'Hi! I saw your campaign for the food brand. I\'d love to collaborate! 🍽️', timestamp: DateTime.now().subtract(const Duration(hours: 2)), isMe: false),
    ChatMessage(id: 'cm2', senderId: 'me', senderName: 'You', senderAvatar: 'https://i.pravatar.cc/100?img=33', message: 'Hey Priya! Your food content looks amazing. Let me send you the brief.', timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 55)), isMe: true),
    ChatMessage(id: 'cm3', senderId: 'user2', senderName: 'Priya Sharma', senderAvatar: 'https://i.pravatar.cc/100?img=1', message: 'Perfect! Looking forward to it. What\'s the timeline?', timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)), isMe: false),
  ];

  // ── Notifications ──────────────────────────────────────────────────────────
  static final List<AppNotification> notifications = [
    AppNotification(id: 'n1', title: 'New Campaign Match!', body: 'Zomato\'s food campaign matches your profile with 94% compatibility.', type: NotificationType.match, timestamp: DateTime.now().subtract(const Duration(minutes: 30))),
    AppNotification(id: 'n2', title: 'Campaign Posted', body: 'boAt Lifestyle posted a new tech influencer campaign worth ₹3.5L.', type: NotificationType.newCampaign, timestamp: DateTime.now().subtract(const Duration(hours: 2))),
    AppNotification(id: 'n3', title: 'New Message', body: 'Priya Sharma sent you a message about the food campaign.', type: NotificationType.message, timestamp: DateTime.now().subtract(const Duration(hours: 5)), isRead: true),
    AppNotification(id: 'n4', title: 'Welcome to BrandBridge!', body: 'Start by exploring influencers or posting your first campaign.', type: NotificationType.general, timestamp: DateTime.now().subtract(const Duration(days: 1)), isRead: true),
  ];

  // ── Personal Brand ─────────────────────────────────────────────────────────
  static final PersonalBrand defaultPersonalBrand = PersonalBrand(
    displayName: 'Alex Sharma',
    avatarUrl: 'https://i.pravatar.cc/300?img=33',
    tagline: 'Digital Marketing Strategist & Growth Hacker',
    bio: 'I help brands and influencers bridge the gap with data-driven marketing strategies. 5+ years of experience in influencer marketing, brand building, and growth hacking.',
    contactEmail: 'alex@brandbridge.in',
    socialLinks: [
      const SocialLink(platform: 'Instagram', url: 'https://instagram.com'),
      const SocialLink(platform: 'LinkedIn', url: 'https://linkedin.com'),
      const SocialLink(platform: 'YouTube', url: 'https://youtube.com'),
    ],
    portfolioItems: [
      const PortfolioItem(id: 'pi1', title: 'Nykaa Campaign', description: '3M reach, 8% engagement', imageUrl: 'https://picsum.photos/seed/port1/400/300'),
      const PortfolioItem(id: 'pi2', title: 'Zomato Gold Launch', description: '5M impressions, 120K clicks', imageUrl: 'https://picsum.photos/seed/port2/400/300'),
      const PortfolioItem(id: 'pi3', title: 'boAt Unboxing Series', description: '2.5M views on YouTube', imageUrl: 'https://picsum.photos/seed/port3/400/300'),
    ],
    services: [
      const BrandService(id: 's1', title: 'Influencer Campaign Strategy', description: 'End-to-end campaign planning & execution', price: 50000),
      const BrandService(id: 's2', title: 'Brand Audit & Positioning', description: 'Complete brand identity review and strategy', price: 25000),
      const BrandService(id: 's3', title: 'Content Calendar Management', description: 'Monthly content planning for social media', price: 15000),
    ],
  );

  // ── AI Mock Replies ────────────────────────────────────────────────────────
  static String getAiReply(String query) {
    final q = query.toLowerCase();
    if (q.contains('caption') && q.contains('restaurant')) {
      return '🍽️ Here are 3 captions for your restaurant promotion:\n\n1. "Every bite tells a story. Come write yours with us. 🍜 Reserve your table today!"\n\n2. "Good food, great vibes, unforgettable moments. Your favourite table is waiting. 🥂"\n\n3. "Life\'s too short for bad food. Discover flavours that make every moment special. ✨ #FoodLovers"';
    }
    if (q.contains('hashtag') && (q.contains('fashion') || q.contains('clothing'))) {
      return '👗 Top trending hashtags for fashion:\n\n#FashionInfluencer #OOTD #StyleInspo #FashionBlogger #WhatIWore #FashionForward #IndianFashion #StyleOfTheDay #FashionContent #TrendAlert\n\n💡 Pro tip: Use 5-10 niche hashtags + 3-5 broad ones for maximum reach!';
    }
    if (q.contains('influencer') && (q.contains('food') || q.contains('restaurant'))) {
      return '🤖 Best influencer types for food businesses:\n\n1. **Micro-influencers (10K-100K)** — Higher engagement, authentic audience, cost-effective\n2. **Food bloggers** — Deep niche audience, high purchase intent\n3. **Lifestyle creators** — Broader reach, good for brand awareness\n\n📊 Recommended budget: ₹15,000-50,000 per post for micro-influencers.';
    }
    if (q.contains('marketing') && (q.contains('idea') || q.contains('tip'))) {
      return '💡 Top 5 digital marketing ideas for your brand:\n\n1. 📱 Run an Instagram Reel challenge with a branded hashtag\n2. 🤝 Partner with 3-5 micro-influencers in your niche\n3. 📧 Build an email list with a free lead magnet\n4. 🎥 Create behind-the-scenes YouTube content\n5. 💬 Start a WhatsApp community for loyal customers\n\nWant me to expand on any of these?';
    }
    if (q.contains('ad copy') || q.contains('advertisement')) {
      return '📣 Here\'s a high-converting ad copy framework:\n\n**Hook:** [Problem your customer has]\n**Agitate:** [Make the problem feel urgent]\n**Solution:** [Your product/service]\n**CTA:** [Clear action to take]\n\n📝 Example:\n"Struggling to grow your brand online? 😤 Most businesses waste ₹50K+ on ads that don\'t convert. BrandBridge connects you with the RIGHT influencers for 3x better ROI. Start your campaign today →"';
    }
    if (q.contains('franchise')) {
      return '🏢 Key tips for franchise promotion:\n\n1. **Local SEO** — Optimise Google My Business for each location\n2. **Influencer tie-ups** — Local micro-influencers drive foot traffic\n3. **UGC campaigns** — Encourage customers to share experiences\n4. **WhatsApp marketing** — Build a loyal local customer base\n5. **Festive campaigns** — Offer special franchise launch deals\n\n📈 Average franchise digital marketing budget: ₹20,000-80,000/month';
    }
    return '🤖 Great question! Here are some key marketing insights:\n\n✅ Consistent content beats viral content long-term\n✅ Micro-influencers often outperform mega-influencers in ROI\n✅ Video content gets 3x more engagement than static posts\n✅ The best time to post on Instagram is 9am-11am and 7pm-9pm IST\n\nWould you like specific advice for your brand or campaign? Just ask! 😊';
  }
}
