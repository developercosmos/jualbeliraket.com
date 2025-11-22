#!/bin/bash

echo "=== PostgreSQL and Redis Connectivity Test ==="
echo "Date: $(date)"
echo ""

echo "1. Testing PostgreSQL Container Status..."
docker ps --filter "name=mercur-postgres" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "2. Testing PostgreSQL Connection..."
if docker exec mercur-postgres psql -U mercur_prod -d mercur_marketplace_prod -c "SELECT 'PostgreSQL connection successful' as status;" 2>/dev/null; then
    echo "✅ PostgreSQL connection: SUCCESS"
else
    echo "❌ PostgreSQL connection: FAILED"
fi

echo ""
echo "3. Testing Redis Container Status..."
docker ps --filter "name=mercur-redis" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "4. Testing Redis Connection..."
if docker exec mercur-redis redis-cli ping 2>/dev/null | grep -q "PONG"; then
    echo "✅ Redis connection: SUCCESS"
else
    echo "❌ Redis connection: FAILED"
fi

echo ""
echo "5. Testing PostgreSQL Database Details..."
echo "Database: $(docker exec mercur-postgres psql -U mercur_prod -d mercur_marketplace_prod -t -c "SELECT current_database();" 2>/dev/null | xargs)"
echo "User: $(docker exec mercur-postgres psql -U mercur_prod -d mercur_marketplace_prod -t -c "SELECT current_user;" 2>/dev/null | xargs)"
echo "Tables: $(docker exec mercur-postgres psql -U mercur_prod -d mercur_marketplace_prod -t -c "SELECT count(*) FROM information_schema.tables WHERE table_schema = 'public';" 2>/dev/null | xargs)"

echo ""
echo "6. Testing Redis Memory Usage..."
docker exec mercur-redis redis-cli info memory | grep used_memory_human | cut -d: -f2 | tr -d '\r' | xargs echo "Redis Memory Used:"

echo ""
echo "7. Port Connectivity Tests..."
echo -n "PostgreSQL port 5434: "
if nc -z localhost 5434 2>/dev/null; then
    echo "✅ OPEN"
else
    echo "❌ CLOSED"
fi

echo -n "Redis port 6379: "
if nc -z localhost 6379 2>/dev/null; then
    echo "✅ OPEN"
else
    echo "❌ CLOSED"
fi

echo ""
echo "8. Container Health Status..."
docker ps --format "table {{.Names}}\t{{.Status}}" | grep -E "(mercur-postgres|mercur-redis)"

echo ""
echo "=== Test Complete ==="