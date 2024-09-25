FROM node:20-alpine

RUN mkdir -p /app/public

WORKDIR /app
RUN npm install -g json-server

EXPOSE 3000
VOLUME [ "/app/public", "/app/db.json" ]

CMD [ "npx", "json-server", "/app/db.json", "--host", "0.0.0.0", "-s", "/app/public"]