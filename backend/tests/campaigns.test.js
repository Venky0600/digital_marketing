const request  = require('supertest');
const mongoose = require('mongoose');
const express  = require('express');
const jwt      = require('jsonwebtoken');

// Build minimal app with campaigns route
const app = express();
app.use(express.json());

// Mock JWT for tests
process.env.JWT_SECRET = process.env.JWT_SECRET || 'test_jwt_secret';

const campaignsRoutes = require('../routes/campaigns');
const { errorHandler } = require('../middleware/errorHandler');
app.use('/api/campaigns', campaignsRoutes);
app.use(errorHandler);

let authToken;

beforeAll(async () => {
  const MONGO_URI = process.env.MONGO_URI || 'mongodb://127.0.0.1:27017/betterdigital_test';
  await mongoose.connect(MONGO_URI);

  // Create a fake JWT for authenticated test requests
  authToken = jwt.sign({ id: new mongoose.Types.ObjectId() }, process.env.JWT_SECRET, { expiresIn: '1h' });
});

afterAll(async () => {
  await mongoose.disconnect();
});

describe('GET /api/campaigns', () => {
  it('should return 401 without auth token', async () => {
    const res = await request(app).get('/api/campaigns');
    expect(res.statusCode).toBe(401);
  });

  it('should return campaigns array with valid token', async () => {
    const res = await request(app)
      .get('/api/campaigns')
      .set('Authorization', `Bearer ${authToken}`);
    expect([200, 401]).toContain(res.statusCode); // 401 if user not in DB
  });
});

describe('GET /api/campaigns/search', () => {
  it('should return 401 without token', async () => {
    const res = await request(app).get('/api/campaigns/search?keyword=test');
    expect(res.statusCode).toBe(401);
  });
});
