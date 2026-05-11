const express = require('express');
const router  = express.Router();
const { aiChat, recommendInfluencers, improveCampaign } = require('../controllers/aiController');
const { protect } = require('../middleware/authMiddleware');

// All AI routes are protected
router.post('/chat',                 protect, aiChat);
router.post('/recommend-influencers',protect, recommendInfluencers);
router.post('/improve-campaign',     protect, improveCampaign);

module.exports = router;
