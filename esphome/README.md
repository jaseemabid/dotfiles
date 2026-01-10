# ESP Home

## Setup

Run with docker compose or local install

```sh
$ docker compose up
$ uv run esphome dashboard ./config
```

Use web UI to configure stuff up and see logs

## Logs

```
uv run esphome --dashboard logs ./config/devkit.yaml --device OTA
```

## Notes

1. TODO: Temp isn't calibrated right with scd30, its always a bit more than the
real value.

2. Since pi.hole isn't the DHCP server on home network, force allocate a static
IP with the DHCP server and add hardcoded DNS A records in pi.hole. Prometheus
needs a good old A record while some other apps use mDNS.

| Device        | Mac                   | IP Address        |
|---------------|-----------------------|-------------------|
| devkit.local  | `AC:67:B2:CC:9D:BC`   | `192.168.1.150`   |
| feather.local | `7C:87:CE:F7:F0:24`   | `192.168.1.151`   |

3. As of 2025.4.06, feather.local can't read from the PM sensor :/ &
   Metric `esphome_sensor_failed` is active.

## Sample logs:

**SCD30 C02 sensor + dev kit**

```
[13:51:33][D][scd30:187]: Got CO2=1054.97ppm temperature=22.35°C humidity=49.51%
[13:51:33][D][sensor:125]: 'SCD30 CO2': Sending state 1054.96924 ppm with 1 decimals of accuracy
[13:51:33][D][sensor:125]: 'SCD30 Temperature': Sending state 22.35104 °C with 2 decimals of accuracy
[13:51:33][D][sensor:125]: 'SCD30 Humidity': Sending state 49.50562 % with 1 decimals of accuracy
```

**PMS5002 + Feather**

```
[13:53:45][D][pmsx003:175]: Got PM1.0 Concentration: 1 µg/m^3, PM2.5 Concentration 3 µg/m^3, PM10.0 Concentration: 4 µg/m^3
[13:53:45][D][sensor:125]: 'PM <1.0': Sending state 1.00000 µg/m³ with 0 decimals of accuracy
[13:53:45][D][sensor:125]: 'PM <2.5µm': Sending state 3.00000 µg/m³ with 0 decimals of accuracy
[13:53:45][D][sensor:125]: 'PM <10.0µm': Sending state 4.00000 µg/m³ with 0 decimals of accuracy
```
