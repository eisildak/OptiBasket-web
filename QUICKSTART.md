# 🚀 Quick Start - Backend API Entegrasyonu

Bu rehber, OptiBasket uygulamasını backend API ile hızlıca test etmek için adım adım talimatlar içerir.

## ⚡ Hızlı Başlangıç (5 Dakika)

### 1. Dependencies Yükle

```bash
cd OptiBasket
flutter pub get
```

### 2. Code Generation

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Bu komut otomatik olarak şu dosyaları oluşturacak:
- API service implementation files (`*.g.dart`)
- Model serialization files (`*.g.dart`, `*.freezed.dart`)

### 3. Backend URL'ini Ayarla

`lib/core/constants/app_constants.dart` dosyasını açın:

```dart
static const String baseUrl = 'https://your-backend-url.com/api/v1';
// veya local test için:
// static const String baseUrl = 'http://localhost:3000/api/v1';
```

### 4. Uygulamayı Çalıştır

```bash
# Web için
flutter run -d chrome

# Android için
flutter run -d android

# iOS için
flutter run -d ios
```

---

## 🧪 Mock Backend ile Test (Backend Hazır Değilse)

Backend henüz hazır değilse, aşağıdaki yöntemlerle test edebilirsiniz:

### Option 1: JSON Server (Önerilen)

**Kurulum:**
```bash
npm install -g json-server
```

**Mock Data Oluştur:**

Proje root'unda `mock-api/db.json` dosyası oluşturun:

```json
{
  "auth": {
    "login": {
      "success": true,
      "data": {
        "user": {
          "id": "user_1",
          "email": "test@test.com",
          "firstName": "Test",
          "lastName": "User",
          "companyName": "Test GmbH",
          "role": "customer",
          "status": "approved"
        },
        "tokens": {
          "accessToken": "mock_access_token_123",
          "refreshToken": "mock_refresh_token_123",
          "expiresIn": 3600
        }
      }
    }
  },
  "products": [
    {
      "id": "1",
      "code": "PRD001",
      "name": "Tomaten Bio 1kg",
      "category": "Gemüse",
      "price": 3.99,
      "unit": "kg",
      "description": "Frische Bio-Tomaten",
      "stock": 150,
      "imageUrl": null,
      "createdAt": "2026-01-01T00:00:00Z",
      "updatedAt": "2026-01-02T00:00:00Z"
    },
    {
      "id": "2",
      "code": "PRD002",
      "name": "Gurken Bio 500g",
      "category": "Gemüse",
      "price": 2.49,
      "unit": "500g",
      "description": "Knackige Bio-Gurken",
      "stock": 200,
      "imageUrl": null,
      "createdAt": "2026-01-01T00:00:00Z",
      "updatedAt": "2026-01-02T00:00:00Z"
    },
    {
      "id": "3",
      "code": "PRD003",
      "name": "Paprika Mix",
      "category": "Gemüse",
      "price": 4.99,
      "unit": "kg",
      "description": "Bunte Paprika Mix",
      "stock": 100,
      "imageUrl": null,
      "createdAt": "2026-01-01T00:00:00Z",
      "updatedAt": "2026-01-02T00:00:00Z"
    }
  ],
  "categories": [
    {
      "id": "cat_1",
      "name": "Gemüse",
      "description": "Frisches Gemüse",
      "productCount": 3
    },
    {
      "id": "cat_2",
      "name": "Obst",
      "description": "Frisches Obst",
      "productCount": 0
    }
  ],
  "cart": {
    "id": "cart_1",
    "userId": "user_1",
    "items": [],
    "createdAt": "2026-01-02T00:00:00Z",
    "updatedAt": "2026-01-02T00:00:00Z"
  }
}
```

**Mock Server'ı Çalıştır:**

```bash
cd mock-api
json-server --watch db.json --port 3000 --routes routes.json
```

`routes.json` dosyası oluşturun (optional - custom routes için):
```json
{
  "/api/v1/*": "/$1",
  "/api/v1/auth/login": "/auth/login",
  "/api/v1/products": "/products",
  "/api/v1/products/:id": "/products/:id",
  "/api/v1/products/categories": "/categories",
  "/api/v1/cart": "/cart"
}
```

**Base URL'i Güncelle:**
```dart
static const String baseUrl = 'http://localhost:3000/api/v1';
```

### Option 2: Postman Mock Server

1. Postman açın
2. New Collection oluşturun: "OptiBasket API"
3. Her endpoint için request ekleyin
4. Her request'e Example Response ekleyin
5. Collection'a sağ tıklayın → Mock Server → Create Mock Server
6. Mock Server URL'ini alın
7. Base URL'i güncelleyin

---

