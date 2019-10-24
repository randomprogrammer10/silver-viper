from environment_metrics import EnvironmentMetrics
from influxdb.manager import InfluxDBManager

metrics = EnvironmentMetrics()
TIME_DELAY = 1

while True:
    try:
        InfluxDBManager.post_data(metrics.build_metrics_dict())
    except Exception as e:
        print(e)
    sleep(TIME_DELAY)
