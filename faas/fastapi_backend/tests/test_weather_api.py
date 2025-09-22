import pytest
from fastapi.testclient import TestClient
import sys
import os

# 将父目录添加到 sys.path 中
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from api import app

# 创建 FastAPI 的测试客户端
client = TestClient(app)

# 示例测试数据
test_lat = 37.7749
test_lon = -122.4194
test_location = "San Francisco"


# 使用 pytest fixture 来为每个测试用例提供一个测试客户端
@pytest.fixture(scope="module")
def test_client():
    with TestClient(app) as client:
        yield client


def test_get_weather(test_client):
    response = test_client.get(
        f"/api/weather?lat={test_lat}&lon={test_lon}&units=metric&lang=en"
    )
    assert response.status_code == 200
    data = response.json()
    assert "weather" in data
    assert "main" in data


def test_get_daily(test_client):
    response = test_client.get(
        f"/api/daily?lat={test_lat}&lon={test_lon}&units=metric&lang=en"
    )
    assert response.status_code == 200
    data = response.json()
    assert "daily" in data
    assert len(data["daily"]) > 0


def test_get_geocode(test_client):
    response = test_client.get(f"/api/geocode?location={test_location}&lang=en")
    assert response.status_code == 200
    data = response.json()
    print(data)
    assert len(data) > 0
    assert "name" in data[0]
    assert data[0]["name"] == test_location
