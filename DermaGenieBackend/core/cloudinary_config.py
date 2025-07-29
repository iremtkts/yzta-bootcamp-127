import os
from dotenv import load_dotenv
import cloudinary

# .env dosyasını yükle
load_dotenv()

# Cloudinary'yi konfigüre et
cloudinary.config(
    cloud_name=os.getenv("CLOUDINARY_CLOUD_NAME"),
    api_key=os.getenv("CLOUDINARY_API_KEY"),
    api_secret=os.getenv("CLOUDINARY_API_SECRET")
)
