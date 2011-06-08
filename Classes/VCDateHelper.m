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

#import "VCDateHelper.h"

@implementation VCDateHelper

+ (NSString *) stringFromDate:(NSDate *)date formatString:(NSString *)formatString 
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	
	[dateFormatter setDateFormat:formatString];
	
	NSString *s = [dateFormatter stringFromDate:date];
	
	[dateFormatter release];
	
	return s;
}

+ (NSString *) stringFromDate:(NSDate *)date formatter:(NSDateFormatter *)dateFormatter
{
	return [dateFormatter stringFromDate:date];
}

+ (NSDate *) dateFromString:(NSString *)date formatString:(NSString *)formatString 
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	
	[dateFormatter setDateFormat:formatString];
	
	NSDate *returnValue = [dateFormatter dateFromString:date];
	
	[dateFormatter release];
	
	return returnValue;
}

+ (NSDate *) dateFromString:(NSString *)date formatter:(NSDateFormatter *)dateFormatter
{
	return [dateFormatter dateFromString:date];
}

+ (NSDate *) stripTime:(NSDate *)date 
{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSDateComponents *components = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit) fromDate:date];
	
	date = [gregorian dateFromComponents:components];

	[gregorian release];
	
	return date;
}

+ (NSDate *) addDays:(NSDate *)date days:(int)days 
{
	return [[[NSDate alloc] initWithTimeInterval:days * 24 * 60 * 60 sinceDate:date] autorelease];
}

+ (NSDate *) addHours:(NSDate *)date hours:(int)hours 
{
	return [[[NSDate alloc] initWithTimeInterval:hours * 60 * 60 sinceDate:date] autorelease];
}

+ (NSDate *) addMinutes:(NSDate *)date minutes:(int)minutes 
{
	return [[[NSDate alloc] initWithTimeInterval:minutes * 60 sinceDate:date] autorelease];
}

+ (NSDate *) addSeconds:(NSDate *)date seconds:(float)seconds 
{
	return [[[NSDate alloc] initWithTimeInterval:seconds sinceDate:date] autorelease];
}

@end

@implementation NSString(DateHelper)

- (NSDate *) dateFromStringWithFormat:(NSString *)formatString 
{
	return [VCDateHelper dateFromString:self formatString:formatString];
}

- (NSDate *) dateFromStringWithFormatter:(NSDateFormatter *)dateFormatter
{
	return [VCDateHelper dateFromString:self formatter:dateFormatter];
}

@end

@implementation NSDate(DateHelper)

- (NSString *) stringFromDateWithFormat:(NSString *)formatString
{
	return [VCDateHelper stringFromDate:self formatString:formatString];
}

- (NSString *) stringFromDateWithFormatter:(NSDateFormatter *)dateFormatter 
{
	return [VCDateHelper stringFromDate:self formatter:dateFormatter];
}

- (NSDate *) stripTime 
{
	return [VCDateHelper stripTime:self];
}

- (NSDate *) addDays:(int)days 
{
	return [VCDateHelper addDays:self days:days];
}

- (NSDate *) addMinutes:(int)minutes 
{
	return [VCDateHelper addMinutes:self minutes:minutes];
}

- (NSDate *) addSeconds:(float)seconds 
{
	return [VCDateHelper addSeconds:self seconds:seconds];
}

- (NSDate *) addHours:(double)hours 
{
	return [VCDateHelper addHours:self hours:hours];
}

@end

