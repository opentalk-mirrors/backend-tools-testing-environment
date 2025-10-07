#!/bin/sh
# Automated CORS injection script for docker-entrypoint.d

echo "Auto-injecting CORS headers with sed..."

# Create log directory if it doesn't exist (fix nginx startup issue)
mkdir -p /var/log/nginx

# Wait for nginx to be fully ready
sleep 3

# Check if CORS headers are already present (avoid duplicate injection)
if grep -q "Access-Control-Allow-Origin" /etc/nginx/conf.d/default.conf; then
    echo "CORS headers already present, skipping injection"
    exit 0
fi

# Backup original config
cp /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.backup

# Currently we need CORS only for the the Outlook add-in development,
# which would run on localhost and request the .well-known location
sed -i '/location \/\.well-known\/opentalk\/client {/a\
          # CORS headers for well-known endpoint (localhost only)\
          set $cors_origin "";\
          if ($http_origin ~* "^https?://localhost(:[0-9]+)?$") {\
              set $cors_origin $http_origin;\
          }\
          add_header '\''Access-Control-Allow-Origin'\'' $cors_origin always;\
          add_header '\''Access-Control-Allow-Methods'\'' '\''GET, OPTIONS'\'' always;\
          add_header '\''Access-Control-Allow-Headers'\'' '\''DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range,Authorization'\'' always;' /etc/nginx/conf.d/default.conf

# Test nginx configuration before proceeding
echo "Testing nginx configuration..."
if nginx -t; then
    echo "✓ Nginx configuration test passed"
    echo "CORS headers auto-injected successfully!"
else
    echo "✗ Nginx configuration test failed"
    echo "Restoring backup configuration..."
    cp /etc/nginx/conf.d/default.conf.backup /etc/nginx/conf.d/default.conf
    exit 1
fi
