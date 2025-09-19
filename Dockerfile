# ===== Build stage =====
FROM gradle:8.8-jdk17 AS build
WORKDIR /app
COPY . .
RUN gradle clean bootJar --no-daemon -x test

# ===== Runtime stage =====
FROM eclipse-temurin:17-jre
WORKDIR /app

COPY --from=build /app/build/libs/*.jar app.jar

ENV JAVA_OPTS=""
ENV SPRING_PROFILES_ACTIVE=local

EXPOSE 8080
ENTRYPOINT ["sh","-c","java $JAVA_OPTS -jar /app/app.jar --spring.profiles.active=${SPRING_PROFILES_ACTIVE}"]
