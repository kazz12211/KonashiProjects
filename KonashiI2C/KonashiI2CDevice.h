//
//  KonashiI2CDevice.h
//  KonashiI2C
//
//  Created by TsubakiKazuo on H28/03/14.
//  Copyright © 平成28年 TsubakiKazuo. All rights reserved.
//

#ifndef KonashiI2CDevice_h
#define KonashiI2CDevice_h


#import "Konashi.h"

@interface KonashiI2CDevice : NSObject

@property (nonatomic, assign) unsigned char deviceAddress;

- (id)initWithAddress:(unsigned char)address;

- (BOOL)writeData:(NSData *)data registerAddress:(unsigned char)regAddr;
- (BOOL)writeBytes:(unsigned char *)bytes length:(NSUInteger)length registerAddress:(unsigned char)regAddr;
- (BOOL)writeByte:(unsigned char)aByte registerAddress:(unsigned char)regAddr;

- (NSData *)readData:(NSUInteger)length fromRegisterAddress:(unsigned char)regAddr;
- (BOOL)readByte:(unsigned char *)byte fromRegisterAddress:(unsigned char)regAddr;
- (NSUInteger)readBytes:(unsigned char *)bytes length:(NSUInteger)length fromRegisterAddress:(unsigned char)regAddr;

@end

#endif /* KonashiI2CDevice_h */
