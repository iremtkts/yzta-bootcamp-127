
from core.config import GEMINI_API_KEY


from utils.normalization import normalize_gender

def get_skin_care_advice(classes: list[str], gender: str) -> str:
    ALLOWED_CLASSES = [
        "Acne", "Dry-Skin", "Englarged-Pores", "Eyebags",
        "Oily-Skin", "Skin-Redness", "Wrinkles"
    ]

    if any(c not in ALLOWED_CLASSES for c in classes):
        return "Tespit edilen bulgular ciddi olabilir. En kısa sürede bir dermatoloji uzmanına başvurun."



    import google.generativeai as genai
    genai.configure(api_key=GEMINI_API_KEY)

    if not GEMINI_API_KEY:
        return "Sunucu yapılandırması eksik: GEMINI_API_KEY bulunamadı."

    
    gender_str = normalize_gender(gender)

    prompt = (
        f"Kullanıcının cinsiyeti: {gender_str}\n"
        f"Cildinde tespit edilen durumlar: {', '.join(classes)}\n\n"
        "Bu cilt problemleri için detaylı bir bakım önerisi hazırla.\n"
        "Yanıtında uygun yerlerde ilgili emojiler kullan. 🧴💧🌿\n"
        "- Cinsiyete özgü olası nedenleri açıkla (örneğin hormonal, yaşam tarzı, çevresel etkiler) 💡\n"
        "- Uygun cilt bakım rutinlerini adım adım belirt 🪞\n"
        "- Kullanılabilecek ürün türlerini öner 🧼\n"
        "- Gerektiğinde doktora başvurulması gerektiğini vurgula 🩺\n"
        "Yanıtı anlaşılır, pozitif ve kullanıcı dostu bir dille yaz. 😊"
    )

    model = genai.GenerativeModel("gemini-1.5-flash")
    try:
        response = model.generate_content(prompt)
        return response.text.strip() if response and hasattr(response, "text") else "Öneri alınamadı."
    except Exception as e:
        return f"Öneri alınırken hata oluştu: {e}"
