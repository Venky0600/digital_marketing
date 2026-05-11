const request = require('supertest');
const mongoose = require('mongoose');
const express  = require('express');

// Must set JWT_SECRET before requiring any route that uses it
process.env.JWT_SECRET = process.env.JWT_SECRET || 'test_jwt_secret_for_jest';

// ── Minimal test app (no rate-limit, no helmet for tests) ──────────────────
const app = express();
app.use(express.json());

const authRoutes = require('../routes/auth');
const { errorHandler } = require('../middleware/errorHandler');
app.use('/api/auth', authRoutes);
app.use(errorHandler);

// ── Setup / Teardown ───────────────────────────────────────────────────────
beforeAll(async () => {
  // Use in-memory-compatible URI (same local DB for integration tests)
  const MONGO_URI = process.env.MONGO_URI || 'mongodb://127.0.0.1:27017/betterdigital_test';
  await mongoose.connect(MONGO_URI);
});

afterAll(async () => {
  // Clean up test users
  const User = require('../models/User');
  await User.deleteMany({ email: /testuser_jest/ });
  await mongoose.disconnect();
});

// ── Auth Tests ─────────────────────────────────────────────────────────────
describe('POST /api/auth/signup', () => {
  it('should return 400 if required fields are missing', async () => {
    const res = await request(app)
      .post('/api/auth/signup')
      .send({ email: 'testuser_jest@test.com' });
    expect(res.statusCode).toBe(400);
    // auth route returns 'error' key; error middleware returns 'message'
    expect(res.body.error || res.body.message).toBeTruthy();
  });

  it('should create a new user and return token', async () => {
    const res = await request(app)
      .post('/api/auth/signup')
      .send({
        fullName: 'Jest Test User',
        email:    'testuser_jest@test.com',
        password: 'Test@1234',
        role:     'businessOwner',
      });
    expect(res.statusCode).toBe(201);
    expect(res.body).toHaveProperty('token');
    expect(res.body.user).toHaveProperty('email', 'testuser_jest@test.com');
  });

  it('should return 400 if email already exists', async () => {
    const res = await request(app)
      .post('/api/auth/signup')
      .send({
        fullName: 'Jest Duplicate',
        email:    'testuser_jest@test.com',
        password: 'Test@1234',
        role:     'businessOwner',
      });
    expect(res.statusCode).toBe(400);
  });
});

describe('POST /api/auth/login', () => {
  it('should return 400 if credentials are missing', async () => {
    const res = await request(app)
      .post('/api/auth/login')
      .send({ email: 'testuser_jest@test.com' });
    expect(res.statusCode).toBe(400);
  });

  it('should return token on valid credentials', async () => {
    const res = await request(app)
      .post('/api/auth/login')
      .send({
        email:    'testuser_jest@test.com',
        password: 'Test@1234',
        role:     'businessOwner',
      });
    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('token');
  });

  it('should return 400 on wrong password', async () => {
    const res = await request(app)
      .post('/api/auth/login')
      .send({
        email:    'testuser_jest@test.com',
        password: 'WrongPassword',
        role:     'businessOwner',
      });
    expect(res.statusCode).toBe(400);
  });

  it('should return 400 on wrong role', async () => {
    const res = await request(app)
      .post('/api/auth/login')
      .send({
        email:    'testuser_jest@test.com',
        password: 'Test@1234',
        role:     'influencer',
      });
    expect(res.statusCode).toBe(400);
  });
});
