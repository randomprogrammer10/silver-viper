import requests


class InfluxDBManager:
    DB_URL = 'http://localhost:8086/write'
    TABLE_NAME = 'weather_metrics'
    POST_PARAMS = { "db": "silverviper" }

    def __init__(self):
        pass

    @classmethod
    def post_data(cls, data_dict):
        payload = cls.format_influxdb_body(data_dict)
        response = requests.post(cls.DB_URL, params=cls.POST_PARAMS, data=payload)
        response.raise_for_status()
        return

    @classmethod
    def format_influxdb_body(cls, payload):
        formatted_str_body = "{},".format(cls.TABLE_NAME)
        for key, val in payload.items():
            formatted_str_body += "{}={} ".format(key, val)

        return formatted_str_body
