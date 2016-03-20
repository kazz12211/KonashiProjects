//
//  Konashi_AQM1602XA_LCD.m
//  KonashiI2C
//
//  Created by TsubakiKazuo on H28/03/20.
//  Copyright © 平成28年 TsubakiKazuo. All rights reserved.
//

#import "Konashi_AQM1602XA_LCD.h"


@implementation Konashi_AQM1602XA_LCD

- (id)init {
    self = [super initWithAddress:AQM1602XA_LCD_ADDRESS];
    return self;
}

- (id)initWithAddress:(unsigned char)addr {
    return [super initWithAddress:addr];
}

unsigned char init_command[9] = {0x38, 0x39, 0x14, 0x73, 0x56, 0x6c, 0x38, 0x01, 0x0c};

- (BOOL)configure {
    [self clear];
    return YES;
}

- (void)clear {
    [NSThread sleepForTimeInterval:0.1];
    for(int i = 0; i < 9; i++) {
        [self writeByte:init_command[i] registerAddress:AQM1602XA_LCD_REGISTER_COMMAND];
        [NSThread sleepForTimeInterval:0.02];
    }
}

- (void)write:(NSString *)str row:(NSUInteger)row {
    char ch;
    const char *s;
    
    if(row > 1)
        return;
    s = [str cStringUsingEncoding:NSASCIIStringEncoding];
    
    if(row == 1) {
        [self writeByte:0x40 + 0x80 registerAddress:AQM1602XA_LCD_REGISTER_COMMAND];
    }
    for(int i = 0; i < str.length || i < 16; i++) {
        ch = s[i];
        [self writeByte:ch registerAddress:AQM1602XA_LCD_REGISTER_DATA];
    }
}

@end
