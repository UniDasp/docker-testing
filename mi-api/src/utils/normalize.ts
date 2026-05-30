export const normalize = (data: any, source: string) => ({
  source,
  title: data.title,
  description: data.description,
  score: data.score,
  image: data.image
});