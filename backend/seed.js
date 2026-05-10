require('dotenv').config();
const mongoose = require('mongoose');

const Influencer = require('./models/Influencer');
const Campaign = require('./models/Campaign');
const Franchise = require('./models/Franchise');
const Product = require('./models/Product');
const ChatMessage = require('./models/ChatMessage');
const Notification = require('./models/Notification');
const PersonalBrand = require('./models/PersonalBrand');

const MONGO_URI = process.env.MONGO_URI || 'mongodb://127.0.0.1:27017/betterdigital';

const influencers = [
  { name: 'Priya Sharma', profileImageUrl: 'https://i.pravatar.cc/300?img=1', bio: 'Fashion & lifestyle content creator with a passion for sustainable brands.', niche: 'Fashion', location: 'Mumbai, India', platform: 'instagram', followers: 285000, engagementRate: 4.8, pricePerPromotion: 25000, rating: 4.9, previousWorks: ['Nykaa', 'Myntra', 'H&M'], isVerified: true, createdAt: new Date(2024, 0, 10) },
  { name: 'Rahul Verma', profileImageUrl: 'https://i.pravatar.cc/300?img=3', bio: 'Tech reviewer and gadget enthusiast. Helping people make smarter buying decisions.', niche: 'Technology', location: 'Bangalore, India', platform: 'youtube', followers: 540000, engagementRate: 6.2, pricePerPromotion: 45000, rating: 4.7, previousWorks: ['Samsung', 'OnePlus', 'boAt'], isVerified: true, createdAt: new Date(2024, 1, 5) },
  { name: 'Ananya Iyer', profileImageUrl: 'https://i.pravatar.cc/300?img=5', bio: 'Food blogger exploring the best of Indian street food and fine dining.', niche: 'Food', location: 'Delhi, India', platform: 'instagram', followers: 182000, engagementRate: 5.5, pricePerPromotion: 18000, rating: 4.8, previousWorks: ['Zomato', 'Swiggy', 'Maggi'], isVerified: false, createdAt: new Date(2024, 2, 15) },
  { name: 'Vikram Singh', profileImageUrl: 'https://i.pravatar.cc/300?img=7', bio: 'Fitness coach and wellness advocate sharing daily workouts and nutrition tips.', niche: 'Fitness', location: 'Pune, India', platform: 'youtube', followers: 312000, engagementRate: 7.1, pricePerPromotion: 32000, rating: 4.6, previousWorks: ['MuscleBlaze', 'Boldfit', 'Decathlon'], isVerified: true, createdAt: new Date(2024, 3, 20) },
  { name: 'Meera Nair', profileImageUrl: 'https://i.pravatar.cc/300?img=9', bio: 'Travel storyteller visiting hidden gems across India and Southeast Asia.', niche: 'Travel', location: 'Kerala, India', platform: 'instagram', followers: 95000, engagementRate: 8.3, pricePerPromotion: 12000, rating: 4.9, previousWorks: ['MakeMyTrip', 'OYO', 'Air India'], isVerified: false, createdAt: new Date(2024, 4, 1) },
  { name: 'Arjun Patel', profileImageUrl: 'https://i.pravatar.cc/300?img=11', bio: 'Business and entrepreneurship content creator helping startups grow.', niche: 'Business', location: 'Ahmedabad, India', platform: 'linkedin', followers: 78000, engagementRate: 9.1, pricePerPromotion: 20000, rating: 4.5, previousWorks: ['Razorpay', 'Zoho', 'Freshworks'], isVerified: true, createdAt: new Date(2024, 5, 12) },
  { name: 'Sneha Kapoor', profileImageUrl: 'https://i.pravatar.cc/300?img=13', bio: 'Beauty and skincare expert helping women discover their best skin.', niche: 'Beauty', location: 'Hyderabad, India', platform: 'instagram', followers: 420000, engagementRate: 5.9, pricePerPromotion: 38000, rating: 4.8, previousWorks: ['Lakme', 'Mamaearth', 'Plum'], isVerified: true, createdAt: new Date(2024, 6, 8) },
  { name: 'Dev Malhotra', profileImageUrl: 'https://i.pravatar.cc/300?img=15', bio: 'Comedy creator making relatable content for Gen Z audiences.', niche: 'Entertainment', location: 'Chandigarh, India', platform: 'tiktok', followers: 1200000, engagementRate: 11.2, pricePerPromotion: 80000, rating: 4.4, previousWorks: ['Pepsi', 'Lays', 'Dream11'], isVerified: true, createdAt: new Date(2024, 7, 20) }
];

