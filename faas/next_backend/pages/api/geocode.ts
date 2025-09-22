// pages/api/geocode.ts
import { NextApiRequest, NextApiResponse } from "next";

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  const { q, lang = "en" } = req.query;
  const API_KEY = process.env.OPENWEATHER_API_KEY;
  const url = `https://api.openweathermap.org/geo/1.0/direct?q=${q}&limit=5&appid=${API_KEY}&lang=${lang}`;

  try {
    const response = await fetch(url);
    if (!response.ok) {
      return res.status(response.status).json(await response.text());
    }
    const data = await response.json();
    res.status(200).json(data);
  } catch (error) {
    res.status(500).json({ error: (error as Error).message });
  }
}
