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

#import "VCDataStore.h"
#import "VCSqlCommand.h"
#import "VCSqlFunction.h"

@interface VCDataStore()

- (void) instanceStopped:(NSNotification *)notification;
+ (VCDataStore *) instance;
- (int) execCommand:(VCSqlCommand *)cmd callback:(void (*)(int,void *,const char *,const void *,int))callback data:(void *)data;
- (int) execCommand:(VCSqlCommand *)cmd;
- (sqlite3 *) openDb;
- (int) lastRowId;

@end

@implementation VCDataStore

static NSString *dbName = nil;
static NSMutableArray *sqlFunctions = nil;

+ (VCDataStore *) instance 
{
	NSThread *currentThread = [NSThread currentThread];
	
	NSMutableDictionary *threadData = [currentThread threadDictionary];
	
	VCDataStore *instance = [threadData valueForKey:@"DataStore"];
	
	if (!instance) 
	{
		instance = [[VCDataStore alloc] init];
		
		[[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(instanceStopped:) name:NSThreadWillExitNotification object:currentThread];

		[threadData setValue:instance forKey:@"DataStore"];
        
        [instance autorelease];
	}
	
	return instance;
}

- (void) instanceStopped:(NSNotification *)notification 
{
	NSThread *currentThread = [NSThread currentThread];
	
	NSMutableDictionary *threadData = [currentThread threadDictionary];
	
	VCDataStore *instance = [threadData valueForKey:@"DataStore"];
	
	[[NSNotificationCenter defaultCenter] removeObserver:instance];
	
	[threadData removeObjectForKey:@"DataStore"];
}

+ (void) setDatabase:(NSString *)db
{
	dbName = [db copy];
}

+ (void) addFunction:(NSString *)name function:(void (*)(sqlite3_context *arg1,int arg2, sqlite3_value **arg3))function numArguments:(int) numArguments
{
	@synchronized(self)
	{
		if (!sqlFunctions)
			sqlFunctions = [[NSMutableArray alloc] init];
		
		[sqlFunctions addObject:[VCSqlFunction functionWithName:name function:function numArguments:numArguments]];
	}
}

- (id) init 
{
	if ((self = [super init])) 
    {
		_db = [self openDb];
	}
	
	return self;
}

+ (int) execCommand:(VCSqlCommand *)cmd callback:(void (*)(int,void *,const char *,const void *,int))callback data:(void *)data
{
	return [[self instance] execCommand:cmd callback:callback data:data];
}

+ (int) execCommand: (VCSqlCommand *)cmd
{
	return [[self instance] execCommand:cmd];
}

+ (int) lastRowId
{
	return [[self instance] lastRowId];
}

- (sqlite3 *) openDb 
{
	sqlite3 *db = NULL;
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:dbName]) 
	{
		if(!sqlite3_open_v2([dbName UTF8String], &db,SQLITE_OPEN_READWRITE|SQLITE_OPEN_CREATE|SQLITE_OPEN_FULLMUTEX,NULL)) 
		{
			NSString *fn = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"createdb.sql"];
			
			NSString *sqlString = [NSString stringWithContentsOfFile:fn encoding:NSUTF8StringEncoding error:NULL];
			
			char *errMsg;
			
			sqlite3_exec(db, [sqlString UTF8String],NULL,NULL,&errMsg);
		}
	} 
	else 
	{
		sqlite3_open_v2([dbName UTF8String], &db,SQLITE_OPEN_READWRITE|SQLITE_OPEN_FULLMUTEX,NULL);
	}
	
	if (sqlFunctions)
		for (VCSqlFunction *function in sqlFunctions)
			sqlite3_create_function(db, [function.name UTF8String], function.numArguments, 0, NULL, function.function, NULL, NULL);
	
	sqlite3_busy_timeout(db, 1000);
	
	return db;
}

- (int) lastRowId 
{
	return sqlite3_last_insert_rowid(_db);
}

- (int) execCommand:(VCSqlCommand *)cmd 
{
	return [self execCommand:cmd callback:nil data:nil];
}

