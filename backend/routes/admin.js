const express = require('express');
const router  = express.Router();
const { getAllUsers, toggleBlockUser, deleteUser, adminGetCampaigns, getAdminStats } = require('../controllers/adminController');
const { protect, authorize } = require('../middleware/authMiddleware');

// All admin routes require auth + admin role
router.use(protect);
router.use(authorize('admin'));

router.get('/stats',                  getAdminStats);
router.get('/users',                  getAllUsers);
router.patch('/users/:id/block',      toggleBlockUser);
router.delete('/users/:id',           deleteUser);
router.get('/campaigns',              adminGetCampaigns);

module.exports = router;
