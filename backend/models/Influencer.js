const mongoose = require('mongoose');

const influencerSchema = new mongoose.Schema({
  name: { type: String, required: true },
  profileImageUrl: { type: String, required: true },
  bio: { type: String, required: true },
  niche: { type: String, required: true },
  location: { type: String, required: true },
  platform: { type: String, required: true },
  followers: { type: Number, required: true },
  engagementRate: { type: Number, required: true },
  pricePerPromotion: { type: Number, required: true },
  rating: { type: Number, required: true },
  previousWorks: [{ type: String }],
  isVerified: { type: Boolean, default: false },
  location_coords: {
    type: { type: String, enum: ['Point'], default: 'Point' },
    coordinates: { type: [Number], default: [0, 0] }
  },
  createdAt: { type: Date, default: Date.now },
});

influencerSchema.index({ location_coords: '2dsphere' });

module.exports = mongoose.model('Influencer', influencerSchema);
