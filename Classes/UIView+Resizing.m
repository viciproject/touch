//=============================================================================
// Vici Touch - Productivity Library for Objective C / iOS SDK 
//
// Copyright (c) 2010-2013 Philippe Leybaert
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

#import "UIView+Resizing.h"


@implementation UIView (Resizing)

- (void) setWidthTo:(float)width
{
	CGRect frame = self.frame;
	frame.size.width = width;
	self.frame = frame;
}

- (void) setHeightTo:(float)height
{
	CGRect frame = self.frame;
	frame.size.height = height;
	self.frame = frame;
}

- (void) setWidthTo:(float)width andHeightTo:(float)height
{
    [self setSizeTo:CGSizeMake(width, height)];
}

- (void) setSizeTo:(CGSize)size
{
    self.frame = CGRectMake(self.frame.origin.x,self.frame.origin.y,size.width,size.height);
}


@end
