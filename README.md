# Anamny Health Tracker

A full-stack health tracking application built with FastAPI (backend) and Expo React Native (frontend), containerized with Docker.

## 🏗️ Architecture

- **Backend**: FastAPI + PostgreSQL + Alembic (Database Migrations)
- **Frontend**: Expo React Native (Web/Mobile)
- **Database**: PostgreSQL 15
- **Authentication**: JWT tokens with secure storage
- **Containerization**: Docker & Docker Compose

## 🚀 Quick Start

### Prerequisites

- Docker and Docker Compose installed
- Node.js 18+ (for local development)
- Python 3.11+ (for local development)

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
- [x] **Database Models**: User and PasswordResetToken tables
- [x] **CRUD Operations**: Complete user management API
- [x] **Health Check Endpoints**: Database connectivity monitoring

#### 📱 Frontend & UX
- [x] **Expo React Native**: Cross-platform mobile/web application
- [x] **Modern UI Design**: Clean, healthcare-themed interface
- [x] **Responsive Layout**: Works on web, iOS, and Android
- [x] **Form Validation**: Client-side input validation with react-hook-form
- [x] **Navigation**: Tab-based navigation (Home, Chat, Profile)
- [x] **State Management**: React Context for global authentication state
- [x] **Error Handling**: User-friendly error messages and loading states
- [x] **Secure Storage**: Platform-appropriate token storage

#### 🐳 DevOps & Infrastructure
- [x] **Docker Containerization**: Both frontend and backend containerized
- [x] **Docker Compose**: Multi-service orchestration
- [x] **Environment Configuration**: Separate configs for development/production
- [x] **Database Persistence**: PostgreSQL data volumes
- [x] **Hot Reload**: Development-friendly auto-reload
- [x] **Health Checks**: Container health monitoring

### 🚧 Not Yet Implemented

#### CI/CD Pipeline
- [ ] **GitHub Actions**: Automated testing and deployment
- [ ] **Automated Testing**: Unit and integration tests
- [ ] **Production Deployment**: Cloud deployment configuration

#### Advanced Features
- [ ] **Password Reset Email**: Email-based password recovery
- [ ] **Health Data Tracking**: Core health metrics functionality
- [ ] **Data Visualization**: Charts and graphs for health data
- [ ] **Social Features**: Chat functionality (UI ready, backend pending)

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
│   │   ├── database.py        # Database configuration
│   │   ├── config.py          # Settings management
│   │   └── main.py           # FastAPI application
│   ├── alembic/              # Database migrations
│   ├── docker-compose.yml    # Backend services
│   ├── Dockerfile            # Backend container
│   └── requirements.txt      # Python dependencies
├── client/                    # Expo React Native Frontend
│   ├── app/                   # App routes and screens
│   │   ├── (tabs)/           # Tab navigation screens
│   │   ├── auth/             # Authentication screens
│   │   └── _layout.tsx       # Root layout
│   ├── contexts/             # React contexts
│   ├── services/             # API services
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

### Health Check
- `GET /` - API health check