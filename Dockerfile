# Start with a base Linux image
FROM debian:bullseye

# Install required tools
RUN apt-get update && apt-get install -y curl git unzip xz-utils libglu1-mesa

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git /opt/flutter && \
    /opt/flutter/bin/flutter --version

# Set Flutter to a version compatible with Dart 3.5.4
WORKDIR /opt/flutter
RUN git checkout 3.13.0 # Adjust to a compatible Flutter version
ENV PATH="/opt/flutter/bin:$PATH"

# Pre-cache Dart SDK and Flutter dependencies
RUN flutter precache && flutter doctor

# Add a non-root user
RUN useradd -ms /bin/bash flutteruser
USER flutteruser

# Set the working directory for your project
WORKDIR /app
COPY . .

# Fetch Flutter dependencies
RUN flutter pub get

# Enable web development
RUN flutter config --enable-web

# Expose a port for the Flutter web server
EXPOSE 8080

# Command to run the Flutter application
CMD ["flutter", "run", "--no-sound-null-safety", "-d", "web-server", "--web-port", "8080"]
