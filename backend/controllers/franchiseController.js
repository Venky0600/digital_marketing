const asyncHandler = require('express-async-handler');
const Franchise = require('../models/Franchise');

// @desc    Get all franchises with pagination
// @route   GET /api/franchises
// @access  Private
const getFranchises = asyncHandler(async (req, res) => {
  const page  = parseInt(req.query.page)  || 1;
  const limit = parseInt(req.query.limit) || 20;
  const skip  = (page - 1) * limit;
  const { lat, lng } = req.query;

  const filter = {};
  if (lat && lng) {
    filter.location_coords = {
      $near: {
        $geometry: { type: 'Point', coordinates: [parseFloat(lng), parseFloat(lat)] },
        $maxDistance: 100000 // 100km for franchises
      }
    };
  }

  const [data, total] = await Promise.all([
    Franchise.find(filter).sort({ createdAt: -1 }).skip(skip).limit(limit),
    Franchise.countDocuments(filter)
  ]);

  res.json({ data, page, limit, total, pages: Math.ceil(total / limit) });
});

// @desc    Search franchises — keyword, location, category, investment range
// @route   GET /api/franchises/search
// @access  Private
const searchFranchises = asyncHandler(async (req, res) => {
  const { keyword, location, category, minInvestment, maxInvestment, lat, lng, page = 1, limit = 20 } = req.query;

  const filter = {};
  
  if (lat && lng) {
    filter.location_coords = {
      $near: {
        $geometry: { type: 'Point', coordinates: [parseFloat(lng), parseFloat(lat)] },
        $maxDistance: 100000
      }
    };
  }

  if (keyword) {
    filter.$or = [
      { brandName:   { $regex: keyword, $options: 'i' } },
      { description: { $regex: keyword, $options: 'i' } },
    ];
  }
  if (location) filter.locationAvailability = { $regex: location, $options: 'i' };
  if (category) filter.category             = { $regex: category, $options: 'i' };
  if (minInvestment || maxInvestment) {
    filter.investmentRequired = {};
    if (minInvestment) filter.investmentRequired.$gte = parseFloat(minInvestment);
    if (maxInvestment) filter.investmentRequired.$lte = parseFloat(maxInvestment);
  }

  const skip = (parseInt(page) - 1) * parseInt(limit);
  const [data, total] = await Promise.all([
    Franchise.find(filter).sort({ createdAt: -1 }).skip(skip).limit(parseInt(limit)),
    Franchise.countDocuments(filter)
  ]);

  res.json({ data, page: parseInt(page), limit: parseInt(limit), total });
});

// @desc    Create franchise
// @route   POST /api/franchises
// @access  Private
const createFranchise = asyncHandler(async (req, res) => {
  const franchise = new Franchise(req.body);
  const saved     = await franchise.save();
  res.status(201).json(saved);
});

module.exports = { getFranchises, searchFranchises, createFranchise };
