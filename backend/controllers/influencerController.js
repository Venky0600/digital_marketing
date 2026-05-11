const asyncHandler = require('express-async-handler');
const Influencer = require('../models/Influencer');

// @desc    Get all influencers with optional filter/pagination
// @route   GET /api/influencers
// @access  Private
const getInfluencers = asyncHandler(async (req, res) => {
  const page  = parseInt(req.query.page)  || 1;
  const limit = parseInt(req.query.limit) || 20;
  const skip  = (page - 1) * limit;

  const [data, total] = await Promise.all([
    Influencer.find().sort({ createdAt: -1 }).skip(skip).limit(limit),
    Influencer.countDocuments()
  ]);

  res.json({ data, page, limit, total, pages: Math.ceil(total / limit) });
});

// @desc    Search influencers — keyword, location, niche, platform, price
// @route   GET /api/influencers/search
// @access  Private
const searchInfluencers = asyncHandler(async (req, res) => {
  const { keyword, location, niche, platform, minPrice, maxPrice, page = 1, limit = 20 } = req.query;

  const filter = {};
  if (keyword) {
    filter.$or = [
      { name:     { $regex: keyword, $options: 'i' } },
      { bio:      { $regex: keyword, $options: 'i' } },
    ];
  }
  if (location) filter.location = { $regex: location, $options: 'i' };
  if (niche)    filter.niche    = { $regex: niche,    $options: 'i' };
  if (platform) filter.platform = { $regex: platform, $options: 'i' };
  if (minPrice || maxPrice) {
    filter.pricePerPromotion = {};
    if (minPrice) filter.pricePerPromotion.$gte = parseFloat(minPrice);
    if (maxPrice) filter.pricePerPromotion.$lte = parseFloat(maxPrice);
  }

  const skip = (parseInt(page) - 1) * parseInt(limit);
  const [data, total] = await Promise.all([
    Influencer.find(filter).sort({ createdAt: -1 }).skip(skip).limit(parseInt(limit)),
    Influencer.countDocuments(filter)
  ]);

  res.json({ data, page: parseInt(page), limit: parseInt(limit), total });
});

// @desc    Create influencer
// @route   POST /api/influencers
// @access  Private
const createInfluencer = asyncHandler(async (req, res) => {
  const influencer = new Influencer(req.body);
  const saved      = await influencer.save();
  res.status(201).json(saved);
});

module.exports = { getInfluencers, searchInfluencers, createInfluencer };
