const request = require('supertest');
const express = require('express');
const notificationsRoutes = require('../routes/notifications');

const app = express();
app.use(express.json());

// Mock auth and firebase service
jest.mock('../middleware/authMiddleware', () => ({
  protect: (req, res, next) => { req.user = { _id: 'mockUser123' }; next(); }
}));
jest.mock('../services/firebaseService', () => ({
  sendPushNotification: jest.fn().mockResolvedValue(undefined)
}));
jest.mock('../models/User', () => ({
  findById: jest.fn().mockResolvedValue({ _id: 'mockUser123', fcmToken: null })
}));
jest.mock('../models/Notification', () => {
  function MockNotification(data) { Object.assign(this, data); }
  MockNotification.prototype.save = jest.fn().mockResolvedValue({ _id: 'notif_123', title: 'Test', body: 'Body', type: 'general' });
  MockNotification.find = jest.fn().mockReturnValue({ sort: jest.fn().mockResolvedValue([]) });
  return MockNotification;
});

app.use('/api/notifications', notificationsRoutes);

describe('Notifications API', () => {
  it('GET /api/notifications — returns empty array initially', async () => {
    const res = await request(app).get('/api/notifications');
    expect(res.statusCode).toBe(200);
    expect(Array.isArray(res.body)).toBe(true);
  });

  it('POST /api/notifications — creates a notification', async () => {
    const res = await request(app)
      .post('/api/notifications')
      .send({ title: 'Test Alert', body: 'Campaign approved!', type: 'newCampaign' });
    expect(res.statusCode).toBe(201);
    expect(res.body).toHaveProperty('title', 'Test');
  });
});
