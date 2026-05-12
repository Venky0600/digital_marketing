const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  fullName: { type: String, required: true, trim: true },
  email:    { type: String, required: true, unique: true, lowercase: true, trim: true },
  password: { type: String, required: true },
  role: {
    type: String,
    enum: ['businessOwner', 'influencer', 'franchiseSeeker', 'admin'],
    required: true
  },
  company:   { type: String },  // For business owners
  niche:     { type: String },  // For influencers
  avatarUrl: { type: String },
  fcmToken:  { type: String },
  isBlocked: { type: Boolean, default: false },
}, { timestamps: true });

// Indexes for fast queries (email index is implicit from unique:true)
userSchema.index({ role: 1 });

module.exports = mongoose.model('User', userSchema);

