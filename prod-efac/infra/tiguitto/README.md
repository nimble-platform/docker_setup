# TIGUITTO

Highly used `Telegraf` + `InfluxDB` + `Grafana` stack with `Mosquitto` MQTT broker. Hence, the name:

```
T   I   G   UITTO
            |--(mosq)
        |--(rafana)
    |--(nfluxDB)
 |--(elegraf)
```

## IoT Sensor Data

Refer to [iotfablab/EPCIS-IoT-Arduino](https://github.com/iotfablab/EPCIS-IoT-Arduino) to publish information to the MQTT broker.

## Setup

1. Create the following directories in the `mosquitto` directory for persistence and logs from the broker:

    ```bash
    mkdir -p mosquitto/log/
    mkdir -p mosquitto/data/
    ```
2. Change ownership of the `data` and `log` folders for the MQTT broker

    ```bash
    sudo chown -R 1883:1883 mosquitto/log/
    sudo chown -R 1883:1883 mosquitto/data/
    ```
    This should over a common error when the Mosquitto Container cannot open the log file to write (see [Mosquitto Issue #1078](https://github.com/eclipse/mosquitto/issues/1078))

3. Create a network for the complete stack using:

    ```bash
    docker network create iotstack
    ```
4. Update the `telegraf/telegraf.conf` according to the MQTT Topics you want to subscribe to under:

    ```toml
        [[inputs.mqtt_consumer]]
            topics = [ "<Company>/#" ]
    ```
5. Additionally, change the enum mappings to add EPC bizLocation meta-data as tags in the InfluxDB:

    ```toml
        [[processors.enum]]

        [[processors.enum.mapping]]

        # create a mapping between extracted sensorID and some meta-data
        tag = "sID"
        dest = "bizLocation"

        [processors.enum.mapping.value_mappings]
            # <<<<< INSERT MAPPINGS HERE >>>>>>
            # "MAC_ADDRESS" = "EPC_BizLocation"
            "AA:11:22:33:DD:FF" = "urn:id:loc:sgln:COMPANY_1"
            "AA:11:22:33:DE:11" = "urn:id:loc:sgln:COMPANY_2"
            "AA:11:22:34:AC:FB" = "urn:id:loc:sgln:COMPANY_3"
    ```

## Bringing up the stack

1. Bring the stack up using:

    ```bash
    docker-compose up -d
    ```
    this should create the necessary volumes and the data to the host from the respective containers (`influxdb`, `telegraf`, `grafana`, `mosquitto`)

2. Trace logs individually using:

    ```bash
    docker-compose logs -f <container_name>
    ```
    OR
    ```bash
    docker-compose logs -f 
    ```

## Test

Tested on: __Raspberry Pi 4 Model B 2GB RAM__

| Docker Tools |        Version                |
|:--------:|:---------------------------------:|
| `docker`         | __19.03.8__               |
| `docker-compose` | __1.25.5__                |
| `docker-py`      | __4.2.0__                 |
| `CPython`        | __3.7.3__                 |
| `OpenSSL`        | __1.1.1d__                |


### Checks

* Grafana should be available on `<IP_ADDRESS>:3000`
* InfluxDB should be available on `<IP_ADDRESS>:8086`
* InfluxDB admin should be available on `<IP_ADDRESS>:8083`
* Mosquitto broker should be avaialble on `<IP_
