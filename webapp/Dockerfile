# Base Image
FROM node:18 as base

# Set working directory
WORKDIR /usr/src/app

# Copy package files and install dependencies
COPY app/package*.json ./
RUN npm install

# Copy the entire app's source code
COPY . .

from base as dev

WORKDIR /usr/src/app/app
EXPOSE 8080
CMD ["npm", "start"]

from base as prod 

WORKDIR /usr/src/app/app
EXPOSE 8080
CMD ["npm", "start"]

