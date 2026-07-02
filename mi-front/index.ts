const express = require("express");
const path = require("path");

const app = express();
const port = Number(process.env.PORT || 3001);
const apiBaseUrl = (process.env.API_BASE_URL || "http://app:3000").replace(/\/$/, "");

app.use(express.static(path.join(process.cwd())));

app.get("/api/*pathPart", async (req, res) => {
  const pathPart = Array.isArray(req.params.pathPart)
    ? req.params.pathPart.join('/')
    : req.params.pathPart;

  const query = new URLSearchParams(req.query).toString();
  const url = `${apiBaseUrl}/${pathPart}${query ? `?${query}` : ""}`;

  try {
    const response = await fetch(url);
    const data = await response.json();
    res.json(data);
  } catch (error) {
    res.status(500).json({
      error: "algo se rompio en el proxy... mala cuea",
      details: String(error)
    });
  }
});

app.listen(port, "0.0.0.0", () => {
  console.log(`Frontend listening on port ${port}, API base URL: ${apiBaseUrl}`);
});