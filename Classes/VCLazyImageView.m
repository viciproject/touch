//=============================================================================
// Vici Touch - Productivity Library for Objective C / iOS SDK 
//
// Copyright (c) 2009-2010 Philippe Leybaert
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

#import "VCLazyImageView.h"

#define kActivityIndicatorWidth (30)

@interface VCLazyImageView()

- (void) showImage:(UIImage *)image;

@end


@implementation VCLazyImageView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame 
{
	if (self = [super initWithFrame:frame]) 
	{
		CGFloat x = self.bounds.size.width / 2 - kActivityIndicatorWidth / 2;
		CGFloat y = self.bounds.size.height / 2 - kActivityIndicatorWidth / 2;
		
		_spinnerView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		_spinnerView.frame = CGRectMake(x, y, kActivityIndicatorWidth, kActivityIndicatorWidth);
		
		[_spinnerView startAnimating];
		
		_imageView = [[UIImageView alloc] initWithFrame:self.bounds];
		_imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

		_spinnerView.hidden = NO;
		_imageView.hidden = YES;

		[self addSubview:_spinnerView];
		[self addSubview:_imageView];
	}
	
	return self;
}

- (void) setContentMode:(UIViewContentMode)contentMode 
{
	[super setContentMode:contentMode];
	
	_imageView.contentMode = contentMode;
}

- (void) setFrame:(CGRect)frame 
{
	[super setFrame:frame];

	CGFloat x = self.bounds.size.width / 2 - kActivityIndicatorWidth / 2;
	CGFloat y = self.bounds.size.height / 2 - kActivityIndicatorWidth / 2;
	
	_spinnerView.frame = CGRectMake(x, y, kActivityIndicatorWidth, kActivityIndicatorWidth);
	_imageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
}

- (void) setImageUrl:(NSString *)url backupImageName:(NSString *)backupImageName 
{
	[_urlConnection cancel];
	[_urlConnection release];
	_urlConnection = nil;
	
	_url = [url copy];
	
	_backupImageName = [backupImageName copy];
	
	if (!url) {
		[self showImage:[UIImage imageNamed:_backupImageName]];
		return;
	}
	
	UIImage *image = [[VCCache sharedInstance] getObject:url];
	
	if (image)
	{
		[self showImage:image];
		return;
	}
	
	_spinnerView.hidden = NO;
	_imageView.hidden = YES;
	
	[_spinnerView startAnimating];
	
	_receivedData = [[NSMutableData alloc] init];
	
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];
	
	_urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
	
	[_urlConnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
	[_urlConnection start];
	
	[request release];
}

- (void) showImage:(UIImage *)image 
{
	_imageView.image = image;
	
	_spinnerView.hidden = YES;
	_imageView.hidden = NO;
	
	[_spinnerView stopAnimating];
	
	if ([_delegate respondsToSelector:@selector(lazyImageView:imageLoaded:)])
	{
		[_delegate lazyImageView:self imageLoaded:image];
	}
}

- (UIImage *) image
{
	return _imageView.image;
}

- (void)dealloc 
{
	[_spinnerView release];
	[_imageView release];
	[_receivedData release];
	[_urlConnection release];
	[_backupImageName release];
	[_url release];
	
	[super dealloc];
}

#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response 
{
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data 
{
    [_receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
	UIImage *image = [UIImage imageWithData:_receivedData];

	[self showImage:image];

	[[VCCache sharedInstance] setObject:image forKey:_url];
	
	[_receivedData release];
	
	_receivedData = nil;
	
	[_urlConnection release];
	_urlConnection = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
	[self showImage:[UIImage imageNamed:_backupImageName]];
	
	[_receivedData release];
	 
	_receivedData = nil;
	
	[_urlConnection release];
	_urlConnection = nil;
}

- (NSCachedURLResponse *) connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse 
{
	return cachedResponse;
}

@end
