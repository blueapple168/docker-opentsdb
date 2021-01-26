ARG JDK_VERSION=8-jdk-buster
FROM openjdk:$JDK_VERSION

ENV GOSU_VERSION=1.12 \
    GOSU_SHA256SUM=0f25a21cf64e58078057adc78f38705163c1d564a959ff30a891c31917011a54 \
    OPENTSDB_VERSION=2.4.0 \
    OPENTSDB_SHA512SUM=36cd2a7a571706e1265f26d77add40931ff4ee76c3a8756b9196852903ddf1c466cdb3960a249adee141184f3cecf2f245f849561d5569be5dd19fd5acbcda12
RUN useradd opentsdb ; \
    apt-get update ; \
    apt-get install --no-install-recommends -y gnuplot-nox ; \
    apt-get clean ; \
    rm -rf /var/lib/apt/lists/* ; \
    curl -L https://github.com/OpenTSDB/opentsdb/releases/download/v$OPENTSDB_VERSION/opentsdb-$OPENTSDB_VERSION_all.deb > /tmp/opentsdb.deb ; \
    echo "$OPENTSDB_SHA512SUM  /tmp/opentsdb.deb" | sha512sum -c ; \
    dpkg -i /tmp/opentsdb.deb ; \
    rm /tmp/opentsdb.deb ; \
    rm /etc/opentsdb/opentsdb.conf ; \
    curl -sL "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64" > /usr/sbin/gosu ; \
    echo "$GOSU_SHA256SUM /usr/sbin/gosu" | sha256sum -c ; \
    chmod +x /usr/sbin/gosu

COPY ./logback.xml /etc/opentsdb/logback.xml

COPY ./run.sh /run.sh
COPY ./unprivileged.sh /unprivileged.sh

VOLUME /var/cache/opentsdb

ENTRYPOINT ["/run.sh"]
