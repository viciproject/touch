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

@interface VCAsyncDownloader : NSObject 
{
	NSURL * _url;
	NSMutableData * _data;
	NSURLConnection * _connection;
	
	BOOL _onMainThread;
	
	id _delegate;
	id _userData;
}

@property (readonly) NSData *data;
@property (retain) id userData;
@property (assign) id delegate;
@property (assign) BOOL useMainThread;

- (id) initWithUrl:(NSString *) url;
- (void) start;
- (void) start:(id) userData;
- (void) cancel;

+ (VCAsyncDownloader *) asyncDownloaderWithUrl:(NSString *) url;

+ (void) start:(NSString *)url delegate:(id) delegate;
+ (void) start:(NSString *)url delegate:(id) delegate onMainThread:(BOOL) onMainThread;
+ (void) start:(NSString *)url delegate:(id) delegate userData:(id) userData;
+ (void) start:(NSString *)url delegate:(id) delegate userData:(id) userData onMainThread:(BOOL) onMainThread;

@end

@interface NSObject(AsyncDownloaderDelegate)
- (void) asyncDownloadCompleted: (VCAsyncDownloader *) asyncDownloader;
- (void) asyncDownloadFailed: (VCAsyncDownloader *) asyncDownloader;
@end