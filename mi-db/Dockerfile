FROM oven/bun:1

WORKDIR /app

RUN apt-get update && apt-get install -y python3 make g++ && rm -rf /var/lib/apt/lists/*

COPY package.json bun.lock bun.lockb* ./
RUN bun install

COPY . .

EXPOSE 5000

CMD ["bun", "run", "start"]
