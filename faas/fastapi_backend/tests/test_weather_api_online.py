import pytest
import httpx

# 线上 API 的基本 URL
BASE_URL = "https://weather.ncuos.com/api"

# 示例测试数据
test_lat = 37.7749
test_lon = -122.4194
test_location = "San Francisco"


@pytest.fixture(scope="module")
def client():
    with httpx.Client() as client:
        yield client


def test_get_weather(client):
    response = client.get(
        f"{BASE_URL}/weather?lat={test_lat}&lon={test_lon}&units=metric&lang=en"
    )
    assert response.status_code == 200
    data = response.json()
    assert "weather" in data
    assert "main" in data


def test_get_daily(client):
    response = client.get(
        f"{BASE_URL}/daily?lat={test_lat}&lon={test_lon}&units=metric&lang=en"
    )
    assert response.status_code == 200
    data = response.json()
    assert "daily" in data
    assert len(data["daily"]) > 0


def test_get_geocode(client):
    response = client.get(f"{BASE_URL}/geocode?q={test_location}&lang=en")
    assert response.status_code == 200
    data = response.json()
    print(data)
    assert len(data) > 0
    assert "name" in data[0]
    assert data[0]["name"] == test_location
