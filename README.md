# Digital Marketing Platform 🚀

A production-ready marketplace platform connecting **Businesses**, **Influencers**, **Franchises**, and **Startups** through campaigns, AI-powered matching, and real-time collaboration.

---

## 🏗️ Architecture

```
┌────────────────────────────────────────────────────────────────┐
│                    Flutter Frontend (Mobile/Web)                │
│  ┌─────────┐ ┌──────────┐ ┌──────────┐ ┌──────────────────┐   │
│  │  Auth   │ │Campaigns │ │ AI Chat  │ │  Analytics       │   │
│  │Provider │ │ & Search │ │(Gemini)  │ │  Dashboard       │   │
│  └────┬────┘ └────┬─────┘ └────┬─────┘ └────────┬─────────┘   │
│       └───────────┴────────────┴────────────────┘             │
│                          HTTP + JWT                            │
└───────────────────────────┬────────────────────────────────────┘
                            │
┌───────────────────────────▼────────────────────────────────────┐
│               Node.js + Express Backend (Port 5000)            │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────────────┐  │
│  │   Auth   │ │ Campaigns│ │  AI API  │ │   Admin/Analytics│  │
│  │  Routes  │ │ /Search  │ │ (Gemini) │ │   Routes         │  │
│  └────┬─────┘ └────┬─────┘ └────┬─────┘ └────────┬─────────┘  │
│       │             │            │                │             │
│  ┌────▼─────────────▼────────────▼────────────────▼─────────┐  │
│  │          JWT Middleware + RBAC + Rate Limiting           │  │
│  │       Helmet + XSS-Clean + Mongo-Sanitize               │  │
│  └──────────────────────────┬──────────────────────────────┘  │
│                             │ Socket.io (Real-time Chat)       │
└─────────────────────────────┼──────────────────────────────────┘
                              │
┌─────────────────────────────▼──────────────────────────────────┐
│                   MongoDB Database                             │
│  Users │ Campaigns │ Influencers │ Franchises │ ChatMessages   │
└────────────────────────────────────────────────────────────────┘
```

---

## ✨ Features

### 🔐 Security
- **JWT Authentication** with role-based access control (RBAC)
- **Roles**: `businessOwner`, `influencer`, `franchiseSeeker`, `admin`
- **Helmet** — secure HTTP headers
- **Rate Limiting** — 100 req/15 min per IP
- **Mongo-Sanitize** — NoSQL injection prevention
- **XSS-Clean** — Cross-site scripting protection
- **Session Persistence** — JWT stored securely on device

### 📣 Core Features
- Post and manage **campaigns**
- Browse and filter **influencers** by niche, location, platform, price
- Explore **franchise** opportunities with investment filters
- **AI-powered matching** via Google Gemini
- **Real-time chat** with Socket.io (typing indicators, online status)
- **Analytics dashboard** with live MongoDB aggregation

### 🤖 AI Integration (Gemini)
- AI marketing suggestions
- Influencer recommendation engine
- Campaign improvement analysis
- Interactive AI chatbot with conversation history

### 📊 Analytics
- Total users, campaigns, influencers, franchises
- Campaign status distribution
- Top influencers by followers
- Monthly growth trends (last 6 months)

### 👑 Admin Panel
- User management & blocking
- Campaign oversight
- Platform statistics

---

## 🛠️ Tech Stack

| Layer     | Technology                         |
|-----------|-------------------------------------|
| Frontend  | Flutter 3.x, Provider, socket_io_client |
| Backend   | Node.js, Express 5.x               |
| Database  | MongoDB, Mongoose                   |
| Auth      | JWT (jsonwebtoken), bcryptjs        |
| Real-Time | Socket.io                          |
| AI        | Google Gemini API (`@google/genai`) |
| Security  | Helmet, express-rate-limit, mongo-sanitize, xss-clean |
| Testing   | Jest, Supertest                     |

---

## 📁 Folder Structure

```
digital_marketing/
├── backend/
│   ├── controllers/       # Business logic (auth, campaigns, AI, admin, analytics)
│   ├── middleware/        # JWT auth, error handler, validation
│   ├── models/            # Mongoose schemas (User, Campaign, Influencer, ...)
│   ├── routes/            # Express routers
│   ├── tests/             # Jest + Supertest integration tests
│   ├── server.js          # App entry point (Socket.io + Express)
│   ├── .env.example       # Environment variable template
│   └── package.json
│
└── lib/                   # Flutter app
    ├── main.dart           # App entry with routes
    ├── models/             # Dart data models
    ├── providers/          # AppProvider (state management)
    ├── screens/            # UI screens
    │   ├── splash_screen.dart         # Auto-login check
    │   ├── login_screen.dart          # Role-based login
    │   ├── home_screen.dart           # Dashboard
    │   ├── campaign_list_screen.dart  # Search & filter campaigns
    │   ├── ai_chat_screen.dart        # Gemini AI assistant
    │   ├── real_time_chat_screen.dart # Socket.io live chat
    │   └── analytics_screen.dart      # Analytics dashboard
    ├── services/
    │   ├── api_service.dart            # HTTP client with JWT injection
    │   └── auth_service.dart           # Token storage (SharedPreferences)
    └── widgets/            # Reusable UI components
```

