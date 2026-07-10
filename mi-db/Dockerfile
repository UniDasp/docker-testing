FROM oven/bun:1

# Install Python and build tools for better-sqlite3 native compilation
RUN apt-get update && apt-get install -y python3 make g++ && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package.json ./
RUN bun install

COPY . .

EXPOSE 3002

CMD ["bun", "run", "start"]
