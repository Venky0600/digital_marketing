const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/User');

// JWT secret must come from environment - validated at server startup
const JWT_SECRET = process.env.JWT_SECRET;

// @route POST /api/auth/signup
// @desc Register a new user
router.post('/signup', async (req, res) => {
  console.log('--- POST /api/auth/signup received ---');
  console.log('Body:', req.body);
  try {
    const { fullName, email, password, role, company, niche } = req.body;

    // Validation
    if (!fullName || !email || !password || !role) {
      return res.status(400).json({ error: 'Please enter all required fields' });
    }

    // Check if user already exists
    console.log('Checking existing user...');
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      console.log('User already exists');
      return res.status(400).json({ error: 'A user with this email already exists' });
    }

    // Hash the password
    console.log('Hashing password...');
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    // Create new user
    console.log('Creating new user...');
    const avatarUrl = `https://i.pravatar.cc/300?u=${email.hashCode || Date.now()}`;
    const newUser = new User({
      fullName,
      email,
      password: hashedPassword,
      role,
      company: role === 'businessOwner' ? company : undefined,
      niche: role === 'influencer' ? niche : undefined,
      avatarUrl
    });

    console.log('Saving user to DB...');
    const savedUser = await newUser.save();

    // Create JWT
    console.log('Creating JWT...');
    const token = jwt.sign({ id: savedUser._id }, JWT_SECRET, { expiresIn: '7d' });

    res.status(201).json({
      token,
      user: {
        id: savedUser._id,
        fullName: savedUser.fullName,
        email: savedUser.email,
        role: savedUser.role,
        avatarUrl: savedUser.avatarUrl,
        company: savedUser.company,
        niche: savedUser.niche
      }
    });

  } catch (err) {
    console.error('Signup error:', err);
    res.status(500).json({ error: 'Server error during registration' });
  }
});

// @route POST /api/auth/login
// @desc Authenticate user & get token
router.post('/login', async (req, res) => {
  try {
    const { email, password, role } = req.body;

    // Validation
    if (!email || !password || !role) {
      return res.status(400).json({ error: 'Please provide email, password, and role' });
    }

    // Find the user
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ error: 'Invalid credentials' });
    }

    // Verify role matches
    if (user.role !== role) {
      return res.status(400).json({ error: `This email is registered as an ${user.role}, please log in using the correct role portal.` });
    }

    // Check password
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ error: 'Invalid credentials' });
    }

    // Generate token
    const token = jwt.sign({ id: user._id }, JWT_SECRET, { expiresIn: '7d' });

    res.json({
      token,
      user: {
        id: user._id,
        fullName: user.fullName,
        email: user.email,
        role: user.role,
        avatarUrl: user.avatarUrl,
        company: user.company,
        niche: user.niche
      }
    });
  } catch (err) {
    console.error('Login error:', err);
    res.status(500).json({ error: 'Server error during login' });
  }
});

module.exports = router;
