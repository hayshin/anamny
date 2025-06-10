# TODO.md for Anamny - Health Tracker App (Expo + FastAPI)

## Tech Stack Summary
- Frontend: Expo (React Native), TypeScript
- Backend: FastAPI (Python), PostgreSQL
- Auth: JWT + OAuth2 (optional Google/Apple login later)
- File Storage: S3/Backblaze (second is more preferrable, but for compability we will use S3 API)
- AI: Use [Agent Development Kit](https://github.com/google/adk-python/) with Gemini API

## Core Features

### 1. Authentication & User Management
#### Backend (FastAPI)
- [ ] JWT Authentication
  - `/auth/register` (email, password, username)
  - `/auth/login` (email, password → returns JWT)
  - `/auth/forgot-password` (email → sends reset link)
  - `/auth/reset-password` (token, new password)
- [ ] User Profile Endpoints
  - `GET /profile` (fetch user data)
  - `PATCH /profile` (update name, age, gender, blood type)

#### Frontend (Expo - React Native)
- [ ] Screens
  - Sign Up / Login (form validation)
  - Forgot Password flow
  - Profile Settings
- [ ] State Management
  - Store JWT in secure storage (Expo SecureStore)
  - Context/Redux for user session

---

### 2. AI Chat & Symptom Analysis
#### Backend (FastAPI + AI Integration)
- [ ] Chat Endpoints
  - `POST /chat/send` (user message → AI response)
  - `GET /chat/history` (fetch past conversations)
- [ ] AI Suggestions
  - Integrate OpenAI API (GPT-4/MedPaLM if available)
  - Cache common symptom-diagnosis pairs

#### Frontend (Expo - React Native)
- [ ] UI Components
  - Chat interface (message bubbles, typing indicator)
  - Suggested quick-reply buttons (e.g., "Headache," "Fever")
  - Loading state for AI response
- [ ] State Management
  - Store chat history locally (SQLite or AsyncStorage)

---

### 3. Medical Records Management
#### Backend (FastAPI + File Storage)
- [ ] File Upload Endpoints
  - `POST /records/upload` (PDF/image → store in S3/Backblaze)
  - `GET /records` (list all user records)
  - `DELETE /records/{id}`
- [ ] OCR Processing
  - Use Tesseract.js or Google Vision API for text extraction

#### Frontend (Expo - React Native)
- [ ] UI Components
  - File/image upload (Expo ImagePicker/DocumentPicker)
  - Gallery view of medical records
  - Search/filter by date, type
  - Text extraction preview

---

### 4. Health Tracking & Reminders
#### Backend (FastAPI)
- [ ] Reminder Endpoints
  - `POST /reminders` (medication/appointment)
  - `GET /reminders` (upcoming reminders)
  - `DELETE /reminders/{id}`

#### Frontend (Expo - React Native)
- [ ] UI Components
  - Add/edit reminders (datetime picker)
  - Push notifications (Expo Notifications)
  - Calendar view for appointments

---

## UI/UX Tasks (Expo - React Native)
### General
- [ ] Theme & Styling
  - Consistent color scheme (healthcare blues/whites)
  - Custom fonts (e.g., Inter or SF Pro)
- [ ] Navigation
  - Tab-based (Home, Chat, Records, Profile)
  - Stack navigation for auth flow
- [ ] Animations
  - Smooth transitions between screens
  - Loading spinners/Skeleton placeholders

### Screens
- [ ] Onboarding (brief app intro)
- [ ] Dashboard (summary of recent records, AI suggestions)
- [ ] Chat Screen (message list, input bar with attachment option)
- [ ] Records Gallery (thumbnails, search bar)
- [ ] Reminders List (grouped by date)

---

## Security & Compliance
- [ ] Backend
  - Rate-limiting on auth endpoints
  - JWT expiration (short-lived access token + refresh token)
- [ ] Frontend
  - Encrypted storage for sensitive data
  - Biometric auth (FaceID/TouchID)

---

## Future Considerations
- Telemedicine API (Zoom/Google Meet integration)
- Wearable Sync (Apple Health/Google Fit)
- Multi-language Support (i18n)

---


Would you like me to break down any section further (e.g., specific API schemas or Expo package recommendations)?
