#!/bin/bash

echo "🚀 Starting OptiBasket Mock API Server..."
echo ""
echo "📍 Server will run on: http://localhost:3000"
echo "📋 Available endpoints:"
echo "   - POST http://localhost:3000/auth/login"
echo "   - POST http://localhost:3000/auth/register"
echo "   - GET  http://localhost:3000/products"
echo "   - GET  http://localhost:3000/products/:id"
echo "   - GET  http://localhost:3000/categories"
echo "   - GET  http://localhost:3000/cart"
echo ""
echo "🔑 Test credentials:"
echo "   Email: test@test.com"
echo "   Password: 12345678 (any password works in mock)"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

json-server --watch db.json --port 3000
