const express = require('express');
const router  = express.Router();
const { getCampaigns, searchCampaigns, createCampaign } = require('../controllers/campaignController');
const { protect } = require('../middleware/authMiddleware');

// Search must come before '/' to avoid param collision
router.get('/search', protect, searchCampaigns);
router.route('/').get(protect, getCampaigns).post(protect, createCampaign);

module.exports = router;
