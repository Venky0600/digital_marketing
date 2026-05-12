const request = require('supertest');
const express = require('express');
const franchisesRoutes = require('../routes/franchises');

const app = express();
app.use(express.json());

jest.mock('../middleware/authMiddleware', () => ({
  protect: (req, res, next) => { req.user = { _id: 'mockUser123' }; next(); }
}));
jest.mock('../models/Franchise', () => {
  function MockFranchise(data) { Object.assign(this, data); }
  MockFranchise.prototype.save = jest.fn().mockResolvedValue({ _id: 'f_123', brandName: 'TestBrand' });
  MockFranchise.find = jest.fn().mockReturnValue({
    sort: jest.fn().mockReturnValue({ skip: jest.fn().mockReturnValue({ limit: jest.fn().mockResolvedValue([]) }) })
  });
  MockFranchise.countDocuments = jest.fn().mockResolvedValue(0);
  return MockFranchise;
});

app.use('/api/franchises', franchisesRoutes);

describe('Franchises API', () => {
  it('GET /api/franchises — returns paginated list', async () => {
    const res = await request(app).get('/api/franchises');
    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('data');
    expect(res.body).toHaveProperty('total');
    expect(Array.isArray(res.body.data)).toBe(true);
  });
});
