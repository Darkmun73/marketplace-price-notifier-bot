# Build
FROM gradle:9-jdk25 AS builder
COPY . /home/gradle/src
WORKDIR /home/gradle/src
RUN ./gradlew bootJar --no-daemon

# Final
FROM bellsoft/liberica-runtime-container:jre-25-musl
RUN apk add --no-cache shadow && \
    groupadd -g 100001 app_group && \
    useradd -r -s /usr/sbin/nologin -u 100001 -g app_group app
USER app
WORKDIR /app
COPY --chown=app:app_group \
     --from=builder \
     /home/gradle/src/build/libs/*-SNAPSHOT.jar /app/tg-bot.jar
ENTRYPOINT ["java", "-jar", "/app/tg-bot.jar"]