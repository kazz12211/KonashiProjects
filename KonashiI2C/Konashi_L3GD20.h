//
//  Konashi_L3GD20.h
//  KonashiI2C
//
//  Created by TsubakiKazuo on H28/03/14.
//  Copyright © 平成28年 TsubakiKazuo. All rights reserved.
//

#ifndef Konashi_L3GD20_h
#define Konashi_L3GD20_h

#import "KonashiI2CDevice.h"

#define L3GD20_ADDRESS_VDDIO                            (0x6B)          // 1101011 (if SA0 connected to VDDIO)
#define L3GD20_ADDRESS_GND                              (0x6A)          // 1101010 (if SA0 connected to GND)
#define L3GD20_POLL_TIMEOUT                             (100)           // Maximum number of read attempts
#define L3GD20_ID                                       (0xD4)

#define L3GD20_SENSITIVITY_250DPS                       (0.00875F)      // Roughly 22/256 for fixed point match
#define L3GD20_SENSITIVITY_500DPS                       (0.0175F)       // Roughly 45/256
#define L3GD20_SENSITIVITY_2000DPS                      (0.070F)        // Roughly 18/256
#define L3GD20_DPS_TO_RADS                              (0.017453293F)  // degress/s to rad/s multiplier

const unsigned char L3GD20_REGISTER_WHO_AM_I            = 0x0F;         // 11010100   r
const unsigned char L3GD20_REGISTER_CTRL_REG1           = 0x20;         // 00000111   rw
const unsigned char L3GD20_REGISTER_CTRL_REG2           = 0x21;         // 00000000   rw
const unsigned char L3GD20_REGISTER_CTRL_REG3           = 0x22;         // 00000000   rw
const unsigned char L3GD20_REGISTER_CTRL_REG4           = 0x23;         // 00000000   rw
const unsigned char L3GD20_REGISTER_CTRL_REG5           = 0x24;         // 00000000   rw
const unsigned char L3GD20_REGISTER_REFERENCE           = 0x25;         // 00000000   rw
const unsigned char L3GD20_REGISTER_OUT_TEMP            = 0x26;         //            r
const unsigned char L3GD20_REGISTER_STATUS_REG          = 0x27;         //            r
const unsigned char L3GD20_REGISTER_OUT_X_L             = 0x28;         //            r
const unsigned char L3GD20_REGISTER_OUT_X_H             = 0x29;         //            r
const unsigned char L3GD20_REGISTER_OUT_Y_L             = 0x2A;         //            r
const unsigned char L3GD20_REGISTER_OUT_Y_H             = 0x2B;         //            r
const unsigned char L3GD20_REGISTER_OUT_Z_L             = 0x2C;         //            r
const unsigned char L3GD20_REGISTER_OUT_Z_H             = 0x2D;         //            r
const unsigned char L3GD20_REGISTER_FIFO_CTRL_REG       = 0x2E;         // 00000000   rw
const unsigned char L3GD20_REGISTER_FIFO_SRC_REG        = 0x2F;         //            r
const unsigned char L3GD20_REGISTER_INT1_CFG            = 0x30;         // 00000000   rw
const unsigned char L3GD20_REGISTER_INT1_SRC            = 0x31;         //            r
const unsigned char L3GD20_REGISTER_TSH_XH              = 0x32;         // 00000000   rw
const unsigned char L3GD20_REGISTER_TSH_XL              = 0x33;         // 00000000   rw
const unsigned char L3GD20_REGISTER_TSH_YH              = 0x34;         // 00000000   rw
const unsigned char L3GD20_REGISTER_TSH_YL              = 0x35;         // 00000000   rw
const unsigned char L3GD20_REGISTER_TSH_ZH              = 0x36;         // 00000000   rw
const unsigned char L3GD20_REGISTER_TSH_ZL              = 0x37;         // 00000000   rw
const unsigned char L3GD20_REGISTER_INT1_DURATION       = 0x38;         // 00000000   rw

typedef enum
{
    L3GD20_RANGE_250DPS,
    L3GD20_RANGE_500DPS,
    L3GD20_RANGE_2000DPS
} L3GD20Range;


@interface Konashi_L3GD20 : KonashiI2CDevice

@property (nonatomic, assign) float x;
@property (nonatomic, assign) float y;
@property (nonatomic, assign) float z;

// default initializer uses L3GD20_ADDRESS_GND for device address
- (id)init;
// explictly specify device address (L3GD20_ADDRESS_VDDIO or L3GD20_ADDRESS_GND)
- (id)initWithAddress:(unsigned char)addr;
- (BOOL)configure:(L3GD20Range)range;
- (BOOL)read;

@property (nonatomic, assign) L3GD20Range range;

@end

#endif /* Konashi_L3GD20_h */
