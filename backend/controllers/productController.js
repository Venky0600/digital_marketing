const asyncHandler = require('express-async-handler');
const Product = require('../models/Product');

// @desc    Get all products
// @route   GET /api/products
// @access  Private
const getProducts = asyncHandler(async (req, res) => {
  const data = await Product.find().sort({ createdAt: -1 });
  res.json(data);
});

// @desc    Create new Product
// @route   POST /api/products
// @access  Private
const createProduct = asyncHandler(async (req, res) => {
  const newData = new Product(req.body);
  const saved = await newData.save();
  res.status(201).json(saved);
});

module.exports = { getProducts, createProduct };
