require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

// Import models
const Influencer = require('./models/Influencer');
const Campaign = require('./models/Campaign');
const Franchise = require('./models/Franchise');
const Product = require('./models/Product');
const ChatMessage = require('./models/ChatMessage');
const Notification = require('./models/Notification');
const PersonalBrand = require('./models/PersonalBrand');

const authRoutes = require('./routes/auth');

const app = express();
const PORT = process.env.PORT || 5000;
const MONGO_URI = process.env.MONGO_URI || 'mongodb://127.0.0.1:27017/betterdigital';

// Middleware
app.use(cors());
app.use(express.json());

// Connect to MongoDB
mongoose.connect(MONGO_URI)
  .then(() => console.log('MongoDB connected successfully'))
  .catch((err) => console.error('MongoDB connection error:', err));

// ----------------------------------------------------
// ROUTES
// ----------------------------------------------------

// Health Check
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', message: 'Backend is running' });
});

// Authentication
app.use('/api/auth', authRoutes);

// Influencers
app.get('/api/influencers', async (req, res) => {
  try {
    const influencers = await Influencer.find().sort({ createdAt: -1 });
    res.json(influencers);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});
app.post('/api/influencers', async (req, res) => {
  try {
    const newInfluencer = new Influencer(req.body);
    const saved = await newInfluencer.save();
    res.status(201).json(saved);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// Campaigns
app.get('/api/campaigns', async (req, res) => {
  try {
    const campaigns = await Campaign.find().sort({ createdAt: -1 });
    res.json(campaigns);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});
app.post('/api/campaigns', async (req, res) => {
  try {
    const newCampaign = new Campaign(req.body);
    const saved = await newCampaign.save();
    res.status(201).json(saved);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// Franchises
app.get('/api/franchises', async (req, res) => {
  try {
    const franchises = await Franchise.find().sort({ createdAt: -1 });
    res.json(franchises);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});
app.post('/api/franchises', async (req, res) => {
  try {
    const newFranchise = new Franchise(req.body);
    const saved = await newFranchise.save();
    res.status(201).json(saved);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// Products
app.get('/api/products', async (req, res) => {
  try {
    const products = await Product.find().sort({ createdAt: -1 });
    res.json(products);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});
app.post('/api/products', async (req, res) => {
  try {
    const newProduct = new Product(req.body);
    const saved = await newProduct.save();
    res.status(201).json(saved);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// Chat Messages
app.get('/api/chat', async (req, res) => {
  try {
    const messages = await ChatMessage.find().sort({ timestamp: 1 });
    res.json(messages);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});
app.post('/api/chat', async (req, res) => {
  try {
    const newMessage = new ChatMessage(req.body);
    const saved = await newMessage.save();
    res.status(201).json(saved);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// Notifications
app.get('/api/notifications', async (req, res) => {
  try {
    const notifications = await Notification.find().sort({ timestamp: -1 });
    res.json(notifications);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});
app.post('/api/notifications', async (req, res) => {
  try {
    const newNotification = new Notification(req.body);
    const saved = await newNotification.save();
    res.status(201).json(saved);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// Personal Brand
app.get('/api/personal-brand', async (req, res) => {
  try {
    const brand = await PersonalBrand.findOne(); // Assuming single personal brand profile for now
    res.json(brand);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});
app.post('/api/personal-brand', async (req, res) => {
  try {
    const newBrand = new PersonalBrand(req.body);
    const saved = await newBrand.save();
    res.status(201).json(saved);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
