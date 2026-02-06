# LearnEnglish - AI-Powered English Learning App

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white" />
  <img src="https://img.shields.io/badge/FastAPI-009688?style=for-the-badge&logo=fastapi&logoColor=white" />
  <img src="https://img.shields.io/badge/MongoDB-47A248?style=for-the-badge&logo=mongodb&logoColor=white" />
  <img src="https://img.shields.io/badge/Google%20Gemini-8E75B2?style=for-the-badge&logo=google&logoColor=white" />
  <img src="https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white" />
</p>

A **Duolingo-style** mobile application for learning English, powered by **Google Gemini AI** for intelligent writing correction and quiz generation, and **OpenAI Whisper** for speech-to-text pronunciation analysis.

---

## Table of Contents

- [Features](#features)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Test Account](#test-account)
- [Running Tests](#running-tests)
- [API Documentation](#api-documentation)
- [Environment Variables](#environment-variables)
- [Gamification System](#gamification-system)
- [User Guide](#user-guide)
- [Contributing](#contributing)
- [License](#license)

---

## Features

- **Interactive Lessons** - Multiple-choice, fill-in-the-blank, and translation challenges
- **AI Writing Correction** - Real-time grammar and spelling feedback powered by Google Gemini
- **Pronunciation Practice** - Speech analysis using OpenAI Whisper STT with word-level accuracy scoring
- **AI Quiz Generation** - Dynamic quiz creation based on topics and difficulty levels
- **Gamification System** - XP points, hearts, streaks, and level progression
- **Leaderboard** - Real-time ranking of learners by XP with pull-to-refresh
- **User Authentication** - Secure JWT-based authentication with bcrypt password hashing
- **Progress Tracking** - Track completed lessons, scores, and learning history
- **Clean Architecture** - BLoC pattern, dependency injection, repository pattern

---

## Architecture

```
┌─────────────────┐     ┌──────────────────┐     ┌──────────────────┐
│   Flutter App    │────>│  Node.js Backend │────>│   MongoDB        │
│   (Mobile/Web)   │     │  (REST API)      │     │   (Database)     │
└─────────────────┘     └────────┬─────────┘     └──────────────────┘
                                 │
                                 v
                        ┌──────────────────┐
                        │ Python AI Service│
                        │ (FastAPI)        │
                        │ - Gemini AI      │
                        │ - Whisper STT    │
                        └──────────────────┘
```

The project follows **Clean Architecture** principles with a clear separation of concerns:

| Layer | Description |
|-------|-------------|
| **Mobile (Flutter)** | Presentation layer with BLoC pattern for state management |
| **Backend (Node.js)** | Business logic, REST API, authentication, data persistence |
| **AI Service (Python)** | AI/ML processing - speech analysis, writing correction, quiz generation |
| **Database (MongoDB)** | Data storage for users, courses, lessons, challenges, progress |

---

## Tech Stack

| Component | Technology |
|-----------|-----------|
| Mobile App | Flutter 3.x, Dart 3.x, BLoC, Clean Architecture |
| Backend API | Node.js 20, Express.js, Mongoose ODM |
| AI Service | Python 3.11, FastAPI, Google Gemini, OpenAI Whisper |
| Database | MongoDB 7 |
| Auth | JWT + bcrypt |
| Container | Docker & Docker Compose V2 |

---

## Project Structure

```
LearnEnglish/
├── backend/                    # Node.js REST API
│   ├── src/
│   │   ├── config/             # Environment configuration
│   │   ├── controllers/        # Request handlers
│   │   ├── middleware/         # Auth, validation, error handling
│   │   ├── models/            # Mongoose schemas (User, Course, Unit, Lesson, Challenge, etc.)
│   │   ├── routes/            # API route definitions
│   │   ├── services/          # Business logic (auth, progress, gamification, AI proxy)
│   │   ├── utils/             # Utilities (ApiError, asyncHandler)
│   │   └── validators/        # Input validation rules
│   ├── seed/                  # Database seed data & test account
│   ├── tests/                 # Jest + Supertest tests (31 tests)
│   └── Dockerfile
│
├── ai-service/                # Python AI microservice
│   ├── app/
│   │   ├── routers/           # FastAPI route handlers (quiz, speech, writing)
│   │   ├── schemas/           # Pydantic request/response models
│   │   ├── services/          # AI service logic (Gemini, Whisper, text comparison)
│   │   └── utils/             # Prompt templates
│   ├── providers/             # AI provider abstraction (Gemini, Local fallback)
│   ├── tests/                 # Pytest tests (16 tests)
│   └── Dockerfile
│
├── mobile/                    # Flutter mobile app
│   ├── lib/
│   │   ├── core/              # Theme, router, network client, constants
│   │   ├── data/              # Models, datasources, repository implementations
│   │   ├── domain/            # Entities, repository interfaces, use cases
│   │   ├── presentation/      # BLoCs, pages, widgets
│   │   ├── injection.dart     # Dependency injection (GetIt)
│   │   └── main.dart          # App entry point
│   └── test/                  # Flutter BLoC tests (15 tests)
│
├── docker-compose.yml         # Multi-container orchestration
├── .env.example               # Environment template
└── .gitignore
```

---

## Prerequisites

- **Docker** >= 24.x & **Docker Compose V2** (docker compose plugin)
- **Node.js** >= 18.x (for local backend development)
- **Python** >= 3.11 (for local AI service development)
- **Flutter** >= 3.10 (for mobile app development)
- **Google Gemini API Key** - Get free at [Google AI Studio](https://aistudio.google.com/apikey)

### Installing Docker Compose V2

Modern Docker uses `docker compose` (V2 plugin) instead of the standalone `docker-compose` command.

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install docker-compose-v2
```

**Verify installation:**
```bash
docker compose version
```

> **Note:** If you have Docker Desktop installed, Docker Compose V2 is already included.

---

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/hongphuoc6104/LearnEnglish.git
cd LearnEnglish
```

### 2. Configure Environment Variables

```bash
# Copy the example env file
cp .env.example .env

# Edit with your values
nano .env
```

**Required variables:**
| Variable | Description |
|----------|-------------|
| `JWT_SECRET` | Secret key for JWT token signing (use a strong random string) |
| `GEMINI_API_KEY` | Your Google Gemini API key from [Google AI Studio](https://aistudio.google.com/apikey) |

### 3. Option A: Run with Docker Compose (Recommended)

```bash
# Build and start all services
docker compose up --build -d

# Check service status
docker compose ps

# View logs
docker compose logs -f

# Stop all services
docker compose down
```

Services will be available at:
| Service | URL |
|---------|-----|
| Backend API | http://localhost:3000 |
| AI Service | http://localhost:8000 |
| AI Docs (Swagger) | http://localhost:8000/docs |
| MongoDB | localhost:27017 |

### 3. Option B: Run Locally (Without Docker)

**Start MongoDB:**
```bash
# Using Docker for MongoDB only
docker run -d --name mongodb -p 27017:27017 mongo:7
```

**Start Backend:**
```bash
cd backend
npm install
npm start              # Production
npm run dev            # Development with hot-reload
```

**Start AI Service:**
```bash
cd ai-service
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

### 4. Seed Database

```bash
cd backend
npm run seed
```

This creates:
- 1 Course (English Basics)
- 3 Units (Greetings & Introductions, Daily Life, Travel & Directions)
- 8 Lessons with 27 Challenges (reading, speaking, writing, listening, mixed)

### 5. Create Test Account (Optional)

```bash
cd backend
npm run seed:test
```

This creates a special test account with all features unlocked (see [Test Account](#test-account) section).

### 6. Run Flutter Mobile App

```bash
cd mobile
flutter pub get
flutter run
```

> **Note:** The API base URL is configured in `lib/core/constants/api_constants.dart`:
> - **Web browser:** `http://localhost:3000` (auto-detected)
> - **Android Emulator:** `http://10.0.2.2:3000` (auto-detected)
> - **iOS Simulator:** `http://localhost:3000`
> - **Physical Device:** Change to `http://YOUR_LOCAL_IP:3000`

---

## Test Account

A special test account is available for testing all features without needing to complete lessons first.

**Create the account:**
```bash
cd backend
npm run seed:test
```

**Credentials:**
| Field | Value |
|-------|-------|
| Email | `tester@learnapp.com` |
| Password | `Test@123456` |

**Account features:**
- 5000 XP (Level 11)
- 5/5 Hearts
- 30-day streak
- All lessons marked as completed
- All challenges unlocked
- Full access to Speaking, Writing, and all lesson types

> This account is designed for QA testing. You can log in directly from the app login screen.

---

## Running Tests

```bash
# Backend tests (31 tests)
cd backend && npm test

# AI Service tests (16 tests)
cd ai-service
python3 -m venv .venv
source .venv/bin/activate
pytest

# Flutter tests (15 tests)
cd mobile && flutter test
```

---

## API Documentation

### Backend Endpoints

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| POST | `/api/auth/register` | Register new user | No |
| POST | `/api/auth/login` | Login | No |
| GET | `/api/auth/profile` | Get user profile | Yes |
| GET | `/api/courses` | List all courses | Yes |
| GET | `/api/courses/:id` | Get course by ID | Yes |
| GET | `/api/courses/:id/units` | Get course units with lessons | Yes |
| GET | `/api/lessons/:id` | Get lesson by ID with challenges | Yes |
| GET | `/api/lessons/:id/challenges` | Get lesson challenges | Yes |
| POST | `/api/progress/submit-answer` | Submit challenge answer | Yes |
| GET | `/api/progress/course/:courseId` | Get user progress for a course | Yes |
| POST | `/api/progress/refill-hearts` | Refill hearts (costs 50 XP) | Yes |
| GET | `/api/leaderboard` | Get leaderboard (top users by XP) | Yes |

### AI Service Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/health` | Health check |
| POST | `/analyze-speech` | Analyze pronunciation (multipart: audio file + target_text) |
| POST | `/correct-writing` | AI writing correction (JSON: text + context) |
| POST | `/generate-quiz` | AI quiz generation (JSON: topic, type, count, difficulty) |

Full interactive API docs available at: `http://localhost:8000/docs`

---

## Environment Variables

### Root `.env` (Docker Compose)

| Variable | Default | Description |
|----------|---------|-------------|
| `JWT_SECRET` | - | **Required.** JWT signing secret |
| `GEMINI_API_KEY` | - | **Required.** Google Gemini API key |
| `MONGO_URI` | `mongodb://mongo:27017/learn_english` | MongoDB connection string |
| `WHISPER_MODEL` | `base` | Whisper model size (`tiny`, `base`, `small`, `medium`) |

### Backend `.env`

| Variable | Default | Description |
|----------|---------|-------------|
| `PORT` | `3000` | Server port |
| `MONGO_URI` | `mongodb://localhost:27017/learn_english` | MongoDB URI |
| `JWT_SECRET` | - | JWT secret key |
| `JWT_EXPIRES_IN` | `7d` | JWT token expiration |
| `AI_SERVICE_URL` | `http://localhost:8000` | AI service URL |
| `NODE_ENV` | `development` | Node environment |

### AI Service `.env`

| Variable | Default | Description |
|----------|---------|-------------|
| `GEMINI_API_KEY` | - | Google Gemini API key |
| `GEMINI_MODEL` | `gemini-2.5-flash` | Gemini model to use |
| `AI_PROVIDER` | `GEMINI` | AI provider (`GEMINI` or `LOCAL`) |
| `AI_SERVICE_PORT` | `8000` | AI service port |

---

## Gamification System

| Feature | Details |
|---------|---------|
| **XP** | +10 per correct answer, +50 per completed lesson |
| **Hearts** | Start with 5, -1 per wrong answer, refill costs 50 XP |
| **Streaks** | Daily activity tracking, consecutive day counting |
| **Levels** | Level = (Total XP / 500) + 1 |
| **Leaderboard** | Ranked by total XP, shows level and streak |

---

## User Guide

### Getting Started
1. **Register** - Create an account with email and password from the login screen
2. **Browse Courses** - The home screen displays available courses
3. **Learn** - Tap a course to see the learning map with all units and lessons

### Lesson Types
| Type | Description |
|------|-------------|
| **Reading** | Multiple-choice and fill-in-the-blank challenges |
| **Speaking** | Hold the mic button and speak the target sentence |
| **Writing** | Write text that gets checked by AI for grammar and spelling |
| **Listening** | Listen to audio and answer questions |
| **Mixed** | Combination of all types |

### Challenge Types
- **SELECT** - Choose the correct answer from multiple options
- **FILL_BLANK** - Fill in the missing word in a sentence
- **ASSIST** - Translate a word or phrase
- **SPEAK** - Record yourself saying a sentence
- **WRITE** - Write a sentence checked by AI
- **LISTEN** - Answer based on audio
- **ARRANGE** - Put words in the correct order

### Navigation
- **Home** - Course list with your stats (XP, hearts, streak)
- **Learning Map** - Visual path of lessons in a course
- **Profile** - Your stats: level, XP, streak, hearts
- **Leaderboard** - Ranking of all users by XP (pull down to refresh)
- **Menu drawer** - Access Profile, Leaderboard, and Logout

### Tips
- Wrong answers cost 1 heart. When hearts reach 0, you need to refill (costs 50 XP)
- Complete lessons to earn XP and unlock the next lessons
- Maintain a daily streak by practicing every day

---

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## License

This project is licensed under the MIT License.

---

<p align="center">
  Built with &#10084; by <a href="https://github.com/hongphuoc6104">hongphuoc6104</a>
</p>
