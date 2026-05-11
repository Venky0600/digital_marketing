const asyncHandler = require('express-async-handler');
const ChatMessage = require('../models/ChatMessage');

// @desc    Get all chat
// @route   GET /api/chat
// @access  Private
const getChatMessages = asyncHandler(async (req, res) => {
  const data = await ChatMessage.find().sort({ timestamp: 1 });
  res.json(data);
});

// @desc    Create new ChatMessage
// @route   POST /api/chat
// @access  Private
const createChatMessage = asyncHandler(async (req, res) => {
  const newData = new ChatMessage(req.body);
  const saved = await newData.save();
  res.status(201).json(saved);
});

module.exports = { getChatMessages, createChatMessage };
