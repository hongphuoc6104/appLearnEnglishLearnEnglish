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
- [Running Tests](#running-tests)
- [API Documentation](#api-documentation)
- [Environment Variables](#environment-variables)
- [Contributing](#contributing)
- [License](#license)

---

## Features

- **Interactive Lessons** - Multiple-choice, fill-in-the-blank, and translation challenges
- **AI Writing Correction** - Real-time grammar and spelling feedback powered by Google Gemini
- **Pronunciation Practice** - Speech analysis using OpenAI Whisper STT with word-level accuracy scoring
- **AI Quiz Generation** - Dynamic quiz creation based on topics and difficulty levels
- **Gamification System** - XP points, hearts, streaks, and level progression
- **Leaderboard** - Compete with other learners
- **User Authentication** - Secure JWT-based authentication with bcrypt password hashing
- **Progress Tracking** - Track completed lessons, scores, and learning history

---

## Architecture

```
┌─────────────────┐     ┌──────────────────┐     ┌──────────────────┐
│   Flutter App    │────▶│  Node.js Backend │────▶│   MongoDB        │
│   (Mobile)       │     │  (REST API)      │     │   (Database)     │
└─────────────────┘     └────────┬─────────┘     └──────────────────┘
                                 │
                                 ▼
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
| Mobile App | Flutter 3.x, Dart, BLoC, Clean Architecture |
| Backend API | Node.js, Express.js, Mongoose ODM |
| AI Service | Python, FastAPI, Google Gemini, OpenAI Whisper |
| Database | MongoDB 7 |
| Auth | JWT + bcrypt |
| Container | Docker & Docker Compose |

---

## Project Structure

```
LearnEnglish/
├── backend/                    # Node.js REST API
│   ├── src/
│   │   ├── config/             # Environment configuration
│   │   ├── controllers/        # Request handlers
│   │   ├── middleware/         # Auth, validation, error handling
│   │   ├── models/            # Mongoose schemas
│   │   ├── routes/            # API route definitions
│   │   ├── services/          # Business logic
│   │   ├── utils/             # Utilities (ApiError, asyncHandler)
│   │   └── validators/        # Input validation rules
│   ├── seed/                  # Database seed data
│   ├── tests/                 # Jest + Supertest tests
│   └── Dockerfile
│
├── ai-service/                # Python AI microservice
│   ├── app/
│   │   ├── routers/           # FastAPI route handlers
│   │   ├── schemas/           # Pydantic models
│   │   ├── services/          # AI service logic
│   │   └── utils/             # Prompt templates
│   ├── tests/                 # Pytest tests
│   └── Dockerfile
│
├── mobile/                    # Flutter mobile app
│   ├── lib/
│   │   ├── core/              # Theme, router, network, constants
│   │   ├── data/              # Models, datasources, repositories
│   │   ├── domain/            # Entities, repository interfaces, usecases
│   │   ├── presentation/      # BLoCs, pages, widgets
│   │   ├── injection.dart     # Dependency injection
│   │   └── main.dart          # App entry point
│   └── test/                  # Flutter BLoC tests
│
├── docker-compose.yml         # Multi-container orchestration
├── .env.example               # Environment template
└── .gitignore
```

---

## Prerequisites

- **Docker** >= 20.x & **Docker Compose** >= 2.x
- **Node.js** >= 18.x (for local backend development)
- **Python** >= 3.11 (for local AI service development)
- **Flutter** >= 3.x (for mobile app development)
- **Google Gemini API Key** - Get free at [Google AI Studio](https://aistudio.google.com/apikey)

---

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/hongphuoc6104/appLearnEnglishLearnEnglish.git
cd appLearnEnglishLearnEnglish
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
| `GEMINI_API_KEY` | Your Google Gemini API key |

### 3. Option A: Run with Docker Compose (Recommended)

```bash
# Build and start all services
docker compose up --build -d

# Check service status
docker compose ps

# View logs
docker compose logs -f
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
cp .env.example .env   # Configure your .env
npm install
npm start              # Production
npm run dev            # Development with hot-reload
```

**Start AI Service:**
```bash
cd ai-service
cp .env.example .env   # Configure your .env
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
- 3 Units (Greetings, Daily Life, Travel)
- 8 Lessons with 27 Challenges

### 5. Run Flutter Mobile App

```bash
cd mobile
flutter pub get
flutter run
```

> **Note:** Update the API base URL in `lib/core/constants/api_constants.dart`:
> - Android Emulator: `http://10.0.2.2:3000`
> - iOS Simulator: `http://localhost:3000`
> - Physical Device: `http://YOUR_LOCAL_IP:3000`

---

## Running Tests

```bash
# Backend tests (31 tests)
cd backend && npm test

# AI Service tests (16 tests)
cd ai-service
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
| GET | `/api/courses/:id/units` | Get course units with lessons | Yes |
| GET | `/api/courses/lessons/:id/challenges` | Get lesson challenges | Yes |
| POST | `/api/progress/submit` | Submit challenge answer | Yes |
| GET | `/api/progress/me` | Get user progress | Yes |
| POST | `/api/progress/hearts/refill` | Refill hearts (costs 50 XP) | Yes |

### AI Service Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/health` | Health check |
| POST | `/analyze-speech` | Analyze pronunciation (multipart: audio + target_text) |
| POST | `/correct-writing` | AI writing correction |
| POST | `/generate-quiz` | AI quiz generation |

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
| `MONGO_URI` | `mongodb://localhost:27017/learnenglish` | MongoDB URI |
| `JWT_SECRET` | - | JWT secret key |
| `AI_SERVICE_URL` | `http://localhost:8000` | AI service URL |

### AI Service `.env`

| Variable | Default | Description |
|----------|---------|-------------|
| `GEMINI_API_KEY` | - | Google Gemini API key |
| `GEMINI_MODEL` | `gemini-2.5-flash` | Gemini model to use |
| `AI_PROVIDER` | `GEMINI` | AI provider (`GEMINI` or `LOCAL`) |

---

## Gamification System

| Feature | Details |
|---------|---------|
| **XP** | +10 per correct answer, +50 per completed lesson |
| **Hearts** | Start with 5, -1 per wrong answer, refill costs 50 XP |
| **Streaks** | Daily activity tracking |
| **Levels** | Level = (Total XP / 500) + 1 |
| **Leaderboard** | Ranked by total XP |

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
  Built with by <a href="https://github.com/hongphuoc6104">hongphuoc6104</a>
</p>
