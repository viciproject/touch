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

#import "VCDataObject.h"
#import "VCDataStore.h"

#import <objc/runtime.h>
#import <objc/message.h>

@interface VCDataObjectCallbackInfo : NSObject

@property (strong) NSMutableArray *array;
@property (weak) VCDataObject *dataObject;
@property (assign) Class type;

@end

@interface VCDataObject() 
@end

@implementation VCDataObject

void DataObject_callback(int mode, id obj, const char *fieldName, const void *value, int length)
{
	VCDataObjectCallbackInfo *info = obj;
	
	switch (mode) 
	{
		case DATA_CALLBACK_STARTRECORD:
			if (info.array)
			{
				info.dataObject = [[info.type alloc] init];
				info.dataObject->isNew = NO;

				[info.array addObject:info.dataObject];
			}
			
			break;
			
		case DATA_CALLBACK_READ_STRING:
		case DATA_CALLBACK_READ_BLOB:
			[info.dataObject storeField:fieldName value:value length:length];
			break;

		case DATA_CALLBACK_ENDRECORD:
			break;

		default:
			break;
	}
}

- (id) init 
{
	if ((self = [super init])) 
	{
		isNew = YES;
	}
	
	return self;
}

- (BOOL) readSingle:(VCSqlCommand *)sql 
{
	VCDataObjectCallbackInfo *info = [[VCDataObjectCallbackInfo alloc] init];
	
	info.array = nil;
	info.dataObject = self;
	
	return [VCDataStore execCommand:sql callback:DataObject_callback data:info] > 0;
}

- (BOOL) save
{
	return [VCDataStore execCommand:[self saveCommand]];
}

+ (id) readSingle:(VCSqlCommand *)sql 
{
	VCDataObject *dataObject = [[self alloc] init];
	
	if (![dataObject readSingle:sql]) 
	{
		return nil;
	}

	dataObject->isNew = NO;
	
	return dataObject;
}

+ (id) readSingle 
{
	NSArray *array = [self readAll];
    
    if ([array count] == 0) return nil;
	
	return [array objectAtIndex:0];
}

+ (NSArray *) readMultipleWithCmd:(VCSqlCommand *)sql 
{
	VCDataObjectCallbackInfo *data = [[VCDataObjectCallbackInfo alloc] init];
	
	data.array = [[NSMutableArray alloc] init];
	data.type = self;
	
	[VCDataStore execCommand:sql callback:DataObject_callback data:data];

	return data.array;
}

+ (NSArray *) readAll 
{
	VCSqlCommand *cmd = [VCSqlCommand sqlCommandFromTable:[self tableName]];
	
	return [self readMultipleWithCmd:cmd];
}

+ (NSArray *) readAll:(NSString *)sortBy 
{
	VCSqlCommand *cmd = [VCSqlCommand sqlCommandFromTable:[self tableName] sortBy:sortBy];
	
	return [self readMultipleWithCmd:cmd];
}


+ (NSArray *) readMultiple:(NSString *)filter 
{
	VCSqlCommand *cmd = [VCSqlCommand sqlCommandFromTable:[self tableName] filter:filter];
	
	return [self readMultipleWithCmd:cmd];
}

+ (NSArray *) readMultiple:(NSString *)filter sortBy:(NSString *)sortBy 
{
	VCSqlCommand *cmd = [VCSqlCommand sqlCommandFromTable:[self tableName] filter:filter sortBy:sortBy];
	
	return [self readMultipleWithCmd:cmd];
}

+ (NSArray *) readMultiple:(NSString *)filter parameters:(VCSqlParameterList *)parameters 
{
	VCSqlCommand *cmd = [VCSqlCommand sqlCommandFromTable:[self tableName] filter:filter parameters:parameters];
	
	return [self readMultipleWithCmd:cmd];
}

+ (NSArray *) readMultiple:(NSString *)filter parameters:(VCSqlParameterList *)parameters sortBy:(NSString *)sortBy 
{
	VCSqlCommand *cmd = [VCSqlCommand sqlCommandFromTable:[self tableName] filter:filter parameters:parameters sortBy:sortBy];
	
	return [self readMultipleWithCmd:cmd];
}

- (void) storeField:(const char *)fieldName value:(const void *)value length:(int)length {}
- (VCSqlCommand *) saveCommand { return nil; }

@end
