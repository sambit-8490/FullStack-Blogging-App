# -------- Stage 1: Build the JAR --------
FROM maven:3.9.5-eclipse-temurin-17-alpine AS build

WORKDIR /app

# Copy Maven project files
COPY pom.xml .
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# -------- Stage 2: Runtime Image --------
FROM eclipse-temurin:17-jdk-alpine

WORKDIR /usr/src/app

# Copy the JAR from the build stage
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

# Optional: Healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget --spider -q http://localhost:8080 || exit 1

CMD ["java", "-jar", "app.jar"]
