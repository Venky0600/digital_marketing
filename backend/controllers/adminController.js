const asyncHandler = require('express-async-handler');
const User       = require('../models/User');
const Campaign   = require('../models/Campaign');
const Franchise  = require('../models/Franchise');

// @desc    Get all users (admin only)
// @route   GET /api/admin/users
// @access  Private/Admin
const getAllUsers = asyncHandler(async (req, res) => {
  const page  = parseInt(req.query.page)  || 1;
  const limit = parseInt(req.query.limit) || 20;
  const skip  = (page - 1) * limit;

  const [users, total] = await Promise.all([
    User.find().select('-password').sort({ createdAt: -1 }).skip(skip).limit(limit),
    User.countDocuments()
  ]);

  res.json({ data: users, page, limit, total, pages: Math.ceil(total / limit) });
});

// @desc    Block or unblock a user
// @route   PATCH /api/admin/users/:id/block
// @access  Private/Admin
const toggleBlockUser = asyncHandler(async (req, res) => {
  const user = await User.findById(req.params.id).select('-password');
  if (!user) {
    res.status(404);
    throw new Error('User not found');
  }
  user.isBlocked = !user.isBlocked;
  await user.save();
  res.json({ message: `User ${user.isBlocked ? 'blocked' : 'unblocked'} successfully`, user });
});

// @desc    Delete a user
// @route   DELETE /api/admin/users/:id
// @access  Private/Admin
const deleteUser = asyncHandler(async (req, res) => {
  const user = await User.findByIdAndDelete(req.params.id);
  if (!user) {
    res.status(404);
    throw new Error('User not found');
  }
  res.json({ message: 'User deleted successfully' });
});

// @desc    Get all campaigns (with optional approval status filter)
// @route   GET /api/admin/campaigns
// @access  Private/Admin
const adminGetCampaigns = asyncHandler(async (req, res) => {
  const campaigns = await Campaign.find().sort({ createdAt: -1 });
  res.json({ data: campaigns, total: campaigns.length });
});

// @desc    Get admin dashboard stats
// @route   GET /api/admin/stats
// @access  Private/Admin
const getAdminStats = asyncHandler(async (req, res) => {
  const [totalUsers, totalCampaigns, totalFranchises, blockedUsers] = await Promise.all([
    User.countDocuments(),
    Campaign.countDocuments(),
    Franchise.countDocuments(),
    User.countDocuments({ isBlocked: true }),
  ]);

  const recentUsers = await User.find().select('-password').sort({ createdAt: -1 }).limit(5);

  res.json({ totalUsers, totalCampaigns, totalFranchises, blockedUsers, recentUsers });
});

module.exports = { getAllUsers, toggleBlockUser, deleteUser, adminGetCampaigns, getAdminStats };
