const mongoose = require('mongoose');

const personalBrandSchema = new mongoose.Schema({
  displayName: { type: String, required: true },
  avatarUrl: { type: String, required: true },
  tagline: { type: String, required: true },
  bio: { type: String, required: true },
  contactEmail: { type: String, required: true },
  socialLinks: [{
    platform: String,
    url: String
  }],
  portfolioItems: [{
    title: String,
    description: String,
    imageUrl: String
  }],
  services: [{
    title: String,
    description: String,
    price: Number
  }],
  createdAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model('PersonalBrand', personalBrandSchema);
