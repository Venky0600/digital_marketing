const express = require('express');
const router  = express.Router();
const { getFranchises, searchFranchises, createFranchise } = require('../controllers/franchiseController');
const { protect } = require('../middleware/authMiddleware');

router.get('/search', protect, searchFranchises);
router.route('/').get(protect, getFranchises).post(protect, createFranchise);

module.exports = router;
