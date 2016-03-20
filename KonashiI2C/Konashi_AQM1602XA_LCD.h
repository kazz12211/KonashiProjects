//
//  Konashi_AQM1602XA_LCD.h
//  KonashiI2C
//
//  Created by TsubakiKazuo on H28/03/20.
//  Copyright © 平成28年 TsubakiKazuo. All rights reserved.
//

#ifndef Konashi_AQM1602XA_LCD_h
#define Konashi_AQM1602XA_LCD_h

#import "KonashiI2CDevice.h"

#define AQM1602XA_LCD_ADDRESS                           (0x3E)

const unsigned char AQM1602XA_LCD_REGISTER_COMMAND      = 0x00;
const unsigned char AQM1602XA_LCD_REGISTER_DATA         = 0x40;

@interface Konashi_AQM1602XA_LCD : KonashiI2CDevice

- (id)init;
- (id)initWithAddress:(unsigned char)addr;
- (BOOL)configure;

// Clear LCD panel
- (void)clear;
// Write characters on LCD
// The LCD can display 16 characters at row 0 and 1
// The string longer than 16 characters will be truncated
- (void)write:(NSString *)str row:(NSUInteger)row;

@end

#endif /* Konashi_AQM1602XA_LCD_h */
