const asyncHandler = require('express-async-handler');
const Notification = require('../models/Notification');

// @desc    Get all notifications
// @route   GET /api/notifications
// @access  Private
const getNotifications = asyncHandler(async (req, res) => {
  const data = await Notification.find().sort({ timestamp: -1 });
  res.json(data);
});

// @desc    Create new Notification
// @route   POST /api/notifications
// @access  Private
const User = require('../models/User');
const { sendPushNotification } = require('../services/firebaseService');
const createNotification = asyncHandler(async (req, res) => {
  const newData = new Notification(req.body);
  const saved = await newData.save();

  // Try to find recipient's FCM token and send push
  if (req.body.userId) {
    const user = await User.findById(req.body.userId);
    if (user && user.fcmToken) {
      await sendPushNotification(user.fcmToken, req.body.title, req.body.body, { type: req.body.type });
    }
  }

  res.status(201).json(saved);
});

module.exports = { getNotifications, createNotification };
