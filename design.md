# Anamny App

Anamny is an application for iOS, Android and Web. It is a tracker of your health - store your tests, research results, ultrasound, X-rays in one place. Talk to Artificial Intelligence, specially sharpened for detection of diseases, to understand what is wrong with you based on your symptoms. Referring to your medical history and research results, it will find the most probable causes in the form of diseases, referring to the necessary sources. Find out which doctor you need and what probable treatment you need, as well as its cost. Keep your medical history in one place.

## Basic Features

### 1. Ai Chat & Symptom Analysis

  - Chat interface for describing symptoms and your assumptions.
  - AI-powered suggestions for:
    - Possible conditions
    - Recommended specialists to visit
    - Next diagnostic steps (tests, scans, etc.)
  - Conversation history storage.

### 2. Medical Records Management

  - File/Image upload support (PDFs, scans, photos of reports).
  - OCR for extracting text from images. (firstly using LLM)
  - Categorization by date, type etc.
  - Lab test results
  - Doctor visit summaries
  - Presribed medications

### 3. Health Tracking & Reminders

  - Medication reminders
  - Appoinment scheduling & notifications
  - Periodic health check-up suggestions

## Advanced Features

### Data Sharing & Collaboration

  - Secure sharing with doctors
  - Exporting records
  - Emergency access mode

### AI Enchancements

  - Integrations with services (medical databases, hospitals)
  - Predict health insights based on trends
  - Files & images vector embeddings for better search abilities

### Family health

  - Add relatives as family
  - See changes of health of them
  - Get notifications about them
  - Medical history of your close relatives will be taken into account

### Security

  - HIPAA/GDPR
  - End-to-end encryption
  - Local backups

## Future Features

  - Device integrations
  - Telemedicine API connections
  - Aids/treatments API connection (for costs and buying)
  - Alerts about epidemics

## Tech Stack Summary
- Frontend: Expo (React Native), TypeScript
- Backend: FastAPI (Python), PostgreSQL
- Auth: JWT + OAuth2 (optional Google/Apple login later)
- File Storage: S3/Backblaze (second is more preferrable, but for compability we will use S3 API)
- AI: Use [Agent Development Kit](https://github.com/google/adk-python/) with Gemini API
- Real-time: WebSockets (for chat)

## Deployment

- Frontend: Expo EAS (or App Store/ Play Store)
- Backend: Docker + AWS EC2
- Database: PostgreSQL (AWS RDS or Supabase)

## API Endpoints



