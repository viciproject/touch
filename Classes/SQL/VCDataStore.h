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

#include <sqlite3.h>

#import <Foundation/Foundation.h>

#import "VCSqlDataTypes.h"
#import "VCSqlCommand.h"
#import "VCSqlParameter.h"

@interface VCDataStore : NSObject 
{
	NSString *_dbFileName;
	sqlite3 *_db;
}

#define DATA_CALLBACK_STARTREADING (1)
#define DATA_CALLBACK_STARTRECORD (2)
#define DATA_CALLBACK_READ_STRING (3)
#define DATA_CALLBACK_READ_BLOB (4)
#define DATA_CALLBACK_ENDRECORD (5)
#define DATA_CALLBACK_ENDREADING (6)


+ (void) setDatabase:(NSString *)db;
+ (void) addFunction:(NSString *)name function:(void (*)(sqlite3_context *arg1,int arg2, sqlite3_value **arg3))function numArguments:(int)numArguments;

+ (int) execCommand:(VCSqlCommand *)cmd callback:(void (*)(int,void *,const char *,const void *,int))callback data:(void *)data;
+ (int) execCommand:(VCSqlCommand *)cmd;

+ (int) getScalar:(VCSqlCommand *)cmd;
+ (NSString *) getScalarString:(VCSqlCommand *)cmd;

- (int) lastRowId;

/*
- (NSDictionary *) readRecord:(SqlCommand *)cmd;
- (NSArray *) readRecords:(SqlCommand *)cmd;
*/


@end
