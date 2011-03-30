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
#import "VCSqlCommand.h"
#import "VCSqlDataTypes.h"

@interface VCDataObject : NSObject 
{
@public
	
	BOOL isNew;
}

- (void) storeField:(const char *) fieldName value:(const void *)value length:(int) length;
- (VCSqlCommand *) saveCommand;

- (BOOL) save;

- (BOOL) readSingle:(VCSqlCommand *)sql;

+ (id) readSingle;
+ (id) readSingle:(VCSqlCommand *)sql;

+ (NSArray *) readMultipleWithCmd:(VCSqlCommand *)cmd;

+ (NSArray *) readAll;
+ (NSArray *) readAll:(NSString *)sortBy;
+ (NSArray *) readMultiple:(NSString *) filter parameters:(VCSqlParameterList *) parameters;
+ (NSArray *) readMultiple:(NSString *) filter;
+ (NSArray *) readMultiple:(NSString *) filter parameters:(VCSqlParameterList *) parameters sortBy:(NSString *)sortBy;
+ (NSArray *) readMultiple:(NSString *) filter sortBy:(NSString *)sortBy;

@end

@interface VCDataObject(Identifiers)

+ (NSString *) tableName;

@end


