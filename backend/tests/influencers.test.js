const request = require('supertest');
const express = require('express');
const influencersRoutes = require('../routes/influencers');

const app = express();
app.use(express.json());

jest.mock('../middleware/authMiddleware', () => ({
  protect: (req, res, next) => { req.user = { _id: 'mockUser123' }; next(); }
}));
jest.mock('../models/Influencer', () => {
  function MockInfluencer(data) { Object.assign(this, data); }
  MockInfluencer.prototype.save = jest.fn().mockResolvedValue({ _id: 'i_123', name: 'Test Influencer' });
  MockInfluencer.find = jest.fn().mockReturnValue({
    sort: jest.fn().mockReturnValue({ skip: jest.fn().mockReturnValue({ limit: jest.fn().mockResolvedValue([]) }) })
  });
  MockInfluencer.countDocuments = jest.fn().mockResolvedValue(0);
  return MockInfluencer;
});

app.use('/api/influencers', influencersRoutes);

describe('Influencers API', () => {
  it('GET /api/influencers — returns paginated list', async () => {
    const res = await request(app).get('/api/influencers');
    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('data');
    expect(res.body).toHaveProperty('total');
    expect(Array.isArray(res.body.data)).toBe(true);
  });

  it('GET /api/influencers — respects page query param', async () => {
    const res = await request(app).get('/api/influencers?page=2&limit=5');
    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('page', 2);
  });
});
