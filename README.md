# Accident Detection System

An AI-powered road safety system that uses Computer Vision, GPS tracking, and real-time monitoring to detect road hazards, estimate collision risk, and provide live alerts.

---

# Overview

The Accident Detection System continuously monitors road environments using a mobile camera and AI-based object detection.

It uses:
- DroidCam for live video streaming from Android
- YOLOv8 for object detection
- OpenCV for image processing and tracking
- FastAPI for backend APIs
- Flutter for mobile application
- GPS for real-time location tracking

The system detects vehicles, pedestrians, and animals, estimates distance, classifies risk levels, and provides real-time alerts.

---

# Key Features

## Real-Time Object Detection
- Detects vehicles, pedestrians, and animals
- Processes live video stream
- Uses YOLOv8 for detection
- Tracks objects across frames

## Collision Risk Assessment
- Estimates distance from camera
- Risk levels:
  - Safe
  - Warning
  - Danger

## GPS Tracking
- Real-time location tracking
- Sends coordinates to backend
- Supports navigation awareness

## Live Dashboard
- Shows detected objects
- Displays collision status
- Shows GPS data
- Real-time updates

## Mobile App (Flutter)
- Live monitoring interface
- Alerts and notifications
- Simple UI for users

---

# Technology Stack

Frontend:
- Flutter
- Dart

Backend:
- FastAPI
- Python

AI / Computer Vision:
- YOLOv8
- OpenCV

Communication:
- REST APIs
- JSON

---

# System Architecture

Mobile Camera + GPS
        ↓
     DroidCam
        ↓
   Video Stream
        ↓
   FastAPI Backend
        ↓
 -------------------------
 |         |            |
YOLO    Distance       GPS
Detection Analysis   Tracking
 -------------------------
        ↓
   Risk Assessment
        ↓
   Flutter App

---

# Project Structure

Accident_Prevention_System/
│
├── Frontend/
├── Backend/
│   ├── app/
│   ├── models/
│   ├── requirements.txt
│   └── main.py
└── README.md

---

# Setup Instructions

## Backend

cd Backend  
python -m venv venv  

Windows:
venv\Scripts\activate  

Linux/macOS:
source venv/bin/activate  

pip install -r requirements.txt  

uvicorn app.main:app --reload --host 0.0.0.0 --port 8000  

Backend runs at:
http://localhost:8000  

API Docs:
http://localhost:8000/docs  

---

## Frontend

cd Frontend  
flutter pub get  
flutter run  

---

## DroidCam Setup

Install DroidCam on phone and PC.

Ensure both devices are on same WiFi network.

Stream URL:
http://YOUR_PHONE_IP:4747/video  

---

## Required Configuration

Backend URL (Frontend):
http://YOUR_SERVER_IP:8000  

DroidCam Stream:
http://YOUR_PHONE_IP:4747/video  

Alert Service:
http://YOUR_SERVER_IP:5000/alert  

---

# Detection Settings

FRAME_W = 640  
FRAME_H = 480  
CONFIDENCE = 0.25  
FOCAL_LENGTH = 700  
DANGER_DIST = 4  
WARNING_DIST = 8  
MAX_TRACK_DIST = 60  
MAX_LOST = 10  

---

# Risk Levels

| Distance | Risk |
|----------|------|
| ≤ 4 m    | Danger |
| ≤ 8 m    | Warning |
| > 8 m    | Safe |

---

# Supabase

- Uses anon key (safe for frontend)
- Security handled using Row Level Security (RLS)
- Users can create their own Supabase project if required

---

# Troubleshooting

## Video Not Working
- Check DroidCam IP
- Ensure same WiFi connection

## Backend Not Working
- Activate virtual environment
- Check model path

## API Issues
- Verify backend IP in frontend

---

# Future Improvements

- ADAS system
- Smart speed prediction
- Cloud dashboard
- Multi-camera support
- Emergency alert system

---

# License

This project is for educational and research purposes only.

---

# Authors

Built using Flutter, FastAPI, YOLOv8, OpenCV, GPS tracking, and real-time collision detection.