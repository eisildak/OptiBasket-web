# 🧪 OptiBasket Mock API Server

Bu klasör, OptiBasket uygulamasını backend olmadan test etmek için JSON Server tabanlı mock API içerir.

## 📦 Kurulum

### 1. JSON Server'ı Yükleyin

```bash
npm install -g json-server
```

Veya Yarn ile:
```bash
yarn global add json-server
```

## 🚀 Kullanım

### Hızlı Başlat

**macOS/Linux:**
```bash
cd mock-api
chmod +x start.sh
./start.sh
```

**Windows:**
```bash
cd mock-api
start.bat
```

**Manuel:**
```bash
cd mock-api
json-server --watch db.json --port 3000
```

Server başladıktan sonra: **http://localhost:3000**

## 🔗 API Endpoints

### Authentication
```bash
# Login
POST http://localhost:3000/auth/login
Content-Type: application/json

{
  "email": "test@test.com",
  "password": "12345678"
}

# Register
POST http://localhost:3000/auth/register
Content-Type: application/json

{
  "email": "newuser@company.com",
  "password": "SecurePass123!",
  "firstName": "John",
  "lastName": "Doe",
  "companyName": "ABC GmbH",
  "vatNumber": "DE123456789"
}
```

### Products
```bash
# Tüm ürünler
GET http://localhost:3000/products

# Tek ürün
GET http://localhost:3000/products/1

# Ürün arama
GET http://localhost:3000/products?name_like=Tomaten

# Kategoriler
GET http://localhost:3000/categories

# Fiyat geçmişi
GET http://localhost:3000/priceHistory?productId=1
```

### Cart
```bash
# Sepeti görüntüle
GET http://localhost:3000/cart
```

### Admin
```bash
# Onay bekleyen kullanıcılar
GET http://localhost:3000/pendingUsers
```

## 🧪 Test Verileri

### Test Kullanıcısı
```
Email: test@test.com
Password: 12345678 (any password)
Role: customer
Status: approved
```

### Ürünler
- 15 adet örnek ürün (Gemüse ve Obst kategorilerinde)
- Her ürün için kod, isim, fiyat, stok bilgisi mevcut

### Kategoriler
- Gemüse (10 ürün)
- Obst (5 ürün)
- Milchprodukte (0 ürün)

## 🔧 Flutter Uygulamasında Kullanım

`lib/core/constants/app_constants.dart` dosyasını güncelleyin:

```dart
// Android Emulator için
static const String baseUrl = 'http://10.0.2.2:3000';

// iOS Simulator için
// static const String baseUrl = 'http://localhost:3000';

// Gerçek cihaz için (Mac'inizin IP adresi)
// static const String baseUrl = 'http://192.168.1.XXX:3000';
```

## 📝 Mock Data Düzenleme

`db.json` dosyasını düzenleyerek test verilerinizi özelleştirebilirsiniz:

```json
{
  "products": [
    {
      "id": "16",
      "code": "PRD016",
      "name": "Yeni Ürün",
      "category": "Gemüse",
      "price": 5.99,
      "unit": "kg",
      "description": "Açıklama",
      "stock": 100
    }
  ]
}
```

Değişiklikler otomatik olarak yenilenir (hot reload).

## 🌐 CORS

JSON Server varsayılan olarak tüm origin'lere izin verir, bu nedenle web uygulamanızda CORS sorunu yaşamazsınız.

## 🛠️ Sorun Giderme

### "json-server: command not found"
```bash
npm install -g json-server
```

### Port 3000 zaten kullanımda
```bash
json-server --watch db.json --port 3001 --routes routes.json
```

### Android Emulator'dan erişim sorunu
Base URL'i değiştirin:
```dart
static const String baseUrl = 'http://10.0.2.2:3000';
```

### iOS Simulator'dan erişim sorunu
```dart
static const String baseUrl = 'http://localhost:3000';
```

### Gerçek cihazdan erişim sorunu
Mac'inizin IP adresini kullanın:
```bash
# IP adresinizi öğrenin
ifconfig | grep "inet " | grep -v 127.0.0.1
```

Ardından:
```dart
static const String baseUrl = 'http://192.168.1.XXX:3000';
```

## 📚 İleri Seviye Kullanım

### Custom Middleware
```javascript
// middleware.js dosyası oluşturun
module.exports = (req, res, next) => {
  if (req.method === 'POST' && req.path === '/api/v1/auth/login') {
    // Her zaman başarılı login
    res.status(200).json(require('./db.json').auth.login);
  } else {
    next();
  }
};
```

Çalıştırma:
```bash
json-server --watch db.json --middlewares middleware.js
```

### Delay Simulation (Network gecikmesi)
```bash
json-server --watch db.json --delay 1000
```

## 📖 Kaynaklar

- [JSON Server Documentation](https://github.com/typicode/json-server)
- [OptiBasket Backend API Template](../BACKEND_API_TEMPLATE.md)
- [Backend Integration Guide](../BACKEND_INTEGRATION.md)

---

**Not:** Bu mock server sadece development amaçlıdır. Production'da gerçek backend API kullanılmalıdır.
