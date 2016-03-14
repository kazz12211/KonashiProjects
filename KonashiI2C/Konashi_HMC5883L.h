//
//  Konashi_HMC5883L.h
//  KonashiI2C
//
//  Created by TsubakiKazuo on H28/03/14.
//  Copyright © 平成28年 TsubakiKazuo. All rights reserved.
//

#ifndef Konashi_HMC5883L_h
#define Konashi_HMC5883L_h

#define HMC5883L_DEVICE_ADDRESS                 (0x1E)

const unsigned char HMC5883L_REGISTER_A         = 0x00;
const unsigned char HMC5883L_REGISTER_B         = 0x01;
const unsigned char HMC5883L_REGISTER_MODE      = 0x02;
const unsigned char HMC5883L_REGISTER_DATA      = 0x03;

const unsigned char HMC5883L_DEFAULT_CONF_A     = 0b01110000;
const unsigned char HMC5883L_DEFAULT_CONF_B     = 0b00100000;

#define HMC5883L_GAIN_SCALE                     (0.92)

const unsigned char HMC5883L_MODE_CONTINUOUS    = 0b0000000;
const unsigned char HMC5883L_MODE_SINGLE        = 0b0000001;
const unsigned char HMC5883L_MODE_IDLE          = 0b0000011;
const unsigned char HMC5883L_MODE_DEFAULT       = HMC5883L_MODE_SINGLE;

const int HMC5883L_X_ADJUSTMENT                 = -252;
const int HMC5883L_Y_ADJUSTMENT                 = 102;
const unsigned int HMC5883L_DIRECTIONS          = 16;

#import "KonashiI2CDevice.h"

@interface Konashi_HMC5883L : KonashiI2CDevice

@property (nonatomic, assign) NSInteger x;
@property (nonatomic, assign) NSInteger y;
@property (nonatomic, assign) NSInteger z;
@property (nonatomic, assign) float degree;
@property (nonatomic, assign) NSString *direction;

- (id)init;
- (BOOL)configure:(unsigned char)confA b:(unsigned char)confB mode:(unsigned char)mode;
- (BOOL)changeMode:(unsigned char)mode;
- (void)continuousRead:(float)dec;
- (void)singleRead:(float)dec;

@end

static NSString *const HMC5883LDataReceivedNotification = @"HMC5883LDataReceivedNotification";

#endif /* Konashi_HMC5883L_h */
