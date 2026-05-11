const mongoose = require('mongoose');

const campaignSchema = new mongoose.Schema({
  businessName:   { type: String, required: true },
  logoUrl:        { type: String },
  category:       { type: String, required: true },
  title:          { type: String, required: true },
  description:    { type: String, required: true },
  location:       { type: String, required: true },
  budget:         { type: Number, required: true },
  targetAudience: { type: String, required: true },
  campaignType:   { type: String, required: true },
  requiredNiche:  { type: String },
  status:         { type: String, required: true, default: 'open', enum: ['open','inProgress','completed'] },
  applicants:     { type: Number, default: 0 },
}, { timestamps: true });

// Indexes for fast search and filtering
campaignSchema.index({ title: 'text', description: 'text', businessName: 'text' });
campaignSchema.index({ location: 1, category: 1, status: 1 });

module.exports = mongoose.model('Campaign', campaignSchema);

