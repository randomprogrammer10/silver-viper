# Silver Viper

## Introduction

## Ingestor

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
