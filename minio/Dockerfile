# ======= Stage 1: Get the mc binary =======
FROM minio/mc:latest as mc-stage
# This stage pulls the official mc image and its binary is available in /usr/bin/mc

# ======= Stage 2: Build the custom MinIO image with embedded mc =======
FROM minio/minio:latest

# Copy the mc binary from the mc-stage
COPY --from=mc-stage /usr/bin/mc /usr/bin/mc

# Copy our custom entrypoint script into the image
COPY entrypoint_init.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose ports (if not already in the base image)
EXPOSE 9000 9001

# Set the entrypoint to our custom script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
