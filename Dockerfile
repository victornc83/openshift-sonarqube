FROM openjdk:8-alpine
MAINTAINER Victor Nieto <victornc83@gmail.com>

ENV SONAR_VERSION=6.4 \
    SONARQUBE_HOME=/opt/sonarqube \
    SONARQUBE_JDBC_USERNAME=sonar \
    SONARQUBE_JDBC_PASSWORD=sonar \
    SONARQUBE_JDBC_URL=

EXPOSE 9000

RUN set -x \
    && apk add --no-cache unzip wget \
    && cd /tmp \
    && wget --no-check-certificate -O sonarqube.zip --no-verbose https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip \
    && mkdir /opt \
    && cd /opt \
    && unzip /tmp/sonarqube.zip \
    && mv sonarqube-$SONAR_VERSION sonarqube \
    && rm /tmp/sonarqube.zip*
COPY fix-permissions.sh /tmp/
COPY run.sh $SONARQUBE_HOME/bin/

RUN /tmp/fix-permissions.sh /opt/sonarqube \
    && chmod 755 $SONARQUBE_HOME/bin/run.sh

VOLUME "$SONARQUBE_HOME/data"

USER 1001
WORKDIR $SONARQUBE_HOME
ENTRYPOINT ["./bin/run.sh"]
