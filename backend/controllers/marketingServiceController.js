const asyncHandler = require('express-async-handler');
const MarketingService = require('../models/MarketingService');

// @desc    Get all marketing services with optional pagination and filters
// @route   GET /api/marketing-services
// @access  Private
const getServices = asyncHandler(async (req, res) => {
  const page  = parseInt(req.query.page)  || 1;
  const limit = parseInt(req.query.limit) || 20;
  const skip  = (page - 1) * limit;

  const { category, minPrice, maxPrice } = req.query;
  const filter = {};
  
  if (category) filter.category = { $regex: category, $options: 'i' };
  if (minPrice || maxPrice) {
    filter.price = {};
    if (minPrice) filter.price.$gte = parseFloat(minPrice);
    if (maxPrice) filter.price.$lte = parseFloat(maxPrice);
  }

  const [data, total] = await Promise.all([
    MarketingService.find(filter).populate('provider', 'fullName email').sort({ createdAt: -1 }).skip(skip).limit(limit),
    MarketingService.countDocuments(filter)
  ]);

  res.json({ data, page, limit, total, pages: Math.ceil(total / limit) });
});

// @desc    Create a marketing service
// @route   POST /api/marketing-services
// @access  Private
const createService = asyncHandler(async (req, res) => {
  req.body.provider = req.user._id; // set from JWT
  const service = new MarketingService(req.body);
  const saved   = await service.save();
  res.status(201).json(saved);
});

module.exports = { getServices, createService };
