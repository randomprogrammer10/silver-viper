from datetime import datetime as dt
from bme280 import BME280
from ltr559 import LTR559
from subprocess import PIPE, Popen
from pms5003 import PMS5003, ReadTimeoutError
from enviroplus import gas

TEMP_TUNING_FACTOR = 0.8
# BME280 temperature/pressure/humidity sensor
BME280 = BME280()
# LTR559 light sensor
LTR559 = LTR559()
# PMS5003 data from air quality sensor
PMS5003 = PMS5003()


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
    pms_data = PMS5003.read()
    return {
        "temperature": calibrated_temp(),
        "pressure": BME280.get_pressure(),
        "humidity": BME280.get_humidity(),
        "light": LTR559.get_lux(),
        "gas_oxidizing": gas.read_oxidising(),
        "gas_reducing": gas.read_reducing(),
        "gas_nh3": gas.read_nh3(),
        "pm_ug_per_m3_1_0": pms_data.pm_ug_per_m3(1.0),
        "pm_ug_per_m3_2_5": pms_data.pm_ug_per_m3(2.5),
        "pm_ug_per_m3_10": pms_data.pm_ug_per_m3(10),
        "pm_per_dl_0_3": pms_data.pm_per_1l_air(0.3),
        "pm_per_dl_0_5": pms_data.pm_per_1l_air(0.5),
        "pm_per_dl_1_0": pms_data.pm_per_1l_air(1.0),
        "pm_per_dl_2_5": pms_data.pm_per_1l_air(2.5),
        "pm_per_dl_5_0": pms_data.pm_per_1l_air(5.0),
        "pm_per_dl_10_0": pms_data.pm_per_1l_air(10.0)
    }

print(build_metrics_dict())
