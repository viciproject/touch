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


#import "VCUtil.h"


@implementation VCUtil

+ (NSString *) documentsPath 
{
	NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
	return [searchPaths objectAtIndex:0];
}

+ (NSString *) cachesPath
{
	NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES); 
	
    return [searchPaths objectAtIndex:0]; 
}

+ (NSString *) mainBundlePath
{
	return [[NSBundle mainBundle] resourcePath];
}

+ (NSString *) fileInDocumentsPath:(NSString *)fileName
{
	return [[self documentsPath] stringByAppendingPathComponent:fileName];
}

+ (NSString *) fileInMainBundlePath:(NSString *)fileName
{
	return [[self mainBundlePath] stringByAppendingPathComponent:fileName];
}

+ (BOOL) fileExists:(NSString *)fileName 
{
	return [[NSFileManager defaultManager] fileExistsAtPath:fileName];
}

+ (BOOL) fileExistsInDocuments:(NSString *)fileName 
{
	return [[NSFileManager defaultManager] fileExistsAtPath:[self fileInDocumentsPath:fileName]];
}

+ (BOOL) fileExistsInMainBundle:(NSString *)fileName 
{
	return [[NSFileManager defaultManager] fileExistsAtPath:[self fileInMainBundlePath:fileName]];
}

static int networkActivityCounter = 0;

+ (void) startNetworkActivity 
{
	networkActivityCounter++;
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = (networkActivityCounter > 0);
}

+ (void) endNetworkActivity 
{
	networkActivityCounter--;
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = (networkActivityCounter > 0);
}

+ (void) showAlertWithTitle:(NSString *)title andMessage:(NSString *)message
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	
	[alertView show];
	
	[alertView release];
}

@end
