FROM eclipse-temurin:21-jdk AS build

ENV GRADLE_HOME=/opt/gradle \
    GRADLE_USER_HOME=/cache/.gradle \
    GRADLE_OPTS="-Dorg.gradle.daemon=false \
    -Dorg.gradle.parallel=true \
    -Dorg.gradle.caching=true \
    -Xmx2g"

WORKDIR /app
COPY . .

RUN --mount=type=cache,target=/root/.gradle,sharing=locked \
    ./gradlew installDist --no-daemon --build-cache

RUN pwd
RUN ls -al
RUN ls -al build
RUN ls -al app
RUN ls -al app/build

FROM eclipse-temurin:21-jre AS runtime

WORKDIR /app
COPY --from=build /app/app/build/install/app/ ./

CMD ["./bin/app"]