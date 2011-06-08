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

#import "VCSqlParameterList.h"

@interface VCSqlParameterList()

//@property (readwrite,nonatomic,retain) NSMutableDictionary *dic;

@end


@implementation VCSqlParameterList

@synthesize dic = _dic;

- (id) init 
{
	if ((self = [super init])) 
	{
		_dic = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}

- (void) dealloc 
{
	[_dic release];
	
	[super dealloc];
}

- (void) merge:(VCSqlParameterList *)params 
{
	for (NSString *name in params.dic) 
	{
		[self.dic setValue:[params valueForName:name] forKey:name];
	}
}

- (void) setValue:(id)value forName:(NSString *)name 
{
	[self.dic setValue:value forKey:name];
}

- (id) valueForName:(NSString *)name 
{
	return [self.dic objectForKey:name];
}

- (NSUInteger) countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len 
{
	return [self.dic countByEnumeratingWithState:state objects:stackbuf count:len];
}


+ (VCSqlParameterList *) from:(NSString *)firstParameterName, ... 
{
	VCSqlParameterList *list = [[VCSqlParameterList alloc] init];
	
	NSString *paramName = firstParameterName;
	
	va_list argumentList;
	
	va_start(argumentList, firstParameterName); 
	
	for (int i=0;;i++) {
		if (i > 0)
			paramName = va_arg(argumentList,NSString *);
		
		if (!paramName)
			break;
		
		id value = va_arg(argumentList,id);
		
		[list.dic setValue:value forKey:paramName];
	}
	
	va_end(argumentList);
	
	return [list autorelease];
}

@end
