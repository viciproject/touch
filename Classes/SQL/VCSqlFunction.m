//
//  VCSqlFunction.m
//  HotspotLocator
//
//  Created by Philippe Leybaert on 04/11/10.
//  Copyright 2010 Activa Consult BVBA. All rights reserved.
//

#import "VCSqlFunction.h"


@implementation VCSqlFunction

@synthesize name = _name;
@synthesize function = _function;
@synthesize numArguments = _numArguments;

+ (VCSqlFunction *) functionWithName:(NSString *) name function:(void (*)(sqlite3_context *arg1,int arg2, sqlite3_value **arg3))function numArguments:(int) numArguments
{
	VCSqlFunction *func = [[VCSqlFunction alloc] init];
	
	func->_name = [name copy];
	func->_function = function;
	func->_numArguments = numArguments;
	
	return [func autorelease];
}

@end