const campaigns = [
  { businessName: 'Zomato', logoUrl: 'https://picsum.photos/seed/zomato/200', category: 'Food Tech', title: 'Zomato Gold Launch Campaign', description: 'Looking for food influencers to promote our new Gold membership program with exclusive restaurant deals.', location: 'Pan India', budget: 500000, targetAudience: 'Adults 22-45', campaignType: 'productPromotion', requiredNiche: 'Food', status: 'open', applicants: 23, createdAt: new Date(2024, 7, 1) },
  { businessName: 'boAt Lifestyle', logoUrl: 'https://picsum.photos/seed/boat/200', category: 'Electronics', title: 'boAt Wave Series Unboxing', description: 'Seeking tech and lifestyle influencers to create unboxing and review content for our new smartwatch series.', location: 'Mumbai, Delhi, Bangalore', budget: 350000, targetAudience: 'Youth 18-30', campaignType: 'brandAwareness', requiredNiche: 'Technology', status: 'open', applicants: 41, createdAt: new Date(2024, 7, 5) },
  { businessName: 'Nykaa', logoUrl: 'https://picsum.photos/seed/nykaa/200', category: 'Beauty', title: 'Nykaa Festive Glow Collection', description: 'Collaborate with beauty influencers for our festive makeup collection launch across digital platforms.', location: 'Pan India', budget: 750000, targetAudience: 'Women 18-40', campaignType: 'influencerCollaboration', requiredNiche: 'Beauty', status: 'inProgress', applicants: 67, createdAt: new Date(2024, 6, 20) },
  { businessName: 'MakeMyTrip', logoUrl: 'https://picsum.photos/seed/mmt/200', category: 'Travel', title: 'Kerala Backwaters Experience', description: 'Travel content creators needed for an immersive 5-day Kerala backwaters trip content series.', location: 'Kerala, India', budget: 420000, targetAudience: 'Travel enthusiasts 25-50', campaignType: 'contentCreation', requiredNiche: 'Travel', status: 'open', applicants: 18, createdAt: new Date(2024, 7, 10) },
  { businessName: 'Decathlon India', logoUrl: 'https://picsum.photos/seed/decathlon/200', category: 'Sports', title: 'Marathon Season Kick-off', description: 'Fitness and sports influencers needed to promote our running gear for the upcoming marathon season.', location: 'Delhi, Mumbai, Bangalore', budget: 280000, targetAudience: 'Fitness enthusiasts 20-45', campaignType: 'eventMarketing', requiredNiche: 'Fitness', status: 'completed', applicants: 55, createdAt: new Date(2024, 5, 15) },
  { businessName: 'Mamaearth', logoUrl: 'https://picsum.photos/seed/mamaearth/200', category: 'Skincare', title: 'Natural Skincare Awareness', description: 'Seeking authentic skincare influencers to promote our toxin-free product range with real skin transformation stories.', location: 'Pan India', budget: 600000, targetAudience: 'Health-conscious women 22-40', campaignType: 'brandAwareness', requiredNiche: 'Beauty', status: 'open', applicants: 29, createdAt: new Date(2024, 7, 12) }
];

