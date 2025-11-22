# Fix for B2C Storefront 500 Error

## 🚨 Problem Identified

The B2C Storefront is showing a 500 Internal Server Error because:
1. **Backend API is not running** (port 9000)
2. **Database connection is failing** (PostgreSQL connection refused)

## 🔧 Quick Fix Steps

### Step 1: Fix Database Connection
Since PostgreSQL is not accessible on standard ports, you have two options:

#### Option A: Use SQLite (Recommended for Development)
Edit `/var/www/jualbeliraket.com/mercur/apps/backend/.env`:
```bash
# Change DATABASE_URL to:
DATABASE_URL=file:.medusa/server/db.sqlite3
```

#### Option B: Fix PostgreSQL Connection
Identify your PostgreSQL connection details and update `.env`:
```bash
# Check your actual PostgreSQL port and user
sudo ss -tulpn | grep postgres
# Then update DATABASE_URL accordingly
```

### Step 2: Clear Cache and Restart Backend
```bash
cd /var/www/jualbeliraket.com/mercur/apps/backend

# Remove medusa cache
rm -rf .medusa/server/

# Start backend
yarn dev
```

### Step 3: Wait for Backend to Start
The backend needs to:
- Connect to database
- Run migrations
- Start API server
- Generate publishable API key

This may take 1-2 minutes initially.

### Step 4: Update Frontend API Key
Once backend starts, get the publishable key:
```bash
cd /var/www/jualbeliraket.com/mercur/apps/backend
npx medusa user email -e admin@yourdomain.com -p password
```

Then update `/var/www/jualbeliraket.com/b2c-marketplace-storefront/.env.local`:
```bash
NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY=pk_your_actual_publishable_key_here
```

### Step 5: Restart Frontend
```bash
cd /var/www/jualbeliraket.com/b2c-marketplace-storefront
npm run dev
```

## 🎯 Easiest Solution (SQLite)

If you want to get it working quickly:

1. **Edit .env**:
   ```bash
   DATABASE_URL=file:.medusa/server/db.sqlite3
   ```

2. **Restart backend**:
   ```bash
   cd /var/www/jualbeliraket.com/mercur/apps/backend
   yarn dev
   ```

3. **Wait 2-3 minutes** for database setup to complete

4. **Check frontend**:
   ```bash
   curl http://localhost:3000
   ```

## 🔍 Verification Commands

Check if backend is running:
```bash
curl http://localhost:9000/health
```

Check if frontend works:
```bash
curl http://localhost:3000
```

## 📋 Complete Working Setup Order

1. **Backend** (Port 9000): `cd mercur/apps/backend && yarn dev`
2. **B2C Storefront** (Port 3000): `cd b2c-marketplace-storefront && npm run dev`
3. **Admin Panel** (Port 5173): `cd admin-panel && npm run dev`
4. **Vendor Panel** (Port 5174): `cd vendor-panel && npm run dev`

## 💡 Alternative: Use Production Database

If you have access to a working PostgreSQL database, use these steps:

1. **Update .env with correct DATABASE_URL**
2. **Run migrations**: `npx medusa db:migrate`
3. **Start backend**: `yarn dev`
4. **Update frontend with correct API key**

---

🚀 **The frontend 500 error will be fixed once the backend API is running and accessible!**
