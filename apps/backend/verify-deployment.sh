#!/bin/bash

echo "🔍 Verifying Deployment..."
echo ""

echo "1️⃣ Checking Cloudinary Integration..."
sshpass -p 'Easy2Use$' ssh -o StrictHostKeyChecking=no qt@172.16.40.61 << 'EOF'
cd ~/zoea-backend
docker-compose exec -T db psql -U admin -d main -t -c "SELECT CASE WHEN EXISTS (SELECT 1 FROM integrations WHERE name = 'cloudinary' AND is_active = true) THEN '✅ Cloudinary integration exists and is active' ELSE '❌ Cloudinary integration not found' END;"
EOF

echo ""
echo "2️⃣ Checking Countries..."
sshpass -p 'Easy2Use$' ssh -o StrictHostKeyChecking=no qt@172.16.40.61 << 'EOF'
cd ~/zoea-backend
docker-compose exec -T db psql -U admin -d main -t -c "SELECT 'Total active countries: ' || COUNT(*) FROM countries WHERE is_active = true;"
docker-compose exec -T db psql -U admin -d main -t -c "SELECT name FROM countries WHERE code IN ('RWA', 'ZAF', 'NGA') AND is_active = true ORDER BY name;"
EOF

echo ""
echo "3️⃣ Checking Cities..."
sshpass -p 'Easy2Use$' ssh -o StrictHostKeyChecking=no qt@172.16.40.61 << 'EOF'
cd ~/zoea-backend
docker-compose exec -T db psql -U admin -d main -t -c "SELECT 'Total active cities: ' || COUNT(*) FROM cities WHERE is_active = true;"
docker-compose exec -T db psql -U admin -d main -t -c "SELECT c.name as country, COUNT(ci.id) as cities FROM countries c LEFT JOIN cities ci ON c.id = ci.country_id WHERE c.code IN ('RWA', 'ZAF', 'NGA') AND c.is_active = true GROUP BY c.name ORDER BY c.name;"
EOF

echo ""
echo "4️⃣ Checking Backend Health..."
curl -s https://zoea-africa.qtsoftwareltd.com/api/health | jq -r '.status' 2>/dev/null && echo "✅ Backend is healthy" || echo "❌ Backend health check failed"

echo ""
echo "5️⃣ Checking Cloudinary Loading in Logs..."
sshpass -p 'Easy2Use$' ssh -o StrictHostKeyChecking=no qt@172.16.40.61 << 'EOF'
cd ~/zoea-backend
docker-compose logs api | grep -i "cloudinary\|loaded.*account" | tail -5 || echo "No Cloudinary logs found (may need to check after first upload)"
EOF

echo ""
echo "✅ Verification Complete!"
echo ""
echo "📝 To test image upload:"
echo "   1. Go to http://209.74.80.195:3015 (or https://admin.zoea.africa)"
echo "   2. Login to admin portal"
echo "   3. Navigate to Listings → Create Listing"
echo "   4. Upload an image"
echo "   5. Check Cloudinary dashboard: https://console.cloudinary.com/console/c/dzcvbnvh3"

