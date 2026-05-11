const fs = require('fs');
const path = require('path');

const models = ['Influencer', 'Campaign', 'Franchise', 'Product', 'ChatMessage', 'Notification', 'PersonalBrand'];

models.forEach(model => {
  const lower = model === 'ChatMessage' ? 'chat' : model === 'PersonalBrand' ? 'personalBrand' : model.toLowerCase() + 's';
  const param = model === 'ChatMessage' ? 'chat' : model === 'PersonalBrand' ? 'personalBrand' : model.toLowerCase();
  const routeName = model === 'ChatMessage' ? 'chat' : model === 'PersonalBrand' ? 'personal-brand' : lower;
  
  // Controller
  const controller = `const asyncHandler = require('express-async-handler');
const ${model} = require('../models/${model}');

// @desc    Get all ${lower}
// @route   GET /api/${routeName}
// @access  Private
const get${model}s = asyncHandler(async (req, res) => {
  const data = await ${model}.find().sort({ ${model === 'ChatMessage' || model === 'Notification' ? 'timestamp' : 'createdAt'}: ${model === 'ChatMessage' ? 1 : -1} });
  res.json(data);
});

// @desc    Create new ${model}
// @route   POST /api/${routeName}
// @access  Private
const create${model} = asyncHandler(async (req, res) => {
  const newData = new ${model}(req.body);
  const saved = await newData.save();
  res.status(201).json(saved);
});

module.exports = { get${model}s, create${model} };
`;
  fs.writeFileSync(path.join(__dirname, 'controllers', model.toLowerCase() + 'Controller.js'), controller);

  // Route
  const route = `const express = require('express');
const router = express.Router();
const { get${model}s, create${model} } = require('../controllers/${model.toLowerCase()}Controller');
const { protect } = require('../middleware/authMiddleware');

router.route('/')
  .get(protect, get${model}s)
  .post(protect, create${model});

module.exports = router;
`;
  fs.writeFileSync(path.join(__dirname, 'routes', routeName + '.js'), route);
});
console.log('Done generating files');
