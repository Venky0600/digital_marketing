const mongoose = require('mongoose');

const franchiseSchema = new mongoose.Schema({
  brandName: { type: String, required: true },
  imageUrl: { type: String, required: true },
  investmentRequired: { type: Number, required: true },
  expectedProfit: { type: Number, required: true },
  locationAvailability: { type: String, required: true },
  category: { type: String, required: true },
  supportProvided: [{ type: String }],
  contactEmail: { type: String, required: true },
  description: { type: String, required: true },
  established: { type: Number, required: true },
  totalOutlets: { type: Number, required: true },
  createdAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model('Franchise', franchiseSchema);
