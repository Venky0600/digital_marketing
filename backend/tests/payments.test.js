const request = require('supertest');
const express = require('express');
const paymentRoutes = require('../routes/payments');

// Mock Express app and middleware
const app = express();
app.use(express.json());

// Mock protect middleware to fake authentication
jest.mock('../middleware/authMiddleware', () => ({
  protect: (req, res, next) => {
    req.user = { _id: 'mockUserId123' };
    next();
  }
}));

// Mock Razorpay
jest.mock('razorpay', () => {
  return jest.fn().mockImplementation(() => ({
    orders: {
      create: jest.fn().mockResolvedValue({ id: 'order_123', amount: 50000, currency: 'INR' })
    }
  }));
});

app.use('/api/payments', paymentRoutes);

describe('Payments API', () => {
  it('should create a Razorpay order', async () => {
    const res = await request(app)
      .post('/api/payments/create-order')
      .send({ amount: 500, currency: 'INR' });
      
    expect(res.statusCode).toEqual(200);
    expect(res.body).toHaveProperty('id', 'order_123');
    expect(res.body).toHaveProperty('amount', 50000);
  });
  
  it('should reject invalid signatures during verification', async () => {
    const res = await request(app)
      .post('/api/payments/verify')
      .send({ 
        razorpay_order_id: 'order_123', 
        razorpay_payment_id: 'pay_123', 
        razorpay_signature: 'invalid_sig' 
      });
      
    expect(res.statusCode).toEqual(400);
  });
});
