# build stage
FROM node:lts-alpine as build-stage
ARG VITE_BACKEND_URL
ENV VITE_BACKEND_URL=$VITE_BACKEND_URL
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build-only

# production stage
FROM nginx:stable-alpine as production-stage
COPY nginx.conf /etc/nginx/
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 8080:8080
ENV VITE_BACKEND_URL=$VITE_BACKEND_URL

CMD ["nginx", "-g", "daemon off;"]

# sudo docker build -t vuejs-cerythme/dockerize-vuejs-app .
# sudo docker run -it -p 80:80 --rm --name dockerize-vuejs-app-1 vuejs-cerythme/dockerize-vuejs-app