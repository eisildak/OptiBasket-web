# Backend API Şablonu

Bu dosya, backend ekibinizin implement etmesi gereken API endpoint'lerinin detaylı şablonunu içerir.

## 🔐 Authentication Endpoints

### POST /api/v1/auth/register
Yeni kullanıcı kaydı (Admin onayı gerektirir)

**Request:**
```json
{
  "email": "john@company.com",
  "password": "SecurePass123!",
  "firstName": "John",
  "lastName": "Doe",
  "companyName": "ABC GmbH",
  "vatNumber": "DE123456789"  // Optional
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Registration successful. Waiting for admin approval.",
  "data": {
    "userId": "user_123",
    "email": "john@company.com",
    "status": "pending"
  }
}
```

---

### POST /api/v1/auth/login
Kullanıcı girişi

**Request:**
```json
{
  "email": "john@company.com",
  "password": "SecurePass123!"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "user_123",
      "email": "john@company.com",
      "firstName": "John",
      "lastName": "Doe",
      "companyName": "ABC GmbH",
      "vatNumber": "DE123456789",
      "role": "customer",
      "status": "approved",
      "createdAt": "2026-01-01T10:00:00Z",
      "updatedAt": "2026-01-02T08:30:00Z"
    },
    "tokens": {
      "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "expiresIn": 3600
    }
  }
}
```

**Error Response (401 Unauthorized):**
```json
{
  "success": false,
  "error": {
    "code": "INVALID_CREDENTIALS",
    "message": "Invalid email or password"
  }
}
```

**Error Response (403 Forbidden - Pending Approval):**
```json
{
  "success": false,
  "error": {
    "code": "ACCOUNT_PENDING",
    "message": "Your account is pending admin approval"
  }
}
```

---

### POST /api/v1/auth/refresh
Token yenileme

**Request:**
```json
{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expiresIn": 3600
  }
}
```

---

### POST /api/v1/auth/logout
Çıkış yapma

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Logged out successfully"
}
```

---

## 📦 Products Endpoints

### GET /api/v1/products
Ürün listesi (Pagination ile)

**Query Parameters:**
- `page` (int, default: 1)
- `limit` (int, default: 20, max: 100)
- `category` (string, optional)
- `search` (string, optional)

**Example:** `/api/v1/products?page=1&limit=20&category=Gemüse`

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "prod_123",
        "code": "PRD001",
        "name": "Tomaten Bio 1kg",
        "category": "Gemüse",
        "price": 3.99,
        "unit": "kg",
        "description": "Frische Bio-Tomaten aus regionalem Anbau",
        "stock": 150,
        "imageUrl": "https://cdn.example.com/products/tomaten.jpg",
        "createdAt": "2026-01-01T00:00:00Z",
        "updatedAt": "2026-01-02T00:00:00Z"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 150,
      "totalPages": 8,
      "hasNext": true,
      "hasPrev": false
    }
  }
}
```

---

### GET /api/v1/products/{id}
Tek ürün detayı

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "id": "prod_123",
    "code": "PRD001",
    "name": "Tomaten Bio 1kg",
    "category": "Gemüse",
    "price": 3.99,
    "unit": "kg",
    "description": "Frische Bio-Tomaten aus regionalem Anbau",
    "stock": 150,
    "imageUrl": "https://cdn.example.com/products/tomaten.jpg",
    "createdAt": "2026-01-01T00:00:00Z",
    "updatedAt": "2026-01-02T00:00:00Z"
  }
}
```

---

### GET /api/v1/products/search
Ürün arama

**Query Parameters:**
- `q` (string, required) - Arama sorgusu

**Example:** `/api/v1/products/search?q=tomaten`

**Response:** Products listesi ile aynı format

---

### GET /api/v1/products/categories
Kategori listesi

**Response (200 OK):**
```json
{
  "success": true,
  "data": [
    {
      "id": "cat_1",
      "name": "Gemüse",
      "description": "Frisches Gemüse",
      "productCount": 45
    },
    {
      "id": "cat_2",
      "name": "Obst",
      "description": "Frisches Obst",
      "productCount": 38
    }
  ]
}
```

---

### GET /api/v1/products/{id}/price-history
Ürün fiyat geçmişi (son 4 hafta)

**Query Parameters:**
- `from` (date, optional) - YYYY-MM-DD formatında
- `to` (date, optional) - YYYY-MM-DD formatında

**Response (200 OK):**
```json
{
  "success": true,
  "data": [
    {
      "id": "ph_1",
      "productId": "prod_123",
      "price": 3.99,
      "timestamp": "2026-01-02T00:00:00Z"
    },
    {
      "id": "ph_2",
      "productId": "prod_123",
      "price": 3.79,
      "timestamp": "2025-12-26T00:00:00Z"
    }
  ]
}
```

---

## 🛒 Cart Endpoints

### GET /api/v1/cart
Kullanıcının sepetini görüntüle

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "id": "cart_123",
    "userId": "user_123",
    "items": [
      {
        "id": "item_1",
        "product": {
          "id": "prod_123",
          "code": "PRD001",
          "name": "Tomaten Bio 1kg",
          "price": 3.99,
          "unit": "kg"
        },
        "quantity": 5,
        "supplierPrice": 4.50
      }
    ],
    "createdAt": "2026-01-02T10:00:00Z",
    "updatedAt": "2026-01-02T14:30:00Z"
  }
}
```

