from fastapi import FastAPI, HTTPException
import httpx

app = FastAPI()

# 将你的 OpenWeatherMap API 密钥存储为环境变量
API_KEY = "73023ffd0325ec02832b91e190a04f6d"


@app.get("/")
def read_root():
    return {"message": "Hello, World!"}


@app.get("/hello/{name}")
def read_item(name: str):
    return {"message": f"Hello, {name}!"}


@app.get("/api/weather")
async def get_weather(lat: float, lon: float, units: str = "metric", lang: str = "en"):
    url = f"https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&units={units}&lang={lang}&appid={API_KEY}"
    async with httpx.AsyncClient() as client:
        response = await client.get(url)
    if response.status_code != 200:
        raise HTTPException(status_code=response.status_code, detail=response.text)
    return response.json()


@app.get("/api/daily")
async def get_daily(lat: float, lon: float, units: str = "metric", lang: str = "en"):
    url = f"https://api.openweathermap.org/data/3.0/onecall?lat={lat}&lon={lon}&units={units}&lang={lang}&exclude=minutely,current&appid={API_KEY}"
    async with httpx.AsyncClient() as client:
        response = await client.get(url)
    if response.status_code != 200:
        raise HTTPException(status_code=response.status_code, detail=response.text)
    return response.json()


@app.get("/api/geocode")
async def get_geocode(location: str, lang: str = "en"):
    url = f"http://api.openweathermap.org/geo/1.0/direct?q={location}&limit=5&appid={API_KEY}&lang={lang}"
    async with httpx.AsyncClient() as client:
        response = await client.get(url)
    if response.status_code != 200:
        raise HTTPException(status_code=response.status_code, detail=response.text)
    return response.json()
