const express = require('express');
const router = express.Router();
const { getChatMessages, createChatMessage } = require('../controllers/chatmessageController');
const { protect } = require('../middleware/authMiddleware');

router.route('/')
  .get(protect, getChatMessages)
  .post(protect, createChatMessage);

module.exports = router;
