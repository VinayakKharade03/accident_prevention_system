STREAM_URL = "http://YOUR_PHONE_IP:4747/video"

FRAME_W, FRAME_H = 640, 480

MODEL_PATH = "models/yolov8n.pt"

FOCAL_LENGTH = 700
DANGER_DIST = 4
WARNING_DIST = 8

MAX_TRACK_DIST = 60
MAX_LOST = 10

ALERT_URL = "http://YOUR_SERVER_IP:5000/alert"

REAL_HEIGHTS = {
    "person": 170, "dog": 60, "cat": 25,
    "cow": 140, "horse": 160, "sheep": 90,
    "car": 150, "truck": 320, "bus": 320,
    "motorbike": 120, "bicycle": 110
}

CLASS_MAP = {
    "person": "person",
    "dog": "animal", "cat": "animal",
    "cow": "animal", "horse": "animal",
    "sheep": "animal",
    "car": "vehicle", "truck": "vehicle",
    "bus": "vehicle", "motorbike": "vehicle",
    "bicycle": "vehicle"
}