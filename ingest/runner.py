import requests
from time import sleep
from environment_metrics import EnvironmentMetrics
from influxdb.manager import InfluxDBManager

metrics = EnvironmentMetrics()
TIME_DELAY = 1

while True:
    try:
        data = metrics.build_metrics_dict()
        print(data)
        response = InfluxDBManager.post_data(data)
        response.raise_for_status()
    except requests.exceptions.RequestException:
        print(response.json())
    except Exception as e:
        print(e)
    sleep(TIME_DELAY)
