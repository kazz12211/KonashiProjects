//
//  Konashi_BME280.h
//  KonashiI2C
//
//  Created by TsubakiKazuo on H28/03/20.
//  Copyright © 平成28年 TsubakiKazuo. All rights reserved.
//

#ifndef Konashi_BME280_h
#define Konashi_BME280_h

#import "KonashiI2CDevice.h"

#define BME280_ADDRESS_VDDIO                        (0x77)    // 1110111 (if SA0 connected to VDDIO)
#define BME280_ADDRESS_GND                          (0x76)    // 1110110 (if SA0 connected to GND)
#define BME280_ID                                   (0x60)


const unsigned char BME280_REGISTER_CALLIB25         = 0xA1;
const unsigned char BME280_REGISTER_CALLIB26         = 0xE1;
const unsigned char BME280_REGISTER_WHO_AM_I         = 0xD0;
const unsigned char BME280_REGISTER_RESET            = 0xE0;
const unsigned char BME280_REGISTER_CTRL_HUMIDITY    = 0xF2;
const unsigned char BME280_REGISTER_STATUS           = 0xF3;
const unsigned char BME280_REGISTER_CTRL_MEASURE     = 0xF4;
const unsigned char BME280_REGISTER_CONFIG           = 0xF5;
const unsigned char BME280_REGISTER_PRESSURE_MSB     = 0xF7;
const unsigned char BME280_REGISTER_PRESSURE_LSB     = 0xF8;
const unsigned char BME280_REGISTER_PRESSURE_XLSB    = 0xF9;
const unsigned char BME280_REGISTER_TEMPERATURE_MSB  = 0xFA;
const unsigned char BME280_REGISTER_TEMPERATURE_LSB  = 0xFB;
const unsigned char BME280_REGISTER_TEMPERATURE_XLSB = 0xFC;
const unsigned char BME280_REGISTER_HUMIDITY_MSB     = 0xFD;
const unsigned char BME280_REGISTER_HUMIDITY_LSB     = 0xFE;

typedef enum
{
    BME280_STANDBY_0_5              = 0x00,
    BME280_STANDBY_62_5             = 0x01,
    BME280_STANDBY_125              = 0x02,
    BME280_STANDBY_250              = 0x03,
    BME280_STANDBY_500              = 0x04,
    BME280_STANDBY_1000             = 0x05,
    BME280_STANDBY_10               = 0x06,
    BME280_STANDBY_20               = 0x07
} BME280Standby;

typedef enum
{
    BME280_FILTER_OFF               = 0x00,
    BME280_FILTER_2                 = 0x01,
    BME280_FILTER_4                 = 0x02,
    BME280_FILTER_8                 = 0x03,
    BME280_FILTER_16                = 0x04
} BME280Filter;

typedef enum
{
    BME280_SPI3_ENABLE              = 0x01,
    BME280_SPI3_DISABLE             = 0x00
} BME280SpiMode;

// used by control measure
typedef enum
{
    BME280_TEMP_OVERSAMPLING_SKIP   = 0x00,
    BME280_TEMP_OVERSAMPLING_1      = 0x01,
    BME280_TEMP_OVERSAMPLING_2      = 0x02,
    BME280_TEMP_OVERSAMPLING_4      = 0x03,
    BME280_TEMP_OVERSAMPLING_8      = 0x04,
    BME280_TEMP_OVERSAMPLING_16     = 0x05
} BME280TemperatureOversampling;

typedef enum
{
    BME280_PRESS_OVERSAMPLING_SKIP  = 0x00,
    BME280_PRESS_OVERSAMPLING_1     = 0x01,
    BME280_PRESS_OVERSAMPLING_2     = 0x02,
    BME280_PRESS_OVERSAMPLING_4     = 0x03,
    BME280_PRESS_OVERSAMPLING_8     = 0x04,
    BME280_PRESS_OVERSAMPLING_16    = 0x05
} BME280PressureOversampling;

typedef enum
{
    BME280_MODE_SLEEP               = 0x00,
    BME280_MODE_FORCED              = 0x01,
    BME280_MODE_NORMAL              = 0x03
} BME280Mode;

// used by control humidity
typedef enum
{
    BME280_HUMID_OVERSAMPLING_SKIP  = 0x00,
    BME280_HUMID_OVERSAMPLING_1     = 0x01,
    BME280_HUMID_OVERSAMPLING_2     = 0x02,
    BME280_HUMID_OVERSAMPLING_4     = 0x03,
    BME280_HUMID_OVERSAMPLING_8     = 0x04,
    BME280_HUMID_OVERSAMPLING_16    = 0x05
} BME280HumidityOversampling;


@interface Konashi_BME280 : KonashiI2CDevice

@property (nonatomic, assign) double temperature;
@property (nonatomic, assign) double pressure;
@property (nonatomic, assign) double humidity;

// default initializer uses BME280_ADDRESS_GND for device address
- (id)init;
// explictly specify device address (BME280_ADDRESS_VDDIO or BME280_ADDRESS_GND)
- (id)initWithAddress:(unsigned char)addr;
- (BOOL)configure:(BME280Standby)standby
           filter:(BME280Filter)filter
              spi:(BME280SpiMode)spiMode
temperatureSampling:(BME280TemperatureOversampling)tempSampling
 pressureSampling:(BME280PressureOversampling)pressureSampling
 humiditySampling:(BME280HumidityOversampling)humiditySampling
             mode:(BME280Mode)mode;
- (BOOL)read;


@end

#endif /* Konashi_BME280_h */
