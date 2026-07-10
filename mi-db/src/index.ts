import Database from "better-sqlite3";
import { Elysia } from "elysia";

const DB_PATH = "/data/anime.db";

function initDb() {
  const db = new Database(DB_PATH);
  db.exec(`
    CREATE TABLE IF NOT EXISTS searches (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      ip TEXT NOT NULL,
      anime TEXT NOT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
  `);
  return db;
}

const db = initDb();

const app = new Elysia()
  .get("/health", () => ({ status: "healthy" }))

  .post("/search", ({ body }) => {
    const { ip, anime } = body as { ip: string; anime: string };
    
    if (!ip || !anime) {
      return { error: "ip and anime are required" };
    }
    
    const stmt = db.prepare("INSERT INTO searches (ip, anime) VALUES (?, ?)");
    stmt.run(ip, anime);
    
    return { status: "saved" };
  })

  .get("/searches", () => {
    const stmt = db.prepare("SELECT ip, anime, created_at FROM searches ORDER BY created_at DESC");
    const rows = stmt.all() as { ip: string; anime: string; created_at: string }[];
    return rows;
  });

if (import.meta.main) {
  app.listen({
    port: 5000,
    hostname: "0.0.0.0"
  });

  console.log("Running on port 5000");
}
