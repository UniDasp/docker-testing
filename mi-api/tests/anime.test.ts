import { describe, expect, test } from "vitest";
import { normalize } from "../src/utils/normalize";

describe("Normalize Utility", () => {
  test("Debe mantener la fuente", () => {
    const result = normalize({
      title: "Naruto",
      description: "Ninja",
      score: 80,
      image: "naruto.jpg"
    }, "anilist");

    expect(result.source).toBe("anilist");
  });

  test("Debe mantener el título", () => {
    const result = normalize({
      title: "One Piece",
      description: "Piratas",
      score: 95,
      image: "onepiece.jpg"
    }, "jikan");

    expect(result.title).toBe("One Piece");
  });

  test("Debe contener todas las propiedades requeridas", () => {
    const result = normalize({
      title: "Bleach",
      description: "Shinigamis",
      score: 85,
      image: "bleach.jpg"
    }, "anilist");

    expect(result).toHaveProperty("source");
    expect(result).toHaveProperty("title");
    expect(result).toHaveProperty("description");
    expect(result).toHaveProperty("score");
    expect(result).toHaveProperty("image");
  });

  test("La puntuación debe ser numérica", () => {
    const result = normalize({
      title: "Attack on Titan",
      description: "Titanes",
      score: 91,
      image: "aot.jpg"
    }, "jikan");

    expect(typeof result.score).toBe("number");
  });

  test("La imagen debe conservarse correctamente", () => {
    const result = normalize({
      title: "Death Note",
      description: "Notebook",
      score: 90,
      image: "https://example.com/image.jpg"
    }, "anilist");

    expect(result.image).toContain("http");
  });
});