- (int) execCommand:(VCSqlCommand *)cmd callback:(void (*)(int,void *,const char *,const void *,int))callback data:(void *)data 
{
//	NSLog(@"SQL: %@",cmd.sql);

	sqlite3_stmt *stmt;
	
	int sqlite_code = 0;
	
	sqlite_code = sqlite3_prepare_v2(_db, [cmd.sql UTF8String], -1, &stmt, NULL);
	
	if (sqlite_code != SQLITE_OK) 
	{
		NSLog(@"Error %d preparing SQLite command %@",sqlite_code,cmd.sql,nil);
		return -1;
	}
		
	for (NSString *varName in cmd.sqlParameters) 
	{
		int paramNumber = sqlite3_bind_parameter_index(stmt, [varName UTF8String]);
	
		id value = [cmd.sqlParameters valueForName:varName];

		if ([value isKindOfClass:[NSNumber class]]) 
		{
			const char *type = [value objCType];
			
			if (*type == 'i' || *type == 'c')
				sqlite3_bind_int(stmt, paramNumber , [value intValue]);
			else if (*type == 'd')
				sqlite3_bind_double(stmt, paramNumber , [value doubleValue]);
			else if (*type == 'f')
				sqlite3_bind_double(stmt, paramNumber, [value floatValue]);
		}
		else if ([value isKindOfClass:[NSString class]]) 
		{
			sqlite3_bind_text(stmt, paramNumber, [value UTF8String], -1, SQLITE_TRANSIENT);
		}
		else if ([value isKindOfClass:[NSData class]]) 
		{
			sqlite3_bind_blob(stmt, paramNumber, [value bytes] , [value length], SQLITE_TRANSIENT);
		}
		else if ([value isKindOfClass:[NSDate class]]) 
		{
			sqlite3_bind_text(stmt, paramNumber, [[value sqlStringValue] UTF8String], -1,SQLITE_TRANSIENT);
		}
	}

	if (callback)
		callback(DATA_CALLBACK_STARTREADING,data,NULL,NULL,-1);
	
	int recordNum = 0;
	
	sqlite_code = SQLITE_ROW;
	
	while (sqlite_code == SQLITE_ROW) 
	{
		sqlite_code = SQLITE_BUSY;
		
		while (sqlite_code == SQLITE_BUSY) 
		{
			sqlite_code = sqlite3_step(stmt);
			
			if (sqlite_code == SQLITE_BUSY) {
				
				NSLog(@"Retrying (busy): %@",cmd.sql);
			}
		}
		
		if (sqlite_code != SQLITE_ROW) 
		{
			if (sqlite_code != SQLITE_DONE) 
			{
				NSLog(@"Error %d executing sqlite3_step [%@]",sqlite_code,cmd.sql,nil);
			}
			
			break;
		}

		if (callback)
			callback(DATA_CALLBACK_STARTRECORD,data,NULL,NULL,-1);
		
		for (int i=0;i<sqlite3_column_count(stmt);i++) 
		{
			const char *fieldName = sqlite3_column_name(stmt, i);
			
			int columnType = sqlite3_column_type(stmt,i);
			
			if (columnType == SQLITE_BLOB) 
			{
				const void *blob = sqlite3_column_blob(stmt, i);
				int numBytes = sqlite3_column_bytes(stmt,i);
				
				if (numBytes > 0 && callback)
					callback(DATA_CALLBACK_READ_BLOB,data,fieldName,blob,numBytes);
			} 
			else 
			{
				const char * value = (const char *) sqlite3_column_text(stmt, i);

				if (value && callback)
					callback(DATA_CALLBACK_READ_STRING,data,fieldName,value,-1);
			}
			
			recordNum++;
		}
		
		if (callback)
			callback(DATA_CALLBACK_ENDRECORD,data,NULL,NULL,-1);

	}

	if (callback)
		callback(DATA_CALLBACK_ENDREADING,data,NULL,NULL,-1);

	sqlite3_finalize(stmt);
	
	return recordNum;
}

void GetScalar_callback(int mode, void *obj, const char *fieldName, const void *value, int length) 
{
	int *returnValue = obj;
	
	switch (mode) 
	{
		case DATA_CALLBACK_READ_STRING:
			*returnValue = atoi(value);
			break;

		default:
			break;
	}
}

void GetScalarString_callback(int mode, void *obj, const char *fieldName, const void *value, int length) 
{
	NSMutableString *returnValue = obj;
	
	switch (mode) 
	{
		case DATA_CALLBACK_READ_STRING:
			[returnValue setString:[NSString stringWithUTF8String:value]];
			break;
			
		default:
			break;
	}
}

+ (int) getScalar:(VCSqlCommand *)cmd 
{
	int returnValue;
	
	[self execCommand:cmd callback:GetScalar_callback data:&returnValue];
	
	return returnValue;
}

+ (NSString *) getScalarString:(VCSqlCommand *)cmd 
{
	NSMutableString *returnValue = [[NSMutableString alloc] init];
	
	[self execCommand:cmd callback:GetScalarString_callback data:returnValue];
	
	return [returnValue autorelease];
}

- (void) dealloc 
{
	sqlite3_close(_db);
	
	[super dealloc];
}

@end
