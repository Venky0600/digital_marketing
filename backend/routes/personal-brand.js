const express = require('express');
const router = express.Router();
const { getPersonalBrands, createPersonalBrand } = require('../controllers/personalbrandController');
const { protect } = require('../middleware/authMiddleware');

router.route('/')
  .get(protect, getPersonalBrands)
  .post(protect, createPersonalBrand);

module.exports = router;
