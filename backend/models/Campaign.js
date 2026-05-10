const mongoose = require('mongoose');

const campaignSchema = new mongoose.Schema({
  businessName: { type: String, required: true },
  logoUrl: { type: String, required: true },
  category: { type: String, required: true },
  title: { type: String, required: true },
  description: { type: String, required: true },
  location: { type: String, required: true },
  budget: { type: Number, required: true },
  targetAudience: { type: String, required: true },
  campaignType: { type: String, required: true },
  requiredNiche: { type: String, required: true },
  status: { type: String, required: true },
  applicants: { type: Number, default: 0 },
  createdAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model('Campaign', campaignSchema);
