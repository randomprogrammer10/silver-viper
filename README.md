# Silver Viper

## Introduction

## Ingestor
Ingestor will poll for environmental metrics, format the data as expected by InfluxDB, and serve as client to write data
to the InfluxDB.


To run the runner script, do the following:
```bash
$ python3 ingest/runner.py

```

### Sample Data Payload
```json
{
  'temperature': 6.119342916169259,
  'pressure': 1016.2504846824368,
  'humidity': 17.044552225182734,
  'light': 286.0087,
  'gas_oxidizing': 3747.8176527643063,
  'gas_reducing': 579051.5463917528,
  'gas_nh3': 66709.16334661355,
  'pm_ug_per_m3_1_0': 0,
  'pm_ug_per_m3_2_5': 1,
  'pm_ug_per_m3_10': 1,
  'pm_per_dl_0_3': 339,
  'pm_per_dl_0_5': 98,
  'pm_per_dl_1_0': 16,
  'pm_per_dl_2_5': 1,
  'pm_per_dl_5_0': 1,
  'pm_per_dl_10_0': 0
}
```

### InfluxDB

We are using InfluxDB to store the time series data.  You can can connect to the local InfluxDB by running the following command on the Pi:

```bash
$ influx -host 127.0.0.1 -port 8086 -database silverviper
```

## Back-End API

To run the back-end server, do the following:

```bash
$ cd back-end
$ ruby app.rb
```

In the console output, you should see that the server is running on local port `4567`.  You can test that it is working by running `curl http://localhost:4567/health`.

## Front-End
