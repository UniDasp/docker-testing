FROM oven/bun:1

# Install Python for better-sqlite3 native compilation
RUN apk add --no-cache python3 make g++

WORKDIR /app

COPY package.json ./
RUN bun install

COPY . .

EXPOSE 3002

CMD ["bun", "run", "start"]
