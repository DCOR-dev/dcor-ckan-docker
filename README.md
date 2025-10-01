## Docker Compose setup for DCOR-CKAN

This repository extends the official [CKAN Docker setup](https://github.com/ckan/ckan-docker) to support custom development needs, including:

- Custom Dockerfiles and entrypoint scripts for CKAN
   - Install `dcor` extensions packages
      - `pip install dcor_control`
      - `dcor inspect --assume-yes`
- Self-hosted MinIO server for object storage integration  
   - The `minio` service is based on a custom Docker image built from the `./minio` directory. It includes:

   - `Dockerfile` based on the official `minio/minio` image
   - `entrypoint_init.sh` that:
      - Starts the MinIO server
      - Waits for it to be ready
      - Configures users, buckets, and policies using `mc`
      - Automatically creates:
        - A new user
        - `ckan` bucket with `readwrite` policy

    This enables integration of MinIO as a storage backend for CKAN file uploads.


## Docker Images
All custom images are pushed to the Docker Hub repo: [mpzpm/dcor-dev](https://hub.docker.com/repository/docker/mpzpm/dcor-dev/tags)

You can pull them directly using:

```bash
docker pull mpzpm/dcor-dev:ckan-latest

docker pull mpzpm/dcor-dev:postgresql-latest

docker pull mpzpm/dcor-dev:minio-latest
```



