FROM node:20-slim

# Install git and CA certs
RUN apt-get update && apt-get install -y git ca-certificates

WORKDIR /app

COPY ./package.json ./package.json
COPY ./package-lock.json ./package-lock.json

RUN npm install

COPY . .

# Optional: disable SSL check if Zscaler blocks Prisma binary fetch
ENV NODE_TLS_REJECT_UNAUTHORIZED=0



# Only generate Prisma client at build time (safe)
RUN npx prisma generate

RUN npm run build

EXPOSE 3000

CMD ["npm", "run", "dev:docker"]
