const request = require('supertest');
const express = require('express');
const aiRoutes = require('../routes/ai');

const app = express();
app.use(express.json());

jest.mock('../middleware/authMiddleware', () => ({
  protect: (req, res, next) => {
    req.user = { _id: 'mockUserId123' };
    next();
  }
}));

// Mock the AI Controller implementations so we don't hit the real Gemini API
jest.mock('../controllers/aiController', () => ({
  chatWithGemini: (req, res) => res.json({ reply: 'Mocked Gemini response' }),
  recommendInfluencers: (req, res) => res.json({ recommendations: 'Mocked recommendations' }),
  improveCampaign: (req, res) => res.json({ improvements: 'Mocked improvements' })
}));

app.use('/api/ai', aiRoutes);

describe('AI API', () => {
  it('should return a mocked Gemini response', async () => {
    const res = await request(app)
      .post('/api/ai/chat')
      .send({ message: 'Hello AI' });
      
    expect(res.statusCode).toEqual(200);
    expect(res.body).toHaveProperty('reply', 'Mocked Gemini response');
  });

  it('should recommend influencers', async () => {
    const res = await request(app)
      .post('/api/ai/recommend-influencers')
      .send({ campaignDetails: 'Looking for a tech influencer' });
      
    expect(res.statusCode).toEqual(200);
    expect(res.body).toHaveProperty('recommendations');
  });
});
