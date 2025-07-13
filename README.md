## 🧴 Uygulama Tanıtımı: DermaGenie

### 🎯 Amaç:
**DermaGenie**, mobil cihaz kamerasını kullanarak cilt analizleri yapan, yapay zekâ destekli bir sağlık uygulamasıdır.  
Kullanıcının cilt durumunu analiz eder, **akne** veya **cilt kuruluğu** gibi problemleri tespit eder ve buna göre  **medikal yönlendirmeler** sunar.

---

## 📱 Temel Özellikler

- **Gerçek zamanlı cilt analizi**: Kamera ile alınan görüntüler CNN modeliyle analiz edilir.
- **Akne Tespiti**: Hafif veya yoğun akne varsa, cilt bakım önerileri ve ürün tavsiyeleri sunulur.
- **Melanom Tespiti**: Şüpheli leke tespit edilirse, kullanıcı doğrudan dermatoloji uzmanına yönlendirilir.
- **GenAI Asistan**: Kişisel cilt tipi ve sorunlarına göre yapay zekâ tavsiyesi üretir (temizleyici, dermatolog takvimi, nemlendirici, vb.)

---

## 👥 Görev Dağılımı ve Ekip Rolleri

| Rol                   | İsim         | Sorumluluklar                                                                 |
|------------------------|--------------|------------------------------------------------------------------------------|
| Product Owner         | İrem Tektaş & Berkay Tekce| Uygulamanın vizyonunu ve kullanıcı ihtiyaçlarını tanımlar.  |
| AI/ML Engineer        | Abdurrazzak Saymaz| CNN modelini eğitir, veri setlerini hazırlar, mobil uyumlu hale getirir. |
| Backend Developer     | Berkay Tekce | FastAPI ile görsel analiz ve öneri servislerini geliştirir.                  |
| Mobile Developer (iOS)| İrem Tektaş  | Kamera arayüzü, API bağlantıları ve kullanıcı arayüzünü tasarlar.            |
| GenAI Prompt Designer | Berkay Tekce | GPT-3.5 / Gemini API ile öneri üreten prompt sistemini geliştirir.           |
| UX/UI Designer        | İrem Tektaş  | Temiz, pastel tonlarda kullanıcı dostu ekranlar tasarlar.                    |
| Scrum Master          | Barış İncesu | Süreçlerin zamanında ve şeffaf yürütülmesini sağlar, sprint yönetimini yapar.|

---

## 🧰 Kullanılacak Teknolojiler

### 📷 Görüntü Analizi
- Python, TensorFlow / PyTorch (CNN eğitimi) veya YOLOv8
- MobileNetV2 veya EfficientNet (mobil uyumlu transfer learning)

### ⚙️ Backend
- FastAPI (görsel işleme, öneri servisi)
- Uvicorn + Docker (veya Railway) (geliştirme/deploy ortamı)
- OpenAI GPT-3.5 API / Gemini API (öneri üretme)

### 📱 iOS Uygulaması
- Swift + UIKit
- URLSession ile API iletişimi
- Kamera kullanımı ve görüntü gönderme
- Kullanıcı arayüzü: akne tespit ekranı, GenAI öneri ekranı

---

## 🧾 Sprint 1 – Veri Keşfi ve Hazırlık

### 🎯 Amaç:
Akne, kuruluk, kızarıklık, melanoma gibi durumları analiz etmek için uygun veri setlerini araştırmak ve ön işleme hazırlığını tamamlamak.

### 📊 Tahmini Sprint Puanı: **21 Story Point**

| Görev                                              | Puan |
|----------------------------------------------------|------|
| Açık veri setlerini araştır ve indir              | 5    |
| Her veri setinin lisans ve etik kullanımını incele | 3    |
| Sınıf haritası ve etiket normalizasyon şeması oluştur | 3 |
| Görüntüleri aynı boyut, renk formatına getir       | 5    |
| Tek bir `labels.csv` ile etiket sistemini birleştir | 5    |

---

### 📅 Daily Scrum (Her gün saat 22:00’de)

Standart üç soru:
1. Dün ne yaptım?
2. Bugün ne yapacağım?
3. Karşılaştığım engeller var mı?

---

## 📸 Görseller

### 📱 Mobil Uygulama Tasarım Örneği

<p align="center">
  <img src="screenshots/1.png" width="250"/>
  <img src="screenshots/2.png" width="250"/>
</p>

---

### 📓 Notebook Görseli

<p align="center">
  <img src="screenshots/notebook.jpg" width="500"/>
</p>

---

### 🖼️ Veri Seti Örnekleri

<p align="center">
  <img src="screenshots/veri-seti.jpg" width="300"/>
  <img src="screenshots/veri-seti2.jpg" width="300"/>
</p>

---

### 📌 Sprint Board Updates

| Görev                     | Durum         |
|---------------------------|---------------|
| Veri seti araştırması     | ✅ Tamamlandı |
| Veri lisans incelemesi    | ✅ Tamamlandı |
| Görsel boyut eşitleme     | ⏳ Devam ediyor |
| Etiket normalizasyonu     | ⏳ Başladı     |
| `labels.csv` oluşturma    | ⏳ Planlandı   |
| Örnek analiz ekran görüntüsü | ⏳ Planlandı   |

---

### 🎤 Sprint Review (Demo & Geri Bildirim)

- **Sunulan:** Etiketlenmiş 2 veri setinden oluşan eğitim datası.
- **Demo:** Veri yapısı ve örnek analiz görselleri gösterildi.
- **Geri Bildirim:** Etiket isimleri kullanıcı odaklı değil. Örneğin, `nv` yerine `benign mole` gibi daha anlaşılır terimler tercih edilmeli.

---

### 🔁 Sprint Retrospective

| Kategori         | Notlar                                                                 |
|------------------|------------------------------------------------------------------------|
| ✅ İyi Gidenler   | Veri seti analizi hızlı yapıldı, kaynaklar etkili toplandı.             |
| 🛠️ Geliştirilecekler | Dosya adlandırmalarında karışıklık oluştu. Daha net sistem belirlenmeli. |
| 💡 Öğrenilenler   | Veri lisansı kontrolü zaman kazandırıyor. Önceden mutlaka yapılmalı.   |

