const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  fullName: {
    type: String,
    required: true
  },
  email: {
    type: String,
    required: true,
    unique: true
  },
  password: {
    type: String,
    required: true
  },
  role: {
    type: String,
    enum: ['businessOwner', 'influencer'],
    required: true
  },
  company: {
    type: String // Required for business owners, handled in logic
  },
  niche: {
    type: String // Required for influencers, handled in logic
  },
  avatarUrl: {
    type: String
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('User', userSchema);
