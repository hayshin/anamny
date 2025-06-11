# Anamny Health Tracker

A full-stack health tracking application built with FastAPI (backend) and Expo React Native (frontend), containerized with Docker.

## 🏗️ Architecture

- **Backend**: FastAPI + PostgreSQL + Alembic (Database Migrations)
- **Frontend**: Expo React Native (Web/Mobile)
- **Database**: PostgreSQL 15
- **AI Engine**: Google Gemini AI via Agno framework
- **Authentication**: JWT tokens with secure storage
- **Containerization**: Docker & Docker Compose

## 🚀 Quick Start

### Prerequisites

- Docker and Docker Compose installed
- Node.js 18+ (for local development)
- Python 3.11+ (for local development)
- Google Gemini API key (for AI chat functionality)

### Setup Environment Variables

Before running the application, you need to set up your environment variables:

1. **Backend Environment**: Create a `.env` file in the `server/` directory:

```bash
# Navigate to server directory
cd server

# Create .env file with your Gemini API key
echo "GEMINI_API_KEY=your_gemini_api_key_here" > .env
```

Get your Gemini API key from [Google AI Studio](https://aistudio.google.com/app/apikey).

### Clone repo


```bash
git clone --recurse-submodules https://github.com/hayshin/anamny.git
cd anamny
```

### Running with Docker

The project consists of two separate Docker Compose setups:

#### 1. Backend + Database (Server)

```bash
# Navigate to server directory
cd server

# Start backend services
docker compose up --build

# This will start:
# - PostgreSQL database on localhost:5432
# - FastAPI backend on localhost:8000
```

#### 2. Frontend (Client)

```bash
# Navigate to client directory  
cd client

# Start frontend service
docker compose up --build

# This will start:
# - Expo development server on localhost:8081
```

### Accessing the Application

- **Frontend Web**: http://localhost:8081
- **Backend API**: http://localhost:8000
- **API Documentation**: http://localhost:8000/docs (Swagger UI)
- **Database**: localhost:5432 (PostgreSQL)

## 🎯 What We've Implemented

### ✅ Completed Features

#### 🔐 Authentication & User Management
- [x] **User Registration**: Create new accounts with email/password
- [x] **User Login**: JWT-based authentication
- [x] **Password Security**: Bcrypt hashing for password storage
- [x] **Token Management**: JWT tokens with secure storage (SecureStore on mobile, localStorage on web)
- [x] **Protected Routes**: Authentication guards for sensitive pages
- [x] **User Profile**: View and update personal information (name, age, gender, blood type)
- [x] **Logout Functionality**: Secure session termination

#### 🤖 AI Chat Functionality
- [x] **AI Health Assistant**: Powered by Google Gemini AI
- [x] **Medical Consultation**: AI provides health advice and recommendations
- [x] **Chat Sessions**: Persistent conversation history
- [x] **Session Management**: Create, view, and delete chat sessions
- [x] **Real-time Responses**: Fast AI-powered health consultations
- [x] **Medical Disclaimers**: Proper warnings about AI limitations
- [x] **Error Handling**: Graceful handling of AI service failures

#### 🛡️ Security Features
- [x] **Secured Endpoints**: JWT token validation for protected routes
- [x] **CORS Configuration**: Proper cross-origin resource sharing setup
- [x] **Input Validation**: Pydantic schemas for request/response validation
- [x] **Environment Variables**: Secure configuration management
- [x] **Password Reset Tokens**: Database schema ready (implementation pending)

#### 🗄️ Database & Backend
- [x] **PostgreSQL Database**: Fully containerized database setup
- [x] **Database Migrations**: Alembic for schema version control
- [x] **FastAPI Backend**: RESTful API with automatic documentation
- [x] **SQLAlchemy ORM**: Type-safe database operations
- [x] **Database Models**: User, PasswordResetToken, ChatSession, and ChatMessage tables
- [x] **CRUD Operations**: Complete user management and chat API
- [x] **Health Check Endpoints**: Database connectivity monitoring
- [x] **AI Integration**: Google Gemini API integration with Agno framework

#### 📱 Frontend & UX
- [x] **Expo React Native**: Cross-platform mobile/web application
- [x] **Modern UI Design**: Clean, healthcare-themed interface
- [x] **Responsive Layout**: Works on web, iOS, and Android
- [x] **Form Validation**: Client-side input validation with react-hook-form
- [x] **Navigation**: Tab-based navigation (Home, Chat, Profile)
- [x] **State Management**: React Context for global authentication state
- [x] **Error Handling**: User-friendly error messages and loading states
- [x] **Secure Storage**: Platform-appropriate token storage
- [x] **Chat Interface**: Real-time chat UI with message history
- [x] **Suggested Questions**: Quick-start prompts for health consultations

#### 🐳 DevOps & Infrastructure
- [x] **Docker Containerization**: Both frontend and backend containerized
- [x] **Docker Compose**: Multi-service orchestration
- [x] **Environment Configuration**: Separate configs for development/production
- [x] **Database Persistence**: PostgreSQL data volumes
- [x] **Hot Reload**: Development-friendly auto-reload
- [x] **Health Checks**: Container health monitoring

### 🚧 Not Yet Implemented

#### Advanced Health Features
- [ ] **Health Data Tracking**: Core health metrics functionality
- [ ] **Data Visualization**: Charts and graphs for health data
- [ ] **Medical Records**: Upload and manage medical documents
- [ ] **Medication Reminders**: Push notifications for medication schedules
- [ ] **Appointment Scheduling**: Integration with healthcare providers

#### Enhanced AI Features
- [ ] **Voice Chat**: Voice-to-text and text-to-voice functionality
- [ ] **Image Analysis**: AI analysis of medical images/photos
- [ ] **Symptom Tracking**: Historical symptom analysis and patterns
- [ ] **Health Insights**: Personalized health recommendations

#### CI/CD Pipeline
- [ ] **GitHub Actions**: Automated testing and deployment
- [ ] **Automated Testing**: Unit and integration tests
- [ ] **Production Deployment**: Cloud deployment configuration

#### Advanced Features
- [ ] **Password Reset Email**: Email-based password recovery
- [ ] **Multi-language Support**: Internationalization
- [ ] **Dark Mode**: Theme switching functionality

## 📂 Project Structure

```
anamny/
├── server/                     # FastAPI Backend
│   ├── src/
│   │   ├── auth/              # Authentication module
│   │   │   ├── api.py         # Auth endpoints
│   │   │   ├── models.py      # User models
│   │   │   ├── schemas.py     # Pydantic schemas
│   │   │   └── utils.py       # Auth utilities
│   │   ├── chat/              # AI Chat module
│   │   │   ├── api.py         # Chat endpoints
│   │   │   ├── models.py      # Chat session/message models
│   │   │   ├── schemas.py     # Chat Pydantic schemas
│   │   │   └── crud.py        # Chat operations & AI integration
│   │   ├── database.py        # Database configuration
│   │   ├── config.py          # Settings management
│   │   └── main.py           # FastAPI application
│   ├── alembic/              # Database migrations
│   ├── docker-compose.yml    # Backend services
│   ├── Dockerfile            # Backend container
│   ├── requirements.txt      # Python dependencies
│   └── .env                  # Environment variables (create this!)
├── client/                    # Expo React Native Frontend
│   ├── app/                   # App routes and screens
│   │   ├── (tabs)/           # Tab navigation screens
│   │   ├── auth/             # Authentication screens
│   │   └── _layout.tsx       # Root layout
│   ├── contexts/             # React contexts
│   ├── services/             # API services
│   │   ├── auth.ts           # Authentication API calls
│   │   └── chat.ts           # Chat API calls
│   ├── docker-compose.yml    # Frontend services
│   ├── Dockerfile            # Frontend container
│   └── package.json          # Node.js dependencies
└── README.md                 # This file
```

## 📊 API Endpoints

### Authentication
- `POST /auth/register` - User registration
- `POST /auth/login` - User login
- `GET /auth/profile` - Get user profile (protected)
- `PUT /auth/profile` - Update user profile (protected)

### AI Chat
- `POST /chat/message` - Send message to AI assistant (protected)
- `GET /chat/sessions` - Get user's chat sessions (protected)
- `GET /chat/sessions/{id}` - Get specific session history (protected)
- `POST /chat/sessions` - Create new chat session (protected)
- `DELETE /chat/sessions/{id}` - Delete chat session (protected)

### Health Check
- `GET /` - API health check
- `GET /health` - Detailed health status

## 🤖 AI Features

### Health Assistant Capabilities
- **Symptom Analysis**: Describe symptoms and get preliminary insights
- **Medical Guidance**: Receive recommendations for tests and specialists
- **Health Education**: Learn about medical conditions and prevention
- **Treatment Suggestions**: Get advice on managing health conditions

### Important Notes
- The AI provides **general information only** and should not replace professional medical advice
- Always consult with qualified healthcare providers for diagnosis and treatment
- The AI is powered by Google's Gemini model with specialized medical training