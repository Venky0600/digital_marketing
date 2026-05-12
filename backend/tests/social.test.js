const request = require('supertest');
const express = require('express');
const socialRoutes = require('../routes/social');

const app = express();
app.use(express.json());

jest.mock('../middleware/authMiddleware', () => ({
  protect: (req, res, next) => { req.user = { _id: 'mockUser123' }; next(); }
}));

app.use('/api/social', socialRoutes);

describe('Social Media Analytics API', () => {
  it('GET /api/social/instagram/:userId — returns Instagram analytics', async () => {
    const res = await request(app).get('/api/social/instagram/user123');
    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('platform', 'instagram');
    expect(res.body).toHaveProperty('followers');
    expect(res.body).toHaveProperty('engagementRate');
  });

  it('GET /api/social/youtube/:channelId — returns YouTube analytics', async () => {
    const res = await request(app).get('/api/social/youtube/channel123');
    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('platform', 'youtube');
    expect(res.body).toHaveProperty('subscribers');
  });

  it('GET /api/social/facebook/:pageId — returns Facebook analytics', async () => {
    const res = await request(app).get('/api/social/facebook/page123');
    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('platform', 'facebook');
    expect(res.body).toHaveProperty('followers');
  });

  it('GET /api/social/overview/:userId — returns combined overview', async () => {
    const res = await request(app).get('/api/social/overview/user123');
    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('platforms');
    expect(res.body.platforms).toHaveProperty('instagram');
    expect(res.body.platforms).toHaveProperty('youtube');
    expect(res.body.platforms).toHaveProperty('facebook');
    expect(res.body).toHaveProperty('totalReach');
  });
});
