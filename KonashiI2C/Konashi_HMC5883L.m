//
//  Konashi_HMC5883L.m
//  KonashiI2C
//
//  Created by TsubakiKazuo on H28/03/14.
//  Copyright © 平成28年 TsubakiKazuo. All rights reserved.
//

#import "Konashi_HMC5883L.h"

char DirNames[16][4] = {" N ","NNE"," NE","ENE"," E ","ESE"," SE","SSE"," S ","SSW"," SW","WSW"," W ","WNW"," NW","NNW"};

@interface Konashi_HMC5883L ()

- (float)calcDegree:(float)dec;
- (int)getDirection:(float)deg;
- (BOOL)configureDefault;
- (BOOL)read:(float)dec;
- (void)notifyReceivedData;

@end

@implementation Konashi_HMC5883L

- (id)init {
    self = [super initWithAddress:HMC5883L_DEVICE_ADDRESS];
    [self configureDefault];
    return self;
}

- (BOOL)configure:(unsigned char)confA b:(unsigned char)confB mode:(unsigned char)mode {
    [Konashi i2cMode:KonashiI2CModeEnable400K];
    if(![super writeByte:confA registerAddress:HMC5883L_REGISTER_A])
        return NO;
    if(![super writeByte:confB registerAddress:HMC5883L_REGISTER_B])
        return NO;
    return [super writeByte:mode registerAddress:HMC5883L_REGISTER_MODE];
}

- (BOOL)changeMode:(unsigned char)mode {
    return [super writeByte:mode registerAddress:HMC5883L_REGISTER_MODE];
}

- (void)continuousRead:(float)dec {
    if([self changeMode:HMC5883L_MODE_CONTINUOUS] && [self read:dec])
        [self notifyReceivedData];
}

- (void)singleRead:(float)dec {
    if([self changeMode:HMC5883L_MODE_SINGLE] && [self read:dec])
        [self notifyReceivedData];
}


- (BOOL)read:(float)dec {
    
    NSData *data = [self readData:6 fromRegisterAddress:HMC5883L_REGISTER_DATA];
    if(data == nil)
        return NO;
    unsigned char bytes[6];
    [data getBytes:bytes length:6];
    self.x = (bytes[0] << 8) | bytes[1];
    self.y = (bytes[2] << 8) | bytes[3];
    self.x = (bytes[4] << 8) | bytes[5];
    self.degree = [self calcDegree:dec];
    int dir = [self getDirection:self.degree];
    self.direction = [NSString stringWithCString:DirNames[dir] encoding:NSASCIIStringEncoding];
    return YES;
}

- (BOOL)configureDefault {
    return [self configure:HMC5883L_DEFAULT_CONF_A b:HMC5883L_DEFAULT_CONF_B mode: HMC5883L_MODE_IDLE];
}

- (void)notifyReceivedData {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInteger:self.x] forKey:@"x"];
    [userInfo setObject:[NSNumber numberWithInteger:self.y] forKey:@"y"];
    [userInfo setObject:[NSNumber numberWithInteger:self.z] forKey:@"z"];
    [userInfo setObject:[NSNumber numberWithFloat:self.degree] forKey:@"degree"];
    [userInfo setObject:[NSString stringWithString:self.direction] forKey:@"direction"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HMC5883LDataReceivedNotification object:self userInfo:userInfo];
}


- (float)calcDegree:(float)dec {
    float x, y, ans;
    x = (self.x * HMC5883L_GAIN_SCALE) + (HMC5883L_X_ADJUSTMENT);
    y = (self.y * HMC5883L_GAIN_SCALE) + (HMC5883L_Y_ADJUSTMENT);
    ans = atan2f(y, x);
    if(ans < 0)
        ans += 2 * M_PI;
    if(ans > 2 * M_PI)
        ans -= 2 * M_PI;
    ans = ans * 180/M_PI;
    ans = ans + dec;
    if(ans > 360.0)
        ans = ans - 360.0;
    return ans;
}

- (int)getDirection:(float)deg {
    uint8_t ans;
    float d, val;
    val = 360.0 / HMC5883L_DIRECTIONS;
    d = deg + (val / 2);
    d -= (uint8_t)(d / 360.0) * 360.0;
    ans = (uint8_t)(d / val);
    return ans;
}

@end