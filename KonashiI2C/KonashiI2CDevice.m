//
//  KonashiI2CDevice.m
//  KonashiI2C
//
//  Created by TsubakiKazuo on H28/03/14.
//  Copyright © 平成28年 TsubakiKazuo. All rights reserved.
//

#import "KonashiI2CDevice.h"

@interface KonashiI2CDevice ()

- (BOOL)writeData:(NSData *)data;
- (BOOL)writeBytes:(unsigned char *)bytes length:(NSUInteger)length;
- (BOOL)writeByte:(unsigned char)aByte;

@end

@implementation KonashiI2CDevice

- (id)initWithAddress:(unsigned char)address {
    self = [super init];
    self.deviceAddress = address;
    return self;
}

- (BOOL)begin {
    return NO;
}

- (void)end {
    
}

- (BOOL)writeData:(NSData *) data {
    
    if([Konashi i2cStartCondition] == KonashiResultFailure)
        return NO;
    [NSThread sleepForTimeInterval:0.01];
    if([Konashi i2cWriteData:data address:self.deviceAddress] == KonashiResultFailure)
        return NO;
    [NSThread sleepForTimeInterval:0.01];
    if([Konashi i2cStopCondition] == KonashiResultFailure)
        return NO;
    [NSThread sleepForTimeInterval:0.01];
    return YES;
}

- (BOOL)writeBytes:(unsigned char *)bytes length:(NSUInteger)length {
    NSData *data = [NSData dataWithBytes:bytes length:length];
    return [self writeData:data];
}

- (BOOL)writeByte:(unsigned char)aByte {
    unsigned char bytes[1];
    bytes[0] = aByte;
    return [self writeBytes:bytes length:1];
}

- (BOOL)writeData:(NSData *)data registerAddress:(unsigned char)regAddr {
    if(![self writeByte:regAddr])
        return NO;
    return [self writeData:data];
}

- (BOOL)writeBytes:(unsigned char *)bytes length:(NSUInteger)length registerAddress:(unsigned char)regAddr {
    if(![self writeByte:regAddr])
        return NO;
    return [self writeBytes:bytes length:length];
}

- (BOOL)writeByte:(unsigned char)aByte registerAddress:(unsigned char)regAddr {
    if(![self writeByte:regAddr])
        return NO;
    return [self writeByte:aByte];
}


- (NSData *)readData:(NSUInteger)length fromRegisterAddress:(unsigned char)regAddr {
    if([self writeByte:regAddr]) {
        NSData *receivedData = nil;
        if([Konashi i2cStartCondition] == KonashiResultFailure)
            return nil;
        [NSThread sleepForTimeInterval:0.01];
        if([Konashi i2cReadRequest:(int)length address:self.deviceAddress] == KonashiResultFailure)
            return nil;
        [NSThread sleepForTimeInterval:0.01];
        receivedData = [Konashi i2cReadData];
        [NSThread sleepForTimeInterval:0.01];
        [Konashi i2cStopCondition];
        return receivedData;
    }
    return nil;
}

- (BOOL)readByte:(unsigned char *)bytes fromRegisterAddress:(unsigned char)regAddr {
    NSData *data = [self readData:1 fromRegisterAddress:regAddr];
    if(data == nil)
        return NO;
    unsigned char res[1];
    [data getBytes:res length:1];
    *bytes = bytes[0];
    return YES;
}

- (NSUInteger)readBytes:(unsigned char *)bytes length:(NSUInteger)length fromRegisterAddress:(unsigned char)regAddr {
    NSData *data = [self readData:length fromRegisterAddress:regAddr];
    if(data == nil)
        return NO;
    NSUInteger len = [data length];
    [data getBytes:bytes length:len];
    return len;
}


@end