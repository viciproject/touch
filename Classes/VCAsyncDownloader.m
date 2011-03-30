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

#import "VCAsyncDownloader.h"

@interface VCAsyncDownloader()

- (void) startInternal;

@end

@implementation VCAsyncDownloader

@synthesize delegate = _delegate;
@synthesize data = _data;
@synthesize userData = _userData;
@synthesize useMainThread = _onMainThread;

- (id) initWithUrl:(NSString *) url 
{
	if (self = [super init]) 
	{
		_url = [[NSURL alloc] initWithString:url];
		
		[self retain];
	}
	
	return self;
}

+ (VCAsyncDownloader *) asyncDownloaderWithUrl:(NSString *) url 
{
	VCAsyncDownloader *instance = [[VCAsyncDownloader alloc] initWithUrl:url];
	
	return [instance autorelease];
}

+ (void) start:(NSString *)url delegate:(id) delegate 
{
	[self start:url delegate:delegate userData:nil onMainThread:NO];
}

+ (void) start:(NSString *)url delegate:(id) delegate onMainThread:(BOOL) onMainThread 
{
	[self start:url delegate:delegate userData:nil onMainThread:onMainThread];
}

+ (void) start:(NSString *)url delegate:(id) delegate userData:(id) userData 
{
	[self start:url delegate:delegate userData:userData onMainThread:NO];
}

+ (void) start:(NSString *)url delegate:(id) delegate userData:(id) userData onMainThread:(BOOL) onMainThread 
{
	VCAsyncDownloader *downloader = [[VCAsyncDownloader alloc] initWithUrl:url];
	
	downloader.delegate = delegate;
	downloader.userData = userData;
	downloader.useMainThread = onMainThread;
	
	[downloader start];
	
	[downloader release];
}

- (void) start:(id) userData 
{
	self.userData = userData;
	
	[self start];
}

- (void) start 
{
	if (_onMainThread && ![NSThread isMainThread]) 
	{
		[self performSelectorOnMainThread:@selector(startInternal) withObject:nil waitUntilDone:NO];
	}
	else 
	{
		[self startInternal];
	}
}

- (void) startInternal 
{
	[_data release];
	[_connection release];
	
	_data = [[NSMutableData alloc] init];
	
    _connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:_url] delegate:self];
}

- (void) cancel 
{
	[_connection cancel];
	
	[self release];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
    [_data appendData:data];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	if ([_delegate respondsToSelector:@selector(asyncDownloadFailed:)])
		[_delegate asyncDownloadFailed:self];
	
	[self release];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
	if ([_delegate respondsToSelector:@selector(asyncDownloadCompleted:)])
		[_delegate asyncDownloadCompleted:self];
	
	[self release];
}

- (void) dealloc {
	
	[_url release];
	[_data release];
	[_connection release];
	[_userData release];
	
	[super dealloc];
}

@end
