CRIU failure for CRaC under Docker Desktop 4.17.0

Build the image with

```
docker build --tag failure:1.0 .
```

Then run the image with

```
docker run \
    -v $(pwd)/cr:/home/app/cr \
    --privileged \
    failure:1.0
```

This will write binary snapshot files into the `cr` directory.

When there's a failure, the details can be seen in a file `dump4.log` in the `cr` directory.