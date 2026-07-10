import { Elysia } from 'elysia';
import { insertSearch, getSearchesByIp, getAllSearches } from './schema';

const app = new Elysia()
  .get('/', () => ({
    message: 'mi-db API - SQLite database for anime searches',
    endpoints: {
      'POST /search': 'Save a search (ip, anime)',
      'GET /search/:ip': 'Get searches by IP',
      'GET /searches': 'Get all searches'
    }
  }))
  .post('/search', async ({ body }: { body: { ip: string; anime: string } }) => {
    const { ip, anime } = body;
    if (!ip || !anime) {
      return { error: 'ip and anime are required' };
    }
    insertSearch(ip, anime);
    return { success: true, ip, anime };
  })
  .get('/search/:ip', ({ params }: { params: { ip: string } }) => {
    const searches = getSearchesByIp(params.ip);
    return { ip: params.ip, searches };
  })
  .get('/searches', () => {
    const searches = getAllSearches();
    return { total: searches.length, searches };
  })
  .listen(3002);

console.log('🚀 mi-db server running on http://localhost:3002');
