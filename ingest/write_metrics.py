from datetime import datetime as dt
from bme280 import BME280
from ltr559 import LTR559
from subprocess import PIPE, Popen


TEMP_TUNING_FACTOR = 0.8
# BME280 temperature/pressure/humidity sensor
BME280 = BME280()
# LTR559 light sensor
LTR559 = LTR559()


# Get the temperature of the CPU for compensation
def get_cpu_temperature():
    process = Popen(['vcgencmd', 'measure_temp'], stdout=PIPE, universal_newlines=True)
    output, _error = process.communicate()
    return float(output[output.index('=') + 1:output.rindex("'")])


def calibrated_temp():
    cpu_temp = get_cpu_temperature()
    cpu_temps = [get_cpu_temperature()] * 5

    # Smooth out with some averaging to decrease jitter
    cpu_temps = cpu_temps[1:] + [cpu_temp]
    avg_cpu_temp = sum(cpu_temps) / float(len(cpu_temps))

    raw_temp = BME280.get_temperature()
    data = raw_temp - ((avg_cpu_temp - raw_temp) / TEMP_TUNING_FACTOR)
    return data


def build_metrics_dict():
    return {
        "timestamp": dt.now().isoformat(),
        "temperature": calibrated_temp(),
        "pressure": BME280.get_pressure(),
        "humidity": BME280.get_humidity(),
        "light": LTR559.get_lux(),
    }

print(build_metrics_dict())
