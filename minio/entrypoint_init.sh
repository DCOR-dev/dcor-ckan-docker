#!/bin/sh
set -e

# Start the MinIO server in the background
echo "[INFO] Starting MinIO server..."
/usr/bin/minio server --address "0.0.0.0:9000" --console-address "0.0.0.0:9001" /data-minio &
MINIO_PID=$!

# Wait for MinIO to be ready. This checks the health endpoint every 3 seconds.
echo "[INFO] Waiting for MinIO to be fully ready..."
until curl -fs http://localhost:9000/minio/health/ready; do
  echo "[WARN] MinIO not ready yet. Retrying in 3 seconds..."
  sleep 3
done

echo "[INFO] MinIO is ready. Running configuration with mc..."

# Set mc alias to point to the local MinIO server using root credentials.
# Note: all services in docker-compose share the same network, so we can use the service name 'minio'.
mc alias set local http://minio:9000 "${MINIO_ROOT_USER}" "${MINIO_ROOT_PASSWORD}"

# Create the new user with the specified access and secret keys.
# Note: mc expects the format: mc admin user add TARGET ACCESSKEY SECRETKEY
mc admin user add local "${MINIO_NEW_USER}" "${MINIO_NEW_SECRET_KEY}" || echo "[INFO] User '${MINIO_NEW_USER}' may already exist"

# Attach the readwrite policy to the new user.
mc admin policy attach local readwrite --user="${MINIO_NEW_USER}" || echo "[INFO] Policy may already be attached"

# Create a bucket called 'ckan' (or adjust name as needed).
mc mb local/ckan || echo "[INFO] Bucket 'ckan' may already exist"

# Set a download policy on the bucket storage subfolder.
mc policy set download local/ckan/storage || echo "[INFO] Bucket policy may already exist"

echo "[INFO] MinIO configuration complete."

# Optionally wait for the background process (MinIO) so the container doesn't exit.
wait $MINIO_PID
