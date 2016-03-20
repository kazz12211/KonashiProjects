//
//  Konashi_BME280.m
//  KonashiI2C
//
//  Created by TsubakiKazuo on H28/03/20.
//  Copyright © 平成28年 TsubakiKazuo. All rights reserved.
//

#import "Konashi_BME280.h"

uint8_t conf, ctrl_meas, ctrl_hum;
unsigned long int hum_raw, temp_raw, press_raw;
uint16_t dig_T1;
int16_t dig_T2;
int16_t dig_T3;
uint16_t dig_P1;
int16_t dig_P2;
int16_t dig_P3;
int16_t dig_P4;
int16_t dig_P5;
int16_t dig_P6;
int16_t dig_P7;
int16_t dig_P8;
int16_t dig_P9;
int8_t  dig_H1;
int16_t dig_H2;
int8_t  dig_H3;
int16_t dig_H4;
int16_t dig_H5;
int8_t  dig_H6;
signed long int t_fine;

@interface Konashi_BME280 ()

- (BOOL)readTrim;
- (BOOL)readRawData;
- (signed long)calibratedTemperature:(signed long) rawT;
- (unsigned long)calibratedPressure:(signed long) rawP;
- (unsigned long)calibratedHumidity:(signed long) rawH;

@end

@implementation Konashi_BME280

// default initializer uses BME280_ADDRESS_GND for device address
- (id)init {
    self = [super initWithAddress:BME280_ADDRESS_GND];
    return self;
}

// explictly specify device address (BME280_ADDRESS_VDDIO or BME280_ADDRESS_GND)
- (id)initWithAddress:(unsigned char)addr {
    self = [super initWithAddress:addr];
    return self;
}

- (BOOL)configure:(BME280Standby)standby
           filter:(BME280Filter)filter
              spi:(BME280SpiMode)spiMode
temperatureSampling:(BME280TemperatureOversampling)tempSampling
 pressureSampling:(BME280PressureOversampling)pressureSampling
 humiditySampling:(BME280HumidityOversampling)humiditySampling
             mode:(BME280Mode)mode {
    conf = (standby << 5) | (filter << 2) | spiMode;
    ctrl_meas = (tempSampling << 5) | (pressureSampling << 2) | mode;
    ctrl_hum = humiditySampling;
    
    unsigned char deviceId;
    if(![self readByte:&deviceId fromRegisterAddress:BME280_REGISTER_WHO_AM_I])
        return NO;
    if(deviceId != BME280_ID)
        return NO;
    
    if(![self writeByte:conf registerAddress:BME280_REGISTER_CONFIG])
        return NO;
    if(![self writeByte:ctrl_meas registerAddress:BME280_REGISTER_CTRL_MEASURE])
        return NO;
    if(![self writeByte:ctrl_hum registerAddress:BME280_REGISTER_CTRL_HUMIDITY])
        return NO;
    
    return [self readTrim];
}

- (BOOL)read {
    signed long temp_cal;
    unsigned long press_cal, hum_cal;
    
    if(![self readRawData])
        return NO;
    
    temp_cal = [self calibratedTemperature:temp_raw];
    press_cal = [self calibratedPressure:press_raw];
    hum_cal = [self calibratedHumidity:hum_raw];
    
    self.temperature = (double)temp_cal / 100.0;
    self.pressure = (double)press_cal / 100.0;
    self.humidity = (double)hum_cal / 1024.0;
    
    return YES;
}

- (BOOL)readTrim {
    uint8_t data[32];
    
    unsigned char bytes[32];
    if([self readBytes:bytes length:24 fromRegisterAddress:0x88] != 24)
        return NO;
    if(![self readByte:&bytes[24] fromRegisterAddress:BME280_REGISTER_CALLIB25])
        return NO;
    if([self readBytes:&bytes[25] length:7 fromRegisterAddress:BME280_REGISTER_CALLIB26] != 7)
        return NO;
    for(int i = 0; i < 32; i++) {
        data[i] = (uint8_t)bytes[i];
    }
    dig_T1 = (data[1] << 8) | data[0];
    dig_T2 = (data[3] << 8) | data[2];
    dig_T3 = (data[5] << 8) | data[4];
    dig_P1 = (data[7] << 8) | data[6];
    dig_P2 = (data[9] << 8) | data[8];
    dig_P3 = (data[11] << 8) | data[10];
    dig_P4 = (data[13] << 8) | data[12];
    dig_P5 = (data[15] << 8) | data[14];
    dig_P6 = (data[17] << 8) | data[16];
    dig_P7 = (data[19] << 8) | data[18];
    dig_P8 = (data[21] << 8) | data[20];
    dig_P9 = (data[23] << 8) | data[22];
    dig_H1 = data[24];
    dig_H2 = (data[26] << 8) | data[25];
    dig_H3 = data[27];
    dig_H4 = (data[28] << 4) | (0x0F & data[29]);
    dig_H5 = (data[30] << 4) | ((data[29] >> 4) & 0x0F);
    dig_H6 = data[31];
    return YES;
}


