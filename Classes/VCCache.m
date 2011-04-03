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

#import "VCCache.h"

@interface VCCacheEntry : NSObject
{
	NSString * key;
	id value;
}

@property (nonatomic,copy) NSString *key;
@property (nonatomic,retain) id value;

@end

@implementation VCCacheEntry

@synthesize key,value;

- (void) dealloc
{
	[key release];
	[value release];
	
	[super dealloc];
}

@end

@implementation VCCache

+ (VCCache *) sharedInstance
{
	static VCCache *instance;
	
	@synchronized(self)
	{
		if (!instance)
			instance = [[VCCache alloc] init];
	}
	
	return instance;
}


- (id) init 
{
	return [self initWithCapacity:100];
}

- (id) initWithCapacity:(int)maxEntries
{
	if (self = [super init])
	{
		_maxEntries = maxEntries;
		
		_entries = [[NSMutableArray alloc] initWithCapacity:_maxEntries];
		_dic = [[NSMutableDictionary alloc] initWithCapacity:_maxEntries];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
	}
	
	return self;
}


- (void) dealloc
{
	[_entries release];
	[_dic release];
	
	[super dealloc];
}

- (void) memoryWarning
{
	@synchronized(self)
	{
		[_entries release];
		[_dic release];

		_entries = [[NSMutableArray alloc] initWithCapacity:_maxEntries];
		_dic = [[NSMutableDictionary alloc] initWithCapacity:_maxEntries];
	}
}

- (id) getObject:(NSString *)key
{
	@synchronized(self)
	{
		VCCacheEntry *entry = [_dic objectForKey:key];
		
		if (entry)
		{
			int i = [_entries indexOfObject:entry];
			
			if (i > 0)
			{
				[_entries insertObject:entry atIndex:0];
				[_entries removeObjectAtIndex:i+1];
			}
			
			return entry.value;
		}
	}
	
	return nil;
}

- (void) setObject:(id)obj forKey:(NSString *)key
{
	@synchronized(self)
	{
		VCCacheEntry *entry = [_dic objectForKey:key];
		
		if (entry)
		{
			[_entries removeObject:entry];
			[_dic removeObjectForKey:key];
		}
		else if ([_entries count] >= _maxEntries)
		{
			entry = [_entries lastObject];
			
			[_dic removeObjectForKey:entry.key];
			[_entries removeLastObject];
		}

		entry = [[VCCacheEntry alloc] init];
		entry.key = key;
		entry.value = obj;
		
		[_dic setObject:entry forKey:key];
		[_entries insertObject:entry atIndex:0];
		
		[entry release];
	}
}

@end

