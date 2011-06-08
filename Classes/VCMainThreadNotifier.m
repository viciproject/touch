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

#import "VCMainThreadNotifier.h"

@interface VCMainThreadNotifier()

- (id) initWithName:(NSString *)name object:(id)object userInfo:(NSDictionary *)userInfo;

- (void) notify;
- (void) notifyAfterDelay:(float)seconds;

- (void) postNotification;
- (void) postNotificationAfterDelay:(NSNumber *)seconds;

@end


@implementation VCMainThreadNotifier

- (id) initWithName:(NSString *)name object:(id)object userInfo:(NSDictionary *)userInfo 
{
	if ((self = [super init])) 
	{
		_name = [name retain];
		_object = [object retain];
		_userInfo = [userInfo retain];
		
		[self retain];
	}
	
	return self;
}

- (void) postNotification 
{
	[[NSNotificationCenter defaultCenter] postNotificationName:_name object:_object userInfo:_userInfo];
	
	[self release];
}

- (void) postNotificationAfterDelay:(NSNumber *)seconds 
{
	[self performSelector:@selector(postNotification) withObject:nil afterDelay:[seconds floatValue]];
}

- (void) notify 
{
	[self performSelectorOnMainThread:@selector(postNotification) withObject:nil waitUntilDone:NO];
}

- (void) notifyAfterDelay:(float)seconds 
{
	[self performSelectorOnMainThread:@selector(postNotificationAfterDelay:) withObject:[NSNumber numberWithFloat:seconds] waitUntilDone:NO];
}

+ (void) notify:(NSString *)name object:(id)object userInfo:(NSDictionary *)userInfo afterDelay:(float)seconds 
{
	VCMainThreadNotifier *notifier = [[VCMainThreadNotifier alloc] initWithName:name object:object userInfo:userInfo];
	
	[notifier notifyAfterDelay:seconds];
	
	[notifier release];
}

+ (void) notify:(NSString *)name object:(id)object userInfo:(NSDictionary *)userInfo 
{
	VCMainThreadNotifier *notifier = [[VCMainThreadNotifier alloc] initWithName:name object:object userInfo:userInfo];
	
	[notifier notify];
	
	[notifier release];
}

+ (void) notify:(NSString *)name userInfo:(NSDictionary *)userInfo afterDelay:(float)seconds 
{
	[VCMainThreadNotifier notify:name object:nil userInfo:userInfo afterDelay:seconds];
}

+ (void) notify:(NSString *)name afterDelay:(float)seconds 
{
	[VCMainThreadNotifier notify:name object:nil userInfo:nil afterDelay:seconds];
}


+ (void) notify:(NSString *)name object:(id)object afterDelay:(float)seconds 
{
	[VCMainThreadNotifier notify:name object:object userInfo:nil afterDelay:seconds];
}

+ (void) notify:(NSString *)name object:(id)object 
{
	[VCMainThreadNotifier notify:name object:object userInfo:nil];
}

+ (void) notify:(NSString *)name userInfo:(NSDictionary *)userInfo 
{
	[VCMainThreadNotifier notify:name object:nil userInfo:userInfo];
}

+ (void) notify:(NSString *)name 
{
	[VCMainThreadNotifier notify:name object:nil userInfo:nil];
}

- (void) dealloc 
{
	[_name release];
	[_object release];
	[_userInfo release];
	
	[super dealloc];
}

@end
