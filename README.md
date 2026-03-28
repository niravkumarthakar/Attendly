# 🎓 Attendly - AI-Powered Attendance System

<div align="center">

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Flask](https://img.shields.io/badge/Flask-000000?style=for-the-badge&logo=flask&logoColor=white)](https://flask.palletsprojects.com/)
[![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://python.org)

**Smart attendance tracking with AI-powered facial recognition**

</div>

## 📋 Overview

Attendly is an AI-powered attendance management system for educational institutions. It combines **ArcFace facial recognition** with a **Flutter mobile app** and **Flask backend** to streamline attendance tracking through automated photo recognition.

## ✨ Features

- 🤖 **AI Face Recognition**: ArcFace technology with 512D embeddings for accurate student identification
- 📱 **Mobile App**: Flutter-based mobile application for teachers and students
- 👥 **Role-based System**: Separate interfaces for teachers and students
- 🏫 **Class Management**: Create classes, generate join codes, manage enrollments
- 📸 **Photo Attendance**: Bulk attendance marking through classroom photos
- 📊 **Analytics Dashboard**: Real-time attendance reports and analytics
- 🔐 **Secure Authentication**: JWT-based authentication with role permissions

## 🛠️ Tech Stack

### Frontend (Flutter)

- **Framework**: Flutter 3.9.2+
- **Language**: Dart
- **State Management**: Provider
- **UI**: Material Design 3
- **Camera**: Image capture and processing
- **Storage**: Secure local storage

### Backend (Flask)

- **Framework**: Flask 2.3.3
- **Language**: Python 3.8+
- **Database**: SQLAlchemy ORM (SQLite/PostgreSQL)
- **Authentication**: JWT tokens
- **AI/ML**: InsightFace, OpenCV, NumPy
- **Vector DB**: ChromaDB for similarity search

## 📁 Project Structure

```
attendly/
├── Frontend/attendly/          # Flutter mobile app
│   ├── lib/
│   │   ├── screens/           # UI screens
│   │   ├── providers/         # State management
│   │   ├── services/          # API services
│   │   └── models/            # Data models
│   └── pubspec.yaml
└── Backend/                   # Flask API server
    ├── app.py                 # Main application
    ├── models/models.py       # Database models
    ├── routes/                # API endpoints
    │   ├── auth.py           # Authentication
    │   ├── classes.py        # Class management
    │   ├── face_data.py      # Face data handling
    │   └── attendance.py     # Attendance tracking
    ├── services/             # Business logic
    │   ├── arcface_service.py
    │   └── vector_db.py
    └── requirements.txt
```

## 🚀 Installation

### Prerequisites

- Python 3.8+
- Flutter SDK 3.9.2+
- Git

### Backend Setup

```bash
cd Backend

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run the server
python app.py
```

### Frontend Setup

```bash
cd Frontend/attendly

# Install dependencies
flutter pub get

# Run the app
flutter run
```

## 📱 Usage

### For Teachers

1. **Sign up** as a teacher
2. **Create classes** and generate join codes
3. **Create attendance sessions** for each class
4. **Take classroom photos** for automated attendance
5. **View reports** and analytics

### For Students

1. **Register** with student role
2. **Upload face photos** (2-5 images for better accuracy)
3. **Join classes** using 6-digit codes
4. **View attendance** records and history

## 🔧 API Endpoints

```
Authentication:
POST /api/auth/signup
POST /api/auth/login
GET  /api/auth/profile

Classes:
POST /api/classes/create
POST /api/classes/join
GET  /api/classes/my-classes

Face Data:
POST /api/face-data/upload
POST /api/face-data/recognize

Attendance:
POST /api/attendance/sessions
POST /api/attendance/photo-recognition
GET  /api/attendance/reports/{session_id}
```

## 🔐 Security

- JWT token-based authentication
- Role-based access control (Teacher/Student)
- Password hashing with bcrypt
- Input validation and sanitization
- CORS protection

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

## 🤝 Collaborators

1. Niravkumar Thakar
2. Yashkumar Fadadu
3. Krutarth Pota

---

<div align="center">

**Built with ❤️ for educational institutions**

</div>
