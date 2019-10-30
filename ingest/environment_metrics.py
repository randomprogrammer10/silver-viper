from datetime import datetime as dt
from bme280 import BME280
from ltr559 import LTR559
from subprocess import PIPE, Popen
from pms5003 import PMS5003, ReadTimeoutError
from enviroplus import gas

class EnvironmentMetrics:
    # Adjust this to calibrate temperature
    # TEMP_TUNING_FACTOR = 0.8 # This is the tuning factor if it is the box
    TEMP_TUNING_FACTOR = 4.0 # This is the tuningh factor for out of the box (for now)

    # bme280 temperature/pressure/humidity sensor
    BME280_INSTANCE = BME280()
    # ltr559 light sensor
    LTR559_INSTANCE = LTR559()
    # PMS5003 data from air quality sensor
    PMS5003_INSTANCE = PMS5003()

    def __init__(self):
        pass

    @classmethod
    def get_cpu_temperature(cls):
        process = Popen(['vcgencmd', 'measure_temp'], stdout=PIPE, universal_newlines=True)
        output, _error = process.communicate()
        return float(output[output.index('=') + 1:output.rindex("'")])

    @classmethod
    def calibrated_temp(cls):
        cpu_temp = cls.get_cpu_temperature()
        cpu_temps = [cls.get_cpu_temperature()] * 5

        # Smooth out with some averaging to decrease jitter
        cpu_temps = cpu_temps[1:] + [cpu_temp]
        avg_cpu_temp = sum(cpu_temps) / float(len(cpu_temps))

        raw_temp = cls.BME280_INSTANCE.get_temperature()
        data = raw_temp - ((avg_cpu_temp - raw_temp) / cls.TEMP_TUNING_FACTOR)
        return data

    @classmethod
    def build_metrics_dict(cls):
        pms_data = cls.PMS5003_INSTANCE.read()
        return {
            "temperature": cls.calibrated_temp(),
            "pressure": cls.BME280_INSTANCE.get_pressure(),
            "humidity": cls.BME280_INSTANCE.get_humidity(),
            "light": cls.LTR559_INSTANCE.get_lux(),
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
