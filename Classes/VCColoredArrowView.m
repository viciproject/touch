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

#import "VCColoredArrowView.h"

@interface VCColoredArrowView()

- (void) initialize;

@end

@implementation VCColoredArrowView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self initialize];
    }
    
    return self;
}

- (void) awakeFromNib
{
    [self initialize];
}

- (void) initialize
{
    self.backgroundColor = [UIColor clearColor];
}

+ (VCColoredArrowView *)accessoryWithColor:(UIColor *)color
{
	VCColoredArrowView *ret = [[VCColoredArrowView alloc] initWithFrame:CGRectMake(0, 0, 11.0, 15.0)];
    
	ret.accessoryColor = color;
    
	return ret;
}

- (void)drawRect:(CGRect)rect
{
	CGFloat x = CGRectGetMaxX(self.bounds)-3.0;;
	CGFloat y = CGRectGetMidY(self.bounds);
    
	const CGFloat R = 4.5;
    
	CGContextRef ctxt = UIGraphicsGetCurrentContext();
	CGContextMoveToPoint(ctxt, x-R, y-R);
	CGContextAddLineToPoint(ctxt, x, y);
	CGContextAddLineToPoint(ctxt, x-R, y+R);
	CGContextSetLineCap(ctxt, kCGLineCapSquare);
	CGContextSetLineJoin(ctxt, kCGLineJoinMiter);
	CGContextSetLineWidth(ctxt, 3);
    
	if (self.highlighted)
	{
		[self.highlightedColor setStroke];
	}
	else
	{
		[self.accessoryColor setStroke];
	}
    
	CGContextStrokePath(ctxt);
}

- (void)setHighlighted:(BOOL)highlighted
{
	[self setNeedsDisplay];
}

- (UIColor *)accessoryColor
{
	if (!_accessoryColor)
	{
		return [UIColor blackColor];
	}
    
	return _accessoryColor;
}

- (UIColor *)highlightedColor
{
	if (!_highlightedColor)
	{
		return [UIColor whiteColor];
	}
    
	return _highlightedColor;
}

- (CGSize) intrinsicContentSize
{
    return CGSizeMake(11.0f, 15.0f);
}

@end
