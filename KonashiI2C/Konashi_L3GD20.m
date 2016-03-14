//
//  Konashi_L3GD20.m
//  KonashiI2C
//
//  Created by TsubakiKazuo on H28/03/14.
//  Copyright © 平成28年 TsubakiKazuo. All rights reserved.
//

#import "Konashi_L3GD20.h"

@implementation Konashi_L3GD20

- (id)init {
    return [self initWithAddress:L3GD20_ADDRESS_GND];
}

- (id)initWithAddress:(unsigned char)addr {
    self = [super initWithAddress:addr];
    // default setting
    self.range = L3GD20_RANGE_250DPS;
    return self;
}

- (BOOL)configure:(L3GD20Range)range {
    switch(range) {
        case L3GD20_RANGE_250DPS:
            [self writeByte:0x00 registerAddress:L3GD20_REGISTER_CTRL_REG4];
            break;
        case L3GD20_RANGE_500DPS:
            [self writeByte:0x10 registerAddress:L3GD20_REGISTER_CTRL_REG4];
            break;
        case L3GD20_RANGE_2000DPS:
            [self writeByte:0x20 registerAddress:L3GD20_REGISTER_CTRL_REG4];
            break;
        default:    // L3GD20_RANGE_250DPS
            [self writeByte:0x00 registerAddress:L3GD20_REGISTER_CTRL_REG4];
            break;
    }
    return YES;
}

- (BOOL)begin {
    unsigned char who;
    if(![self readByte:&who fromRegisterAddress:L3GD20_REGISTER_WHO_AM_I])
        return NO;
    if(who != L3GD20_ID)
        return NO;
    // go to normal mode with measuring x, y, z axis.
    return [self writeByte:0x0F registerAddress:L3GD20_REGISTER_CTRL_REG1];
}

- (void)end {
    // go to sleep mode
    [self writeByte:0x08 registerAddress:L3GD20_REGISTER_CTRL_REG1];
}

- (BOOL)read {
    unsigned char bytes[6];
    if([self readBytes:bytes length:6 fromRegisterAddress:L3GD20_REGISTER_OUT_X_L | 0x80]) {
        int x, y, z;
        x = (int)(bytes[0] | (((int)bytes[1]) << 8));
        y = (int)(bytes[2] | (((int)bytes[3]) << 8));
        z = (int)(bytes[4] | (((int)bytes[5]) << 8));
        switch(self.range) {
            case L3GD20_RANGE_250DPS:
                self.x = x * L3GD20_SENSITIVITY_250DPS;
                self.y = y * L3GD20_SENSITIVITY_250DPS;
                self.z = z * L3GD20_SENSITIVITY_250DPS;
                break;
            case L3GD20_RANGE_500DPS:
                self.x = x * L3GD20_SENSITIVITY_500DPS;
                self.y = y * L3GD20_SENSITIVITY_500DPS;
                self.z = z * L3GD20_SENSITIVITY_500DPS;
                break;
            case L3GD20_RANGE_2000DPS:
                self.x = x * L3GD20_SENSITIVITY_2000DPS;
                self.y = y * L3GD20_SENSITIVITY_2000DPS;
                self.z = z * L3GD20_SENSITIVITY_2000DPS;
                break;
        }
        
    }
    return NO;
}

@end