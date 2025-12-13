# La Fourchette Backend API

Node.js + Express backend for the La Fourchette restaurant reservation system.

## Setup

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Configure database:**
   - Copy `.env.example` to `.env`
   - Update with your MS SQL Server credentials:
     ```
     DB_USER=your_username
     DB_PASSWORD=your_password
     DB_SERVER=your_server_address
     DB_DATABASE=la_fourchette
     ```

3. **Start the server:**
   ```bash
   npm start
   ```

   For development with auto-reload:
   ```bash
   npm run dev
   ```

## API Endpoints

### Menu

**Get Weekly Menu**
```
GET /api/menu/week?date=2024-12-13
```

Response:
```json
{
  "week_start": "2024-12-09",
  "days": [
    {
      "date": "2024-12-09",
      "items": [
        {
          "schedule_id": "uuid",
          "food_item": {
            "id": "uuid",
            "name": "Μουσακάς",
            "name_en": "Moussaka",
            "image_url": "https://...",
            "image_source": "preloaded"
          },
          "price": 8.50,
          "stock_quantity": 50
        }
      ]
    }
  ]
}
```

### Orders

**Create Order**
```
POST /api/orders
Content-Type: application/json

{
  "user_email": "user@company.com",
  "user_name": "John",
  "user_surname": "Doe",
  "schedule_id": "uuid",
  "quantity": 2,
  "order_type": "restaurant"
}
```

**Get User Orders**
```
GET /api/orders?user_email=user@company.com
```

**Update Order**
```
PATCH /api/orders/{order_id}
Content-Type: application/json

{
  "quantity": 3
}
```

**Delete Order**
```
DELETE /api/orders/{order_id}
```

## Testing

Test the health endpoint:
```bash
curl http://localhost:3000/health
```

Test the menu endpoint:
```bash
curl "http://localhost:3000/api/menu/week?date=2024-12-13"
```
