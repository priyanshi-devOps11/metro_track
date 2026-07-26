# Delhi Metro Navigation & Ticketing Application

## 🚇 Complete Production-Ready Metro App

### Tech Stack
- **Frontend**: Flutter (Android + iOS)
- **Backend**: Node.js + Express
- **Database**: Supabase (PostgreSQL)
- **Authentication**: Firebase Auth
- **State Management**: Provider (MVVM)
- **API Client**: Dio (Retrofit-style)
- **Local Storage**: Hive
- **Voice**: Flutter TTS & Speech Recognition

---

## 📁 Project Structure-

```
metro_track/
├── backend/                    # Node.js Express Backend
│   ├── src/
│   │   ├── config/
│   │   │   ├── database.js
│   │   │   └── firebase.js
│   │   ├── controllers/
│   │   │   ├── routeController.js
│   │   │   ├── stationController.js
│   │   │   └── ticketController.js
│   │   ├── services/
│   │   │   ├── dijkstraService.js
│   │   │   ├── fareService.js
│   │   │   └── qrService.js
│   │   ├── models/
│   │   │   └── schemas.js
│   │   ├── routes/
│   │   │   ├── api.js
│   │   │   └── index.js
│   │   ├── middleware/
│   │   │   ├── auth.js
│   │   │   └── errorHandler.js
│   │   └── utils/
│   │       └── helpers.js
│   ├── data/
│   │   └── metro_data.json
│   ├── package.json
│   └── server.js
│
├── lib/                        # Flutter Application
│   ├── main.dart
│   ├── core/
│   ├── data/
│   ├── domain/
│   └── features/
│
├── supabase/
│   └── schema.sql             # Database Schema
│
└── README.md
```

---

## 🚀 Setup Instructions

### Backend Setup

1. **Install Dependencies**
```bash
cd backend
npm install
```

2. **Environment Variables**
Create `.env` file:
```env
PORT=3000
SUPABASE_URL=your_supabase_url
SUPABASE_KEY=your_supabase_anon_key
FIREBASE_PROJECT_ID=your_firebase_project_id
NODE_ENV=development
```

3. **Setup Supabase Database**
- Create Supabase project at https://supabase.com
- Run the SQL schema from `supabase/schema.sql`
- Insert mock data using provided scripts

4. **Start Backend**
```bash
npm run dev
```

Backend runs on `http://localhost:3000`

---

### Frontend Setup

1. **Install Flutter Dependencies**
```bash
cd lib
flutter pub get
```

2. **Configure Firebase**
- Create Firebase project
- Download `google-services.json` (Android)
- Download `GoogleService-Info.plist` (iOS)
- Place in respective directories

3. **Update API Base URL**
Edit `lib/data/network/api_client.dart`:
```dart
static const String baseUrl = 'http://localhost:3000/api';
// For production: 'https://your-backend.com/api'
```

4. **Run Application**
```bash
flutter run
```

---

## 🗄️ Database Schema

### Tables:
- `stations` - Metro stations with gate info
- `lines` - Metro lines (Red, Blue, Yellow, etc.)
- `connections` - Graph edges between stations
- `fares` - Fare rules based on distance
- `tickets` - Generated tickets
- `users` - User profiles
- `user_history` - Travel history

---

## 🎯 Core Features Implementation

### 1. Smart Route Finder (Dijkstra's Algorithm)
- **File**: `backend/src/services/dijkstraService.js`
- Handles interchange penalties
- Optimizes for minimum time
- Returns step-by-step navigation

### 2. Station Navigator
- **File**: `lib/features/station_navigator/`
- Gate-specific guidance
- Platform and line information
- Accessibility-first design

### 3. Live Metro Tracker
- **File**: `backend/src/services/liveTrackerService.js`
- Mock real-time ETA
- Crowd level simulation
- Platform information

### 4. Integrated Ticketing
- **File**: `lib/features/ticket_wallet/`
- QR code generation
- Fare calculation
- Payment mock integration

### 5. Voice Assistant
- **File**: `lib/features/voice_assistant/`
- Hindi + English support
- Speech-to-text route finding
- Elderly-friendly responses

### 6. Offline Mode
- **File**: `lib/data/local/hive_service.dart`
- Cached stations and routes
- Local Dijkstra execution
- Automatic sync when online

---

## 🔐 Authentication Flow

1. User signs up via Firebase Auth
2. Backend verifies Firebase token
3. User profile created in Supabase
4. JWT token issued for API calls

---

## 💳 Payment Integration (Mock)

- UPI simulation
- Paytm wallet mock
- QR code ticket generation
- Transaction history

---

## 🧪 Testing

### Backend Tests
```bash
cd backend
npm test
```

### Flutter Tests
```bash
flutter test
```

---

## 📱 API Endpoints

### Routes
- `POST /api/routes/find` - Find shortest route
- `GET /api/stations` - Get all stations
- `GET /api/stations/:id` - Get station details

### Tickets
- `POST /api/tickets/generate` - Generate ticket
- `GET /api/tickets/user/:userId` - Get user tickets
- `POST /api/tickets/validate` - Validate QR code

### Live Tracking
- `GET /api/live/station/:stationId` - Get live info
- `GET /api/live/train/:trainId` - Track specific train

---

## 🌐 Deployment

### Backend (Heroku/Railway)
```bash
git push heroku main
```

### Frontend (Play Store / App Store)
```bash
flutter build apk --release
flutter build ios --release
```

---

## 🎨 UI/UX Highlights

- Large touch targets (minimum 48x48dp)
- High contrast mode
- Font scaling support
- Voice navigation
- Bilingual support (Hindi/English)
- Offline-first architecture

---

## 📊 Mock Data Included

- 50+ Delhi Metro stations
- Red, Blue, Yellow lines
- Realistic travel times
- Interchange stations
- Gate information

---

## 🔧 Troubleshooting

### Backend won't start
- Check Supabase credentials
- Verify Node.js version (v16+)
- Check port availability

### Flutter build fails
- Run `flutter clean`
- Check Firebase configuration
- Verify dependencies in `pubspec.yaml`

---

## 📄 License

MIT License - Free for educational and commercial use

---

## 👥 Contributing

1. Fork the repository
2. Create feature branch
3. Commit changes
4. Push to branch
5. Create Pull Request

---

## 📞 Support

For issues and questions:
- Create GitHub issue
- Email: srivastavapriyanshi8081@gmail.com

---

**Built with ❤️ for Delhi Metro commuters**
