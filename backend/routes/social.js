const express = require('express');
const router = express.Router();
const {
  getInstagramAnalytics,
  getYouTubeAnalytics,
  getFacebookAnalytics,
  getSocialOverview,
} = require('../controllers/socialController');
const { protect } = require('../middleware/authMiddleware');

// Individual platform routes
router.get('/instagram/:userId', protect, getInstagramAnalytics);
router.get('/youtube/:channelId', protect, getYouTubeAnalytics);
router.get('/facebook/:pageId', protect, getFacebookAnalytics);

// Combined overview
router.get('/overview/:userId', protect, getSocialOverview);

module.exports = router;
