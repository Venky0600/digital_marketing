const asyncHandler = require('express-async-handler');
const Campaign = require('../models/Campaign');

// @desc    Get all campaigns with optional search/filter/pagination
// @route   GET /api/campaigns
// @access  Private
const getCampaigns = asyncHandler(async (req, res) => {
  const page  = parseInt(req.query.page)  || 1;
  const limit = parseInt(req.query.limit) || 20;
  const skip  = (page - 1) * limit;

  const filter = buildFilter(req.query);

  const [campaigns, total] = await Promise.all([
    Campaign.find(filter).sort({ createdAt: -1 }).skip(skip).limit(limit),
    Campaign.countDocuments(filter)
  ]);

  res.json({ data: campaigns, page, limit, total, pages: Math.ceil(total / limit) });
});

// @desc    Search campaigns — keyword, location, category, budget
// @route   GET /api/campaigns/search
// @access  Private
const searchCampaigns = asyncHandler(async (req, res) => {
  const { keyword, location, category, minBudget, maxBudget, lat, lng, page = 1, limit = 20 } = req.query;

  const filter = {};

  if (lat && lng) {
    filter.location_coords = {
      $near: {
        $geometry: { type: 'Point', coordinates: [parseFloat(lng), parseFloat(lat)] },
        $maxDistance: 50000 // 50km
      }
    };
  }

  if (keyword) {
    filter.$or = [
      { title:       { $regex: keyword, $options: 'i' } },
      { description: { $regex: keyword, $options: 'i' } },
      { businessName:{ $regex: keyword, $options: 'i' } },
    ];
  }
  if (location) filter.location = { $regex: location, $options: 'i' };
  if (category) filter.category = { $regex: category, $options: 'i' };
  if (minBudget || maxBudget) {
    filter.budget = {};
    if (minBudget) filter.budget.$gte = parseFloat(minBudget);
    if (maxBudget) filter.budget.$lte = parseFloat(maxBudget);
  }

  const skip = (parseInt(page) - 1) * parseInt(limit);
  const [data, total] = await Promise.all([
    Campaign.find(filter).sort({ createdAt: -1 }).skip(skip).limit(parseInt(limit)),
    Campaign.countDocuments(filter)
  ]);

  res.json({ data, page: parseInt(page), limit: parseInt(limit), total });
});

// @desc    Create campaign
// @route   POST /api/campaigns
// @access  Private
const createCampaign = asyncHandler(async (req, res) => {
  const campaign = new Campaign(req.body);
  const saved    = await campaign.save();
  res.status(201).json(saved);
});

// Helper: build filter from query params
function buildFilter(query) {
  const filter = {};
  if (query.location) filter.location = { $regex: query.location, $options: 'i' };
  if (query.category) filter.category = { $regex: query.category, $options: 'i' };
  if (query.lat && query.lng) {
    filter.location_coords = {
      $near: {
        $geometry: { type: 'Point', coordinates: [parseFloat(query.lng), parseFloat(query.lat)] },
        $maxDistance: 50000
      }
    };
  }
  return filter;
}

module.exports = { getCampaigns, searchCampaigns, createCampaign };
