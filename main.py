import cv2
import mediapipe as mp
from mediapipe.tasks import python
from mediapipe.tasks.python import vision

# 1. Setup MediaPipe Landmarker
model_path = 'hand_landmarker.task' 

BaseOptions = mp.tasks.BaseOptions
HandLandmarker = mp.tasks.vision.HandLandmarker
HandLandmarkerOptions = mp.tasks.vision.HandLandmarkerOptions
VisionRunningMode = mp.tasks.vision.RunningMode

options = HandLandmarkerOptions(
    base_options=BaseOptions(model_asset_path=model_path),
    running_mode=VisionRunningMode.VIDEO, # Optimized for continuous frames
    num_hands=2
)

# 2. Start Video Capture
def get_working_camera():
    # Try indices 0 through 2
    for index in [0, 1, 2]:
        cap = cv2.VideoCapture(index)
        if cap.isOpened():
            success, _ = cap.read()
            if success:
                print(f"Using Camera Index: {index}")
                return cap
            cap.release()
    return None

cap = get_working_camera()

if cap is None:
    print("Error: No working camera found!")
    exit()

with HandLandmarker.create_from_options(options) as landmarker:
    while cap.isOpened():
        success, frame = cap.read()
        if not success:
            break
        
        frame = cv2.flip(frame, 1)

        # Convert frame to MediaPipe format
        mp_image = mp.Image(image_format=mp.ImageFormat.SRGB, data=frame)
        
        # Calculate timestamp (required for VIDEO mode)
        timestamp = int(cap.get(cv2.CAP_PROP_POS_MSEC))
        
        # Detect Hand Landmarks
        result = landmarker.detect_for_video(mp_image, timestamp)

        # 3. Draw Results
        CONNECTIONS = [ # A list of which landmark indices connect to each other (e.g., [0, 1] is Wrist to Thumb Base)
            (0, 1), (1, 2), (2, 3), (3, 4),      # Thumb
            (0, 5), (5, 6), (6, 7), (7, 8),      # Index
            (0, 9), (9, 10), (10, 11), (11, 12), # Middle
            (0, 13), (13, 14), (14, 15), (15, 16), # Ring
            (0, 17), (17, 18), (18, 19), (19, 20), # Pinky
            (5, 9), (9, 13), (13, 17)            # Knuckles
        ]

        if result.hand_landmarks:
            for landmarks in result.hand_landmarks:
                # 1. First, draw the lines (bones)
                for connection in CONNECTIONS:
                    start_idx, end_idx = connection
                    p1 = landmarks[start_idx]
                    p2 = landmarks[end_idx]
                    
                    x1, y1 = int(p1.x * frame.shape[1]), int(p1.y * frame.shape[0])
                    x2, y2 = int(p2.x * frame.shape[1]), int(p2.y * frame.shape[0])
                    cv2.line(frame, (x1, y1), (x2, y2), (255, 255, 255), 2) # lines

                # 2. Then, draw the dots (joints)
                for point in landmarks:
                    x, y = int(point.x * frame.shape[1]), int(point.y * frame.shape[0])
                    cv2.circle(frame, (x, y), 4, (255, 255, 255), -1) # dots

        cv2.imshow('Hand Tracking', frame)

        # Press 'q' to quit
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

cap.release()
cv2.destroyAllWindows()
