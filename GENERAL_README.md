# 🌍 OptiBasket Ekosistemi ve Proje Özeti

Bu doküman, **OptiBasket** projesinin genel yapısını, ekosistemdeki diğer bileşenlerle ilişkisini ve teknik detaylarını özetlemektedir.

## 🏗️ Ekosistem Mimarisi

OptiBasket projesi, tam kapsamlı bir B2B e-ticaret ve fiyat karşılaştırma çözümü sunmak için üç ana bileşenden oluşur:

1.  **📱 OptiBasket (Bu Repo)**
    *   **Rolü:** Müşteri Yüzü (Mobile & Web Uygulaması).
    *   **Kullanıcı:** B2B Müşterileri (Restoranlar, Marketler vb.).
    *   **İşlevi:** Ürün arama, tedarikçi fiyatlarını karşılaştırma, sepet oluşturma ve sipariş verme.
    *   **Teknoloji:** Flutter (Dart).

2.  **🖥️ optibasket_firma_dashboard**
    *   **Rolü:** Yönetim Paneli (Admin Dashboard).
    *   **Kullanıcı:** Sistem Yöneticileri ve Tedarikçiler.
    *   **İşlevi:** Ürün kataloğu yönetimi, müşteri onaylama (B2B kayıtları onaya tabidir), fiyat güncellemeleri ve sipariş takibi.

3.  **⚙️ optibasket-backend**
    *   **Rolü:** Sunucu ve API.
    *   **İşlevi:** Tüm verilerin tutulduğu, iş mantığının çalıştığı ve diğer iki uygulamanın (Mobil ve Dashboard) haberleştiği merkezi sistem.

---

## 📱 Bu Repo: OptiBasket (Flutter App)

Bu depo, ekosistemin **müşteri tarafındaki mobil ve web uygulamasını** içerir.

### 🛠️ Teknik Altyapı

Proje, ölçeklenebilirlik ve test edilebilirlik için **Clean Architecture** prensiplerine göre yapılandırılmıştır.

*   **Dil:** Dart (>=3.2.0)
*   **Framework:** Flutter
*   **State Management:** Riverpod (`flutter_riverpod`, `riverpod_annotation`)
*   **Navigasyon:** GoRouter (`go_router`)
*   **Network:** Dio & Retrofit
*   **Yerel Depolama:** Shared Preferences & Flutter Secure Storage & Hive
*   **Çoklu Dil:** `flutter_localizations` (TR, EN, DE, NL)

### 📂 Proje Yapısı

```
lib/
├── core/              # Uygulama genelindeki çekirdek modüller (Network, Theme, Router)
├── features/          # Özellik bazlı modüller (Her özellik kendi Presentation ve Provider katmanına sahiptir)
│   ├── auth/          # Giriş, Kayıt, Profil
│   ├── products/      # Ürün Listeleme ve Detay
│   ├── cart/          # Sepet Yönetimi
│   ├── comparison/    # Fiyat Karşılaştırma Mantığı
│   └── admin/         # (Uygulama içi basit admin özellikleri)
└── shared/            # Ortak kullanılan modeller, servisler ve widget'lar
```

### ✨ Temel Özellikler

*   **Akıllı Fiyat Karşılaştırma:** Kullanıcılar kendi tedarikçi fiyatları ile katalog fiyatlarını karşılaştırabilir.
*   **Tasarruf Analizi:** Geçmişe dönük (4 haftalık) fiyat takibi ve tasarruf hesaplaması.
*   **Güvenli Kimlik Doğrulama:** Yönetici onaylı kayıt süreci.
*   **Çoklu Platform:** Web, iOS ve Android desteği.

---

## 🚀 Kurulum ve Çalıştırma

Bu projeyi geliştirmek veya çalıştırmak için aşağıdaki adımları izleyin.

### 1. Ön Hazırlık
*   Flutter SDK yüklü olmalıdır.
*   Bir IDE (VS Code veya Android Studio) gereklidir.

### 2. Bağımlılıkları Yükleme
Terminalde proje dizinine giderek paketleri yükleyin:
```bash
flutter pub get
```

### 3. Mock API (Backend Simülasyonu)
Gerçek backend (`optibasket-backend`) hazır değilse veya geliştirme yapıyorsanız, proje içindeki **Mock API**'yi başlatmanız gerekir. Bu, uygulamanın veri çekebilmesi için şarttır.

**Mac/Linux:**
```bash
cd mock-api
./start.sh
```

**Windows:**
```bash
cd mock-api
start.bat
```
*Mock sunucu `http://localhost:3000` adresinde çalışacaktır.*

### 4. Uygulamayı Başlatma
Mock API çalışırken, yeni bir terminalde uygulamayı başlatın:

```bash
flutter run
```

---

## 🔗 Backend Entegrasyonu

Uygulama, RESTful API standartlarına göre haberleşir. Backend entegrasyonu ile ilgili detaylı dokümantasyon için proje içindeki şu dosyalara bakabilirsiniz:

*   📄 **BACKEND_INTEGRATION.md**: Entegrasyon adımları ve gereksinimler.
*   📄 **BACKEND_API_TEMPLATE.md**: Beklenen API endpoint yapıları ve JSON formatları.
