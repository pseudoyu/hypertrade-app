// pages/api/daily.ts
import { NextApiRequest, NextApiResponse } from "next";

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  const { lat, lon, units = "metric", lang = "en" } = req.query;
  const API_KEY = process.env.OPENWEATHER_API_KEY;
  const url = `https://api.openweathermap.org/data/3.0/onecall?lat=${lat}&lon=${lon}&units=${units}&lang=${lang}&exclude=minutely,current&appid=${API_KEY}`;

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
