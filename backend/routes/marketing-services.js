const express = require('express');
const router = express.Router();
const { getServices, createService } = require('../controllers/marketingServiceController');
const { protect } = require('../middleware/authMiddleware');

router.route('/')
  .get(protect, getServices)
  .post(protect, createService);

module.exports = router;
