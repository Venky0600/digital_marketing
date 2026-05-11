require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const http = require('http');
const { Server } = require('socket.io');
const { errorHandler } = require('./middleware/errorHandler');

// Validate required environment variables at startup
if (!process.env.JWT_SECRET) {
  console.error('FATAL: JWT_SECRET is not defined in .env. Exiting.');
  process.exit(1);
}
if (!process.env.MONGO_URI) {
  console.error('FATAL: MONGO_URI is not defined in .env. Exiting.');
  process.exit(1);
}

// Import routes
const authRoutes        = require('./routes/auth');
const influencersRoutes = require('./routes/influencers');
const campaignsRoutes   = require('./routes/campaigns');
const franchisesRoutes  = require('./routes/franchises');
const productsRoutes    = require('./routes/products');
const chatRoutes        = require('./routes/chat');
const notificationsRoutes = require('./routes/notifications');
const personalBrandRoutes = require('./routes/personal-brand');
const aiRoutes          = require('./routes/ai');
const adminRoutes       = require('./routes/admin');
const analyticsRoutes   = require('./routes/analytics');

const app    = express();
const server = http.createServer(app);
const io     = new Server(server, {
  cors: { origin: '*', methods: ['GET', 'POST'] }
});

const PORT      = process.env.PORT || 5000;
const MONGO_URI = process.env.MONGO_URI;

// ── Security Middleware ─────────────────────────────────────────────────────
app.use(helmet());                  // Sets secure HTTP headers

// Manual sanitizer — compatible with Express 5 (req.query is read-only in Express 5)
// Strips $ keys (NoSQL injection) and < > characters (XSS) from req.body and req.params
const mongoSanitize = require('express-mongo-sanitize');

function sanitizeValue(val) {
  if (typeof val === 'string') return val.replace(/</g, '&lt;').replace(/>/g, '&gt;');
  if (Array.isArray(val))     return val.map(sanitizeValue);
  if (val && typeof val === 'object') {
    Object.keys(val).forEach(k => { val[k] = sanitizeValue(val[k]); });
  }
  return val;
}

app.use((req, res, next) => {
  if (req.body)   req.body   = mongoSanitize.sanitize(sanitizeValue(req.body));
  if (req.params) req.params = mongoSanitize.sanitize(sanitizeValue(req.params));
  next();
});

// Global rate limiter: 100 requests per 15 min per IP
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100,
  message: { message: 'Too many requests, please try again later.' }
});
app.use('/api', limiter);

// CORS — allow local Flutter/web clients
app.use(cors({ origin: '*' }));
app.use(express.json({ limit: '10kb' })); // Prevent large payload attacks


// ── MongoDB ─────────────────────────────────────────────────────────────────
mongoose.connect(MONGO_URI)
  .then(() => console.log('MongoDB connected successfully'))
  .catch((err) => { console.error('MongoDB connection error:', err); process.exit(1); });

// ── Socket.io — Real-Time Chat ───────────────────────────────────────────────
const onlineUsers = new Map(); // socketId -> { userId, name }

io.on('connection', (socket) => {
  console.log('Socket connected:', socket.id);

  // Register user as online
  socket.on('user:online', ({ userId, name }) => {
    onlineUsers.set(socket.id, { userId, name });
    io.emit('users:online', Array.from(onlineUsers.values()));
  });

  // Join a chat room (e.g. conversation between two users)
  socket.on('room:join', ({ roomId }) => {
    socket.join(roomId);
    console.log(`Socket ${socket.id} joined room ${roomId}`);
  });

  // Send message to room
  socket.on('message:send', ({ roomId, message }) => {
    io.to(roomId).emit('message:receive', message);
  });

  // Typing indicator
  socket.on('typing:start', ({ roomId, userName }) => {
    socket.to(roomId).emit('typing:start', { userName });
  });
  socket.on('typing:stop', ({ roomId }) => {
    socket.to(roomId).emit('typing:stop');
  });

  socket.on('disconnect', () => {
    onlineUsers.delete(socket.id);
    io.emit('users:online', Array.from(onlineUsers.values()));
    console.log('Socket disconnected:', socket.id);
  });
});

// Attach io to req so controllers can emit if needed
app.use((req, res, next) => { req.io = io; next(); });

// ── Health Check ─────────────────────────────────────────────────────────────
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', message: 'Digital Marketing API is running', timestamp: new Date() });
});

// ── Routes ────────────────────────────────────────────────────────────────────
app.use('/api/auth',          authRoutes);
app.use('/api/influencers',   influencersRoutes);
app.use('/api/campaigns',     campaignsRoutes);
app.use('/api/franchises',    franchisesRoutes);
app.use('/api/products',      productsRoutes);
app.use('/api/chat',          chatRoutes);
app.use('/api/notifications', notificationsRoutes);
app.use('/api/personal-brand',personalBrandRoutes);
app.use('/api/ai',            aiRoutes);
app.use('/api/admin',         adminRoutes);
app.use('/api/analytics',     analyticsRoutes);

// ── Centralized Error Handler ─────────────────────────────────────────────────
app.use(errorHandler);

// ── Start Server ──────────────────────────────────────────────────────────────
server.listen(PORT, () => {
  console.log(`Server running on port ${PORT} [${process.env.NODE_ENV || 'development'}]`);
});

// Handle port-in-use error gracefully
server.on('error', (err) => {
  if (err.code === 'EADDRINUSE') {
    console.error(`\n❌  Port ${PORT} is already in use.`);
    console.error(`   Run this to fix it:  taskkill /IM node.exe /F  then  npm start\n`);
    process.exit(1);
  } else {
    throw err;
  }
});
