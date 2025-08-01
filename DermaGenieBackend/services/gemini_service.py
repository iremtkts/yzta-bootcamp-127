import google.generativeai as genai
from core.config import GEMINI_API_KEY

# API anahtarını ayarla
genai.configure(api_key=GEMINI_API_KEY)

def get_skin_care_advice(classes: list[str]) -> str:
    """
    YOLO class listesine göre bakım önerisi veya doktora gitme uyarısı döndürür.
    """
    ALLOWED_CLASSES = [
        "Acne", "Dry-Skin", "Englarged-Pores", "Eyebags",
        "Oily-Skin", "Skin-Redness", "Wrinkles"
    ]

    # Eğer listede izin verilmeyen class varsa → doktora yönlendir
    if any(c not in ALLOWED_CLASSES for c in classes):
        return "Tespit edilen bulgular ciddi olabilir. En kısa sürede bir dermatoloji uzmanına başvurun."

    # Prompt oluştur
    prompt = (
        f"Kullanıcının cildinde şu durumlar tespit edildi: {', '.join(classes)}.\n"
        "Bu cilt tipleri için nasıl bakım yapılmalı, hangi ürünler önerilmeli? "
        "Detaylı ama anlaşılır bir şekilde açıkla."
    )

    # Gemini 1.5 Pro kullanımı
    model = genai.GenerativeModel("gemini-1.5-pro")
    response = model.generate_content(prompt)

    return response.text.strip() if response and hasattr(response, "text") else "Öneri alınamadı."
