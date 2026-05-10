const mongoose = require('mongoose');

const productSchema = new mongoose.Schema({
  name: { type: String, required: true },
  imageUrl: { type: String, required: true },
  description: { type: String, required: true },
  price: { type: Number, required: true },
  discountedPrice: { type: Number },
  offerBadge: { type: String },
  benefits: [{ type: String }],
  testimonials: [{
    name: String,
    review: String,
    rating: Number,
    avatarUrl: String
  }],
  ctaLabel: { type: String },
  category: { type: String, required: true },
  createdAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model('Product', productSchema);
