# 🚗 Accident Detection System

An AI-powered road safety system that uses Computer Vision, GPS tracking, and real-time monitoring to detect road hazards, estimate collision risk, and provide live alerts.

---

## 📖 Overview

The Accident Detection System continuously monitors road environments using a mobile camera and AI-based object detection.

### Technologies Used

* 📱 DroidCam for live video streaming from Android devices
* 🤖 YOLOv8 for object detection
* 🎥 OpenCV for image processing and object tracking
* ⚡ FastAPI for backend APIs
* 📲 Flutter for the mobile application
* 📍 GPS for real-time location tracking

The system detects vehicles, pedestrians, and animals, estimates distance, classifies risk levels, and provides real-time alerts.

---

## ✨ Key Features

### 🚘 Real-Time Object Detection

* Detects vehicles, pedestrians, and animals
* Processes live video streams
* Uses YOLOv8 for high-speed detection
* Tracks objects across frames

### ⚠️ Collision Risk Assessment

* Estimates object distance from the camera
* Classifies risk levels:

  * Safe
  * Warning
  * Danger

### 📍 GPS Tracking

* Real-time location tracking
* Sends coordinates to the backend
* Supports location-aware monitoring

### 📊 Live Dashboard

* Displays detected objects
* Shows collision status
* Displays GPS data
* Real-time updates

### 📱 Mobile App (Flutter)

* Live monitoring interface
* Alerts and notifications
* Simple and user-friendly UI

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

### Communication

* REST APIs
* JSON

---

## 🏗 System Architecture

```text
Mobile Camera + GPS
         │
         ▼
      DroidCam
         │
         ▼
    Video Stream
         │
         ▼
   FastAPI Backend
         │
 ┌───────┼────────┐
 ▼       ▼        ▼
YOLO  Distance   GPS
Detect Analysis Tracking
         │
         ▼
  Risk Assessment
         │
         ▼
    Flutter App
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

```bash
cd Backend

python -m venv venv
```

#### Windows

```bash
venv\Scripts\activate
```

#### Linux / macOS

```bash
source venv/bin/activate
```

#### Install Dependencies

```bash
pip install -r requirements.txt
```

#### Start Server

```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

Backend runs at:

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

1. Install DroidCam on both your phone and PC.
2. Connect both devices to the same Wi-Fi network.
3. Start the DroidCam server.

Video Stream URL:

```text
http://YOUR_PHONE_IP:4747/video
```

---

## ⚙️ Required Configuration

### Backend URL (Frontend)

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

## 🗄 Supabase

* Uses an anonymous key (safe for frontend usage)
* Security enforced through Row Level Security (RLS)
* Users can configure their own Supabase project if required

---

## 🛠 Troubleshooting

### Video Stream Not Working

* Verify DroidCam IP address
* Ensure both devices are on the same Wi-Fi network

### Backend Not Running

* Activate the virtual environment
* Verify YOLO model path configuration
* Check dependency installation

### API Connection Issues

* Verify backend IP address in frontend configuration
* Ensure backend server is running

---

## 🔮 Future Improvements

* Advanced Driver Assistance System (ADAS)
* Smart speed prediction
* Cloud monitoring dashboard
* Multi-camera support
* Emergency alert and response system
* Edge AI optimization

---

## 📜 License

This project is intended for educational and research purposes only.

---

## 👨‍💻 Authors

Built using Flutter, FastAPI, YOLOv8, OpenCV, GPS tracking, and real-time collision detection technologies.
