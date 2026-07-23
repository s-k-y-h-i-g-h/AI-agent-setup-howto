# --- Stage 1: Build the site ---
FROM node:20-alpine AS builder
WORKDIR /app

# Using npm install instead of npm ci for better compatibility with existing lockfiles
COPY package*.json ./
RUN npm install

# Copy the rest of the project and build it
COPY . .
RUN npm run build

# --- Stage 2: Serve the files ---
FROM nginx:alpine
# Remove default nginx static content
RUN rm -rf /usr/share/nginx/html/*
# Copy the built site from the builder stage into Nginx's web folder
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
