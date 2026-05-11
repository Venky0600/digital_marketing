const express = require('express');
const router  = express.Router();
const {
  getOverview, getMonthlyGrowth, getUserRoles, getTopInfluencers, getCampaignStatus
} = require('../controllers/analyticsController');
const { protect } = require('../middleware/authMiddleware');

router.get('/overview',        protect, getOverview);
router.get('/monthly-growth',  protect, getMonthlyGrowth);
router.get('/user-roles',      protect, getUserRoles);
router.get('/top-influencers', protect, getTopInfluencers);
router.get('/campaign-status', protect, getCampaignStatus);

module.exports = router;
