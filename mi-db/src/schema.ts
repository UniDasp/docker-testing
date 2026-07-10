import Database from 'better-sqlite3';
import { join } from 'path';

const dbPath = join(process.cwd(), 'anime.db');
const db = new Database(dbPath);

// Crear tabla si no existe
db.exec(`
  CREATE TABLE IF NOT EXISTS searches (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ip TEXT NOT NULL,
    anime TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
  )
`);

// Crear índice para búsquedas más rápidas
db.exec(`
  CREATE INDEX IF NOT EXISTS idx_ip ON searches(ip)
`);

console.log('📦 Database initialized at:', dbPath);

export interface Search {
  id?: number;
  ip: string;
  anime: string;
  created_at?: string;
}

export const insertSearch = (ip: string, anime: string): void => {
  const stmt = db.prepare('INSERT INTO searches (ip, anime) VALUES (?, ?)');
  stmt.run(ip, anime);
};

export const getSearchesByIp = (ip: string): Search[] => {
  const stmt = db.prepare('SELECT * FROM searches WHERE ip = ? ORDER BY created_at DESC');
  return stmt.all(ip) as Search[];
};

export const getAllSearches = (): Search[] => {
  const stmt = db.prepare('SELECT * FROM searches ORDER BY created_at DESC');
  return stmt.all() as Search[];
};

export default db;
