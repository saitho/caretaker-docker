# Caretaker Docker container

## Submodules

Make sure to initialize submodules:

```
git submodule init && git submodule update
```

## Building the Docker image

Before building the image you'll have to modify the base image:

```
docker pull martinhelmich/typo3:8.7 && \
./docker-copyedit/docker-copyedit.py FROM martinhelmich/typo3:8.7 INTO martinhelmich/typo3-modified:8.7 REMOVE ALL VOLUMES && \
```

Then build with `docker build .` for via `docker-compose up`.