---

### POST /api/v1/cart/add
Sepete ürün ekle

**Request:**
```json
{
  "productId": "prod_123",
  "quantity": 5,
  "supplierPrice": 4.50
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Product added to cart",
  "data": {
    "cartId": "cart_123",
    "itemId": "item_1"
  }
}
```

---

### PUT /api/v1/cart/update/{itemId}
Sepet öğesini güncelle

**Request:**
```json
{
  "quantity": 10,
  "supplierPrice": 4.30
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Cart item updated",
  "data": {
    "itemId": "item_1",
    "quantity": 10,
    "supplierPrice": 4.30
  }
}
```

---

### DELETE /api/v1/cart/remove/{itemId}
Sepetten ürün çıkar

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Item removed from cart"
}
```

---

### DELETE /api/v1/cart/clear
Sepeti temizle

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Cart cleared"
}
```

---

## 📊 Comparison Endpoints

### POST /api/v1/comparison/compare
Fiyat karşılaştırması yap

**Request:**
```json
{
  "cartId": "cart_123",
  "comparisonDate": "2026-01-02T00:00:00Z"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "id": "comp_123",
    "userId": "user_123",
    "comparisonDate": "2026-01-02T00:00:00Z",
    "items": [
      {
        "productId": "prod_123",
        "productName": "Tomaten Bio 1kg",
        "quantity": 5,
        "yourPrice": 3.99,
        "supplierPrice": 4.50,
        "savings": 2.55,
        "savingsPercentage": 11.33
      }
    ],
    "totalYourPrice": 19.95,
    "totalSupplierPrice": 22.50,
    "totalSavings": 2.55,
    "savingsPercentage": 11.33,
    "createdAt": "2026-01-02T15:00:00Z"
  }
}
```

---

### GET /api/v1/comparison/history
Geçmiş karşılaştırmalar

**Query Parameters:**
- `page` (int, default: 1)
- `limit` (int, default: 10)

**Response:** Comparison report listesi

---

## 👨‍💼 Admin Endpoints

### GET /api/v1/admin/users/pending
Onay bekleyen kullanıcılar

**Headers:**
```
Authorization: Bearer {adminAccessToken}
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": [
    {
      "id": "user_456",
      "email": "newuser@company.com",
      "firstName": "Jane",
      "lastName": "Smith",
      "companyName": "XYZ GmbH",
      "vatNumber": "DE987654321",
      "status": "pending",
      "createdAt": "2026-01-02T09:00:00Z"
    }
  ]
}
```

---

### POST /api/v1/admin/users/approve/{userId}
Kullanıcıyı onayla

**Response (200 OK):**
```json
{
  "success": true,
  "message": "User approved successfully",
  "data": {
    "userId": "user_456",
    "status": "approved"
  }
}
```

---

### POST /api/v1/admin/users/reject/{userId}
Kullanıcıyı reddet

**Request (Optional):**
```json
{
  "reason": "Invalid company information"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "User rejected",
  "data": {
    "userId": "user_456",
    "status": "rejected"
  }
}
```

---

### PUT /api/v1/admin/products/{id}/price
Ürün fiyatını güncelle

**Request:**
```json
{
  "price": 4.29
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Price updated successfully",
  "data": {
    "productId": "prod_123",
    "oldPrice": 3.99,
    "newPrice": 4.29,
    "updatedAt": "2026-01-02T16:00:00Z"
  }
}
```

---

## 🔒 Security Requirements

### Authentication
- JWT Bearer token kullanılmalı
- Access token süresi: 1 saat
- Refresh token süresi: 7 gün
- HTTPS zorunlu (production)

### Rate Limiting
- Login: 5 istək / 15 dəqiqə
- API endpoints: 100 istək / dəqiqə
- Admin endpoints: 50 istək / dəqiqə

### CORS
- Development: `*` (all origins)
- Production: Sadece onaylanmış domainler

---

## 📧 Email Notifications

Backend aşağıdaki durumlarda email göndermelidir:

1. **Kayıt Sonrası:**
   - Kullanıcıya: "Kaydınız alındı, onay bekleniyor"
   - Admin'e: "Yeni kullanıcı onay bekliyor"

2. **Onay Sonrası:**
   - Kullanıcıya: "Hesabınız onaylandı"

3. **Red Sonrası:**
   - Kullanıcıya: "Kaydınız reddedildi" + sebep

---

**Not:** Tüm tarih formatları ISO 8601 standardında olmalıdır: `YYYY-MM-DDTHH:mm:ssZ`
