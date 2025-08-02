
import requests
from io import BytesIO


VIVID_COLORS = [
    (255, 0, 0),     # Kırmızı
    (0, 255, 0),     # Yeşil
    (0, 0, 255),     # Mavi
    (255, 255, 0),   # Sarı
    (255, 0, 255),   # Fuşya
    (0, 255, 255),   # Camgöbeği
    (255, 128, 0),   # Turuncu
    (128, 0, 255)    # Mor
]

def get_color_for_class(class_name: str):
    index = abs(hash(class_name)) % len(VIVID_COLORS)
    return VIVID_COLORS[index]


def draw_bboxes(image_url: str, detections: list):
    import cv2                     # heavy import
    import numpy as np 
  
    resp = requests.get(image_url)
    resp.raise_for_status()
    img_array = np.asarray(bytearray(resp.content), dtype=np.uint8)
    img = cv2.imdecode(img_array, cv2.IMREAD_COLOR)

    for det in detections:
        bbox = det["bbox"]
        x1, y1, x2, y2 = map(int, [bbox["x1"], bbox["y1"], bbox["x2"], bbox["y2"]])
        label = det["class_name"]
        conf = det["confidence"]

        
        color = get_color_for_class(label)

        
        cv2.rectangle(img, (x1, y1), (x2, y2), color, 2)
        cv2.putText(
            img, f"{label} {conf:.2f}", (x1, max(y1 - 5, 15)),
            cv2.FONT_HERSHEY_SIMPLEX, 0.5, color, 1
        )

    _, buffer = cv2.imencode(".jpg", img)
    return BytesIO(buffer)
