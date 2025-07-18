## 🧴 Uygulama Tanıtımı: DermaGenie

### 🎯 Amaç:
**DermaGenie**, dermatolojik farkındalık oluşturmak isteyen herkes için tasarlanmış bir mobil sağlık uygulamasıdır.
Uygulama, mobil cihaz kamerası üzerinden alınan yüz görüntülerini analiz ederek akne, cilt kuruluğu, melanom riski gibi durumları YOLOv8 tabanlı yapay zeka modeliyle tespit eder.

**Tespit sonrası:**

Estetik sorunlarda (akne, kuruluk) kullanıcılara GenAI destekli kişisel bakım önerileri sunulur.
Ciddi dermatolojik bulgularda (melanom şüphesi) kullanıcı doğrudan uzman hekime yönlendirilir.
DermaGenie, yapay zekâyı sadece analiz aracı olarak değil, aynı zamanda kullanıcıya güven veren, rehberlik eden bir dijital cilt danışmanı olarak konumlandırır.

---

## 📱 Temel Özellikler

- **Gerçek zamanlı cilt analizi**: Kamera ile alınan görüntüler AI modeliyle analiz edilir.
- **Akne Tespiti**: Hafif veya yoğun akne varsa, cilt bakım önerileri ve ürün tavsiyeleri sunulur.
- **Melanom Tespiti**: Şüpheli leke tespit edilirse, kullanıcı doğrudan dermatoloji uzmanına yönlendirilir.
- **GenAI Asistan**: Kişisel cilt tipi ve sorunlarına göre yapay zekâ tavsiyesi üretir (temizleyici, dermatolog takvimi, nemlendirici, vb.)

---

## Takım Adı: 127

## 👥 Görev Dağılımı ve Ekip Rolleri

| Rol                   | İsim         |
|------------------------|--------------|
| Product Owner         |Berkay Tekce|
| Scrum Master          |İrem Tektaş|
| Developer             | Abdurrazzak Saymaz | 

---

## 🧰 Kullanılacak Teknolojiler

### 📷 Görüntü Analizi
- YOLOv8


### ⚙️ Backend
- FastAPI (görsel işleme, öneri servisi)
- Railway (geliştirme/deploy ortamı)
- Gemini API (öneri üretme)

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

## 🧾 Sprint 2 – Mobil Arayüz Tasarımı & YOLOv8 Model Eğitimi

### 🎯 Sprintin Amacı:
Uygulamanın kullanıcı arayüzünü MVVM mimarisi ve feature-based klasörleme yapısıyla kodlamak, Roboflow’dan elde edilen HAM10000 ve akne-kuruluk gibi sorunları içeren iki veri setinin YOLOv8 ile model eğitimi gerçekleştirmek.

---

### 📊 Tahmin Edilen Puan: **26**  
### ✅ Tamamlanan Puan: **18**

---

### 📐 Puanlama Mantığı:
Görevlerin puanları, işin karmaşıklığı, tahmini süresi ve teknik belirsizlik miktarına göre belirlenmiştir:

- 3 SP → basit arayüz veya veri işleme adımı  
- 5 SP → orta düzeyde kodlama veya eğitim görevleri  
- 8 SP → çok adımlı veya yüksek belirsizlik içeren teknik görevler

---

### 📝 Product Backlog Görevleri ve Puanlar

| Görev                                                                 | Puan | Durum         |
|------------------------------------------------------------------------|------|----------------|
| MVVM + feature-based proje yapısını oluşturma                         | 5    | ✅ Tamamlandı   |
| Login, SignUp, Kamera, Analiz, AI ekranlarının kodlanması             | 5    | ✅ Tamamlandı   |
| GenAI öneri ekranı için yükleme animasyonu ve sonuç alanı             | 3    | ✅ Tamamlandı   |
| Roboflow’daki iki veri setinin  YOLOv8 formatına getirme              | 5    | ✅ Tamamlandı   |
| YOLOv8 modelini eğitme (acne, dryness, melanoma, vb.)                 | 5    | ⏳ Planlandı   |
| Model çıktılarının mobil uygulama arayüzüne entegrasyonu (planlama)   | 3    | ⏳ Planlandı    |


---

### 📅 Daily Scrum (Saat 22:00’de)

> Her akşam yapılan takım içi kısa toplantılarda aşağıdaki başlıklar üzerinden bilgi paylaşımı yapılmıştır:

- **Dün ne yaptım?**
- **Bugün ne yapacağım?**
- **Bir engelle karşılaştım mı?**

📸 Scrum süreci WhatsApp ve Trello üzerinden yürütülmüştür.

---

### 📌 Sprint Board Updates

Trello bağlantısı: [Trello Sprint 2 Board](https://trello.com/invite/b/68728a90daf440f29514683e/ATTI1891fce45a84d7a7dff4990f6a8473d10BD13A86/yzta-grup-127)


---

### 📸 Ürün Screenshot

#### 📱 Arayüz – Giriş & Anasayfa
<p align="center">
  <img src="screenshots/login.png" width="250"/>
  <img src="screenshots/results.png" width="250"/>
</p>

#### 📷 Kamera & AI Öneri
<p align="center">
  <img src="screenshots/history.png" width="250"/>
  <img src="screenshots/detail.png" width="250"/>
</p>


---

### 🎤 Sprint Review

- Arayüzlerin hepsi MVVM mimarisiyle geliştirildi.
- YOLOv8 modeli başarıyla eğitildi ancak Colab süresi yetersiz kaldı.
- Alternatif daha küçük boyutlu veri seti ile yeniden eğitim yapma kararlaştırıldı.
- Kullanıcıya yaş ve cinsiyet odaklı öneriler sunmak için GenAI prompt'larının geliştirilmesine karar verildi.

---

### 🔁 Sprint Retrospektif

| Kategori            | Notlar                                                                 |
|---------------------|------------------------------------------------------------------------|
| ✅ İyi Gidenler      | UI tasarımı ve model hazırlığı eksiksiz ilerledi. |
| 🛠️ Geliştirilecekler | HAM10000 eğitimi Colab'da uzun sürdü, daha hafif veri seti kullanılmalı. |
| 💡 Öğrenilenler      | Roboflow üzerindeki farklı veri setleri dikkatlice yeniden adlandırılarak birleştirilmeli, yoksa model eğitimi bozulabiliyor. |
| 🔄 Takım Değişimi    | Scrum Master rolünü  İrem Tektaş’a devir aldı. |

