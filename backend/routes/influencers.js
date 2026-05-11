const express = require('express');
const router  = express.Router();
const { getInfluencers, searchInfluencers, createInfluencer } = require('../controllers/influencerController');
const { protect } = require('../middleware/authMiddleware');

router.get('/search', protect, searchInfluencers);
router.route('/').get(protect, getInfluencers).post(protect, createInfluencer);

module.exports = router;
