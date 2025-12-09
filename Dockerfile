# Multi-Stage Build: Yeh method final image ko chota aur secure rakhta hai.

# Stage 1: Build Stage
# Maven aur Java JDK (17) use karke code compile aur package karein.
FROM maven:3.9.6-eclipse-temurin-17 AS build

# Application source code copy karein
COPY . /app

# Working directory set karein
WORKDIR /app

# Maven ka use karke application ko package karein (final jar file banayenge)
# '-DskipTests' se build time kam hoga. Production pipeline mein tests run hone chahiye.
RUN mvn clean package -DskipTests

# Stage 2: Run Stage
# Production ke liye sirf JRE (Java Runtime Environment) wali lightweight image use karein
FROM eclipse-temurin:17-jre-focal

# Final jar file ko build stage se copy karein
# Is file ka naam aapki pom.xml ke <artifactId>-<version> se banta hai.
# Agar aapne Spring Initializr se banaya hai, toh yeh naam 'aams-0.0.1-SNAPSHOT.jar' hoga.
COPY --from=build /app/target/aams-0.0.1-SNAPSHOT.jar aams.jar

# Container ke liye port 8080 open karein
EXPOSE 8080

# Container start hone par application run karein
ENTRYPOINT ["java", "-jar", "/aams.jar"]