const franchises = [
  { brandName: 'Chai Point', imageUrl: 'https://picsum.photos/seed/chai/400/250', investmentRequired: 1500000, expectedProfit: 120000, locationAvailability: 'Mumbai, Pune, Bangalore, Delhi', category: 'Beverages', supportProvided: ['Training', 'Supply Chain', 'Marketing'], contactEmail: 'franchise@chaipoint.com', description: 'India\'s largest organised tea retail chain with 200+ outlets. Low investment, high ROI model.', established: 2010, totalOutlets: 215, createdAt: new Date(2024, 0, 1) },
  { brandName: 'FreshMenu Kitchen', imageUrl: 'https://picsum.photos/seed/freshmenu/400/250', investmentRequired: 2500000, expectedProfit: 220000, locationAvailability: 'Bangalore, Mumbai, Hyderabad', category: 'Cloud Kitchen', supportProvided: ['Technology', 'Menu R&D', 'Delivery Partners', 'Branding'], contactEmail: 'franchise@freshmenu.com', description: 'Tech-enabled cloud kitchen franchise with 15+ cuisine options and guaranteed delivery partnership.', established: 2014, totalOutlets: 87, createdAt: new Date(2024, 1, 15) },
  { brandName: 'Jockey Exclusive Store', imageUrl: 'https://picsum.photos/seed/jockey/400/250', investmentRequired: 3000000, expectedProfit: 180000, locationAvailability: 'Tier 1 & Tier 2 Cities', category: 'Apparel', supportProvided: ['Visual Merchandising', 'CRM', 'Supply Chain', 'Marketing Fund'], contactEmail: 'retail@jockey.in', description: 'Premium innerwear & activewear franchise with strong brand equity and consistent consumer demand.', established: 1994, totalOutlets: 1200, createdAt: new Date(2024, 2, 10) },
  { brandName: 'Dr. Batra\'s Clinic', imageUrl: 'https://picsum.photos/seed/drbatras/400/250', investmentRequired: 5000000, expectedProfit: 350000, locationAvailability: 'Pan India', category: 'Healthcare', supportProvided: ['Medical Training', 'IT System', 'Branding', 'Patient CRM'], contactEmail: 'franchise@drbatras.com', description: 'India\'s leading chain of homeopathy clinics with 300+ clinics. Proven model with medical backend support.', established: 1982, totalOutlets: 320, createdAt: new Date(2024, 3, 5) }
];

const products = [
  { name: 'GlowBoost Vitamin C Serum', imageUrl: 'https://picsum.photos/seed/serum/600/400', description: 'Advanced brightening serum with 20% Vitamin C, Niacinamide and Hyaluronic Acid. Dermatologist tested.', price: 1499, discountedPrice: 999, offerBadge: '🔥 33% OFF', benefits: ['Brightens skin tone', 'Reduces dark spots', 'Deep hydration', 'Boosts collagen'], testimonials: [{name: 'Kavya R.', review: 'My skin looks 10x better in just 2 weeks!', rating: 5, avatarUrl: 'https://i.pravatar.cc/100?img=20'}], ctaLabel: 'Buy Now', category: 'Skincare', createdAt: new Date(2024, 4, 1) },
  { name: 'PowerPro Whey Protein', imageUrl: 'https://picsum.photos/seed/protein/600/400', description: 'Premium whey protein isolate with 26g protein per serving. Available in 5 delicious flavours.', price: 3499, discountedPrice: 2799, offerBadge: '⚡ Flash Sale', benefits: ['26g protein/serving', 'Zero added sugar', 'Fast absorption', 'FSSAI certified'], testimonials: [{name: 'Rohit M.', review: 'Best tasting protein powder I\'ve had!', rating: 5, avatarUrl: 'https://i.pravatar.cc/100?img=22'}], ctaLabel: 'Add to Cart', category: 'Fitness', createdAt: new Date(2024, 5, 10) },
  { name: 'BrandBridge Marketing Course', imageUrl: 'https://picsum.photos/seed/course/600/400', description: 'Complete digital marketing masterclass covering SEO, influencer marketing, paid ads and personal branding.', price: 9999, discountedPrice: 4999, offerBadge: '🎓 50% OFF', benefits: ['12 modules', 'Certificate', 'Lifetime access', '1-on-1 mentorship'], testimonials: [{name: 'Sanjana P.', review: 'Landed my first brand deal after this course!', rating: 5, avatarUrl: 'https://i.pravatar.cc/100?img=25'}], ctaLabel: 'Enroll Now', category: 'Education', createdAt: new Date(2024, 6, 15) }
];

