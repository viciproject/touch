//=============================================================================
// Vici Touch - Productivity Library for Objective C / iOS SDK 
//
// Copyright (c) 2010-2011 Philippe Leybaert
//
// Permission is hereby granted, free of charge, to any person obtaining a copy 
// of this software and associated documentation files (the "Software"), to deal 
// in the Software without restriction, including without limitation the rights 
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
// copies of the Software, and to permit persons to whom the Software is 
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in 
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.
//=============================================================================

#import <Foundation/Foundation.h>

@interface VCDateHelper : NSObject 
{
}

+ (NSString *) stringFromDate:(NSDate *)date formatString:(NSString *)formatString;
+ (NSDate *) dateFromString:(NSString *)date formatString:(NSString *)formatString;

+ (NSDate *) stripTime:(NSDate *)date;
+ (NSDate *) addDays:(NSDate *)date days:(int)days;
+ (NSDate *) addHours:(NSDate *)date hours:(int)hours;
+ (NSDate *) addMinutes:(NSDate *)date minutes:(int)minutes;
+ (NSDate *) addSeconds:(NSDate *)date seconds:(float)seconds;

@end

@interface NSString(DateHelper)

- (NSDate *) dateFromStringWithFormat:(NSString *)formatString;
- (NSDate *) dateFromStringWithFormatter:(NSDateFormatter *)dateFormatter;

@end

@interface NSDate(DateHelper)

- (NSString *) stringFromDateWithFormat:(NSString *)formatString;
- (NSString *) stringFromDateWithFormatter:(NSDateFormatter *)dateFormatter;
- (NSDate *) stripTime;
- (NSDate *) addDays:(int)days;
- (NSDate *) addHours:(double)hours; 
- (NSDate *) addMinutes:(int)minutes;
- (NSDate *) addSeconds:(float)seconds;

@end
