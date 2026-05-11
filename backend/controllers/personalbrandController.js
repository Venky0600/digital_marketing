const asyncHandler = require('express-async-handler');
const PersonalBrand = require('../models/PersonalBrand');

// @desc    Get all personalBrand
// @route   GET /api/personal-brand
// @access  Private
const getPersonalBrands = asyncHandler(async (req, res) => {
  const data = await PersonalBrand.find().sort({ createdAt: -1 });
  res.json(data);
});

// @desc    Create new PersonalBrand
// @route   POST /api/personal-brand
// @access  Private
const createPersonalBrand = asyncHandler(async (req, res) => {
  const newData = new PersonalBrand(req.body);
  const saved = await newData.save();
  res.status(201).json(saved);
});

module.exports = { getPersonalBrands, createPersonalBrand };