## 📝 Test Senaryoları

### 1. Login Test

**Test Kullanıcısı:**
```
Email: test@test.com
Password: 12345678
```

**Beklenen Davranış:**
- ✅ Loading indicator görünür
- ✅ Başarılı login sonrası `/products` sayfasına yönlenir
- ✅ Token kaydedilir
- ✅ User bilgisi state'e kaydedilir

**Test Adımları:**
1. Uygulamayı başlat
2. Login ekranında email ve şifre gir
3. "Login" butonuna tıkla
4. Products sayfasının açıldığını doğrula

### 2. Products Listesi Test

**Beklenen Davranış:**
- ✅ Loading indicator gösterilir
- ✅ Ürünler listelenir
- ✅ Her ürün için: isim, kod, fiyat, kategori görünür
- ✅ "Add to Cart" butonu çalışır

**Test Adımları:**
1. Products sayfasına git
2. Ürünlerin yüklendiğini doğrula
3. Bir ürüne tıkla veya "Add to Cart" butonuna bas

### 3. Cart Test

**Beklenen Davranış:**
- ✅ Sepete eklenen ürün görünür
- ✅ Miktar artırıp azaltılabilir
- ✅ Tedarikçi fiyatı girilebilir
- ✅ Tasarruf hesaplaması doğru çalışır
- ✅ Toplam fiyat doğru hesaplanır

**Test Adımları:**
1. Bir ürünü sepete ekle
2. Cart icon'una tıkla
3. Miktarı değiştir
4. Tedarikçi fiyatını gir
5. Tasarruf miktarını kontrol et

---

## 🔧 Sorun Giderme

### Problem: "Code generation failed"

```bash
flutter clean
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Problem: "Connection refused" / "Network error"

**Çözüm 1:** Backend URL'ini kontrol edin
```dart
// lib/core/constants/app_constants.dart
static const String baseUrl = 'http://10.0.2.2:3000/api/v1'; // Android emulator için
// static const String baseUrl = 'http://localhost:3000/api/v1'; // iOS simulator için
```

**Çözüm 2:** CORS ayarlarını kontrol edin (web için)

Backend'de CORS enable olmalı:
```javascript
// Express.js example
app.use(cors({
  origin: '*', // Development için
  credentials: true
}));
```

**Çözüm 3:** Android Manifest'i kontrol edin
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<uses-permission android:name="android.permission.INTERNET"/>
```

### Problem: "401 Unauthorized"

**Muhtemel Sebepler:**
1. Token expire olmuş
2. Token doğru kaydedilmemiş
3. Authorization header eksik

**Debug:**
```dart
// lib/core/network/dio_client.dart dosyasında logger'ı kontrol edin
_logger.d('Request Headers: ${options.headers}');
```

### Problem: "Invalid JSON"

Backend response'u kontrol edin:
```bash
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"12345678"}' | jq
```

---

## 📊 API Test Komutları

### Login
```bash
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@test.com",
    "password": "12345678"
  }'
```

### Get Products
```bash
curl http://localhost:3000/api/v1/products
```

### Get Products with Auth
```bash
curl http://localhost:3000/api/v1/products \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

### Get Cart
```bash
curl http://localhost:3000/api/v1/cart \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

---

## 🎯 Checklist

Backend entegrasyonu için kontrol listesi:

### Hazırlık
- [ ] Flutter SDK kurulu (3.2.0+)
- [ ] Dependencies yüklendi (`flutter pub get`)
- [ ] Code generation tamamlandı
- [ ] Backend URL ayarlandı

### Test
- [ ] Mock server çalışıyor (veya gerçek backend hazır)
- [ ] Login çalışıyor
- [ ] Products listesi yükleniyor
- [ ] Cart işlemleri çalışıyor
- [ ] Error handling test edildi

### Production
- [ ] Production backend URL ayarlandı
- [ ] API keys güvenli şekilde saklanıyor
- [ ] HTTPS kullanılıyor
- [ ] Error messages kullanıcı dostu
- [ ] Loading states implement edildi

---

## 📞 Destek

Sorun yaşarsanız:

1. **Console Log'ları Kontrol Edin**
   ```
   flutter run --verbose
   ```

2. **Network İsteklerini Monitör Edin**
   - Chrome DevTools (Web)
   - Charles Proxy (Mobile)
   - Postman (API test)

3. **Provider State'i Debug Edin**
   ```dart
   // Console'da print edin
   ref.listen(authStateProvider, (previous, next) {
     print('Auth State Changed: $next');
   });
   ```

---

**Son Güncelleme:** 2 Ocak 2026

**İletişim:** Backend ekibiyle koordinasyon için BACKEND_INTEGRATION.md dosyasını paylaşın.