- (BOOL)readRawData {
    uint32_t data[8];
    unsigned char buff[8];
    if(![self writeByte:BME280_REGISTER_PRESSURE_MSB registerAddress:self.deviceAddress])
        return NO;
    if([self readBytes:buff length:8 fromRegisterAddress:BME280_REGISTER_PRESSURE_MSB] != 8)
        return NO;
    for(int i = 0; i < 8; i++) {
        data[i] = (uint32_t)buff[i];
    }
    
    press_raw = (data[0] << 12) | (data[1] << 4) | (data[2] >> 4);
    temp_raw = (data[3] << 12) | (data[4] << 4) | (data[5] >> 4);
    hum_raw = (data[6] << 8) | data[7];
    return YES;
}


- (signed long)calibratedTemperature:(signed long) rawT {
    signed long int var1, var2, T;
    var1 = ((((rawT >> 3) - ((signed long int)dig_T1<<1))) * ((signed long int)dig_T2)) >> 11;
    var2 = (((((rawT >> 4) - ((signed long int)dig_T1)) * ((rawT>>4) - ((signed long int)dig_T1))) >> 12) * ((signed long int)dig_T3)) >> 14;
    
    t_fine = var1 + var2;
    T = (t_fine * 5 + 128) >> 8;
    return T;
}


- (unsigned long)calibratedPressure:(signed long) rawP {
    signed long int var1, var2;
    unsigned long int P;
    var1 = (((signed long int)t_fine)>>1) - (signed long int)64000;
    var2 = (((var1>>2) * (var1>>2)) >> 11) * ((signed long int)dig_P6);
    var2 = var2 + ((var1*((signed long int)dig_P5))<<1);
    var2 = (var2>>2)+(((signed long int)dig_P4)<<16);
    var1 = (((dig_P3 * (((var1>>2)*(var1>>2)) >> 13)) >>3) + ((((signed long int)dig_P2) * var1)>>1))>>18;
    var1 = ((((32768+var1))*((signed long int)dig_P1))>>15);
    if (var1 == 0)
    {
        return 0;
    }
    P = (((unsigned long int)(((signed long int)1048576)-rawP)-(var2>>12)))*3125;
    if(P<0x80000000)
    {
        P = (P << 1) / ((unsigned long int) var1);
    }
    else
    {
        P = (P / (unsigned long int)var1) * 2;
    }
    var1 = (((signed long int)dig_P9) * ((signed long int)(((P>>3) * (P>>3))>>13)))>>12;
    var2 = (((signed long int)(P>>2)) * ((signed long int)dig_P8))>>13;
    P = (unsigned long int)((signed long int)P + ((var1 + var2 + dig_P7) >> 4));
    return P;
}

- (unsigned long)calibratedHumidity:(signed long)rawH {
    signed long int v_x1;
    
    v_x1 = (t_fine - ((signed long int)76800));
    v_x1 = (((((rawH << 14) -(((signed long int)dig_H4) << 20) - (((signed long int)dig_H5) * v_x1)) +
              ((signed long int)16384)) >> 15) * (((((((v_x1 * ((signed long int)dig_H6)) >> 10) *
                                                      (((v_x1 * ((signed long int)dig_H3)) >> 11) + ((signed long int) 32768))) >> 10) + (( signed long int)2097152)) *
                                                   ((signed long int) dig_H2) + 8192) >> 14));
    v_x1 = (v_x1 - (((((v_x1 >> 15) * (v_x1 >> 15)) >> 7) * ((signed long int)dig_H1)) >> 4));
    v_x1 = (v_x1 < 0 ? 0 : v_x1);
    v_x1 = (v_x1 > 419430400 ? 419430400 : v_x1);
    return (unsigned long int)(v_x1 >> 12);   
}


@end
