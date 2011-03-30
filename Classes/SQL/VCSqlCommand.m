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

#import "VCSqlCommand.h"
#import "VCSqlParameterList.h"

@interface VCSqlCommand()

@property (readwrite,nonatomic,retain) VCSqlParameterList *sqlParameters;

@end


@implementation VCSqlCommand

@synthesize sql = _sql;
@synthesize sqlParameters = _sqlParameters;

- (id) init 
{
	if (self = [super init]) 
	{
		_sqlParameters = [[VCSqlParameterList alloc] init];
		_sql = nil;
	}
	
	return self;
}

+ (id) sqlCommandFromSql:(NSString *) sql parameters:(VCSqlParameterList *)parameters 
{
	VCSqlCommand *cmd = [[VCSqlCommand alloc] init];
	
	cmd.sql = sql;
	cmd.sqlParameters = parameters;
	
	return [cmd autorelease];
}

+ (id) sqlCommandFromSql:(NSString *) sql 
{
	VCSqlCommand *cmd = [[VCSqlCommand alloc] init];
	
	cmd.sql = sql;
	
	return [cmd autorelease];
}

+ (id) sqlCommandFromTable:(NSString *) tableName 
{
	return [VCSqlCommand sqlCommandFromSql:[NSString stringWithFormat:@"select * from %@",tableName]];
}

+ (id) sqlCommandFromTable:(NSString *) tableName sortBy:(NSString *)sortBy 
{
	VCSqlCommand *cmd = [self sqlCommandFromTable:tableName];
	
	cmd.sql = [cmd.sql stringByAppendingFormat:@" order by %@",sortBy];

	return cmd;
}

+ (id) sqlCommandFromTable:(NSString *) tableName filter:(NSString *) filter 
{
	VCSqlCommand *cmd = [[VCSqlCommand alloc] init];
	
	cmd.sql = [NSString stringWithFormat:@"select * from %@",tableName];
	
	if ([filter length] > 0) 
	{
		cmd.sql = [cmd.sql stringByAppendingString:@" where "];
		cmd.sql = [cmd.sql stringByAppendingString:filter];
	}

	return [cmd autorelease];
}

+ (id) sqlCommandFromTable:(NSString *) tableName filter:(NSString *) filter sortBy:(NSString *)sortBy 
{
	VCSqlCommand *cmd = [self sqlCommandFromTable:tableName filter:filter];
	
	cmd.sql = [cmd.sql stringByAppendingFormat:@" order by %@",sortBy];
	
	return cmd;
}

+ (id) sqlCommandFromTable:(NSString *) tableName filter:(NSString *) filter parameters:(VCSqlParameterList *)parameters 
{
	VCSqlCommand *cmd = [[VCSqlCommand alloc] init];
	
	cmd.sql = [NSString stringWithFormat:@"select * from %@",tableName];
	cmd.sqlParameters = parameters;
	
	if ([filter length] > 0) 
	{
		cmd.sql = [cmd.sql stringByAppendingString:@" where "];
		cmd.sql = [cmd.sql stringByAppendingString:filter];
	}
	
	return [cmd autorelease];
}

+ (id) sqlCommandFromTable:(NSString *) tableName filter:(NSString *) filter parameters:(VCSqlParameterList *)parameters sortBy:(NSString *) sortBy 
{
	VCSqlCommand *cmd = [self sqlCommandFromTable:tableName filter:filter parameters:parameters];
	
	cmd.sql = [cmd.sql stringByAppendingFormat:@" order by %@",sortBy];
	
	return cmd;
}

- (void) applyParameters:(VCSqlParameterList *)parameters 
{
	[self.sqlParameters merge:parameters];
}

- (void) addParameter:(id) value withName:(NSString *)name 
{
	[self.sqlParameters setValue:value forName:name];
}

- (void) dealloc 
{
	[_sql release];
	[_sqlParameters release];
	
	[super dealloc];
}

@end
