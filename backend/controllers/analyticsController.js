const asyncHandler = require('express-async-handler');
const User       = require('../models/User');
const Campaign   = require('../models/Campaign');
const Influencer = require('../models/Influencer');
const Franchise  = require('../models/Franchise');
const ChatMessage= require('../models/ChatMessage');

// @desc    Get analytics overview
// @route   GET /api/analytics/overview
// @access  Private
const getOverview = asyncHandler(async (req, res) => {
  const [
    totalUsers,
    totalCampaigns,
    totalInfluencers,
    totalFranchises,
    totalMessages,
  ] = await Promise.all([
    User.countDocuments(),
    Campaign.countDocuments(),
    Influencer.countDocuments(),
    Franchise.countDocuments(),
    ChatMessage.countDocuments(),
  ]);

  res.json({
    totalUsers,
    totalCampaigns,
    totalInfluencers,
    totalFranchises,
    totalMessages,
  });
});

// @desc    Get monthly campaign growth (last 6 months)
// @route   GET /api/analytics/monthly-growth
// @access  Private
const getMonthlyGrowth = asyncHandler(async (req, res) => {
  const sixMonthsAgo = new Date();
  sixMonthsAgo.setMonth(sixMonthsAgo.getMonth() - 6);

  const campaigns = await Campaign.aggregate([
    { $match: { createdAt: { $gte: sixMonthsAgo } } },
    {
      $group: {
        _id: { year: { $year: '$createdAt' }, month: { $month: '$createdAt' } },
        count: { $sum: 1 },
      }
    },
    { $sort: { '_id.year': 1, '_id.month': 1 } }
  ]);

  const users = await User.aggregate([
    { $match: { createdAt: { $gte: sixMonthsAgo } } },
    {
      $group: {
        _id: { year: { $year: '$createdAt' }, month: { $month: '$createdAt' } },
        count: { $sum: 1 },
      }
    },
    { $sort: { '_id.year': 1, '_id.month': 1 } }
  ]);

  res.json({ campaigns, users });
});

// @desc    Get role distribution of users
// @route   GET /api/analytics/user-roles
// @access  Private
const getUserRoles = asyncHandler(async (req, res) => {
  const distribution = await User.aggregate([
    { $group: { _id: '$role', count: { $sum: 1 } } }
  ]);
  res.json(distribution);
});

// @desc    Get top influencers by follower count
// @route   GET /api/analytics/top-influencers
// @access  Private
const getTopInfluencers = asyncHandler(async (req, res) => {
  const top = await Influencer.find()
    .sort({ followers: -1 })
    .limit(5)
    .select('name niche followers engagementRate platform profileImageUrl');
  res.json(top);
});

// @desc    Get campaign status distribution
// @route   GET /api/analytics/campaign-status
// @access  Private
const getCampaignStatus = asyncHandler(async (req, res) => {
  const distribution = await Campaign.aggregate([
    { $group: { _id: '$status', count: { $sum: 1 } } }
  ]);
  res.json(distribution);
});

module.exports = { getOverview, getMonthlyGrowth, getUserRoles, getTopInfluencers, getCampaignStatus };
