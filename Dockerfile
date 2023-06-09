FROM --platform=linux/amd64 ubuntu:20.04
WORKDIR /home/app
# Add required libraries
RUN apt-get update && apt-get install -y \
        curl \
        jq \
        libnl-3-200 \
    && rm -rf /var/lib/apt/lists/*
# Install latest CRaC OpenJDK
RUN release="$(curl -sL https://api.github.com/repos/CRaC/openjdk-builds/releases/latest)" \
    && asset="$(echo $release | sed -e 's/\r//g' | sed -e 's/\x09//g' | tr '\n' ' ' | jq '.assets[] | select(.name | test("openjdk-[0-9]+-crac\\+[0-9]+_linux-x64\\.tar\\.gz"))')" \
    && id="$(echo $asset | jq .id)" \
    && name="$(echo $asset | jq -r .name)" \
    && curl -LJOH 'Accept: application/octet-stream' "https://api.github.com/repos/CRaC/openjdk-builds/releases/assets/$id" >&2 \
    && tar xzf "$name" \
    && mv ${name%%.tar.gz} /azul-crac-jdk \
    && rm "$name"
# Copy layers
COPY layers/libs /home/app/libs
COPY layers/classes /home/app/classes
COPY layers/resources /home/app/resources
COPY layers/application.jar /home/app/application.jar
# Add build scripts
COPY scripts/checkpoint.sh /home/app/checkpoint.sh
COPY scripts/warmup.sh /home/app/warmup.sh
ENTRYPOINT ["/home/app/checkpoint.sh"]
