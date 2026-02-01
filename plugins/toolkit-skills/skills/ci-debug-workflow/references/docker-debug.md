# Docker Debug Reference

## Container Won't Start

### Check Logs

```bash
docker logs <container>
docker logs --tail 100 -f <container>
```

### Inspect Container

```bash
docker inspect <container>
docker inspect --format='{{.State.ExitCode}}' <container>
```

### Common Exit Codes

- `0` - Success
- `1` - Application error
- `137` - OOM killed (128 + 9)
- `139` - Segfault (128 + 11)
- `143` - SIGTERM (128 + 15)

## Build Failures

### Cache Issues

```bash
# Rebuild without cache
docker build --no-cache -t myimage .

# Prune build cache
docker builder prune
```

### Layer Debugging

```bash
# Build up to specific stage
docker build --target builder -t debug .

# Run shell in intermediate image
docker run -it --rm <image-id> /bin/sh
```

## Runtime Issues

### Shell Into Running Container

```bash
docker exec -it <container> /bin/sh
# or for bash
docker exec -it <container> /bin/bash
```

### Shell Into Failed Container

```bash
# Commit failed container state
docker commit <container> debug-image
docker run -it --rm debug-image /bin/sh
```

### Override Entrypoint

```bash
docker run -it --rm --entrypoint /bin/sh myimage
```

## Resource Problems

### Check Resource Usage

```bash
docker stats <container>
docker system df
```

### Memory Limits

```bash
# Run with more memory
docker run -m 2g myimage

# Check if OOM killed
docker inspect --format='{{.State.OOMKilled}}' <container>
```

## Network Issues

### Check Network

```bash
docker network ls
docker network inspect <network>
```

### Test Connectivity

```bash
docker exec <container> curl -I http://other-service:8080
docker exec <container> nslookup other-service
```

### Port Mapping

```bash
docker port <container>
docker run -p 8080:80 myimage
```

## Volume Problems

### Check Mounts

```bash
docker inspect --format='{{.Mounts}}' <container>
```

### Permission Issues

```bash
# Check user inside container
docker exec <container> id
docker exec <container> ls -la /app
```

## Docker Compose

### View Combined Logs

```bash
docker compose logs -f
docker compose logs <service>
```

### Rebuild Single Service

```bash
docker compose up -d --build <service>
```

### Shell Into Service

```bash
docker compose exec <service> /bin/sh
```