---

## 🚀 Installation & Setup

### Prerequisites
- Flutter SDK ≥ 3.0.0
- Node.js ≥ 18.x
- MongoDB (local or Atlas)
- Google Gemini API key ([Get one here](https://aistudio.google.com/))

### Backend Setup
```bash
cd backend
npm install

# Copy env template and fill in values
cp .env.example .env
# Edit .env:
#   MONGO_URI=mongodb://127.0.0.1:27017/betterdigital
#   JWT_SECRET=your_strong_secret_here
#   GEMINI_API_KEY=your_gemini_api_key

npm start
```

### Flutter Setup
```bash
flutter pub get
flutter run
```

### Run Backend Tests
```bash
cd backend
npm test
```

---

## 🔑 API Documentation

### Auth
| Method | Route               | Access  | Description           |
|--------|---------------------|---------|-----------------------|
| POST   | `/api/auth/signup`  | Public  | Register new user     |
| POST   | `/api/auth/login`   | Public  | Login & get JWT token |

### Campaigns
| Method | Route                      | Access  | Description              |
|--------|----------------------------|---------|--------------------------|
| GET    | `/api/campaigns`           | Private | List all (paginated)     |
| POST   | `/api/campaigns`           | Private | Create campaign          |
| GET    | `/api/campaigns/search`    | Private | Search & filter campaigns|

Query params for search: `keyword`, `location`, `category`, `minBudget`, `maxBudget`, `page`, `limit`

### Influencers
| Method | Route                        | Access  | Description              |
|--------|------------------------------|---------|--------------------------|
| GET    | `/api/influencers`           | Private | List all (paginated)     |
| POST   | `/api/influencers`           | Private | Add influencer           |
| GET    | `/api/influencers/search`    | Private | Search & filter          |

Query params: `keyword`, `location`, `niche`, `platform`, `minPrice`, `maxPrice`

### Franchises
| Method | Route                       | Access  | Description              |
|--------|-----------------------------|---------|--------------------------|
| GET    | `/api/franchises`           | Private | List all (paginated)     |
| POST   | `/api/franchises`           | Private | Add franchise            |
| GET    | `/api/franchises/search`    | Private | Search & filter          |

### AI
| Method | Route                          | Access  | Description                  |
|--------|--------------------------------|---------|------------------------------|
| POST   | `/api/ai/chat`                 | Private | Gemini AI chatbot            |
| POST   | `/api/ai/recommend-influencers`| Private | AI influencer recommendations|
| POST   | `/api/ai/improve-campaign`     | Private | AI campaign analysis         |

### Analytics
| Method | Route                            | Access  | Description              |
|--------|----------------------------------|---------|--------------------------|
| GET    | `/api/analytics/overview`        | Private | Platform stats overview  |
| GET    | `/api/analytics/monthly-growth`  | Private | Monthly user & campaign growth |
| GET    | `/api/analytics/top-influencers` | Private | Top 5 influencers        |
| GET    | `/api/analytics/campaign-status` | Private | Campaign status breakdown|

### Admin
| Method | Route                         | Access | Description         |
|--------|-------------------------------|--------|---------------------|
| GET    | `/api/admin/stats`            | Admin  | Dashboard stats     |
| GET    | `/api/admin/users`            | Admin  | All users           |
| PATCH  | `/api/admin/users/:id/block`  | Admin  | Block/unblock user  |
| DELETE | `/api/admin/users/:id`        | Admin  | Delete user         |

---

## 🔌 Socket.io Events

| Event              | Direction      | Description                    |
|--------------------|----------------|--------------------------------|
| `user:online`      | Client → Server| Register user as online        |
| `room:join`        | Client → Server| Join a chat room               |
| `message:send`     | Client → Server| Send a message to a room       |
| `message:receive`  | Server → Client| Receive new message            |
| `typing:start`     | Client → Server| Notify typing started          |
| `typing:stop`      | Client → Server| Notify typing stopped          |
| `users:online`     | Server → Client| Updated list of online users   |

---

## 🔮 Future Enhancements
- Firebase Cloud Messaging (push notifications)
- Payment gateway integration (Razorpay/Stripe)
- Video call integration for influencer meetings
- Multi-language support (i18n)
- Campaign analytics with conversion tracking
- Automated influencer-campaign matching (ML model)
- CI/CD pipeline with GitHub Actions
- Docker containerization

---

## 📸 Screenshots
*(Add screenshots of: Login, Home, Campaigns, AI Chat, Analytics, Real-time Chat)*

---

## 📄 License
MIT License. See [LICENSE](LICENSE) for details.
