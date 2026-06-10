# 🚗 Accident Detection System

An AI-powered road safety system that uses Computer Vision, GPS tracking, and real-time monitoring to detect road hazards, estimate collision risk, and provide live alerts.

---

## 📖 Overview

The Accident Detection System continuously monitors road environments using a mobile camera and AI-based object detection.

The system combines:

* 📱 DroidCam for live video streaming
* 🤖 YOLOv8 for object detection
* 🎥 OpenCV for image processing and tracking
* ⚡ FastAPI for backend APIs
* 📲 Flutter for the mobile application
* 📍 GPS for real-time location tracking
* 🔐 Supabase Authentication for secure login and logout

The system detects vehicles, pedestrians, and animals, estimates their distance from the camera, classifies risk levels, and provides real-time alerts to users.

---
## 📸 Screenshots

### 🔐 Authentication
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/67611b08-fb50-4d8b-9605-3f6943241756" />


###📊 Dashboard
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/9d59c9dd-9a70-4dc2-8e17-618ea5e12e05" />


### 🚗 Live Object Detection
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/af1a8d84-36b8-4924-89f5-098ec0ee677e" />


### 🗺️ GPS Navigation & Tracking
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/371740ad-8a71-46b3-a166-110a74075e36" />



### ⚠️ Risk Alerts & Logs
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/b38f2a7b-c7c8-4108-ac22-eec70db1520b" />

---

## ✨ Key Features

### 🚘 Real-Time Object Detection

* Detects vehicles, pedestrians, and animals
* Processes live video streams
* Uses YOLOv8 for high-speed object detection
* Tracks objects across consecutive frames

### ⚠️ Collision Risk Assessment

* Estimates object distance from the camera
* Classifies collision risk levels:

  * Safe
  * Warning
  * Danger

### 📍 GPS Tracking

* Real-time location monitoring
* Sends GPS coordinates to backend services
* Supports location-aware safety analysis

### 📊 Live Dashboard

* Displays detected objects
* Shows collision risk status
* Displays GPS information
* Provides real-time updates

### 📱 Mobile Application

* Built with Flutter
* Live monitoring interface
* Alert notifications
* User-friendly UI

### 🔐 User Authentication

* User Registration (Sign Up)
* User Login
* User Logout
* Session Management
* Secure authentication using Supabase Auth

---

## 🛠 Technology Stack

### Frontend

* Flutter
* Dart

### Backend

* FastAPI
* Python

### AI / Computer Vision

* YOLOv8
* OpenCV

### Authentication & Database

* Supabase
* Supabase Authentication
* PostgreSQL

### Communication

* REST APIs
* JSON

---

## 🏗 System Architecture

```text
                    ┌─────────────────┐
                    │   Flutter App   │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │ Supabase Auth   │
                    │ Login / Logout  │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │ FastAPI Backend │
                    └────────┬────────┘
                             │
          ┌──────────────────┼──────────────────┐
          ▼                  ▼                  ▼
    YOLO Detection     Distance Analysis    GPS Tracking
          │                  │                  │
          └──────────────┬───┴──────────────────┘
                         ▼
                  Risk Assessment
                         │
                         ▼
                   Alert System
```

---

## 📂 Project Structure

```text
Accident_Prevention_System/
│
├── Frontend/
│
├── Backend/
│   ├── app/
│   ├── models/
│   ├── requirements.txt
│   └── main.py
│
└── README.md
```

---

## 🚀 Setup Instructions

### Backend Setup

Clone the repository:

```bash
git clone <repository-url>
cd Accident_Prevention_System
```

Create a virtual environment:

```bash
cd Backend
python -m venv venv
```

Activate the environment:

#### Windows

```bash
venv\Scripts\activate
```

#### Linux / macOS

```bash
source venv/bin/activate
```

Install dependencies:

```bash
pip install -r requirements.txt
```

Run the FastAPI server:

```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

Backend URL:

```text
http://localhost:8000
```

API Documentation:

```text
http://localhost:8000/docs
```

---

### Frontend Setup

```bash
cd Frontend

flutter pub get

flutter run
```

---

## 📹 DroidCam Setup

1. Install DroidCam on your Android device.
2. Install DroidCam Client on your PC.
3. Connect both devices to the same Wi-Fi network.
4. Start the DroidCam server.

Example video stream URL:

```text
http://YOUR_PHONE_IP:4747/video
```

---

## 🔐 Supabase Configuration

Create a Supabase project and enable Authentication.

Add the following configuration to your Flutter application:

```env
SUPABASE_URL=YOUR_SUPABASE_URL
SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY
```

### Authentication Features

* Email & Password Sign Up
* Email & Password Login
* User Session Management
* Secure Logout
* JWT-Based Authentication

### Security

* Supabase Authentication handles user identity
* Anonymous key is safe for frontend usage
* Row Level Security (RLS) protects database records
* Users can access only authorized data

---

## ⚙️ Required Configuration

### Backend URL

```text
http://YOUR_SERVER_IP:8000
```

### DroidCam Stream URL

```text
http://YOUR_PHONE_IP:4747/video
```

### Alert Service

```text
http://YOUR_SERVER_IP:5000/alert
```

---

## 🎯 Detection Settings

```python
FRAME_W = 640
FRAME_H = 480

CONFIDENCE = 0.25
FOCAL_LENGTH = 700

DANGER_DIST = 4
WARNING_DIST = 8

MAX_TRACK_DIST = 60
MAX_LOST = 10
```

---

## 🚨 Risk Levels

| Distance | Risk Level |
| -------- | ---------- |
| ≤ 4 m    | 🔴 Danger  |
| ≤ 8 m    | 🟠 Warning |
| > 8 m    | 🟢 Safe    |

---

## 📡 API Endpoints

| Method | Endpoint | Description      |
| ------ | -------- | ---------------- |
| GET    | /        | Health Check     |
| POST   | /detect  | Object Detection |
| GET    | /gps     | GPS Data         |
| POST   | /alert   | Alert Generation |

> Actual endpoints may vary based on implementation.

---

## 🛠 Troubleshooting

### Video Stream Not Working

* Verify DroidCam IP address
* Ensure both devices are on the same Wi-Fi network
* Check camera permissions

### Backend Not Running

* Activate the virtual environment
* Verify model file paths
* Check dependency installation

### Authentication Issues

* Verify Supabase URL
* Verify Supabase Anon Key
* Ensure Authentication is enabled in Supabase

### API Connection Issues

* Verify backend IP address
* Ensure backend server is running
* Check firewall/network settings

---

## 🔮 Future Improvements

* Advanced Driver Assistance System (ADAS)
* Smart speed prediction
* Cloud dashboard
* Multi-camera support
* Emergency response integration
* Driver behavior analysis
* Edge AI optimization

---

## 📜 License

This project is intended for educational and research purposes only.

---

## 👨‍💻 Authors

Developed using Flutter, FastAPI, YOLOv8, OpenCV, GPS tracking, Supabase Authentication, and real-time collision detection technologies.
