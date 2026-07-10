import { Elysia } from "elysia";
import { normalize } from "./utils/normalize";

const DB_SERVICE_URL = process.env.DB_SERVICE_URL || "http://mi-db:5000";

async function saveSearch(ip: string, anime: string) {
  try {
    await fetch(`${DB_SERVICE_URL}/search`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ ip, anime })
    });
  } catch (error) {
    console.error("Failed to save search:", error);
  }
}

async function fetchAniListAnime(search: string) {
  const res = await fetch("https://graphql.anilist.co", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      query: `
        query ($search: String) {
          Media(search: $search, type: ANIME) {
            title { romaji }
            description
            averageScore
            coverImage { large }
          }
        }
      `,
      variables: { search }
    })
  });

  const json = await res.json();

  if (json.errors || !json.data?.Media)
    return null;

  const m = json.data.Media;

  return normalize({
    title: m.title.romaji,
    description: m.description,
    score: m.averageScore,
    image: m.coverImage.large
  }, "anilist");
}

async function fetchJikanAnime(search: string) {
  const res = await fetch(
    `https://api.jikan.moe/v4/anime?q=${encodeURIComponent(search)}`
  );

  const json = await res.json();

  const a = json.data?.[0];

  if (!a)
    return null;

  return normalize({
    title: a.title,
    description: a.synopsis,
    score: a.score,
    image: a.images.jpg.image_url
  }, "jikan");
}

async function getAnime(search: string) {
  for (const fn of [fetchAniListAnime, fetchJikanAnime]) {
    try {
      const res = await fn(search);

      if (res)
        return res;

    } catch { }
  }

  return {
    error: "busque por todos lados y no salio nada util..."
  };
}

async function fetchAniListCharacter(search: string) {
  const res = await fetch("https://graphql.anilist.co", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      query: `
        query ($search: String) {
          Character(search: $search) {
            name { full }
            description
            image { large }
          }
        }
      `,
      variables: { search }
    })
  });

  const json = await res.json();

  if (json.errors || !json.data?.Character)
    return null;

  const c = json.data.Character;

  return {
    source: "anilist",
    name: c.name.full,
    description: c.description,
    image: c.image.large
  };
}

async function fetchJikanCharacter(search: string) {
  const res = await fetch(
    `https://api.jikan.moe/v4/characters?q=${encodeURIComponent(search)}`
  );

  const json = await res.json();

  const c = json.data?.[0];

  if (!c)
    return null;

  return {
    source: "jikan",
    name: c.name,
    description: c.about,
    image: c.images.jpg.image_url
  };
}

async function getCharacter(search: string) {
  for (const fn of [fetchAniListCharacter, fetchJikanCharacter]) {
    try {
      const res = await fn(search);

      if (res)
        return res;

    } catch { }
  }

  return {
    error: "ni rastro del personaje, desaparecio del mapa..."
  };
}

export const app = new Elysia()

  .get("/anime", async ({ query, request }) => {
    const search = query.q || "Naruto";
    const ip = request.headers.get("x-forwarded-for") || 
               request.headers.get("x-real-ip") || 
               "unknown";
    
    saveSearch(ip, search);
    
    return await getAnime(search);
  })

  .get("/anime/trending", async () => {
    try {
      const res = await fetch("https://api.jikan.moe/v4/top/anime");
      const json = await res.json();

      return json.data.slice(0, 5).map((a: any) => ({
        title: a.title,
        score: a.score,
        image: a.images.jpg.image_url
      }));

    } catch {
      return {
        error: "iba todo bien hasta que el top decidio no existir..."
      };
    }
  })

  .get("/anime/:id", async ({ params }) => {
    try {
      const res = await fetch(
        `https://api.jikan.moe/v4/anime/${params.id}`
      );

      const json = await res.json();

      const a = json.data;

      return {
        title: a.title,
        description: a.synopsis,
        score: a.score,
        image: a.images.jpg.image_url
      };

    } catch {
      return {
        error: "ese anime no aparecio, capaz el id esta cursed..."
      };
    }
  })

  .get("/character", async ({ query }) => {
    const search = query.q || "Naruto";
    return await getCharacter(search);
  })

  .get("/character/:id", async ({ params }) => {
    try {
      const res = await fetch(
        `https://api.jikan.moe/v4/characters/${params.id}`
      );

      const json = await res.json();

      const c = json.data;

      return {
        name: c.name,
        description: c.about,
        image: c.images.jpg.image_url
      };

    } catch {
      return {
        error: "ese personaje no quiere ser encontrado... o simplemente no existe."
      };
    }
  });

if (import.meta.main) {
  app.listen({
    port: 3000,
    hostname: "0.0.0.0"
  });

  console.log("Running on port 3000");
}