const chatMessages = [
  { senderId: 'user2', senderName: 'Priya Sharma', senderAvatar: 'https://i.pravatar.cc/100?img=1', message: 'Hi! I saw your campaign for the food brand. I\'d love to collaborate! 🍽️', timestamp: new Date(Date.now() - 2 * 3600000), isMe: false },
  { senderId: 'me', senderName: 'You', senderAvatar: 'https://i.pravatar.cc/100?img=33', message: 'Hey Priya! Your food content looks amazing. Let me send you the brief.', timestamp: new Date(Date.now() - 1.9 * 3600000), isMe: true },
  { senderId: 'user2', senderName: 'Priya Sharma', senderAvatar: 'https://i.pravatar.cc/100?img=1', message: 'Perfect! Looking forward to it. What\'s the timeline?', timestamp: new Date(Date.now() - 1.5 * 3600000), isMe: false }
];

const notifications = [
  { title: 'New Campaign Match!', body: 'Zomato\'s food campaign matches your profile with 94% compatibility.', type: 'match', timestamp: new Date(Date.now() - 1800000), isRead: false },
  { title: 'Campaign Posted', body: 'boAt Lifestyle posted a new tech influencer campaign worth ₹3.5L.', type: 'newCampaign', timestamp: new Date(Date.now() - 7200000), isRead: false },
  { title: 'New Message', body: 'Priya Sharma sent you a message about the food campaign.', type: 'message', timestamp: new Date(Date.now() - 18000000), isRead: true },
  { title: 'Welcome to BrandBridge!', body: 'Start by exploring influencers or posting your first campaign.', type: 'general', timestamp: new Date(Date.now() - 86400000), isRead: true }
];

const personalBrand = {
  displayName: 'Alex Sharma',
  avatarUrl: 'https://i.pravatar.cc/300?img=33',
  tagline: 'Digital Marketing Strategist & Growth Hacker',
  bio: 'I help brands and influencers bridge the gap with data-driven marketing strategies. 5+ years of experience in influencer marketing, brand building, and growth hacking.',
  contactEmail: 'alex@brandbridge.in',
  socialLinks: [
    { platform: 'Instagram', url: 'https://instagram.com' },
    { platform: 'LinkedIn', url: 'https://linkedin.com' },
    { platform: 'YouTube', url: 'https://youtube.com' }
  ],
  portfolioItems: [
    { title: 'Nykaa Campaign', description: '3M reach, 8% engagement', imageUrl: 'https://picsum.photos/seed/port1/400/300' },
    { title: 'Zomato Gold Launch', description: '5M impressions, 120K clicks', imageUrl: 'https://picsum.photos/seed/port2/400/300' },
    { title: 'boAt Unboxing Series', description: '2.5M views on YouTube', imageUrl: 'https://picsum.photos/seed/port3/400/300' }
  ],
  services: [
    { title: 'Influencer Campaign Strategy', description: 'End-to-end campaign planning & execution', price: 50000 },
    { title: 'Brand Audit & Positioning', description: 'Complete brand identity review and strategy', price: 25000 },
    { title: 'Content Calendar Management', description: 'Monthly content planning for social media', price: 15000 }
  ]
};

async function seedDB() {
  try {
    await mongoose.connect(MONGO_URI);
    console.log('MongoDB connected for seeding.');

    // Clear existing data
    await Influencer.deleteMany();
    await Campaign.deleteMany();
    await Franchise.deleteMany();
    await Product.deleteMany();
    await ChatMessage.deleteMany();
    await Notification.deleteMany();
    await PersonalBrand.deleteMany();

    console.log('Cleared existing data.');

    // Insert mock data
    await Influencer.insertMany(influencers);
    await Campaign.insertMany(campaigns);
    await Franchise.insertMany(franchises);
    await Product.insertMany(products);
    await ChatMessage.insertMany(chatMessages);
    await Notification.insertMany(notifications);
    
    const pb = new PersonalBrand(personalBrand);
    await pb.save();

    console.log('Mock data seeded successfully!');
    process.exit(0);
  } catch (err) {
    console.error('Error seeding data:', err);
    process.exit(1);
  }
}

seedDB();
