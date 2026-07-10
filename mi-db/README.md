# mi-db

SQLite database service for storing anime searches by IP.

## Tech Stack
- **Runtime**: Bun
- **Language**: TypeScript
- **Database**: SQLite (better-sqlite3)
- **Framework**: Elysia

## Schema
- `ip`: IP address that performed the search
- `anime`: Anime that was searched

## API Endpoints
- `POST /search` - Save a search (body: `{ ip, anime }`)
- `GET /search/:ip` - Get all searches by IP
- `GET /searches` - Get all searches

## Development
```bash
bun install
bun run dev
```

## Production
```bash
bun run start
```
