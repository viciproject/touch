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

#import "VCStaticWebView.h"

@implementation VCStaticWebView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) 
	{
        _webView = [[UIWebView alloc] initWithFrame:self.bounds];
		_webView.delegate = self;
		_webView.userInteractionEnabled = NO;
		
		[self addSubview:_webView];
		
		_maskView = [[UIView alloc] initWithFrame:self.bounds];
		_maskView.backgroundColor = [UIColor clearColor];
		_maskView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		
		[self addSubview:_maskView];
    }

    return self;
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error 
{
}

- (void) webViewDidFinishLoad:(UIWebView *)webView 
{
	[_webView sizeToFit];

	CGRect frame = self.frame;
	
	frame.size.height = _webView.frame.size.height;
	
	self.frame = frame;
	
	[_delegate staticWebView:self sizeChanged:frame.size];
}

- (void) sizeToFit 
{
	[_webView sizeToFit];
	
	CGRect frame = self.frame;
	
	frame.size.height = _webView.frame.size.height;
	
	self.frame = frame;
}

- (void) setHTML:(NSString *)html 
{
	[_webView loadHTMLString:html baseURL:nil];
}

- (void) dealloc 
{
	_webView.delegate = nil;
	
	[_webView release];
	[_maskView release];
	
    [super dealloc];
}

@end
