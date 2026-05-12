const mongoose = require('mongoose');

const marketingServiceSchema = new mongoose.Schema({
  title: {
    type: String,
    required: [true, 'Please add a service title'],
    trim: true,
  },
  description: {
    type: String,
    required: [true, 'Please add a description'],
  },
  category: {
    type: String,
    required: [true, 'Please specify category'],
    enum: ['SEO', 'Instagram Promotion', 'YouTube Promotion', 'Branding', 'Ad Campaigns', 'Other'],
  },
  price: {
    type: Number,
    required: [true, 'Please add a price'],
  },
  provider: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  rating: {
    type: Number,
    default: 0,
    min: 0,
    max: 5,
  },
  reviewsCount: {
    type: Number,
    default: 0,
  },
}, { timestamps: true });

module.exports = mongoose.model('MarketingService', marketingServiceSchema);
